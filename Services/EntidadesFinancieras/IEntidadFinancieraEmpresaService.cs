using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;

namespace Services.EntidadesFinancieras
{
    public interface IEntidadFinancieraEmpresaService
    {
        Task<List<EntidadFinancieraEmpresaDto>> ListarPorEmpresaAsync(int idEmpresa, bool soloActivos = true, bool soloVisibles = true);
        Task<EntidadFinancieraEmpresaDto> ObtenerPorIdAsync(int idEntidadFinancieraEmpresa, bool incluirRelaciones = false);
        Task<EntidadFinancieraEmpresaDto> AsignarEntidadAsync(int idEmpresa, AsignarEntidadFinancieraDto dto);
        Task<EntidadFinancieraEmpresaDto> ActualizarConfigAsync(int idEntidadFinancieraEmpresa, ActualizarConfigEntidadDto dto);
        Task<bool> DesasignarEntidadAsync(int idEntidadFinancieraEmpresa);
        Task<EntidadFinancieraEmpresaDto> CambiarEstadoAsync(int idEntidadFinancieraEmpresa, CambiarEstadoDto dto);

        // Contactos
        Task<List<ContactoDto>> ObtenerContactosAsync(int idEntidadFinancieraEmpresa);
        Task<ContactoDto> AgregarContactoAsync(int idEntidadFinancieraEmpresa, CrearContactoDto dto);
        Task<bool> EliminarContactoAsync(int idEntidadFinancieraEmpresa, int idContacto);

        // Dominios
        Task<List<DominioDto>> ObtenerDominiosAsync(int idEntidadFinancieraEmpresa);
        Task<DominioDto> AgregarDominioAsync(int idEntidadFinancieraEmpresa, CrearDominioDto dto);
        Task<bool> EliminarDominioAsync(int idEntidadFinancieraEmpresa, int idDominio);
    }
}
