using DTOs.IAM.Permisos;
using DTOs.IAM.Roles;

namespace Repositories.IAM
{
    public interface IRolRepository
    {
        Task<RolDto> CrearAsync(CrearRolDto dto, string usuarioCreacion);
        Task<RolDto> ActualizarAsync(ActualizarRolDto dto, string usuarioModificacion);
        Task<bool> CambiarEstadoAsync(int idRol, bool activo, string usuarioModificacion);
        Task<bool> EliminarAsync(int idRol, string usuarioModificacion);
        Task<RolDto> ObtenerPorIdAsync(int idRol);
        Task<IEnumerable<RolDto>> ListarAsync(bool soloActivos = true, bool incluirEliminados = false, int? idEmpresa = null, bool excluirSuperAdmin = false);
        Task<IEnumerable<PermisoDto>> ObtenerPermisosAsync(int idRol);
        Task<IEnumerable<PermisoDto>> AsignarPermisosAsync(int idRol, List<int> permisosIds, string usuarioModificacion);
    }
}
