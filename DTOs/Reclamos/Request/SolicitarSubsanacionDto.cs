using System.ComponentModel.DataAnnotations;

namespace DTOs.Reclamos.Request
{
    public class SolicitarSubsanacionDto
    {
        [Required(ErrorMessage = "Debe especificar qué información se requiere")]
        [StringLength(5000, ErrorMessage = "La solicitud no puede exceder 5000 caracteres")]
        public string InformacionRequerida { get; set; }

        [Required(ErrorMessage = "Debe especificar un plazo para la subsanación")]
        [Range(1, 30, ErrorMessage = "El plazo debe ser entre 1 y 30 días")]
        public int DiasParaSubsanar { get; set; }

        [StringLength(5000, ErrorMessage = "Las observaciones no pueden exceder 5000 caracteres")]
        public string? Observaciones { get; set; }
    }
}
