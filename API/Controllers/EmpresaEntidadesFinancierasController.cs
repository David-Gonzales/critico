using DTOs.Common;
using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.EntidadesFinancieras;

namespace API.Controllers
{
    [ApiController]
    [Route("api/empresas/{idEmpresa}/entidades-financieras")]
    [Authorize]
    public class EmpresaEntidadesFinancierasController : ControllerBase
    {
        private readonly IEntidadFinancieraEmpresaService _entidadFinancieraEmpresaService;

        public EmpresaEntidadesFinancierasController(IEntidadFinancieraEmpresaService entidadFinancieraEmpresaService)
        {
            _entidadFinancieraEmpresaService = entidadFinancieraEmpresaService;
        }


        [HttpGet("")]
        public async Task<IActionResult> ListarEntidades(
            int idEmpresa,
            [FromQuery] bool soloActivos = true,
            [FromQuery] bool soloVisibles = true)
        {
            var entidades = await _entidadFinancieraEmpresaService.ListarPorEmpresaAsync(idEmpresa, soloActivos, soloVisibles);
            return Ok(new ApiResponse<List<EntidadFinancieraEmpresaDto>>(entidades, "Entidades obtenidas exitosamente"));
        }


        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerEntidad(
            int idEmpresa,
            int id,
            [FromQuery] bool incluirRelaciones = false)
        {
            var entidad = await _entidadFinancieraEmpresaService.ObtenerPorIdAsync(id, incluirRelaciones);
            return Ok(new ApiResponse<EntidadFinancieraEmpresaDto>(entidad, "Entidad obtenida exitosamente"));
        }


        [HttpPost("")]
        public async Task<IActionResult> AsignarEntidad(int idEmpresa, [FromBody] AsignarEntidadFinancieraDto dto)
        {
            var entidad = await _entidadFinancieraEmpresaService.AsignarEntidadAsync(idEmpresa, dto);
            return CreatedAtAction(
                nameof(ObtenerEntidad),
                new { idEmpresa, id = entidad.IdEntidadFinancieraEmpresa },
                new ApiResponse<EntidadFinancieraEmpresaDto>(entidad, "Entidad asignada exitosamente")
            );
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> ActualizarConfig(int idEmpresa, int id, [FromBody] ActualizarConfigEntidadDto dto)
        {
            var entidad = await _entidadFinancieraEmpresaService.ActualizarConfigAsync(id, dto);
            return Ok(new ApiResponse<EntidadFinancieraEmpresaDto>(entidad, "Configuración actualizada exitosamente"));
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DesasignarEntidad(int idEmpresa, int id)
        {
            await _entidadFinancieraEmpresaService.DesasignarEntidadAsync(id);
            return Ok(new ApiResponse<object>(null, "Entidad desasignada exitosamente"));
        }


        [HttpPatch("{id}/status")]
        public async Task<IActionResult> CambiarEstado(int idEmpresa, int id, [FromBody] CambiarEstadoDto dto)
        {
            var entidad = await _entidadFinancieraEmpresaService.CambiarEstadoAsync(id, dto);
            return Ok(new ApiResponse<EntidadFinancieraEmpresaDto>(entidad, "Estado actualizado exitosamente"));
        }

        // Contactos

        [HttpGet("{id}/contacts")]
        public async Task<IActionResult> ObtenerContactos(int idEmpresa, int id)
        {
            var contactos = await _entidadFinancieraEmpresaService.ObtenerContactosAsync(id);
            return Ok(new ApiResponse<List<ContactoDto>>(contactos, "Contactos obtenidos exitosamente"));
        }

        [HttpPost("{id}/contacts")]
        public async Task<IActionResult> AgregarContacto(int idEmpresa, int id, [FromBody] CrearContactoDto dto)
        {
            var contacto = await _entidadFinancieraEmpresaService.AgregarContactoAsync(id, dto);
            return Ok(new ApiResponse<ContactoDto>(contacto, "Contacto agregado exitosamente"));
        }

        [HttpDelete("{id}/contacts/{idContacto}")]
        public async Task<IActionResult> EliminarContacto(int idEmpresa, int id, int idContacto)
        {
            await _entidadFinancieraEmpresaService.EliminarContactoAsync(id, idContacto);
            return Ok(new ApiResponse<object>(null, "Contacto eliminado exitosamente"));
        }

        // Dominio

        [HttpGet("{id}/domains")]
        public async Task<IActionResult> ObtenerDominios(int idEmpresa, int id)
        {
            var dominios = await _entidadFinancieraEmpresaService.ObtenerDominiosAsync(id);
            return Ok(new ApiResponse<List<DominioDto>>(dominios, "Dominios obtenidos exitosamente"));
        }


        [HttpPost("{id}/domains")]
        public async Task<IActionResult> AgregarDominio(int idEmpresa, int id, [FromBody] CrearDominioDto dto)
        {
            var dominio = await _entidadFinancieraEmpresaService.AgregarDominioAsync(id, dto);
            return Ok(new ApiResponse<DominioDto>(dominio, "Dominio agregado exitosamente"));
        }


        [HttpDelete("{id}/domains/{idDominio}")]
        public async Task<IActionResult> EliminarDominio(int idEmpresa, int id, int idDominio)
        {
            await _entidadFinancieraEmpresaService.EliminarDominioAsync(id, idDominio);
            return Ok(new ApiResponse<object>(null, "Dominio eliminado exitosamente"));
        }
    }
}
