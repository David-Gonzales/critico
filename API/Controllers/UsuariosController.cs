using DTOs.Common;
using DTOs.IAM.Usuarios;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.IAM;

namespace API.Controllers
{
    [ApiController]
    [Route("api/admin")]
    [Authorize]
    public class UsuariosController : ControllerBase
    {
        private readonly IUsuarioService _usuarioService;

        public UsuariosController(IUsuarioService usuarioService)
        {
            _usuarioService = usuarioService;
        }

        [HttpGet("users")]
        public async Task<IActionResult> ListarUsuarios([FromQuery] bool soloActivos = true, int? idEmpresa = null)
        {
            var usuarios = await _usuarioService.ListarUsuariosAsync(soloActivos, idEmpresa);
            return Ok(new ApiResponse<IEnumerable<UsuarioDto>>(usuarios, "Usuarios obtenidos exitosamente"));
        }

        [HttpGet("users/{id}")]
        public async Task<IActionResult> ObtenerUsuarioPorId(int id)
        {
            var usuario = await _usuarioService.ObtenerUsuarioPorIdAsync(id);
            return Ok(new ApiResponse<UsuarioDetalleDto>(usuario, "Usuario obtenido exitosamente"));
        }

        [HttpPost("users")]
        public async Task<IActionResult> CrearUsuario([FromBody] CrearUsuarioDto dto)
        {
            var nuevoUsuario = await _usuarioService.CrearUsuarioAsync(dto);
            return CreatedAtAction(
                nameof(ObtenerUsuarioPorId), 
                new { id = nuevoUsuario.IdUsuario },
                new ApiResponse<UsuarioDetalleDto>(nuevoUsuario, "Usuario creado exitosamente")
            );
        }

        [HttpPut("users/{id}")]
        public async Task<IActionResult> ActualizarUsuario(int id, [FromBody] ActualizarUsuarioDto dto)
        {
            if (id != dto.IdUsuario)
                throw new ArgumentException("El ID del usuario no coincide.");

            var usuarioActualizado = await _usuarioService.ActualizarUsuarioAsync(dto);
            return Ok(new ApiResponse<UsuarioDetalleDto>(usuarioActualizado, "Usuario actualizado exitosamente"));
        }

        [HttpPatch("users/{id}/status")]
        public async Task<IActionResult> CambiarEstado(int id, [FromBody] CambiarEstadoUsuarioDto dto)
        {
            if (id != dto.IdUsuario)
                throw new ArgumentException("El ID del usuario no coincide.");

            var resultado = await _usuarioService.CambiarEstadoAsync(id, dto.Activo);
            return Ok(new ApiResponse<bool>(resultado, "Estado del usuario actualizado exitosamente"));
        }

        [HttpPatch("users/{id}/change-password")]
        public async Task<IActionResult> CambiarPassword(int id, [FromBody] CambiarPasswordUsuarioDto dto)
        {
            if (id != dto.IdUsuario)
                throw new ArgumentException("El ID del usuario no coincide.");

            var resultado = await _usuarioService.CambiarPasswordAsync(dto);
            return Ok(new ApiResponse<bool>(resultado, "Contraseña cambiada exitosamente"));
        }
    }
}
