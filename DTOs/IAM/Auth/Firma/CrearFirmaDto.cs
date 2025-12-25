namespace DTOs.IAM.Auth.Firma
{
    public class CrearFirmaDto
    {
        public int IdUsuario { get; set; }
        public string NombreCompleto { get; set; }
        public string Cargo { get; set; }
        public string DocumentoIdentidad { get; set; }
        public int? IdEntidadFinanciera { get; set; }
        public int? IdEmpresa { get; set; }
    }
}
