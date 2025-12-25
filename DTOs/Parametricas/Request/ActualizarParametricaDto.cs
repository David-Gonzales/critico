using System.ComponentModel.DataAnnotations;

namespace DTOs.Parametricas.Request
{
    public class ActualizarParametricaDto
    {
        [StringLength(100)]
        public string? Alias { get; set; }

        [StringLength(500)]
        public string? Nombre { get; set; }

        public string? Valor { get; set; }

        [StringLength(1000)]
        public string? Descripcion { get; set; }

        public int? Orden { get; set; }
    }
}
