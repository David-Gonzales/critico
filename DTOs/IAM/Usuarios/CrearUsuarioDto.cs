namespace DTOs.IAM.Usuarios
{
    public class CrearUsuarioDto
    {
        public string NombreUsuario { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string? Telefono { get; set; }
        public string? DocumentoIdentidad { get; set; }
        public int? IdEmpresa { get; set; }
        public List<int> RolesIds { get; set; } = new List<int>();
        public List<int> EmpresasIds { get; set; } = new List<int>();
    }
}
