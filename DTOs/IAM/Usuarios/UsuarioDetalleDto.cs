using DTOs.IAM.Empresas;
using DTOs.IAM.Roles;

namespace DTOs.IAM.Usuarios
{
    public class UsuarioDetalleDto : UsuarioDto
    {
        public List<RolSimpleDto> Roles { get; set; } = new List<RolSimpleDto>();
        public List<EmpresaSimpleDto> Empresas { get; set; } = new List<EmpresaSimpleDto>();
    }
}
