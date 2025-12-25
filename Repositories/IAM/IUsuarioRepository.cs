using DTOs.IAM.Usuarios;

namespace Repositories.IAM
{
    public interface IUsuarioRepository
    {
        Task<IEnumerable<UsuarioDto>> ListarAsync(bool soloActivos = true, bool incluirEliminados = false, int? idEmpresa = null, bool excluirSuperAdmin = false);
        Task<UsuarioDetalleDto> ObtenerPorIdAsync(int idUsuario);
        Task<UsuarioDetalleDto> CrearAsync(CrearUsuarioDto dto, string passwordHash, string creadoPor);
        Task<UsuarioDetalleDto> ActualizarAsync(ActualizarUsuarioDto dto, string editadoPor);
        Task<bool> CambiarPasswordAsync(int idUsuario, string passwordHash, string editadoPor);
        Task<bool> CambiarEstadoAsync(int idUsuario, bool activo, string editadoPor);
    }
}
