namespace DTOs.IAM.Roles
{
    public class CrearRolDto
    {
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public bool EsSistema { get; set; }
        public int? IdEmpresa { get; set; }
    }
}
