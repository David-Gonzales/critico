namespace DTOs.IAM.Usuarios
{
    public class ActualizarUsuarioDto
    {
        public int IdUsuario { get; set; }
        public string NombreUsuario { get; set; }
        public string Email { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Telefono { get; set; }
        public string DocumentoIdentidad { get; set; }
        public List<int> RolesIds { get; set; } = new List<int>();
        public List<int> EmpresasIds { get; set; } = new List<int>();
    }
}
