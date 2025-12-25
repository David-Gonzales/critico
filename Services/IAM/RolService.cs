using DTOs.IAM.Permisos;
using DTOs.IAM.Roles;
using Microsoft.AspNetCore.Http;
using Repositories.IAM;
using Services.Common;

namespace Services.IAM
{
    public class RolService : IRolService
    {
        private readonly IRolRepository _rolRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public RolService(IRolRepository rolRepository, IHttpContextAccessor httpContextAccessor)
        {
            _rolRepository = rolRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        private string ObtenerUsuarioActual()
        {
            // obtener el usuario que realiza la acción desde el contexto HTTP CreadoPor o EditadoPor
            var usuario = _httpContextAccessor.HttpContext?.User?.Identity?.Name;
            return usuario ?? "SISTEMA";
        }

        public async Task<RolDto> CrearRolAsync(CrearRolDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Codigo))
                throw new ArgumentException("El código del rol es requerido");

            if (string.IsNullOrWhiteSpace(dto.Nombre))
                throw new ArgumentException("El nombre del rol es requerido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _rolRepository.CrearAsync(dto, usuarioActual);
        }

        public async Task<RolDto> ActualizarRolAsync(ActualizarRolDto dto)
        {
            if (dto.IdRol <= 0)
                throw new ArgumentException("ID de rol inválido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _rolRepository.ActualizarAsync(dto, usuarioActual);
        }

        public async Task<bool> CambiarEstadoRolAsync(int idRol, bool activo)
        {
            if (idRol <= 0)
                throw new ArgumentException("ID de rol inválido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _rolRepository.CambiarEstadoAsync(idRol, activo, usuarioActual);
        }

        public async Task<bool> EliminarRolAsync(int idRol)
        {
            if (idRol <= 0)
                throw new ArgumentException("ID de rol inválido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _rolRepository.EliminarAsync(idRol, usuarioActual);
        }

        public async Task<IEnumerable<RolDto>> ListarRolesAsync(bool soloActivos, int? idEmpresa = null)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!idEmpresa.HasValue)
            {
                if (!esSuperAdmin)
                    idEmpresa = TenantHelper.ObtenerEmpresaPrincipal(httpContext);
            }
            else
            {
                if (!esSuperAdmin)
                {
                    var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);

                    if (!empresasUsuario.Contains(idEmpresa.Value))
                        throw new UnauthorizedAccessException("No tiene acceso a la empresa solicitada");
                }
            }

            bool excluirSuperAdmin = !esSuperAdmin;

            return await _rolRepository.ListarAsync(soloActivos, incluirEliminados: false, idEmpresa, excluirSuperAdmin);
        }

        public async Task<RolConPermisosDto> ObtenerRolConPermisosAsync(int idRol)
        {
            var rol = await _rolRepository.ObtenerPorIdAsync(idRol);

            if (rol == null)
                throw new KeyNotFoundException($"No se encontró el rol con ID {idRol}");

            var permisos = await _rolRepository.ObtenerPermisosAsync(idRol);

            return new RolConPermisosDto
            {
                IdRol = rol.IdRol,
                Codigo = rol.Codigo,
                Nombre = rol.Nombre,
                Descripcion = rol.Descripcion,
                EsSistema = rol.EsSistema,
                IdEmpresa = rol.IdEmpresa,
                NombreEmpresa = rol.NombreEmpresa,
                FechaCreacion = rol.FechaCreacion,
                CreadoPor = rol.CreadoPor,
                FechaEdicion = rol.FechaEdicion,
                EditadoPor = rol.EditadoPor,
                Activo = rol.Activo,
                Permisos = permisos.ToList()
            };
        }

        public async Task<IEnumerable<PermisoDto>> AsignarPermisosAsync(int idRol, List<int> permisosIds)
        {
            if (idRol <= 0)
                throw new ArgumentException("Id de rol inválido");

            if (permisosIds == null || !permisosIds.Any())
                throw new ArgumentException("Debe seleccionar al menos un permiso");

            if (permisosIds.Distinct().Count() != permisosIds.Count)
                throw new ArgumentException("La lista de permisos contiene IDs duplicados");

            var usuarioActual = ObtenerUsuarioActual();
            return await _rolRepository.AsignarPermisosAsync(idRol, permisosIds, usuarioActual);
        }
    }
}
