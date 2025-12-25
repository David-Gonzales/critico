using DTOs.Estados.Request;
using DTOs.Estados.Response;

namespace Services.Estados
{
    public interface IEstadoReclamoService
    {
        Task<List<EstadoReclamoDto>> ListarEstadosAsync(int? idEmpresa = null, bool soloActivos = true);
        Task<EstadoReclamoDto> ObtenerEstadoPorIdAsync(int idReclamoEstado);
        Task<EstadoReclamoDto> CrearEstadoAsync(CrearEstadoReclamoDto dto);
        Task<EstadoReclamoDto> ActualizarEstadoAsync(int idReclamoEstado, ActualizarEstadoReclamoDto dto);
        Task<bool> EliminarEstadoAsync(int idReclamoEstado);
        Task<bool> ReordenarEstadosAsync(ReordenarEstadosDto dto);
        Task<EstadoReclamoDto> CambiarEstadoActivoAsync(int idReclamoEstado, CambiarEstadoDto dto);
    }
}
