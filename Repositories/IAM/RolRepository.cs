using Common.Interfaces;
using Common.Settings;
using Dapper;
using DTOs.IAM.Permisos;
using DTOs.IAM.Roles;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.IAM
{
    public class RolRepository : IRolRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public RolRepository(DatabaseSettings databaseSettings, IDateTimeService dateTimeService)
        {
            _connectionString = databaseSettings.GetConnectionString;
            _dateTimeService = dateTimeService;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public async Task<RolDto> CrearAsync(CrearRolDto dto, string creadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new DynamicParameters();
            parametros.Add("@Codigo", dto.Codigo);
            parametros.Add("@Nombre", dto.Nombre);
            parametros.Add("@Descripcion", dto.Descripcion);
            parametros.Add("@EsSistema", false);
            parametros.Add("@IdEmpresa", dto.IdEmpresa);
            parametros.Add("@CreadoPor", creadoPor);
            parametros.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parametros.Add("@IdRol", dbType: DbType.Int32, direction: ParameterDirection.Output);

            var resultado = await connection.QueryFirstOrDefaultAsync<RolDto>(
                "sp_Rol_Crear",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado;
        }

        public async Task<RolDto> ActualizarAsync(ActualizarRolDto dto, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdRol = dto.IdRol,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                Descripcion = dto.Descripcion,
                IdEmpresa = dto.IdEmpresa,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            return await connection.QueryFirstOrDefaultAsync<RolDto>(
                "sp_Rol_Actualizar",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<bool> CambiarEstadoAsync(int idRol, bool activo, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdRol = idRol,
                Activo = activo,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            var resultado = await connection.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Rol_CambiarEstado",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado?.Resultado == 1;
        }

        public async Task<bool> EliminarAsync(int idRol, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdRol = idRol,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            var resultado = await connection.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Rol_Eliminar",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado?.Resultado == 1;
        }

        public async Task<RolDto> ObtenerPorIdAsync(int idRol)
        {
            using var connection = CreateConnection();

            var parametros = new 
            { 
                IdRol = idRol 
            };

            return await connection.QueryFirstOrDefaultAsync<RolDto>(
                "sp_Rol_ObtenerPorId",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }


        public async Task<IEnumerable<RolDto>> ListarAsync(bool soloActivos, bool incluirEliminados = false, int? idEmpresa = null, bool excluirSuperAdmin = false)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                SoloActivos = soloActivos,
                IncluirEliminados = incluirEliminados,
                IdEmpresa = idEmpresa,
                ExcluirSuperAdmin = excluirSuperAdmin
            };

            return await connection.QueryAsync<RolDto>(
                "sp_Rol_Listar",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<IEnumerable<PermisoDto>> ObtenerPermisosAsync(int idRol)
        {
            using var connection = CreateConnection();

            var parametros = new 
            { 
                IdRol = idRol 
            };

            return await connection.QueryAsync<PermisoDto>(
                "sp_Rol_ObtenerPermisos",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<IEnumerable<PermisoDto>> AsignarPermisosAsync(int idRol, List<int> permisosIds, string editadoPor)
        {
            using var connection = CreateConnection();

            var permisosIdsString = string.Join(",", permisosIds);

            var parametros = new
            {
                IdRol = idRol,
                PermisosIds = permisosIdsString,
                EditadoPor = editadoPor
            };

            return await connection.QueryAsync<PermisoDto>(
                "sp_Rol_AsignarPermisos",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }
    }
}
