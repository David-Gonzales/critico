using Common.Exceptions;
using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;
using Microsoft.AspNetCore.Http;
using Repositories.EntidadesFinancieras;
using Services.Common;

namespace Services.EntidadesFinancieras
{
    public class EntidadFinancieraMaestraService : IEntidadFinancieraMaestraService
    {
        private readonly IEntidadFinancieraMaestraRepository _entidadFinancieraMaestraRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public EntidadFinancieraMaestraService(
            IEntidadFinancieraMaestraRepository entidadFinancieraMaestraRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _entidadFinancieraMaestraRepository = entidadFinancieraMaestraRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        private string ObtenerUsuarioActual()
        {
            var httpContext = _httpContextAccessor.HttpContext;
            return httpContext?.User?.Identity?.Name ?? "SYSTEM";
        }

        // Método solo para SuperAdmin
        public async Task<List<EntidadFinancieraMaestraDto>> ListarEntidadesAsync(bool soloActivos = true)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin)
                throw new ApiException("Solo el SuperAdmin puede gestionar el catálogo maestro de entidades financieras");

            return await _entidadFinancieraMaestraRepository.ListarEntidadesAsync(soloActivos);
        }

        public async Task<EntidadFinancieraMaestraDto> ObtenerEntidadPorIdAsync(int idEntidadFinanciera)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin)
                throw new ApiException("Solo el SuperAdmin puede gestionar el catálogo maestro de entidades financieras");

            var entidad = await _entidadFinancieraMaestraRepository.ObtenerEntidadPorIdAsync(idEntidadFinanciera);

            if (entidad == null)
                throw new ApiException("Entidad financiera no encontrada");

            return entidad;
        }

        public async Task<EntidadFinancieraMaestraDto> CrearEntidadAsync(CrearEntidadFinancieraMaestraDto dto)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin)
                throw new ApiException("Solo el SuperAdmin puede gestionar el catálogo maestro de entidades financieras");

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraMaestraRepository.CrearEntidadAsync(dto, usuarioActual);
        }

        public async Task<EntidadFinancieraMaestraDto> ActualizarEntidadAsync(
            int idEntidadFinanciera,
            ActualizarEntidadFinancieraMaestraDto dto)
        {
            await ObtenerEntidadPorIdAsync(idEntidadFinanciera);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraMaestraRepository.ActualizarEntidadAsync(idEntidadFinanciera, dto, usuarioActual);
        }

        public async Task<bool> EliminarEntidadAsync(int idEntidadFinanciera)
        {
            await ObtenerEntidadPorIdAsync(idEntidadFinanciera);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraMaestraRepository.EliminarEntidadAsync(idEntidadFinanciera, usuarioActual);
        }

        public async Task<EntidadFinancieraMaestraDto> CambiarEstadoAsync(
            int idEntidadFinanciera,
            CambiarEstadoDto dto)
        {
            await ObtenerEntidadPorIdAsync(idEntidadFinanciera);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraMaestraRepository.CambiarEstadoAsync(idEntidadFinanciera, dto.Activo, usuarioActual);
        }
    }
}
