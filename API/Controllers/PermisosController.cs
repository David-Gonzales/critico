using DTOs.Common;
using DTOs.IAM.Permisos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.IAM;

namespace API.Controllers
{
    [ApiController]
    [Route("api/admin")]
    [Authorize]
    public class PermisosController : ControllerBase
    {
        private readonly IPermisoService _permisoService;

        public PermisosController(IPermisoService permisoService)
        {
            _permisoService = permisoService;
        }

        [HttpPost("permissions")]
        public async Task<IActionResult> CrearPermiso([FromBody] CrearPermisoDto dto)
        {
            var permiso = await _permisoService.CrearPermisoAsync(dto);
            return CreatedAtAction(
                nameof(ObtenerPermiso),
                new { id = permiso.IdPermiso },
                new ApiResponse<PermisoDto>(permiso, "Permiso creado exitosamente")
            );
        }

        [HttpPut("permissions/{id}")]
        public async Task<IActionResult> ActualizarPermiso(int id, [FromBody] ActualizarPermisoDto dto)
        {
            if (id != dto.IdPermiso)
                throw new ArgumentException("El ID del permiso no coincide.");

            var permiso = await _permisoService.ActualizarPermisoAsync(dto);
            return Ok(new ApiResponse<PermisoDto>(permiso, "Permiso actualizado exitosamente"));
        }

        [HttpPatch("permissions/{id}/status")]
        public async Task<IActionResult> CambiarEstado(int id, [FromBody] CambiarEstadoPermisoDto dto)
        {
            if (id != dto.IdPermiso)
                throw new ArgumentException("El ID del permiso no coincide.");

            var resultado = await _permisoService.CambiarEstadoPermisoAsync(id, dto.Activo);
            return Ok(new ApiResponse<bool>(resultado, "Estado del permiso actualizado exitosamente"));
        }

        [HttpDelete("permissions/{id}")]
        public async Task<IActionResult> EliminarPermiso(int id)
        {
            var resultado = await _permisoService.EliminarPermisoAsync(id);
            return Ok(new ApiResponse<bool>(resultado, "Permiso eliminado exitosamente"));
        }

        [HttpGet("permissions/{id}")]
        public async Task<IActionResult> ObtenerPermiso(int id)
        {
            var permiso = await _permisoService.ObtenerPermisoPorIdAsync(id);
            return Ok(new ApiResponse<PermisoDto>(permiso));
        }

        [HttpGet("permissions")]
        public async Task<IActionResult> ListarPermisos([FromQuery] bool soloActivos = true, int? idEmpresa = null)
        {
            var permisos = await _permisoService.ListarPermisosAsync(soloActivos, idEmpresa);
            return Ok(new ApiResponse<IEnumerable<PermisoDto>>(permisos, "Permisos obtenidos exitosamente"));
        }
    }
}
