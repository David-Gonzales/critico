namespace Common.Models
{
    public class Usuario : AuditableBase
    {
        public int IdUsuario { get; set; }
        public string NombreUsuario { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string? Telefono { get; set; }
        public string? DocumentoIdentidad { get; set; }
        public int? IdEmpresa { get; set; }

        public bool RequiereDobleFactor { get; set; } = false;
        public string? SecretoDobleFactor { get; set; }

        public int IntentosFallidos { get; set; } = 0;
        public DateTime? FechaBloqueo { get; set; }
        public DateTime? UltimoAcceso { get; set; }
    }
}
