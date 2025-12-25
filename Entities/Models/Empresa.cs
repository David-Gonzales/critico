namespace Common.Models
{
    public class Empresa : AuditableBase
    {
        public int IdEmpresa { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }

    }
}
