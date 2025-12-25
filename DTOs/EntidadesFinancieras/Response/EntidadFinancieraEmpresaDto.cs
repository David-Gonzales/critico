namespace DTOs.EntidadesFinancieras.Response
{
    public class EntidadFinancieraEmpresaDto
    {
        // Datos de la asignación
        public int IdEntidadFinancieraEmpresa { get; set; }
        public int IdEntidadFinanciera { get; set; }
        public int IdEmpresa { get; set; }

        // Datos de la entidad maestra (para mostrar)
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string? RUC { get; set; }
        public string? RazonSocial { get; set; }
        public string? SitioWeb { get; set; }
        public string? DireccionMaestra { get; set; }
        public string? Descripcion { get; set; }

        // Configuración específica de la empresa
        public string? EmailNotificacion { get; set; }
        public string? Telefono { get; set; }
        public string? CanalAtencion { get; set; }
        public string? LogoUrl { get; set; }
        public string? LogoDarkUrl { get; set; }

        public bool Visible { get; set; }
        public bool Activo { get; set; }

        public string? NombreEmpresa { get; set; }

        // Relaciones con lazy loading
        public List<ContactoDto>? Contactos { get; set; }
        public List<DominioDto>? Dominios { get; set; }

        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string? EditadoPor { get; set; }
    }
}
