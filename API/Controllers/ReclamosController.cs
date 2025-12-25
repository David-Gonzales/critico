using DTOs.Common;
using DTOs.Reclamos.Request;
using DTOs.Reclamos.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.Reclamos;

namespace API.Controllers
{
    [ApiController]
    [Route("api/complaints")]
    [Authorize]
    public class ReclamosController : ControllerBase
    {
        private readonly IReclamoService _reclamoService;
        public ReclamosController(IReclamoService reclamoService)
        {
            _reclamoService = reclamoService;
        }


        [HttpPost("")]
        public async Task<IActionResult> CrearReclamo([FromBody] CrearReclamoDto dto)
        {
            var nuevoReclamo = await _reclamoService.CrearReclamoAsync(dto);
            return CreatedAtAction(
                nameof(ObtenerReclamoPorId),
                new { id = nuevoReclamo.IdReclamo },
                new ApiResponse<ReclamoDto>(nuevoReclamo, "Reclamo creado exitosamente")
            );
        }


        [HttpGet("")]
        public async Task<IActionResult> ListarReclamos(
            [FromQuery] int? idEmpresa = null,
            [FromQuery] int? idEstado = null,
            [FromQuery] int? idEntidadFinancieraEmpresa = null,
            [FromQuery] int? idUsuarioAsignado = null,
            [FromQuery] string? numeroDocumento = null,
            [FromQuery] string? codigoReclamo = null,
            [FromQuery] DateTime? fechaDesde = null,
            [FromQuery] DateTime? fechaHasta = null,
            [FromQuery] bool soloActivos = true)
        {
            var reclamos = await _reclamoService.ListarReclamosAsync(
                idEmpresa,
                idEstado,
                idEntidadFinancieraEmpresa,
                idUsuarioAsignado,
                numeroDocumento,
                codigoReclamo,
                fechaDesde,
                fechaHasta,
                soloActivos
            );
            return Ok(new ApiResponse<IEnumerable<ReclamoListDto>>(reclamos, "Reclamos obtenidos exitosamente"));
        }


        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerReclamoPorId(int id)
        {
            var reclamo = await _reclamoService.ObtenerReclamoPorIdAsync(id);
            return Ok(new ApiResponse<ReclamoDto>(reclamo, "Reclamo obtenido exitosamente"));

        }


        [HttpGet("/status/{doc}/{code}")]
        [AllowAnonymous]
        public async Task<IActionResult> ConsultarEstadoReclamoPublico(string doc, string code)
        {
            var estadoReclamo = await _reclamoService.ConsultarEstadoReclamoPublicoAsync(doc, code);
            if (estadoReclamo == null)
                return NotFound(new ApiResponse<string>("Reclamo no encontrado"));

            return Ok(new ApiResponse<ConsultaEstadoReclamoDto>(estadoReclamo, "Estado del reclamo obtenido exitosamente"));
        }


        [HttpPost("/{id}/files")]
        public async Task<IActionResult> SubirArchivo(int id, [FromForm] IFormFile archivo)
        {
            if (archivo == null || archivo.Length == 0)
                return BadRequest(new ApiResponse<object>(null, "No se proporcionó ningún archivo"));

            // Crear DTO con el stream del archivo
            var dto = new SubirArchivoReclamoDto
            {
                NombreArchivo = archivo.FileName,
                ContentType = archivo.ContentType,
                TamañoBytes = archivo.Length,
                ArchivoStream = archivo.OpenReadStream()
            };

            var archivoSubido = await _reclamoService.SubirArchivoAsync(id, dto);

            return Ok(new ApiResponse<ReclamoArchivoDto>(
                archivoSubido,
                "Archivo subido exitosamente"
            ));
        }

        [HttpGet("{id}/files")]
        public async Task<IActionResult> ListarArchivos(int id)
        {
            var archivos = await _reclamoService.ObtenerArchivosAsync(id);
            return Ok(new ApiResponse<List<ReclamoArchivoDto>>(archivos, "Archivos obtenidos exitosamente"));
        }

        
        [HttpGet("/{id}/files/{fileId}")]
        public async Task<IActionResult> DescargarArchivo(int id, int fileId)
        {
            var (fileStream, contentType, fileName) = await _reclamoService.DescargarArchivoAsync(id, fileId);
            return File(fileStream, contentType, fileName);
        }


        [HttpPatch("{id}/assign")]
        public async Task<IActionResult> AsignarReclamo(int id, [FromBody] AsignarReclamoDto dto)
        {
            var reclamoAsignado = await _reclamoService.AsignarReclamoAsync(id, dto);
            return Ok(new ApiResponse<ReclamoDto>(reclamoAsignado, "Reclamo asignado exitosamente"));
        }


        [HttpPost("{id}/validate-admission")]
        public async Task<IActionResult> ValidarAdmision(int id, [FromBody] ValidarAdmisionReclamoDto dto)
        {
            var reclamo = await _reclamoService.ValidarAdmisionAsync(id, dto);

            var mensaje = dto.EsAdmitido
                ? "Reclamo admitido exitosamente"
                : "Reclamo denegado exitosamente";

            return Ok(new ApiResponse<ReclamoDto>(reclamo, mensaje));
        }


        [HttpPost("/{id}/info-request")]
        public async Task<IActionResult> SolicitarSubsanacionInformacion(int id, [FromBody] SolicitarSubsanacionDto dto)
        {
            var reclamoActualizado = await _reclamoService.SolicitarSubsanacionAsync(id, dto);
            return Ok(new ApiResponse<ReclamoConSubsanacionDto>(reclamoActualizado, "Solicitud de subsanación enviada exitosamente"));
        }

        [HttpPost("/{id}/comments")]
        public async Task<IActionResult> AgregarComentario(int id, [FromBody] AgregarComentarioDto dto)
        {
            var comentario = await _reclamoService.AgregarComentarioAsync(id, dto);
            return Ok(new ApiResponse<ReclamoComentarioDto>(comentario, "Comentario agregado exitosamente"));
        }

        [HttpGet("{id}/comments")]
        public async Task<IActionResult> ListarComentarios(int id)
        {
            var comentarios = await _reclamoService.ObtenerComentariosAsync(id);
            return Ok(new ApiResponse<List<ReclamoComentarioDto>>(comentarios, "Comentarios obtenidos exitosamente"));
        }

        [HttpGet("{id}/history")]
        public async Task<IActionResult> ObtenerHistorialEstados(int id)
        {
            var historial = await _reclamoService.ObtenerHistorialEstadosAsync(id);
            return Ok(new ApiResponse<List<ReclamoEstadoHistorialDto>>(historial, "Historial de estados obtenido exitosamente"));
        }

        [HttpPatch("{id}/status")]
        public async Task<IActionResult> CambiarEstado(int id, [FromBody] CambiarEstadoReclamoDto request)
        {
            var reclamo = await _reclamoService.CambiarEstadoAsync(id, request);
            return Ok(new ApiResponse<ReclamoDto>(reclamo, "Estado actualizado exitosamente"));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> ActualizarReclamo(int id, [FromBody] ActualizarReclamoDto dto)
        {
            var reclamo = await _reclamoService.ActualizarReclamoAsync(id, dto);
            return Ok(new ApiResponse<ReclamoDto>(reclamo, "Reclamo actualizado exitosamente"));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> EliminarReclamo(int id)
        {
            await _reclamoService.EliminarReclamoAsync(id);
            return Ok(new ApiResponse<object>(null, "Reclamo eliminado exitosamente"));
        }
    }
}
