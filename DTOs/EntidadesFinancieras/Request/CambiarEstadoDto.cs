using System.ComponentModel.DataAnnotations;

namespace DTOs.EntidadesFinancieras.Request
{
    public class CambiarEstadoDto
    {
        [Required(ErrorMessage = "El estado es requerido")]
        public bool Activo { get; set; }
    }
}
