using Common.Exceptions;
using Common.Interfaces;
using Common.Settings;
using DTOs.IAM.Auth;
using DTOs.IAM.Auth.Firma;
using Microsoft.AspNetCore.Http;
using Repositories.IAM;
using System.Security.Claims;

namespace Services.IAM
{
    public class AuthService : IAuthService
    {
        private readonly IAuthRepository _authRepository;
        private readonly IFirmaRepository _firmaRepository;
        private readonly IJwtService _jwtService;
        private readonly JwtSettings _jwtSettings;
        private readonly IDateTimeService _dateTimeService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public AuthService(IAuthRepository authRepository, IFirmaRepository firmaRepository, IJwtService jwtService, JwtSettings jwtSettings, IDateTimeService dateTimeService, IHttpContextAccessor httpContextAccessor)
        {
            _authRepository = authRepository;
            _firmaRepository = firmaRepository;
            _jwtService = jwtService;
            _jwtSettings = jwtSettings;
            _dateTimeService = dateTimeService;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<LoginResponseDto> LoginAsync(LoginRequestDto request)
        {
            if (string.IsNullOrWhiteSpace(request.Email))
                throw new ApiException("El email es requerido");

            if (string.IsNullOrWhiteSpace(request.Password))
                throw new ApiException("La contraseña es requerida");

            var usuario = await _authRepository.ObtenerUsuarioPorEmailAsync(request.Email);
            if (usuario == null || !BCrypt.Net.BCrypt.Verify(request.Password, usuario.PasswordHash))
                throw new UnauthorizedAccessException("Credenciales inválidas.");

            bool passwordValido = BCrypt.Net.BCrypt.Verify(request.Password, usuario.PasswordHash);
            if (!passwordValido)
                throw new UnauthorizedAccessException("Credenciales incorrectas");

            var roles = await _authRepository.ObtenerRolesUsuarioAsync(usuario.IdUsuario);
            if (!roles.Any())
                throw new UnauthorizedAccessException("Usuario sin roles asignados");

            var empresas = await _authRepository.ObtenerEmpresasUsuarioAsync(usuario.IdUsuario);
            if (!empresas.Any())
                throw new UnauthorizedAccessException("Usuario sin empresas asignadas");


            var token = _jwtService.GenerarToken(usuario, roles, empresas);
            var refreshToken = _jwtService.GenerarRefreshToken();

            var expiracion = _dateTimeService.NowPeru.AddDays(_jwtSettings.RefreshTokenDurationInDays);
            await _authRepository.GuardarRefreshTokenAsync(usuario.IdUsuario, refreshToken, expiracion);

            return new LoginResponseDto
            {
                Token = token,
                RefreshToken = refreshToken,
                Usuario = new UsuarioInfoDto
                {
                    IdUsuario = usuario.IdUsuario,
                    NombreUsuario = usuario.NombreUsuario,
                    Email = usuario.Email,
                    NombreCompleto = $"{usuario.Nombres} {usuario.Apellidos}",
                    Roles = roles,
                    Empresas = empresas
                }
            };
        }

        public async Task<TokensDto> RefreshTokenAsync(RefreshTokenRequestDto request)
        {
            if (string.IsNullOrWhiteSpace(request.Token))
                throw new ApiException("El token es requerido");

            if (string.IsNullOrWhiteSpace(request.RefreshToken))
                throw new ApiException("El refresh token es requerido");

            var principal = _jwtService.ValidarToken(request.Token, ignoreExpiration: true);
            if (principal == null)
                throw new UnauthorizedAccessException("Token inválido.");

            var emailClaim = principal.FindFirst(ClaimTypes.Email);
            if (emailClaim == null || string.IsNullOrEmpty(emailClaim.Value))
                throw new UnauthorizedAccessException("Token inválido: no contiene email");

            var email = emailClaim.Value;

            var refreshTokenDb = await _authRepository.ObtenerRefreshTokenAsync(request.RefreshToken);
            if (refreshTokenDb == null)
                throw new UnauthorizedAccessException("Refresh token inválido");

            if (refreshTokenDb.Expiracion < _dateTimeService.NowPeru)
                throw new UnauthorizedAccessException("Refresh token expirado");

            var usuario = await _authRepository.ObtenerUsuarioPorEmailAsync(email);
            if (usuario == null)
                throw new UnauthorizedAccessException("Usuario no encontrado.");

            var roles = await _authRepository.ObtenerRolesUsuarioAsync(usuario.IdUsuario);
            if (!roles.Any())
                throw new UnauthorizedAccessException("Usuario sin roles asignados");

            var empresas = await _authRepository.ObtenerEmpresasUsuarioAsync(usuario.IdUsuario);
            if (!empresas.Any())
                throw new UnauthorizedAccessException("Usuario sin empresas asignadas");

            await _authRepository.RevocarRefreshTokenAsync(request.RefreshToken, usuario.NombreUsuario);

            var nuevoToken = _jwtService.GenerarToken(usuario, roles, empresas);
            var nuevoRefreshToken = _jwtService.GenerarRefreshToken();

            var expiracion = _dateTimeService.NowPeru.AddDays(_jwtSettings.RefreshTokenDurationInDays);
            await _authRepository.GuardarRefreshTokenAsync(usuario.IdUsuario, nuevoRefreshToken, expiracion);

            return new TokensDto
            {
                Token = nuevoToken,
                RefreshToken = nuevoRefreshToken
            };
        }

        public async Task<DocumentoFirmaDto> ValidarFirmaDigitalAsync(FirmaDigitalRequestDto dto)
        {
            var usuario = await _authRepository.ObtenerUsuarioPorEmailAsync(dto.Email);
            if (usuario == null)
                throw new ApiException("Usuario no encontrado");

            if (!usuario.Activo)
                throw new ApiException("Usuario inactivo");

            if (!BCrypt.Net.BCrypt.Verify(dto.Password, usuario.PasswordHash))
                throw new ApiException("Contraseña incorrecta");

            var firma = await _firmaRepository.ObtenerFirmaActivaPorUsuarioAsync(usuario.IdUsuario);
            if (firma == null)
                throw new ApiException("El usuario no tiene una firma registrada");

            var httpContext = _httpContextAccessor.HttpContext;
            var documentoFirma = new DocumentoFirmaDto
            {
                TipoDocumento = dto.TipoDocumento,
                IdDocumento = dto.IdDocumento,
                IdFirma = firma.IdFirma,
                IdUsuarioFirmante = usuario.IdUsuario,
                PasswordValidado = true,
                MetodoValidacion = "PASSWORD",
                IpAddress = httpContext?.Connection.RemoteIpAddress?.ToString(),
                FechaFirma = _dateTimeService.NowPeru
            };

            var resultado = await _firmaRepository.RegistrarFirmaDocumentoAsync(documentoFirma);

            return resultado;
        }
    }
}
