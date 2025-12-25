using Common.Settings;
using Dapper;
using DTOs.Menus;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.Menus
{
    public class MenuRepository : IMenuRepository
    {
        private readonly string _connectionString;

        public MenuRepository(DatabaseSettings databaseSettings)
        {
            _connectionString = databaseSettings.GetConnectionString;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public async Task<IEnumerable<MenuDto>> ListarAsync(bool soloActivos, bool incluirEliminados = false, int? idEmpresa = null)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                SoloActivos = soloActivos,
                IncluirEliminados = incluirEliminados,
                IdEmpresa = idEmpresa
            };

            return await connection.QueryAsync<MenuDto>(
                "sp_Menu_Listar",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }
    }
}
