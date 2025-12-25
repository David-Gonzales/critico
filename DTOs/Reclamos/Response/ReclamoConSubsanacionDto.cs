namespace DTOs.Reclamos.Response
{
    public class ReclamoConSubsanacionDto : ReclamoDto
    {
        public int? IdReclamoSubsanacion { get; set; }
        public string? InformacionRequerida { get; set; }
        public int? DiasParaSubsanar { get; set; }
        public DateTime? FechaLimiteSubsanacion { get; set; }
        public string? EstadoSubsanacion { get; set; }
    }
}
