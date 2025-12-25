using System.ComponentModel.DataAnnotations;

namespace DTOs.Reclamos.Request
{
    public class AgregarComentarioDto
    {
        [Required(ErrorMessage = "El comentario es requerido")]
        [StringLength(5000, ErrorMessage = "El comentario no puede exceder 5000 caracteres")]
        public required string Comentario { get; set; }

        [Required(ErrorMessage = "Debe especificar si el comentario es interno")]
        public bool EsInterno { get; set; }
    }
}
