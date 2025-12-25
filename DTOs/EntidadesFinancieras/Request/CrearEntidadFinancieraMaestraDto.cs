using System.ComponentModel.DataAnnotations;

namespace DTOs.EntidadesFinancieras.Request
{
    public class CrearEntidadFinancieraMaestraDto
    {
        [Required(ErrorMessage = "El código es requerido")]
        [StringLength(20, ErrorMessage = "El código no puede exceder 20 caracteres")]
        public string Codigo { get; set; }

        [Required(ErrorMessage = "El nombre es requerido")]
        [StringLength(200, ErrorMessage = "El nombre no puede exceder 200 caracteres")]
        public string Nombre { get; set; }

        [StringLength(11, MinimumLength = 11, ErrorMessage = "El RUC debe tener 11 dígitos")]
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

        // Si es true, asigna automáticamente la entidad a las 2 empresas activas
        public bool AsignarATodasLasEmpresas { get; set; } = true;
    }

}
