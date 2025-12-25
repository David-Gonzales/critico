namespace DTOs.EntidadesFinancieras.Response
{
    public class ContactoDto
    {
        public int IdEntidadFinancieraContacto { get; set; }
        public int IdEntidadFinancieraEmpresa { get; set; }
        public string NombreContacto { get; set; }
        public string EmailContacto { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
