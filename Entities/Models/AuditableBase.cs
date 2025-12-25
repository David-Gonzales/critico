namespace Common.Models
{
    public class AuditableBase
    {
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string? EditadoPor { get; set; }

        public bool Activo { get; set; } = true;
        public bool Eliminado { get; set; } = false;
    }
}
