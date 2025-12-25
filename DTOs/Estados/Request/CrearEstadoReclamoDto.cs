using System.ComponentModel.DataAnnotations;

namespace DTOs.Estados.Request
{
    public class CrearEstadoReclamoDto
    {
        [Required(ErrorMessage = "El código es requerido")]
        [StringLength(50, ErrorMessage = "El código no puede exceder 50 caracteres")]
        public string Codigo { get; set; }

        [Required(ErrorMessage = "El nombre es requerido")]
        [StringLength(100, ErrorMessage = "El nombre no puede exceder 100 caracteres")]
        public string Nombre { get; set; }

        [StringLength(500, ErrorMessage = "La descripción no puede exceder 500 caracteres")]
        public string? Descripcion { get; set; }

        public int? Orden { get; set; }

        [Required(ErrorMessage = "El color es requerido")]
        [RegularExpression(@"^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", ErrorMessage = "El color debe ser un código hexadecimal válido (ej: #FF5733)")]
        public string Color { get; set; }

        public bool EsEstadoFinal { get; set; } = false;

        public bool EsEliminable { get; set; } = true;

        [Required(ErrorMessage = "La empresa es requerida")]
        public int IdEmpresa { get; set; }
    }
}
