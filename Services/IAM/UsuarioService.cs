using Common.Exceptions;
using DTOs.IAM.Usuarios;
using Microsoft.AspNetCore.Http;
using Repositories.IAM;
using Services.Common;

namespace Services.IAM
{
    public class UsuarioService : IUsuarioService
    {
        private readonly IUsuarioRepository _usuarioRepository;
        private readonly IPasswordService _passwordService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public UsuarioService(IUsuarioRepository usuarioRepository, IPasswordService passwordService, IHttpContextAccessor httpContextAccessor)
        {
            _usuarioRepository = usuarioRepository;
            _passwordService = passwordService;
            _httpContextAccessor = httpContextAccessor;
        }

        private string ObtenerUsuarioActual()
        {
            // obtener el usuario que realiza la acción desde el contexto HTTP CreadoPor o EditadoPor
            var usuario = _httpContextAccessor.HttpContext?.User?.Identity?.Name;
            return usuario ?? "SISTEMA";
        }

        public async Task<IEnumerable<UsuarioDto>> ListarUsuariosAsync(bool soloActivos = true, int? idEmpresa = null)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!idEmpresa.HasValue )
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

            bool excluirSuperAdmin = !esSuperAdmin;

            return await _usuarioRepository.ListarAsync(soloActivos, incluirEliminados: false, idEmpresa, excluirSuperAdmin);
        }

        public async Task<UsuarioDetalleDto> ObtenerUsuarioPorIdAsync(int idUsuario)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(idUsuario);

            if (usuario == null)
                throw new KeyNotFoundException($"No se encontró el usuario con ID {idUsuario}");

            return usuario;
        }

        public async Task<UsuarioDetalleDto> CrearUsuarioAsync(CrearUsuarioDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.NombreUsuario))
                throw new ApiException("El nombre de usuario es requerido");

            if (string.IsNullOrWhiteSpace(dto.Email))
                throw new ApiException("El email es requerido");

            if (string.IsNullOrWhiteSpace(dto.Password))
                throw new ApiException("La contraseña es requerida");

            if (dto.Password.Length <= 6)
                throw new ApiException("La contraseña debe tener al menos 6 caracteres");

            if (!dto.RolesIds.Any())
                throw new ApiException("Debe asignar al menos un rol");

            if (!dto.EmpresasIds.Any())
                throw new ApiException("Debe asignar al menos una empresa");

            var passwordHash = _passwordService.HashPassword(dto.Password);

            var usuarioActual = ObtenerUsuarioActual();
            return await _usuarioRepository.CrearAsync(dto, passwordHash, usuarioActual);
        }

        public async Task<UsuarioDetalleDto> ActualizarUsuarioAsync(ActualizarUsuarioDto dto)
        {
            if (dto.IdUsuario <= 0)
                throw new ArgumentException("ID de usuario inválido");

            if (string.IsNullOrWhiteSpace(dto.NombreUsuario))
                throw new ApiException("El nombre de usuario es requerido");

            if (string.IsNullOrWhiteSpace(dto.Email))
                throw new ApiException("El email es requerido");

            if (!dto.RolesIds.Any())
                throw new ApiException("Debe asignar al menos un rol");

            if (!dto.EmpresasIds.Any())
                throw new ApiException("Debe asignar al menos una empresa");

            var usuarioActual = ObtenerUsuarioActual();
            return await _usuarioRepository.ActualizarAsync(dto, usuarioActual);
        }

        public async Task<bool> CambiarPasswordAsync(CambiarPasswordUsuarioDto dto)
        {
            if (dto.IdUsuario <= 0)
                throw new ArgumentException("ID de usuario inválido");

            if (string.IsNullOrWhiteSpace(dto.PasswordNuevo))
                throw new ApiException("La nueva contraseña es requerida");

            if (dto.PasswordNuevo.Length <= 6)
                throw new ApiException("La contraseña debe tener al menos 6 caracteres");

            var passwordHash = _passwordService.HashPassword(dto.PasswordNuevo);
            var usuarioActual = ObtenerUsuarioActual();

            return await _usuarioRepository.CambiarPasswordAsync(dto.IdUsuario, passwordHash, usuarioActual);
        }

        public async Task<bool> CambiarEstadoAsync(int idUsuario, bool activo)
        {
            if (idUsuario <= 0)
                throw new ArgumentException("ID de usuario inválido");

            var usuarioActual = ObtenerUsuarioActual();
            return await _usuarioRepository.CambiarEstadoAsync(idUsuario, activo, usuarioActual);
        }
    }
}
