using DTOs.IAM.Permisos;

namespace Repositories.IAM
{
    public interface IPermisoRepository
    {
        Task<PermisoDto> CrearAsync(CrearPermisoDto dto, string creadoPor);
        Task<PermisoDto> ActualizarAsync(ActualizarPermisoDto dto, string editadoPor);
        Task<bool> CambiarEstadoAsync(int idPermiso, bool activo, string editadoPor);
        Task<bool> EliminarAsync(int idPermiso, string editadoPor);
        Task<PermisoDto> ObtenerPorIdAsync(int idPermiso);
        Task<IEnumerable<PermisoDto>> ListarAsync(bool soloActivos, bool incluirEliminados = false, int? idEmpresa = null);
    }
}
