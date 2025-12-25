namespace DTOs.Reclamos.Response
{
    public class ReclamoListDto
    {
        public int IdReclamo { get; set; }
        public string CodigoReclamo { get; set; }
        public string NumeroDocumento { get; set; }
        public string NombresReclamante { get; set; }
        public string ApellidosReclamante { get; set; }
        public string RazonSocial { get; set; }
        public string EmailReclamante { get; set; }
        public string TelefonoReclamante { get; set; }
        public DateTime FechaHechos { get; set; }
        public decimal? MontoReclamado { get; set; }
        public string MonedaReclamado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime? FechaLimiteRespuesta { get; set; }
        public int DiasPlazo { get; set; }
        public int DiasAmpliados { get; set; }

        // Estado
        public string CodigoEstado { get; set; }
        public string NombreEstado { get; set; }
        public string ColorEstado { get; set; }

        // Entidad
        public int IdEntidadFinancieraEmpresa { get; set; }
        public int IdEntidadFinanciera { get; set; }
        public string NombreEntidadFinanciera { get; set; }
        public string? LogoEntidad { get; set; }

        // Empresa
        public string NombreEmpresa { get; set; }

        // Usuario asignado
        public string NombreUsuarioAsignado { get; set; }

        // Indicador de vencimiento
        public string EstadoVencimiento { get; set; }
    }
}
