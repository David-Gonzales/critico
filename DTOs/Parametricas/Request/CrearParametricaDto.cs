using System.ComponentModel.DataAnnotations;

namespace DTOs.Parametricas.Request
{
    public class CrearParametricaDto
    {
        [Required(ErrorMessage = "El grupo de paramétrica es requerido")]
        public int IdGrupoParametrica { get; set; }

        [StringLength(100)]
        public string? Alias { get; set; }

        [Required(ErrorMessage = "El nombre es requerido")]
        [StringLength(500)]
        public string Nombre { get; set; }

        public string? Valor { get; set; }

        [StringLength(1000)]
        public string? Descripcion { get; set; }

        public int? Orden { get; set; }

        public bool EsEliminable { get; set; } = true;
    }
}
