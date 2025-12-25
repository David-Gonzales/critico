namespace DTOs.IAM.Auth.Firma
{
    public class FirmaDto
    {
        public int IdFirma { get; set; }

        public int IdUsuario { get; set; }
        public string NombreCompleto { get; set; }
        public string Cargo { get; set; }
        public string DocumentoIdentidad { get; set; }
        public int? IdEntidadFinanciera { get; set; }
        public string NombreEntidad { get; set; }

        public string NombreArchivo { get; set; }
        public string RutaArchivo { get; set; }
        public string ContentType { get; set; }

        public int? IdEmpresa { get; set; }
        public string NombreEmpresa { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
