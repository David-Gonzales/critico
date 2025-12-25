using DTOs.IAM.Permisos;
using DTOs.IAM.Roles;

namespace Services.IAM
{
    public interface IRolService
    {
        Task<RolDto> CrearRolAsync(CrearRolDto dto);
        Task<RolDto> ActualizarRolAsync(ActualizarRolDto dto);
        Task<bool> CambiarEstadoRolAsync(int idRol, bool activo);
        Task<bool> EliminarRolAsync(int idRol);
        Task<IEnumerable<RolDto>> ListarRolesAsync(bool soloActivos, int? idEmpresa = null);
        Task<RolConPermisosDto> ObtenerRolConPermisosAsync(int idRol);
        Task<IEnumerable<PermisoDto>> AsignarPermisosAsync(int idRol, List<int> permisosIds);
    }
}
