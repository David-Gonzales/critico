using DTOs.IAM.Usuarios;

namespace Services.IAM
{
    public interface IUsuarioService
    {
        Task<IEnumerable<UsuarioDto>> ListarUsuariosAsync(bool soloActivos = true, int? idEmpresa = null);
        Task<UsuarioDetalleDto> ObtenerUsuarioPorIdAsync(int idUsuario);
        Task<UsuarioDetalleDto> CrearUsuarioAsync(CrearUsuarioDto dto);
        Task<UsuarioDetalleDto> ActualizarUsuarioAsync(ActualizarUsuarioDto dto);
        Task<bool> CambiarPasswordAsync(CambiarPasswordUsuarioDto dto);
        Task<bool> CambiarEstadoAsync(int idUsuario, bool activo);
    }
}
