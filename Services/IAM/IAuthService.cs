using DTOs.IAM.Auth;
using DTOs.IAM.Auth.Firma;

namespace Services.IAM
{
    public interface IAuthService
    {
        Task<LoginResponseDto> LoginAsync(LoginRequestDto request);
        Task<TokensDto> RefreshTokenAsync(RefreshTokenRequestDto request);
        Task<DocumentoFirmaDto> ValidarFirmaDigitalAsync(FirmaDigitalRequestDto dto);
    }
}
