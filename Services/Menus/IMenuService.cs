using DTOs.Menus;

namespace Services.Menus
{
    public interface IMenuService
    {
        Task<IEnumerable<MenuDto>> ListarMenusAsync(bool soloActivos, int? idEmpresa = null);
    }
}
