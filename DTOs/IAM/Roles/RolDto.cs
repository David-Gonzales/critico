namespace DTOs.IAM.Roles
{
    public class RolDto
    {
        public int IdRol { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public bool EsSistema { get; set; }
        public int? IdEmpresa { get; set; }
        public string? NombreEmpresa { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string EditadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
