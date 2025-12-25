namespace DTOs.IAM.Auth
{
    public class LoginResponseDto
    {
        public string Token { get; set; }
        public string RefreshToken { get; set; }
        public UsuarioInfoDto Usuario { get; set; }
    }
}
