using Microsoft.AspNetCore.Http;

namespace Services.Common
{
    public static class TenantHelper
    {
        public static List<int> ObtenerEmpresasUsuarioActual(HttpContext httpContext)
        {
            var tenantIds = httpContext?.Items["TenantIds"] as List<int>;
            return tenantIds ?? new List<int>();
        }

        public static int? ObtenerEmpresaPrincipal(HttpContext httpContext)
        {
            var empresas = ObtenerEmpresasUsuarioActual(httpContext);
            return empresas.FirstOrDefault() == 0 ? null : empresas.FirstOrDefault();
        }

        public static bool EsSuperAdmin(HttpContext httpContext)
        {
            var empresas = ObtenerEmpresasUsuarioActual(httpContext);
            return empresas.Count > 1;
        }

        public static bool TieneAccesoAEmpresa(HttpContext httpContext, int idEmpresa)
        {
            var empresas = ObtenerEmpresasUsuarioActual(httpContext);
            return empresas.Count == 0 || empresas.Contains(idEmpresa);
        }
    }
}
