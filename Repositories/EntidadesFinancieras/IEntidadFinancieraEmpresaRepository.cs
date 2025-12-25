using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;

namespace Repositories.EntidadesFinancieras
{
    public interface IEntidadFinancieraEmpresaRepository
    {
        Task<List<EntidadFinancieraEmpresaDto>> ListarPorEmpresaAsync(int idEmpresa, bool soloActivos = true, bool soloVisibles = true);
        Task<EntidadFinancieraEmpresaDto?> ObtenerPorIdAsync(int idEntidadFinancieraEmpresa, bool incluirRelaciones = false);
        Task<EntidadFinancieraEmpresaDto> AsignarEntidadAsync(int idEmpresa, AsignarEntidadFinancieraDto dto, string creadoPor);
        Task<EntidadFinancieraEmpresaDto> ActualizarConfigAsync(int idEntidadFinancieraEmpresa, ActualizarConfigEntidadDto dto, string editadoPor);
        Task<bool> DesasignarEntidadAsync(int idEntidadFinancieraEmpresa, string eliminadoPor);
        Task<EntidadFinancieraEmpresaDto> CambiarEstadoAsync(int idEntidadFinancieraEmpresa, bool activo, string editadoPor);

        // Contactos
        Task<List<ContactoDto>> ObtenerContactosAsync(int idEntidadFinancieraEmpresa);
        Task<ContactoDto> AgregarContactoAsync(int idEntidadFinancieraEmpresa, CrearContactoDto dto, string creadoPor);
        Task<bool> EliminarContactoAsync(int idContacto, string eliminadoPor);

        // Dominios
        Task<List<DominioDto>> ObtenerDominiosAsync(int idEntidadFinancieraEmpresa);
        Task<DominioDto> AgregarDominioAsync(int idEntidadFinancieraEmpresa, CrearDominioDto dto, string creadoPor);
        Task<bool> EliminarDominioAsync(int idDominio, string eliminadoPor);
    }
}
