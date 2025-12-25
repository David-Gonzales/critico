using System.ComponentModel.DataAnnotations;

namespace DTOs.Reclamos.Request
{
    public class ValidarAdmisionReclamoDto
    {
        [Required(ErrorMessage = "Debe indicar si el reclamo es admitido o no")]
        public bool EsAdmitido { get; set; }

        [Required(ErrorMessage = "El motivo de la decisión es requerido")]
        [StringLength(2000, ErrorMessage = "El motivo no puede exceder 2000 caracteres")]
        public string Motivo { get; set; }

        [StringLength(5000, ErrorMessage = "Las observaciones no pueden exceder 5000 caracteres")]
        public string? Observaciones { get; set; }
    }
}
