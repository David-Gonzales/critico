namespace DTOs.IAM.Permisos
{
    public class ActualizarPermisoDto
    {
        public int IdPermiso { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public string Modulo { get; set; }
        public string Recurso { get; set; }
        public string Accion { get; set; }
        public int? IdEmpresa { get; set; }
    }
}
