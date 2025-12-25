using Common.Exceptions;
using Common.Interfaces;
using Common.Settings;
using Dapper;
using DTOs.Parametricas.Request;
using DTOs.Parametricas.Response;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.Parametricas
{
    public class ParametricaRepository : IParametricaRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public ParametricaRepository(
            DatabaseSettings databaseSettings,
            IDateTimeService dateTimeService)
        {
            _connectionString = databaseSettings.GetConnectionString;
            _dateTimeService = dateTimeService;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        // Grupo de paramétricas
        public async Task<List<GrupoParametricaDto>> ListarGruposAsync(
            int? idEmpresa = null,
            string? tipoGrupo = null,
            bool soloActivos = true)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEmpresa", idEmpresa);
            parameters.Add("@TipoGrupo", tipoGrupo);
            parameters.Add("@SoloActivos", soloActivos);

            var grupos = await connection.QueryAsync<GrupoParametricaDto>(
                "sp_GrupoParametrica_Listar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return grupos.ToList();
        }

        public async Task<GrupoParametricaDto?> ObtenerGrupoPorIdAsync(int idGrupoParametrica)
        {
            using var connection = CreateConnection();

            var grupo = await connection.QueryFirstOrDefaultAsync<GrupoParametricaDto>(
                "sp_GrupoParametrica_ObtenerPorId",
                new { IdGrupoParametrica = idGrupoParametrica },
                commandType: CommandType.StoredProcedure
            );

            return grupo;
        }

        // Paramétricas
        public async Task<List<ParametricaDto>> ListarParametricasAsync(
            int? idGrupoParametrica = null,
            string? nombre = null,
            string? dominio = null,
            int? idEmpresa = null,
            bool? estado = null,
            bool soloActivos = true)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdGrupoParametrica", idGrupoParametrica);
            parameters.Add("@Nombre", nombre);
            parameters.Add("@Dominio", dominio);
            parameters.Add("@IdEmpresa", idEmpresa);
            parameters.Add("@Estado", estado);
            parameters.Add("@SoloActivos", soloActivos);

            var parametricas = await connection.QueryAsync<ParametricaDto>(
                "sp_Parametrica_Listar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return parametricas.ToList();
        }

        public async Task<ParametricaDto?> ObtenerParametricaPorIdAsync(int idParametrica)
        {
            using var connection = CreateConnection();

            var parametrica = await connection.QueryFirstOrDefaultAsync<ParametricaDto>(
                "sp_Parametrica_ObtenerPorId",
                new { IdParametrica = idParametrica },
                commandType: CommandType.StoredProcedure
            );

            return parametrica;
        }

        public async Task<ParametricaDto> CrearParametricaAsync(CrearParametricaDto dto, string creadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdGrupoParametrica", dto.IdGrupoParametrica);
            parameters.Add("@Alias", dto.Alias);
            parameters.Add("@Nombre", dto.Nombre);
            parameters.Add("@Valor", dto.Valor);
            parameters.Add("@Descripcion", dto.Descripcion);
            parameters.Add("@Orden", dto.Orden);
            parameters.Add("@EsEliminable", dto.EsEliminable);
            parameters.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parameters.Add("@CreadoPor", creadoPor);

            var parametrica = await connection.QueryFirstOrDefaultAsync<ParametricaDto>(
                "sp_Parametrica_Crear",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return parametrica ?? throw new ApiException("Error al crear la paramétrica");
        }

        public async Task<ParametricaDto> ActualizarParametricaAsync(
            int idParametrica,
            ActualizarParametricaDto dto,
            string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdParametrica", idParametrica);
            parameters.Add("@Alias", dto.Alias);
            parameters.Add("@Nombre", dto.Nombre);
            parameters.Add("@Valor", dto.Valor);
            parameters.Add("@Descripcion", dto.Descripcion);
            parameters.Add("@Orden", dto.Orden);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            var parametrica = await connection.QueryFirstOrDefaultAsync<ParametricaDto>(
                "sp_Parametrica_Actualizar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return parametrica ?? throw new ApiException("Error al actualizar la paramétrica");
        }

        public async Task<bool> EliminarParametricaAsync(int idParametrica, string eliminadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdParametrica", idParametrica);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EliminadoPor", eliminadoPor);

            try
            {
                var result = await connection.QueryFirstOrDefaultAsync<int>(
                    "sp_Parametrica_Eliminar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return result == 1;
            }
            // Código del RAISERROR en caso la paramétrica sea del sistema y no se pueda eliminar o si la paramétrica está en uso
            catch (SqlException ex) when (ex.Number == 50000) 
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<ParametricaDto> CambiarEstadoParametricaAsync(
            int idParametrica,
            bool activo,
            string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdParametrica", idParametrica);
            parameters.Add("@Activo", activo);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            var parametrica = await connection.QueryFirstOrDefaultAsync<ParametricaDto>(
                "sp_Parametrica_CambiarEstado",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return parametrica ?? throw new ApiException("Error al cambiar el estado de la paramétrica");
        }
    }
}
