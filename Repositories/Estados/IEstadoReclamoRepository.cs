using DTOs.Estados.Request;
using DTOs.Estados.Response;

namespace Repositories.Estados
{
    public interface IEstadoReclamoRepository
    {
        Task<List<EstadoReclamoDto>> ListarEstadosAsync(int? idEmpresa = null, bool soloActivos = true);
        Task<EstadoReclamoDto?> ObtenerEstadoPorIdAsync(int idReclamoEstado);
        Task<EstadoReclamoDto> CrearEstadoAsync(CrearEstadoReclamoDto dto, string creadoPor);
        Task<EstadoReclamoDto> ActualizarEstadoAsync(int idReclamoEstado, ActualizarEstadoReclamoDto dto, string editadoPor);
        Task<bool> EliminarEstadoAsync(int idReclamoEstado, string eliminadoPor);
        Task<bool> ReordenarEstadosAsync(List<EstadoOrdenDto> estados, string editadoPor);
        Task<EstadoReclamoDto> CambiarEstadoActivoAsync(int idReclamoEstado, bool activo, string editadoPor);
    }
}
