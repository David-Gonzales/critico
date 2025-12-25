using System.ComponentModel.DataAnnotations;

namespace DTOs.EntidadesFinancieras.Request
{
    public class CrearContactoDto
    {
        [Required(ErrorMessage = "El nombre del contacto es requerido")]
        [StringLength(200)]
        public string NombreContacto { get; set; }

        [Required(ErrorMessage = "El email del contacto es requerido")]
        [EmailAddress(ErrorMessage = "El email no es válido")]
        [StringLength(200)]
        public string EmailContacto { get; set; }
    }
}
