using Common.Exceptions;
using DTOs.Parametricas.Request;
using DTOs.Parametricas.Response;
using Microsoft.AspNetCore.Http;
using Repositories.Parametricas;
using Services.Common;
using System.Text.RegularExpressions;

namespace Services.Parametricas
{
    public class ParametricaService : IParametricaService
    {
        private readonly IParametricaRepository _parametricaRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public ParametricaService(
            IParametricaRepository parametricaRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _parametricaRepository = parametricaRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        private string ObtenerUsuarioActual()
        {
            var httpContext = _httpContextAccessor.HttpContext;
            return httpContext?.User?.Identity?.Name ?? "SYSTEM";
        }

        // Grupo Paramétricas
        public async Task<List<GrupoParametricaDto>> ListarGruposAsync(
            int? idEmpresa = null,
            string? tipoGrupo = null,
            bool soloActivos = true)
        {

            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin && idEmpresa.HasValue)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(idEmpresa.Value))
                    throw new ApiException("No tiene acceso a la empresa solicitada");
            }

            return await _parametricaRepository.ListarGruposAsync(idEmpresa, tipoGrupo, soloActivos);
        }

        public async Task<GrupoParametricaDto> ObtenerGrupoPorIdAsync(int idGrupoParametrica)
        {
            var grupo = await _parametricaRepository.ObtenerGrupoPorIdAsync(idGrupoParametrica);

            if (grupo == null)
                throw new ApiException("Grupo de paramétrica no encontrado");

            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            // Validar acceso
            if (!esSuperAdmin && grupo.IdEmpresa.HasValue)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(grupo.IdEmpresa.Value))
                    throw new ApiException("No tiene acceso a este grupo de paramétrica");
            }

            return grupo;
        }
        
        //Paramétricas
        public async Task<List<ParametricaDto>> ListarParametricasAsync(
            int? idGrupoParametrica = null,
            string? nombre = null,
            string? dominio = null,
            bool? estado = null,
            bool soloActivos = true)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            int? idEmpresa = null;

            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (empresasUsuario.Count == 1)
                {
                    idEmpresa = empresasUsuario.First();
                }
            }

            var parametricas = await _parametricaRepository.ListarParametricasAsync(
                idGrupoParametrica, 
                nombre, 
                dominio,
                idEmpresa,
                estado,
                soloActivos);

            if (!esSuperAdmin && idEmpresa == null)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                parametricas = parametricas
                    .Where(p => p.IdEmpresa == null || empresasUsuario.Contains(p.IdEmpresa.Value))
                    .ToList();
            }

            return parametricas;
        }

        public async Task<ParametricaDto> ObtenerParametricaPorIdAsync(int idParametrica)
        {
            var parametrica = await _parametricaRepository.ObtenerParametricaPorIdAsync(idParametrica);

            if (parametrica == null)
                throw new ApiException("Paramétrica no encontrada");

            return parametrica;
        }

        public async Task<ParametricaDto> CrearParametricaAsync(CrearParametricaDto dto)
        {
            // Validar que el grupo existe
            var grupo = await _parametricaRepository.ObtenerGrupoPorIdAsync(dto.IdGrupoParametrica);
            if (grupo == null)
                throw new ApiException("El grupo de paramétrica especificado no existe");

            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!esSuperAdmin && grupo.IdEmpresa.HasValue)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(grupo.IdEmpresa.Value))
                    throw new ApiException("No tiene acceso a crear paramétricas en este grupo");
            }

            var usuarioActual = ObtenerUsuarioActual();
            return await _parametricaRepository.CrearParametricaAsync(dto, usuarioActual);
        }

        public async Task<ParametricaDto> ActualizarParametricaAsync(int idParametrica, ActualizarParametricaDto dto)
        {
            // Validar que la paramétrica existe
            var parametricaExistente = await ObtenerParametricaPorIdAsync(idParametrica);

            var usuarioActual = ObtenerUsuarioActual();
            return await _parametricaRepository.ActualizarParametricaAsync(idParametrica, dto, usuarioActual);
        }

        public async Task<bool> EliminarParametricaAsync(int idParametrica)
        {
            // Validar que la paramétrica existe
            var parametricaExistente = await ObtenerParametricaPorIdAsync(idParametrica);

            var usuarioActual = ObtenerUsuarioActual();
            return await _parametricaRepository.EliminarParametricaAsync(idParametrica, usuarioActual);
        }

        public async Task<ParametricaDto> CambiarEstadoParametricaAsync(int idParametrica, CambiarEstadoParametricaDto dto)
        {
            // Validar que la paramétrica existe
            var parametricaExistente = await ObtenerParametricaPorIdAsync(idParametrica);

            var usuarioActual = ObtenerUsuarioActual();
            return await _parametricaRepository.CambiarEstadoParametricaAsync(idParametrica, dto.Activo, usuarioActual);
        }
    }
}
