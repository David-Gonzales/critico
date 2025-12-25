using System.ComponentModel.DataAnnotations;

namespace DTOs.Reclamos.Request
{
    public class CrearReclamoDto
    {
        // Reclamante
        public string? TipoPersona { get; set; }
        [Required(ErrorMessage = "El tipo de documento es requerido")]
        public required string TipoDocumento { get; set; }
        [Required(ErrorMessage = "El número de documento es requerido")]
        [StringLength(20)]
        public required string NumeroDocumento { get; set; }

        //Para persona natural
        public string? NombresReclamante { get; set; }
        public string? ApellidosReclamante { get; set; }
        public DateTime? FechaNacimiento { get; set; }

        //Para persona jurídica
        public string? RazonSocial { get; set; }
        public string? RepresentanteLegalNombres { get; set; }
        public string? RepresentanteLegalDNI { get; set; }

        //Contacto
        [Required(ErrorMessage = "El email es requerido")]
        [EmailAddress(ErrorMessage = "Email inválido")]
        public required string EmailReclamante { get; set; }

        public string? TelefonoReclamante { get; set; }
        public string? OtroTelefonoReclamante { get; set; }
        public string? DireccionReclamante { get; set; }

        // Canal(DCF)
        public string? TipoCanal { get; set; }

        // Entidad y producto
        [Required(ErrorMessage = "La entidad financiera es requerida")]
        public int IdEntidadFinancieraEmpresa { get; set; }
        public int? IdTipoProducto { get; set; }
        public string? NumeroProducto { get; set; }
        public string? NumeroReclamoEntidad { get; set; }
        public DateTime? FechaRegistroEntidad { get; set; }

        // Tipo y motivo
        public int? IdTipoRequerimiento { get; set; }
        public int? IdMotivoReclamo { get; set; }

        // Hechos
        [Required(ErrorMessage = "La fecha de los hechos es requerida")]
        public DateTime FechaHechos { get; set; }

        public TimeSpan? HoraHechos { get; set; }

        [Required(ErrorMessage = "La descripción de los hechos es requerida")]
        public required string DescripcionHechos { get; set; }

        public string? Caso { get; set; }

        public decimal? MontoReclamado { get; set; }
        public string? MonedaReclamado { get; set; }

        // Solución
        [Required(ErrorMessage = "La solución solicitada es requerida")]
        public required string SolucionSolicitada { get; set; }

        public string? ResultadoEsperado { get; set; }

        // Reclamo en otra instancia(AloBanco)
        public bool? PresentoReclamoOtraInstancia { get; set; }
        public int? IdInstancia { get; set; }
        public DateTime? FechaPresentacionOtraInstancia { get; set; }

        // Fuente(AloBanco)
        public int? IdFuente { get; set; }
        public string? ComoSeEnteroAlobanco { get; set; }

        // Empresa (multitenant)
        [Required(ErrorMessage = "La empresa es requerida")]
        public int IdEmpresa { get; set; }
    }
}
