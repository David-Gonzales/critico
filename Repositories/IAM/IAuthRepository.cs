using Common.Models;
using DTOs.IAM.Auth;

namespace Repositories.IAM
{
    public interface IAuthRepository
    {
        Task<Usuario?> ObtenerUsuarioPorEmailAsync(string email);
        Task<List<string>> ObtenerRolesUsuarioAsync(int idUsuario, int? idEmpresa = null);
        Task<List<EmpresaDto>> ObtenerEmpresasUsuarioAsync(int idUsuario);
        Task GuardarRefreshTokenAsync(int idUsuario, string token, DateTime expiracion);
        Task<RefreshToken?> ObtenerRefreshTokenAsync(string token);
        Task RevocarRefreshTokenAsync(string token, string editadoPor);
    }
}
