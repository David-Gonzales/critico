namespace DTOs.Estados.Response
{
    public class EstadoReclamoDto
    {
        public int IdReclamoEstado { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string? Descripcion { get; set; }
        public int Orden { get; set; }
        public string Color { get; set; }
        public bool EsEstadoFinal { get; set; }
        public bool EsEliminable { get; set; }
        public bool EsEstadoSistema { get; set; }
        public int IdEmpresa { get; set; }
        public string NombreEmpresa { get; set; }
        public bool EnUso { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string? EditadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
