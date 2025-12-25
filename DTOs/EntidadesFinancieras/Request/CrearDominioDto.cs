using System.ComponentModel.DataAnnotations;

namespace DTOs.EntidadesFinancieras.Request
{
    public class CrearDominioDto
    {
        [Required(ErrorMessage = "El dominio es requerido")]
        [StringLength(200)]
        [RegularExpression(@"^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z]{2,})+$",
            ErrorMessage = "El dominio no tiene un formato válido")]
        public string Dominio { get; set; }
    }
}
