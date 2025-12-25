using System.ComponentModel.DataAnnotations;

namespace DTOs.Parametricas.Request
{
    public class CambiarEstadoParametricaDto
    {
        [Required(ErrorMessage = "El estado es requerido")]
        public bool Activo { get; set; }
    }
}
