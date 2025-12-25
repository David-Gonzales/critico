using System.ComponentModel.DataAnnotations;

namespace DTOs.Reclamos.Request
{
    public class CambiarEstadoReclamoDto
    {
        [Required(ErrorMessage = "El nuevo estado es requerido")]
        public int IdEstadoNuevo { get; set; }

        public string? Motivo { get; set; }
        public string? Observaciones { get; set; }
    }
}
