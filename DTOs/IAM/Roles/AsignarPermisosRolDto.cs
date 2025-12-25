namespace DTOs.IAM.Roles
{
    public class AsignarPermisosRolDto
    {
        public int IdRol { get; set; }
        public List<int> PermisosIds { get; set; } = new List<int>();
    }
}
