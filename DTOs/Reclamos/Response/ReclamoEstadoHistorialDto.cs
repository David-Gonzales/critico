namespace DTOs.Reclamos.Response
{
    public class ReclamoEstadoHistorialDto
    {
        public int IdReclamoEstadoHistorialDto { get; set; }
        public int IdReclamo { get; set; }
        public int? IdEstadoAnterior { get; set; }
        public string? NombreEstadoAnterior { get; set; }
        public int IdEstadoNuevo { get; set; }
        public string NombreEstadoNuevo { get; set; }
        public string? Motivo { get; set; }
        public string? Observaciones { get; set; }
        public DateTime FechaCambio { get; set; }
        public string CambiadoPor { get; set; }
    }
}
