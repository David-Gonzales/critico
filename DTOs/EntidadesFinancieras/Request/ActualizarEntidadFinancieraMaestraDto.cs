using System.ComponentModel.DataAnnotations;

namespace DTOs.EntidadesFinancieras.Request
{
    public class ActualizarEntidadFinancieraMaestraDto
    {
        [StringLength(20)]
        public string? Codigo { get; set; }

        [StringLength(200)]
        public string? Nombre { get; set; }

        [StringLength(11, MinimumLength = 11)]
        [RegularExpression(@"^\d{11}$", ErrorMessage = "El RUC debe contener solo números")]
        public string? RUC { get; set; }

        [StringLength(300)]
        public string? RazonSocial { get; set; }

        [Url(ErrorMessage = "El sitio web no es una URL válida")]
        [StringLength(200)]
        public string? SitioWeb { get; set; }

        [StringLength(500)]
        public string? Direccion { get; set; }

        [StringLength(1000)]
        public string? Descripcion { get; set; }
    }
}
