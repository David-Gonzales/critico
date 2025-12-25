using System.ComponentModel.DataAnnotations;

namespace DTOs.Estados.Request
{
    public class ReordenarEstadosDto
    {
        [Required(ErrorMessage = "Debe proporcionar el nuevo orden de estados")]
        [MinLength(1, ErrorMessage = "Debe proporcionar al menos un estado")]
        public List<EstadoOrdenDto> Estados { get; set; }
    }
    public class EstadoOrdenDto
    {
        [Required]
        public int IdReclamoEstado { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "El orden debe ser mayor a 0")]
        public int Orden { get; set; }
    }
}
