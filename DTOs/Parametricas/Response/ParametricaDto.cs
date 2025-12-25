namespace DTOs.Parametricas.Response
{
    public class ParametricaDto
    {
        public int IdParametrica { get; set; }
        public int IdGrupoParametrica { get; set; }
        public string CodigoGrupo { get; set; }
        public string NombreGrupo { get; set; }
        public string TipoGrupo { get; set; }
        public int? IdEmpresa { get; set; }
        public string? Alias { get; set; }
        public string Nombre { get; set; }
        public string? Valor { get; set; }
        public string? Descripcion { get; set; }
        public int? Orden { get; set; }
        public bool EsEliminable { get; set; }
        public bool EnUso { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string? EditadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
