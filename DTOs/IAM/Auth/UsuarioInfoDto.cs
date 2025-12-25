namespace DTOs.IAM.Auth
{
    public class UsuarioInfoDto
    {
        public int IdUsuario { get; set; }
        public string NombreUsuario { get; set; }
        public string Email { get; set; }
        public string NombreCompleto { get; set; }
        public List<string> Roles { get; set; }
        public List<EmpresaDto> Empresas { get; set; }
    }
}
