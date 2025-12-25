using DTOs.Common;
using DTOs.IAM.Auth;
using DTOs.IAM.Auth.Firma;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.IAM;

namespace API.Controllers
{
    [ApiController]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] LoginRequestDto request)
        {
            var response = await _authService.LoginAsync(request);
            return Ok( new ApiResponse<LoginResponseDto>(response) );
            
        }

        [HttpPost("refresh-token")]
        [AllowAnonymous]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequestDto request)
        {
            var response = await _authService.RefreshTokenAsync(request);
            return Ok(new ApiResponse<TokensDto>(response));
        }

        [HttpPost("verify-digital-signature")]
        [Authorize]
        public async Task<IActionResult> ValidarFirmaDigital([FromBody] FirmaDigitalRequestDto request)
        {
            var response = await _authService.ValidarFirmaDigitalAsync(request);
            return Ok(new ApiResponse<DocumentoFirmaDto>(response, "Firma digital validada exitosamente"));
        }
    }
}
