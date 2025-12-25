namespace DTOs.IAM.Auth.Firma
{
    public class DocumentoFirmaDto
    {
        public int IdDocumentoFirma { get; set; }
        public string TipoDocumento { get; set; }
        public int IdDocumento { get; set; }
        public int IdFirma { get; set; }
        public int IdUsuarioFirmante { get; set; }
        public string NombreUsuarioFirmante { get; set; }
        public bool PasswordValidado { get; set; }
        public string MetodoValidacion { get; set; }
        public string IpAddress { get; set; }
        public DateTime FechaFirma { get; set; }
    }
}
