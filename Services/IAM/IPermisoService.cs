using DTOs.IAM.Permisos;

namespace Services.IAM
{
    public interface IPermisoService
    {
        Task<PermisoDto> CrearPermisoAsync(CrearPermisoDto dto);
        Task<PermisoDto> ActualizarPermisoAsync(ActualizarPermisoDto dto);
        Task<bool> CambiarEstadoPermisoAsync(int idPermiso, bool activo);
        Task<bool> EliminarPermisoAsync(int idPermiso);
        Task<PermisoDto> ObtenerPermisoPorIdAsync(int idPermiso);
        Task<IEnumerable<PermisoDto>> ListarPermisosAsync(bool soloActivos, int? idEmpresa = null);
    }
}
