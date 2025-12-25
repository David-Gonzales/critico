using DTOs.Common;
using DTOs.IAM.Permisos;
using DTOs.IAM.Roles;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.IAM;

namespace API.Controllers
{
    [ApiController]
    [Route("api/admin")]
    [Authorize]
    public class RolesController : ControllerBase
    {
        private readonly IRolService _rolService;
        public RolesController(IRolService rolService)
        {
            _rolService = rolService;
        }

        [HttpPost("roles")]
        public async Task<IActionResult> CrearRol([FromBody] CrearRolDto dto)
        {
            
            var rol = await _rolService.CrearRolAsync(dto);
            return CreatedAtAction(
                nameof(ObtenerRolPorId), 
                new { id = rol.IdRol },
                new ApiResponse<RolDto>(rol, "Rol creado exitosamente")
            );
            
        }

        [HttpPut("roles/{id}")]
        public async Task<IActionResult> ActualizarRol(int id, [FromBody] ActualizarRolDto dto)
        {
            if (id != dto.IdRol)
                throw new ArgumentException("El ID del rol no coincide.");

            var rol = await _rolService.ActualizarRolAsync(dto);
            return Ok(new ApiResponse<RolDto>(rol, "Rol actualizado exitosamente"));
            
        }

        [HttpPatch("roles/{id}/status")]
        public async Task<IActionResult> CambiarEstado(int id, [FromBody] CambiarEstadoRolDto dto)
        {
            if (id != dto.IdRol)
                throw new ArgumentException("El ID del rol no coincide.");

            var resultado = await _rolService.CambiarEstadoRolAsync(id, dto.Activo);

            return Ok(new ApiResponse<bool>(resultado, "Estado del rol actualizado exitosamente"));
            
        }

        [HttpDelete("roles/{id}")]
        public async Task<IActionResult> EliminarRol(int id)
        {
            var resultado = await _rolService.EliminarRolAsync(id);
            return Ok(new ApiResponse<bool>(resultado, "Rol eliminado exitosamente"));
        }

        [HttpGet("roles/{id}")]
        public async Task<IActionResult> ObtenerRolPorId(int id)
        {
            var rol = await _rolService.ObtenerRolConPermisosAsync(id);
            return Ok( new ApiResponse<RolConPermisosDto>(rol, "Rol obtenido exitosamente"));

        }

        [HttpGet("roles")]
        public async Task<IActionResult> ListarRoles([FromQuery] bool soloActivos = true, int? idEmpresa = null)
        {
            var roles = await _rolService.ListarRolesAsync(soloActivos, idEmpresa);
            return Ok( new ApiResponse<IEnumerable<RolDto>>(roles, "Roles obtenidos exitosamente") );

        }
        
        [HttpGet("roles/{id}/permissions")]
        public async Task<IActionResult> ObtenerPermisos(int id)
        {
            var rol = await _rolService.ObtenerRolConPermisosAsync(id);
            return Ok(new ApiResponse<RolConPermisosDto>(rol, "Permisos por Rol obtenidos exitosamente"));
            
        }

        [HttpPut("roles/{id}/permissions")]
        public async Task<IActionResult> AsignarPermisos(int id, [FromBody] AsignarPermisosRolDto dto)
        {
            if (id != dto.IdRol)
                throw new ArgumentException("El ID del rol no coincide.");

            var permisos = await _rolService.AsignarPermisosAsync(dto.IdRol, dto.PermisosIds);
            return Ok(new ApiResponse<IEnumerable<PermisoDto>>(permisos, "Permisos asignados exitosamente"));
            
        }
    }
}
