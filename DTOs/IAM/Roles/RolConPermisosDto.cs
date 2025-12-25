using DTOs.IAM.Permisos;
using System.Text.Json.Serialization;

namespace DTOs.IAM.Roles
{
    public class RolConPermisosDto : RolDto
    {
        [JsonPropertyOrder(99)]
        public List<PermisoDto> Permisos { get; set; }
    }
}
