using Common.Models;
using DTOs.IAM.Auth;
using System.Security.Claims;

namespace Services.IAM
{
    public interface IJwtService
    {
        string GenerarToken(Usuario usuario, List<string> roles, List<EmpresaDto> empresas);
        string GenerarRefreshToken();
        ClaimsPrincipal? ValidarToken(string token, bool ignoreExpiration = false);
    }
}
