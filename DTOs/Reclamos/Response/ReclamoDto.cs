namespace DTOs.Reclamos.Response
{
    public class ReclamoDto
    {
        public int IdReclamo { get; set; }
        public string CodigoReclamo { get; set; }

        // Reclamante
        public string TipoPersona { get; set; }
        public string TipoDocumento { get; set; }
        public string NumeroDocumento { get; set; }
        public string NombresReclamante { get; set; }
        public string ApellidosReclamante { get; set; }
        public string RazonSocial { get; set; }
        public string RepresentanteLegalNombres { get; set; }
        public string RepresentanteLegalDNI { get; set; }
        public string EmailReclamante { get; set; }
        public string TelefonoReclamante { get; set; }
        public string OtroTelefono { get; set; }
        public string DireccionReclamante { get; set; }
        public DateTime? FechaNacimiento { get; set; }

        // Canal
        public string TipoCanal { get; set; }

        // Entidad y producto
        public int IdEntidadFinancieraEmpresa { get; set; }
        public int IdEntidadFinanciera { get; set; }
        public string NombreEntidadFinanciera { get; set; }
        public string CodigoEntidad { get; set; }
        public string RUCEntidad { get; set; }
        public string LogoEntidad { get; set; }
        public string EmailEntidad { get; set; }

        public int? IdTipoProducto { get; set; }
        public string NombreTipoProducto { get; set; }
        public string NumeroProducto { get; set; }
        public string NumeroReclamoEntidad { get; set; }
        public DateTime? FechaRegistroEntidad { get; set; }

        // Tipo y motivo
        public int? IdTipoRequerimiento { get; set; }
        public string NombreTipoRequerimiento { get; set; }
        public int? IdMotivoReclamo { get; set; }
        public string NombreMotivoReclamo { get; set; }

        // Hechos
        public DateTime FechaHechos { get; set; }
        public TimeSpan? HoraHechos { get; set; }
        public string DescripcionHechos { get; set; }
        public string Caso { get; set; }
        public decimal? MontoReclamado { get; set; }
        public string MonedaReclamado { get; set; }

        // Solución
        public string SolucionSolicitada { get; set; }
        public string ResultadoEsperado { get; set; }

        // Estado
        public int IdEstadoActual { get; set; }
        public string CodigoEstado { get; set; }
        public string NombreEstado { get; set; }
        public string ColorEstado { get; set; }
        public DateTime? FechaLimiteRespuesta { get; set; }
        public DateTime? FechaComunicacionAmpliacion { get; set; }
        public DateTime? FechaFinAtencion { get; set; }
        public int DiasPlazo { get; set; }
        public int DiasAmpliados { get; set; }

        // Asignación
        public int? IdUsuarioAsignado { get; set; }
        public string NombreUsuarioAsignado { get; set; }
        public string NombreCompletoAsignado { get; set; }
        public DateTime? FechaAsignacion { get; set; }

        // Resolución
        public string NumeroResolucion { get; set; }
        public DateTime? FechaResolucion { get; set; }
        public int? IdTipoRespuesta { get; set; }
        public string NombreTipoRespuesta { get; set; }

        // Reclamo en otra instancia
        public bool? PresentoReclamoOtraInstancia { get; set; }
        public int? IdInstancia { get; set; }
        public string NombreInstancia { get; set; }
        public DateTime? FechaPresentacionOtraInstancia { get; set; }

        // Fuente
        public int? IdFuente { get; set; }
        public string NombreFuente { get; set; }
        public string ComoSeEnteroAlobanco { get; set; }

        
        public int IdEmpresa { get; set; }
        public string NombreEmpresa { get; set; }

        
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string EditadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
