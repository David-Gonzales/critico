using System.ComponentModel.DataAnnotations;

namespace DTOs.EntidadesFinancieras.Request
{
    public class ActualizarConfigEntidadDto
    {
        [EmailAddress(ErrorMessage = "El email de notificación no es válido")]
        [StringLength(200)]
        public string? EmailNotificacion { get; set; }

        [StringLength(20)]
        public string? Telefono { get; set; }

        [StringLength(500)]
        public string? CanalAtencion { get; set; }

        [Url(ErrorMessage = "La URL del logo no es válida")]
        [StringLength(500)]
        public string? LogoUrl { get; set; }

        [Url(ErrorMessage = "La URL del logo dark no es válida")]
        [StringLength(500)]
        public string? LogoDarkUrl { get; set; }
    }
}
