using DTOs.Common;
using DTOs.Menus;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.Menus;

namespace API.Controllers
{
    [ApiController]
    [Route("api/menu")]
    [Authorize]
    public class MenusController : ControllerBase
    {
        private readonly IMenuService _menuService;

        public MenusController(IMenuService menuService)
        {
            _menuService = menuService;
        }

        [HttpGet("menus")]
        public async Task<IActionResult> ListarMenus([FromQuery] bool soloActivos = true, int? idEmpresa = null)
        {
            var menus = await _menuService.ListarMenusAsync(soloActivos, idEmpresa);
            return Ok(new ApiResponse<IEnumerable<MenuDto>>(menus, "Menús obtenidos exitosamente"));
        }
    }
}
