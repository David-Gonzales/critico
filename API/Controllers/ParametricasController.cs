using DTOs.Common;
using DTOs.Parametricas.Request;
using DTOs.Parametricas.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.Parametricas;

namespace API.Controllers
{
    [ApiController]
    [Route("api/parametricas")]
    [Authorize]
    public class ParametricasController : ControllerBase
    {
        private readonly IParametricaService _parametricaService;

        public ParametricasController(IParametricaService parametricaService)
        {
            _parametricaService = parametricaService;
        }


        [HttpGet("grupos")]
        public async Task<IActionResult> ListarGrupos(
            [FromQuery] int? idEmpresa = null,
            [FromQuery] string? tipoGrupo = null,
            [FromQuery] bool soloActivos = true)
        {
            var grupos = await _parametricaService.ListarGruposAsync(idEmpresa, tipoGrupo, soloActivos);
            return Ok(new ApiResponse<List<GrupoParametricaDto>>(grupos, "Grupos obtenidos exitosamente"));
        }


        [HttpGet("grupos/{id}")]
        public async Task<IActionResult> ObtenerGrupo(int id)
        {
            var grupo = await _parametricaService.ObtenerGrupoPorIdAsync(id);
            return Ok(new ApiResponse<GrupoParametricaDto>(grupo, "Grupo obtenido exitosamente"));
        }


        [HttpGet]
        public async Task<IActionResult> ListarParametricas(
            [FromQuery] int? idGrupoParametrica = null,
            [FromQuery] string? nombre = null,
            [FromQuery] string? dominio = null,
            [FromQuery] bool? estado = null,
            [FromQuery] bool soloActivos = true)
        {
            var parametricas = await _parametricaService.ListarParametricasAsync(idGrupoParametrica, nombre, dominio, estado, soloActivos);
            return Ok(new ApiResponse<List<ParametricaDto>>(parametricas, "Paramétricas obtenidas exitosamente"));
        }


        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerParametrica(int id)
        {
            var parametrica = await _parametricaService.ObtenerParametricaPorIdAsync(id);
            return Ok(new ApiResponse<ParametricaDto>(parametrica, "Paramétrica obtenida exitosamente"));
        }


        [HttpPost]
        public async Task<IActionResult> CrearParametrica([FromBody] CrearParametricaDto dto)
        {
            var parametrica = await _parametricaService.CrearParametricaAsync(dto);
            return CreatedAtAction(
                nameof(ObtenerParametrica),
                new { id = parametrica.IdParametrica },
                new ApiResponse<ParametricaDto>(parametrica, "Paramétrica creada exitosamente")
            );
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> ActualizarParametrica(int id, [FromBody] ActualizarParametricaDto dto)
        {
            var parametrica = await _parametricaService.ActualizarParametricaAsync(id, dto);
            return Ok(new ApiResponse<ParametricaDto>(parametrica, "Paramétrica actualizada exitosamente"));
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> EliminarParametrica(int id)
        {
            await _parametricaService.EliminarParametricaAsync(id);
            return Ok(new ApiResponse<object>(null, "Paramétrica eliminada exitosamente"));
        }


        [HttpPatch("{id}/estado")]
        public async Task<IActionResult> CambiarEstado(int id, [FromBody] CambiarEstadoParametricaDto dto)
        {
            var parametrica = await _parametricaService.CambiarEstadoParametricaAsync(id, dto);
            return Ok(new ApiResponse<ParametricaDto>(parametrica, "Estado actualizado exitosamente"));
        }
    }
}