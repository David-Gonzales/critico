using DTOs.Menus;

namespace Repositories.Menus
{
    public interface IMenuRepository
    {
        Task<IEnumerable<MenuDto>> ListarAsync(bool soloActivos, bool incluirEliminados = false, int? idEmpresa = null);
    }
}
