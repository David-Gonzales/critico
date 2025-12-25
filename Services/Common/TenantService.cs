using Microsoft.AspNetCore.Http;

namespace Services.Common
{
    public class TenantService : ITenantService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public TenantService(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public List<int> ObtenerEmpresasActuales()
        {
            var context = _httpContextAccessor.HttpContext;
            if (context?.Items["TenantIds"] is List<int> tenantIds)
            {
                return tenantIds;
            }
            return new List<int>();
        }

        public bool TieneAccesoAEmpresa(int idEmpresa)
        {
            var empresasActuales = ObtenerEmpresasActuales();
            return empresasActuales.Contains(idEmpresa);
        }
    }
}
