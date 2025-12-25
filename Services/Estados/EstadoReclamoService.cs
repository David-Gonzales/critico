using Common.Exceptions;
using DTOs.Estados.Request;
using DTOs.Estados.Response;
using Microsoft.AspNetCore.Http;
using Repositories.Estados;
using Services.Common;

namespace Services.Estados
{
    public class EstadoReclamoService : IEstadoReclamoService
    {
        private readonly IEstadoReclamoRepository _estadoReclamoRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public EstadoReclamoService(IEstadoReclamoRepository estadoReclamoRepository, IHttpContextAccessor httpContextAccessor)
        {
            _estadoReclamoRepository = estadoReclamoRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        private string ObtenerUsuarioActual()
        {
            var httpContext = _httpContextAccessor.HttpContext;
            return httpContext?.User?.Identity?.Name ?? "SYSTEM";
        }

        public async Task<List<EstadoReclamoDto>> ListarEstadosAsync(int? idEmpresa = null, bool soloActivos = true)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);
            var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);

            // Valido acceso por empresa
            if (!esSuperAdmin)
            {
                if (idEmpresa.HasValue && !empresasUsuario.Contains(idEmpresa.Value))
                    throw new ApiException("No tiene acceso a la empresa solicitada");
                
                if (!idEmpresa.HasValue)
                {
                    idEmpresa = empresasUsuario.FirstOrDefault();

                    if (idEmpresa == 0) throw new ApiException("El usuario no tiene una empresa asignada");
                }
            }

            return await _estadoReclamoRepository.ListarEstadosAsync(idEmpresa, soloActivos);
        }

        public async Task<EstadoReclamoDto> ObtenerEstadoPorIdAsync(int idReclamoEstado)
        {
            var estado = await _estadoReclamoRepository.ObtenerEstadoPorIdAsync(idReclamoEstado);

            if (estado == null)
                throw new ApiException("Estado no encontrado");

            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            // Valido acceso
            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(estado.IdEmpresa))
                    throw new ApiException("Estado no encontrado o no tiene permisos para verlo");
            }

            return estado;
        }

        public async Task<EstadoReclamoDto> CrearEstadoAsync(CrearEstadoReclamoDto dto)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            // Valido acceso a la empresa
            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(dto.IdEmpresa))
                    throw new ApiException("No tiene acceso a crear estados para esta empresa");
            }

            var usuarioActual = ObtenerUsuarioActual();
            return await _estadoReclamoRepository.CrearEstadoAsync(dto, usuarioActual);
        }

        public async Task<EstadoReclamoDto> ActualizarEstadoAsync(int idReclamoEstado, ActualizarEstadoReclamoDto dto)
        {
            // Valido que el estado existe y el usuario tiene acceso
            var estadoExistente = await ObtenerEstadoPorIdAsync(idReclamoEstado);

            var usuarioActual = ObtenerUsuarioActual();
            return await _estadoReclamoRepository.ActualizarEstadoAsync(idReclamoEstado, dto, usuarioActual);
        }

        public async Task<bool> EliminarEstadoAsync(int idReclamoEstado)
        {
            // Valido que el estado existe y el usuario tiene acceso
            var estadoExistente = await ObtenerEstadoPorIdAsync(idReclamoEstado);

            var usuarioActual = ObtenerUsuarioActual();
            return await _estadoReclamoRepository.EliminarEstadoAsync(idReclamoEstado, usuarioActual);
        }

        public async Task<bool> ReordenarEstadosAsync(ReordenarEstadosDto dto)
        {
            // Valido que todos los estados pertenecen a la misma empresa y que el usuario tiene acceso
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);

                // Valido cada estado
                foreach (var estadoOrden in dto.Estados)
                {
                    var estado = await _estadoReclamoRepository.ObtenerEstadoPorIdAsync(estadoOrden.IdReclamoEstado);
                    if (estado == null)
                        throw new ApiException($"Estado con ID {estadoOrden.IdReclamoEstado} no encontrado");

                    if (!empresasUsuario.Contains(estado.IdEmpresa))
                        throw new ApiException("No tiene acceso a todos los estados especificados");
                }
            }

            var usuarioActual = ObtenerUsuarioActual();
            return await _estadoReclamoRepository.ReordenarEstadosAsync(dto.Estados, usuarioActual);
        }

        public async Task<EstadoReclamoDto> CambiarEstadoActivoAsync(int idReclamoEstado, CambiarEstadoDto dto)
        {
            // Valido que el estado existe y el usuario tiene acceso
            var estadoExistente = await ObtenerEstadoPorIdAsync(idReclamoEstado);

            var usuarioActual = ObtenerUsuarioActual();
            return await _estadoReclamoRepository.CambiarEstadoActivoAsync(idReclamoEstado, dto.Activo, usuarioActual);
        }
    }
}
