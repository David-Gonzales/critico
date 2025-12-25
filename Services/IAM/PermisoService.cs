using DTOs.IAM.Permisos;
using Microsoft.AspNetCore.Http;
using Repositories.IAM;
using Services.Common;

namespace Services.IAM
{
    public class PermisoService : IPermisoService
    {
        private readonly IPermisoRepository _permisoRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public PermisoService(IPermisoRepository permisoRepository, IHttpContextAccessor httpContextAccessor)
        {
            _permisoRepository = permisoRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        private string ObtenerUsuarioActual()
        {
            var usuario = _httpContextAccessor.HttpContext?.User?.Identity?.Name;
            return usuario ?? "SISTEMA";
        }

        public async Task<PermisoDto> CrearPermisoAsync(CrearPermisoDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Codigo))
                throw new ArgumentException("El código del permiso es requerido");

            if (string.IsNullOrWhiteSpace(dto.Nombre))
                throw new ArgumentException("El nombre del permiso es requerido");

            if (string.IsNullOrWhiteSpace(dto.Recurso))
                throw new ArgumentException("El recurso del permiso es requerido");

            if (string.IsNullOrWhiteSpace(dto.Accion))
                throw new ArgumentException("La acción del permiso es requerida");

            var usuarioActual = ObtenerUsuarioActual();
            return await _permisoRepository.CrearAsync(dto, usuarioActual);
        }

        public async Task<PermisoDto> ActualizarPermisoAsync(ActualizarPermisoDto dto)
        {
            if (dto.IdPermiso <= 0)
                throw new ArgumentException("ID de permiso inválido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _permisoRepository.ActualizarAsync(dto, usuarioActual);
        }

        public async Task<bool> CambiarEstadoPermisoAsync(int idPermiso, bool activo)
        {
            if (idPermiso <= 0)
                throw new ArgumentException("ID de permiso inválido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _permisoRepository.CambiarEstadoAsync(idPermiso, activo, usuarioActual);
        }

        public async Task<bool> EliminarPermisoAsync(int idPermiso)
        {
            if (idPermiso <= 0)
                throw new ArgumentException("ID de permiso inválido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _permisoRepository.EliminarAsync(idPermiso, usuarioActual);
        }

        public async Task<PermisoDto> ObtenerPermisoPorIdAsync(int idPermiso)
        {
            if (idPermiso <= 0)
                throw new ArgumentException("ID de permiso inválido");

            var permiso = await _permisoRepository.ObtenerPorIdAsync(idPermiso);

            if (permiso == null)
                throw new KeyNotFoundException($"No se encontró el permiso con ID {idPermiso}");

            return permiso;
        }

        public async Task<IEnumerable<PermisoDto>> ListarPermisosAsync(bool soloActivos, int? idEmpresa = null)
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
                        throw new UnauthorizedAccessException("No tiene acceso a la empresa solicitada.");
                }
            } 

            return await _permisoRepository.ListarAsync(soloActivos, incluirEliminados: false, idEmpresa);
        }
    }
}
