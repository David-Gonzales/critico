using DTOs.Parametricas.Request;
using DTOs.Parametricas.Response;

namespace Repositories.Parametricas
{
    public interface IParametricaRepository
    {
        // Grupos de Paramétricas
        Task<List<GrupoParametricaDto>> ListarGruposAsync(int? idEmpresa = null, string? tipoGrupo = null, bool soloActivos = true);
        Task<GrupoParametricaDto?> ObtenerGrupoPorIdAsync(int idGrupoParametrica);

        // Paramétricas
        Task<List<ParametricaDto>> ListarParametricasAsync(int? idGrupoParametrica = null, string? nombre = null, string? dominio = null, int? idEmpresa = null, bool? estado = null, bool soloActivos = true);
        Task<ParametricaDto?> ObtenerParametricaPorIdAsync(int idParametrica);
        Task<ParametricaDto> CrearParametricaAsync(CrearParametricaDto dto, string creadoPor);
        Task<ParametricaDto> ActualizarParametricaAsync(int idParametrica, ActualizarParametricaDto dto, string editadoPor);
        Task<bool> EliminarParametricaAsync(int idParametrica, string eliminadoPor);
        Task<ParametricaDto> CambiarEstadoParametricaAsync(int idParametrica, bool activo, string editadoPor);
    }
}
