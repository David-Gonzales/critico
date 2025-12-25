using Common.Interfaces;
using Common.Settings;
using Dapper;
using DTOs.IAM.Permisos;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.IAM
{
    public class PermisoRepository : IPermisoRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public PermisoRepository(DatabaseSettings databaseSettings, IDateTimeService dateTimeService)
        {
            _connectionString = databaseSettings.GetConnectionString;
            _dateTimeService = dateTimeService;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public async Task<PermisoDto> CrearAsync(CrearPermisoDto dto, string creadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new DynamicParameters();
            parametros.Add("@Codigo", dto.Codigo);
            parametros.Add("@Nombre", dto.Nombre);
            parametros.Add("@Descripcion", dto.Descripcion);
            parametros.Add("@Modulo", dto.Modulo);
            parametros.Add("@Recurso", dto.Recurso);
            parametros.Add("@Accion", dto.Accion);
            parametros.Add("@IdEmpresa", dto.IdEmpresa);
            parametros.Add("@CreadoPor", creadoPor);
            parametros.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parametros.Add("@IdPermiso", dbType: DbType.Int32, direction: ParameterDirection.Output);

            var resultado = await connection.QueryFirstOrDefaultAsync<PermisoDto>(
                "sp_Permiso_Crear",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado;
        }

        public async Task<PermisoDto> ActualizarAsync(ActualizarPermisoDto dto, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdPermiso = dto.IdPermiso,
                Codigo = dto.Codigo,
                Nombre = dto.Nombre,
                Descripcion = dto.Descripcion,
                Modulo = dto.Modulo,
                Recurso = dto.Recurso,
                Accion = dto.Accion,
                IdEmpresa = dto.IdEmpresa,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            return await connection.QueryFirstOrDefaultAsync<PermisoDto>(
                "sp_Permiso_Actualizar",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<bool> CambiarEstadoAsync(int idPermiso, bool activo, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdPermiso = idPermiso,
                Activo = activo,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            var resultado = await connection.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Permiso_CambiarEstado",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado?.Resultado == 1;
        }

        public async Task<bool> EliminarAsync(int idPermiso, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdPermiso = idPermiso,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            var resultado = await connection.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Permiso_Eliminar",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado?.Resultado == 1;
        }

        public async Task<PermisoDto> ObtenerPorIdAsync(int idPermiso)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdPermiso = idPermiso
            };

            return await connection.QueryFirstOrDefaultAsync<PermisoDto>(
                "sp_Permiso_ObtenerPorId",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<IEnumerable<PermisoDto>> ListarAsync(bool soloActivos, bool incluirEliminados = false, int? idEmpresa = null)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                SoloActivos = soloActivos,
                IncluirEliminados = incluirEliminados,
                IdEmpresa = idEmpresa,
            };

            return await connection.QueryAsync<PermisoDto>(
                "sp_Permiso_Listar",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }
    }
}
