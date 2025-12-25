using Common.Exceptions;
using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;
using Microsoft.AspNetCore.Http;
using Repositories.EntidadesFinancieras;
using Services.Common;

namespace Services.EntidadesFinancieras
{
    public class EntidadFinancieraEmpresaService : IEntidadFinancieraEmpresaService
    {
        private readonly IEntidadFinancieraEmpresaRepository _entidadFinancieraEmpresaRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public EntidadFinancieraEmpresaService(
            IEntidadFinancieraEmpresaRepository entidadFinancieraEmpresaRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _entidadFinancieraEmpresaRepository = entidadFinancieraEmpresaRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        private string ObtenerUsuarioActual()
        {
            var httpContext = _httpContextAccessor.HttpContext;
            return httpContext?.User?.Identity?.Name ?? "SYSTEM";
        }

        public async Task<List<EntidadFinancieraEmpresaDto>> ListarPorEmpresaAsync(
            int idEmpresa,
            bool soloActivos = true,
            bool soloVisibles = true)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(idEmpresa))
                    throw new ApiException("No tiene acceso a la empresa solicitada");
            }

            return await _entidadFinancieraEmpresaRepository.ListarPorEmpresaAsync(idEmpresa, soloActivos, soloVisibles);
        }

        public async Task<EntidadFinancieraEmpresaDto> ObtenerPorIdAsync(
            int idEntidadFinancieraEmpresa,
            bool incluirRelaciones = false)
        {
            var entidad = await _entidadFinancieraEmpresaRepository.ObtenerPorIdAsync(idEntidadFinancieraEmpresa, incluirRelaciones);

            if (entidad == null)
                throw new ApiException("Entidad financiera no encontrada");

            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(entidad.IdEmpresa))
                    throw new ApiException("No tiene acceso a esta entidad financiera");
            }

            return entidad;
        }

        public async Task<EntidadFinancieraEmpresaDto> AsignarEntidadAsync(
            int idEmpresa,
            AsignarEntidadFinancieraDto dto)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(idEmpresa))
                    throw new ApiException("No tiene acceso para asignar entidades a esta empresa");
            }

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.AsignarEntidadAsync(idEmpresa, dto, usuarioActual);
        }

        public async Task<EntidadFinancieraEmpresaDto> ActualizarConfigAsync(
            int idEntidadFinancieraEmpresa,
            ActualizarConfigEntidadDto dto)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.ActualizarConfigAsync(idEntidadFinancieraEmpresa, dto, usuarioActual);
        }

        public async Task<bool> DesasignarEntidadAsync(int idEntidadFinancieraEmpresa)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.DesasignarEntidadAsync(idEntidadFinancieraEmpresa, usuarioActual);
        }

        public async Task<EntidadFinancieraEmpresaDto> CambiarEstadoAsync(
            int idEntidadFinancieraEmpresa,
            CambiarEstadoDto dto)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.CambiarEstadoAsync(idEntidadFinancieraEmpresa, dto.Activo, usuarioActual);
        }

        // Contactos

        public async Task<List<ContactoDto>> ObtenerContactosAsync(int idEntidadFinancieraEmpresa)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            return await _entidadFinancieraEmpresaRepository.ObtenerContactosAsync(idEntidadFinancieraEmpresa);
        }

        public async Task<ContactoDto> AgregarContactoAsync(
            int idEntidadFinancieraEmpresa,
            CrearContactoDto dto)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.AgregarContactoAsync(idEntidadFinancieraEmpresa, dto, usuarioActual);
        }

        public async Task<bool> EliminarContactoAsync(int idEntidadFinancieraEmpresa, int idContacto)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.EliminarContactoAsync(idContacto, usuarioActual);
        }

        // Dominios

        public async Task<List<DominioDto>> ObtenerDominiosAsync(int idEntidadFinancieraEmpresa)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            return await _entidadFinancieraEmpresaRepository.ObtenerDominiosAsync(idEntidadFinancieraEmpresa);
        }

        public async Task<DominioDto> AgregarDominioAsync(
            int idEntidadFinancieraEmpresa,
            CrearDominioDto dto)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.AgregarDominioAsync(idEntidadFinancieraEmpresa, dto, usuarioActual);
        }

        public async Task<bool> EliminarDominioAsync(int idEntidadFinancieraEmpresa, int idDominio)
        {
            await ObtenerPorIdAsync(idEntidadFinancieraEmpresa);

            var usuarioActual = ObtenerUsuarioActual();
            return await _entidadFinancieraEmpresaRepository.EliminarDominioAsync(idDominio, usuarioActual);
        }
    }
}
