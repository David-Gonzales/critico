namespace DTOs.EntidadesFinancieras.Response
{
    public class DominioDto
    {
        public int IdEntidadFinancieraDominio { get; set; }
        public int IdEntidadFinancieraEmpresa { get; set; }
        public string Dominio { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
