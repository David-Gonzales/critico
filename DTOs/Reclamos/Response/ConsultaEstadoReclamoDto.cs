namespace DTOs.Reclamos.Response
{
    //Endpoint público
    public class ConsultaEstadoReclamoDto
    {
        public string CodigoReclamo { get; set; }
        public string NumeroDocumento { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string NombreEstado { get; set; }
        public string ColorEstado { get; set; }
        public DateTime? FechaLimiteRespuesta { get; set; }
        public string NombreEntidadFinanciera { get; set; }
        public string? LogoEntidad { get; set; }
        public string? NumeroResolucion { get; set; }
        public DateTime? FechaResolucion { get; set; }
    }
}
