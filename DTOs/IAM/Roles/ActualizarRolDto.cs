namespace DTOs.IAM.Roles
{
    public class ActualizarRolDto
    {
        public int IdRol { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public int? IdEmpresa { get; set; }
    }
}
