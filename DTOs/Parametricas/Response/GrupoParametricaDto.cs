namespace DTOs.Parametricas.Response
{
    public class GrupoParametricaDto
    {
        public int IdGrupoParametrica { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string? Descripcion { get; set; }
        public string TipoGrupo { get; set; } // "DOMINIO" o "APLICACION"
        public int? IdEmpresa { get; set; }
        public string? NombreEmpresa { get; set; }
        public int TotalParametricas { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string? EditadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
