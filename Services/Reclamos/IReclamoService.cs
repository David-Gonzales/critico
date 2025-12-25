using DTOs.Reclamos.Request;
using DTOs.Reclamos.Response;

namespace Services.Reclamos
{
    public interface IReclamoService
    {
        Task<ReclamoDto> CrearReclamoAsync(CrearReclamoDto dto);
        Task<ReclamoDto> ObtenerReclamoPorIdAsync(int idReclamo);
        Task<List<ReclamoListDto>> ListarReclamosAsync(
            int? idEmpresa = null,
            int? idEstado = null,
            int? idEntidadFinancieraEmpresa = null,
            int? idUsuarioAsignado = null,
            string? numeroDocumento = null,
            string? codigoReclamo = null,
            DateTime? fechaDesde = null,
            DateTime? fechaHasta = null,
            bool soloActivos = true
        );
        Task<ReclamoDto> CambiarEstadoAsync(int idReclamo, CambiarEstadoReclamoDto dto);
        Task<ReclamoDto> AsignarReclamoAsync(int idReclamo, AsignarReclamoDto dto);

        //Archivos
        Task<ReclamoArchivoDto> SubirArchivoAsync(int idReclamo, SubirArchivoReclamoDto dto);
        Task<List<ReclamoArchivoDto>> ObtenerArchivosAsync(int idReclamo);
        Task<(Stream FileStream, string ContentType, string FileName)> DescargarArchivoAsync(int idReclamo, int idReclamoArchivo);

        Task<ReclamoComentarioDto> AgregarComentarioAsync(int idReclamo, AgregarComentarioDto dto);
        Task<List<ReclamoComentarioDto>> ObtenerComentariosAsync(int idReclamo);
        Task<List<ReclamoEstadoHistorialDto>> ObtenerHistorialEstadosAsync(int idReclamo);
        Task<ConsultaEstadoReclamoDto?> ConsultarEstadoReclamoPublicoAsync(string numeroDocumento, string codigoReclamo);
        Task<ReclamoDto> ActualizarReclamoAsync(int idReclamo, ActualizarReclamoDto dto);
        Task<bool> EliminarReclamoAsync(int idReclamo);

        // Admision y Subsanacion
        Task<ReclamoDto> ValidarAdmisionAsync(int idReclamo, ValidarAdmisionReclamoDto dto);
        Task<ReclamoConSubsanacionDto> SolicitarSubsanacionAsync(int idReclamo, SolicitarSubsanacionDto dto);
    }
}
