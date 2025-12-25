using DTOs.Common;
using DTOs.Estados.Request;
using DTOs.Estados.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.Estados;

namespace API.Controllers
{
    [ApiController]
    [Route("api/states")]
    [Authorize]
    public class EstadosController : ControllerBase
    {
        private readonly IEstadoReclamoService _estadoReclamoService;

        public EstadosController(IEstadoReclamoService estadoReclamoService)
        {
            _estadoReclamoService = estadoReclamoService;
        }

        [HttpGet]
        public async Task<IActionResult> ListarEstados(
            [FromQuery] int? idEmpresa = null,
            [FromQuery] bool soloActivos = true)
        {
            var estados = await _estadoReclamoService.ListarEstadosAsync(idEmpresa, soloActivos);
            return Ok(new ApiResponse<List<EstadoReclamoDto>>(estados, "Estados obtenidos exitosamente"));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerEstado(int id)
        {
            var estado = await _estadoReclamoService.ObtenerEstadoPorIdAsync(id);
            return Ok(new ApiResponse<EstadoReclamoDto>(estado, "Estado obtenido exitosamente"));
        }

        [HttpPost]
        public async Task<IActionResult> CrearEstado([FromBody] CrearEstadoReclamoDto dto)
        {
            var estado = await _estadoReclamoService.CrearEstadoAsync(dto);
            return CreatedAtAction(
                nameof(ObtenerEstado),
                new { id = estado.IdReclamoEstado },
                new ApiResponse<EstadoReclamoDto>(estado, "Estado creado exitosamente")
            );
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> ActualizarEstado(int id, [FromBody] ActualizarEstadoReclamoDto dto)
        {
            var estado = await _estadoReclamoService.ActualizarEstadoAsync(id, dto);
            return Ok(new ApiResponse<EstadoReclamoDto>(estado, "Estado actualizado exitosamente"));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> EliminarEstado(int id)
        {
            await _estadoReclamoService.EliminarEstadoAsync(id);
            return Ok(new ApiResponse<object>(null, "Estado eliminado exitosamente"));
        }

        [HttpPost("reorder")]
        public async Task<IActionResult> ReordenarEstados([FromBody] ReordenarEstadosDto dto)
        {
            await _estadoReclamoService.ReordenarEstadosAsync(dto);
            return Ok(new ApiResponse<object>(null, "Estados reordenados exitosamente"));
        }

        [HttpPatch("{id}/status")]
        public async Task<IActionResult> CambiarEstado(int id, [FromBody] CambiarEstadoDto dto)
        {
            var estado = await _estadoReclamoService.CambiarEstadoActivoAsync(id, dto);
            return Ok(new ApiResponse<EstadoReclamoDto>(estado, "Estado actualizado exitosamente"));
        }

    }
}
