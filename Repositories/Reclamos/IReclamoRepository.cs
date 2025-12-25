using DTOs.Reclamos.Request;
using DTOs.Reclamos.Response;
using System.Data;

namespace Repositories.Reclamos
{
    public interface IReclamoRepository
    {
        Task<ReclamoDto> CrearReclamoAsync(CrearReclamoDto dto, string creadoPor);
        Task<ReclamoDto?> ObtenerPorIdAsync(int idReclamo, int? idEmpresa = null);
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
        Task<ReclamoDto> CambiarEstadoAsync(int idReclamo, CambiarEstadoReclamoDto dto, string cambiadoPor);
        Task<ReclamoDto> AsignarReclamoAsync(int idReclamo, AsignarReclamoDto dto, string asignadoPor);
        Task<string> GenerarCodigoReclamoAsync(int idEmpresa, IDbConnection connection,
            IDbTransaction transaction);

        //Archivos
        Task<ReclamoArchivoDto> SubirArchivoAsync(int idReclamo, SubirArchivoReclamoDto dto, string subidoPor);
        Task<List<ReclamoArchivoDto>> ObtenerArchivosAsync(int idReclamo);
        Task<ReclamoArchivoDto?> ObtenerArchivoPorIdAsync(int idReclamoArchivo);

        Task<ReclamoComentarioDto> AgregarComentarioAsync(int idReclamo, AgregarComentarioDto dto, string comentadoPor);
        Task<List<ReclamoComentarioDto>> ObtenerComentariosAsync(int idReclamo, bool incluirInternos = true);

        Task<List<ReclamoEstadoHistorialDto>> ObtenerHistorialEstadosAsync(int idReclamo);

        // Consulta pública
        Task<ConsultaEstadoReclamoDto?> ConsultarEstadoPublicoAsync(string numeroDocumento, string codigoReclamo);

        Task<ReclamoDto> ActualizarReclamoAsync(int idReclamo, ActualizarReclamoDto dto, string editadoPor);
        Task<bool> EliminarReclamoAsync(int idReclamo, string eliminadoPor);
        Task<bool> ValidarUsuarioExisteAsync(int idUsuario);
        Task<bool> ValidarUsuarioTieneAccesoEmpresaAsync(int idUsuario, int idEmpresa);

        // Validar/Denegar admisión y solicitar subsanación
        Task<ReclamoDto> ValidarAdmisionAsync(int idReclamo, ValidarAdmisionReclamoDto dto, string validadoPor);
        Task<ReclamoConSubsanacionDto> SolicitarSubsanacionAsync(int idReclamo, SolicitarSubsanacionDto dto, string solicitadoPor);

    }
}