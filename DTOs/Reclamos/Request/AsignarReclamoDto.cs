using System.ComponentModel.DataAnnotations;

namespace DTOs.Reclamos.Request
{
    public class AsignarReclamoDto
    {
        [Required(ErrorMessage = "El usuario es requerido")]
        public int IdUsuarioNuevo { get; set; }

        public string? Motivo { get; set; }
        public string? Prioridad { get; set; }
    }
}
