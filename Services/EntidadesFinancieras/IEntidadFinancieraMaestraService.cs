using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;

namespace Services.EntidadesFinancieras
{
    public interface IEntidadFinancieraMaestraService
    {
        Task<List<EntidadFinancieraMaestraDto>> ListarEntidadesAsync(bool soloActivos = true);
        Task<EntidadFinancieraMaestraDto> ObtenerEntidadPorIdAsync(int idEntidadFinanciera);
        Task<EntidadFinancieraMaestraDto> CrearEntidadAsync(CrearEntidadFinancieraMaestraDto dto);
        Task<EntidadFinancieraMaestraDto> ActualizarEntidadAsync(int idEntidadFinanciera, ActualizarEntidadFinancieraMaestraDto dto);
        Task<bool> EliminarEntidadAsync(int idEntidadFinanciera);
        Task<EntidadFinancieraMaestraDto> CambiarEstadoAsync(int idEntidadFinanciera, CambiarEstadoDto dto);
    }
}
