using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;
using static DTOs.EntidadesFinancieras.Response.EntidadFinancieraMaestraDto;

namespace Repositories.EntidadesFinancieras
{
    public interface IEntidadFinancieraMaestraRepository
    {
        Task<List<EntidadFinancieraMaestraDto>> ListarEntidadesAsync(bool soloActivos = true);
        Task<EntidadFinancieraMaestraDto?> ObtenerEntidadPorIdAsync(int idEntidadFinanciera);
        Task<EntidadFinancieraMaestraDto> CrearEntidadAsync(CrearEntidadFinancieraMaestraDto dto, string creadoPor);
        Task<EntidadFinancieraMaestraDto> ActualizarEntidadAsync(int idEntidadFinanciera, ActualizarEntidadFinancieraMaestraDto dto, string editadoPor);
        Task<bool> EliminarEntidadAsync(int idEntidadFinanciera, string eliminadoPor);
        Task<EntidadFinancieraMaestraDto> CambiarEstadoAsync(int idEntidadFinanciera, bool activo, string editadoPor);
    }
}
