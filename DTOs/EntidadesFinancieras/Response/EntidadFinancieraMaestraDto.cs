namespace DTOs.EntidadesFinancieras.Response
{
    public class EntidadFinancieraMaestraDto
    {
        public int IdEntidadFinanciera { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string? RUC { get; set; }
        public string? RazonSocial { get; set; }
        public string? SitioWeb { get; set; }
        public string? Direccion { get; set; }
        public string? Descripcion { get; set; }

        public int NumeroEmpresasAsignadas { get; set; }

        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string? EditadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
