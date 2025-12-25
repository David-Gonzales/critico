using System.ComponentModel.DataAnnotations;

namespace DTOs.Estados.Request
{
    public class ActualizarEstadoReclamoDto
    {
        [StringLength(50)]
        public string? Codigo { get; set; }

        [StringLength(100)]
        public string? Nombre { get; set; }

        [StringLength(500)]
        public string? Descripcion { get; set; }

        public int? Orden { get; set; }

        [RegularExpression(@"^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", ErrorMessage = "El color debe ser un código hexadecimal válido")]
        public string? Color { get; set; }

        public bool? EsEstadoFinal { get; set; }
    }
}
