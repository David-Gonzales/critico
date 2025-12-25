using DTOs.Common;
using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.EntidadesFinancieras;

namespace API.Controllers
{
    [ApiController]
    [Route("api/entidades-financieras-maestras")]
    [Authorize(Roles = "SuperAdmin")]
    public class EntidadesFinancierasMaestrasController : ControllerBase
    {
        private readonly IEntidadFinancieraMaestraService _entidadFinancieraMaestraService;

        public EntidadesFinancierasMaestrasController(IEntidadFinancieraMaestraService entidadFinancieraMaestraService)
        {
            _entidadFinancieraMaestraService = entidadFinancieraMaestraService;
        }

        [HttpGet("")]
        public async Task<IActionResult> ListarEntidades([FromQuery] bool soloActivos = true)
        {
            var entidades = await _entidadFinancieraMaestraService.ListarEntidadesAsync(soloActivos);
            return Ok(new ApiResponse<List<EntidadFinancieraMaestraDto>>(entidades, "Entidades maestras obtenidas exitosamente"));
        }


        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerEntidad(int id)
        {
            var entidad = await _entidadFinancieraMaestraService.ObtenerEntidadPorIdAsync(id);
            return Ok(new ApiResponse<EntidadFinancieraMaestraDto>(entidad, "Entidad maestra obtenida exitosamente"));
        }


        [HttpPost("")]
        public async Task<IActionResult> CrearEntidad([FromBody] CrearEntidadFinancieraMaestraDto dto)
        {
            var entidad = await _entidadFinancieraMaestraService.CrearEntidadAsync(dto);
            return CreatedAtAction(
                nameof(ObtenerEntidad),
                new { id = entidad.IdEntidadFinanciera },
                new ApiResponse<EntidadFinancieraMaestraDto>(entidad, "Entidad maestra creada exitosamente")
            );
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> ActualizarEntidad(int id, [FromBody] ActualizarEntidadFinancieraMaestraDto dto)
        {
            var entidad = await _entidadFinancieraMaestraService.ActualizarEntidadAsync(id, dto);
            return Ok(new ApiResponse<EntidadFinancieraMaestraDto>(entidad, "Entidad maestra actualizada exitosamente"));
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> EliminarEntidad(int id)
        {
            await _entidadFinancieraMaestraService.EliminarEntidadAsync(id);
            return Ok(new ApiResponse<object>(null, "Entidad maestra eliminada exitosamente"));
        }


        [HttpPatch("{id}/status")]
        public async Task<IActionResult> CambiarEstado(int id, [FromBody] CambiarEstadoDto dto)
        {
            var entidad = await _entidadFinancieraMaestraService.CambiarEstadoAsync(id, dto);
            return Ok(new ApiResponse<EntidadFinancieraMaestraDto>(entidad, "Estado actualizado exitosamente"));
        }
    }
}
