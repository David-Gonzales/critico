using DTOs.Menus;
using Microsoft.AspNetCore.Http;
using Repositories.Menus;
using Services.Common;

namespace Services.Menus
{
    public class MenuService : IMenuService
    {
        private readonly IMenuRepository _menuRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public MenuService(IMenuRepository menuRepository, IHttpContextAccessor httpContextAccessor)
        {
            _menuRepository = menuRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<IEnumerable<MenuDto>> ListarMenusAsync(bool soloActivos, int? idEmpresa = null)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            if (!idEmpresa.HasValue)
            {
                if (!esSuperAdmin)
                    idEmpresa = TenantHelper.ObtenerEmpresaPrincipal(httpContext);
            }
            else
            {
                if (!esSuperAdmin)
                {
                    var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                    if (!empresasUsuario.Contains(idEmpresa.Value))
                        throw new UnauthorizedAccessException("No tiene acceso a la empresa solicitada.");
                }
            }

            return await _menuRepository.ListarAsync(soloActivos, incluirEliminados: false, idEmpresa);
        }
    }
}
