namespace DTOs.Reclamos.Request
{
    public class ActualizarReclamoDto
    {
        // Reclamante
        public string? TipoPersona { get; set; }
        public string? TipoDocumento { get; set; }
        public string? NumeroDocumento { get; set; }
        public string? NombresReclamante { get; set; }
        public string? ApellidosReclamante { get; set; }
        public DateTime? FechaNacimiento { get; set; }
        public string? RazonSocial { get; set; }
        public string? RepresentanteLegalNombres { get; set; }
        public string? RepresentanteLegalDNI { get; set; }
        public string? EmailReclamante { get; set; }
        public string? TelefonoReclamante { get; set; }
        public string? OtroTelefono { get; set; }
        public string? DireccionReclamante { get; set; }
        
        // Canal
        public string? TipoCanal { get; set; }

        // Entidad y producto
        public int? IdEntidadFinancieraEmpresa { get; set; }
        public int? IdTipoProducto { get; set; }
        public string? NumeroProducto { get; set; }
        public string? NumeroReclamoEntidad { get; set; }
        public DateTime? FechaRegistroEntidad { get; set; }

        // Tipo y motivo
        public int? IdTipoRequerimiento { get; set; }
        public int? IdMotivoReclamo { get; set; }

        // Hechos
        public DateTime? FechaHechos { get; set; }
        public TimeSpan? HoraHechos { get; set; }
        public string? DescripcionHechos { get; set; }
        public string? Caso { get; set; }
        public decimal? MontoReclamado { get; set; }
        public string? MonedaReclamado { get; set; }

        // Solución
        public string? SolucionSolicitada { get; set; }
        public string? ResultadoEsperado { get; set; }

        // Reclamo en otra instancia
        public bool? PresentoReclamoOtraInstancia { get; set; }
        public int? IdInstancia { get; set; }
        public DateTime? FechaPresentacionOtraInstancia { get; set; }

        // Fuente
        public int? IdFuente { get; set; }
        public string? ComoSeEnteroAlobanco { get; set; }
    }
}
