using DTOs.Parametricas.Request;
using DTOs.Parametricas.Response;

namespace Services.Parametricas
{
    public interface IParametricaService
    {
        // Grupos
        Task<List<GrupoParametricaDto>> ListarGruposAsync(int? idEmpresa = null, string? tipoGrupo = null, bool soloActivos = true);
        Task<GrupoParametricaDto> ObtenerGrupoPorIdAsync(int idGrupoParametrica);

        // Paramétricas
        Task<List<ParametricaDto>> ListarParametricasAsync(int? idGrupoParametrica = null, string? nombre = null, string? dominio = null, bool? estado = null, bool soloActivos = true);
        Task<ParametricaDto> ObtenerParametricaPorIdAsync(int idParametrica);
        Task<ParametricaDto> CrearParametricaAsync(CrearParametricaDto dto);
        Task<ParametricaDto> ActualizarParametricaAsync(int idParametrica, ActualizarParametricaDto dto);
        Task<bool> EliminarParametricaAsync(int idParametrica);
        Task<ParametricaDto> CambiarEstadoParametricaAsync(int idParametrica, CambiarEstadoParametricaDto dto);
    }
}
