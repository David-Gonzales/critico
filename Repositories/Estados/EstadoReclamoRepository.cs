using Common.Exceptions;
using Common.Interfaces;
using Common.Settings;
using Dapper;
using DTOs.Estados.Request;
using DTOs.Estados.Response;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Text.Json;

namespace Repositories.Estados
{
    public class EstadoReclamoRepository : IEstadoReclamoRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public EstadoReclamoRepository(DatabaseSettings databaseSettings, IDateTimeService dateTimeService)
        {
            _connectionString = databaseSettings.GetConnectionString;
            _dateTimeService = dateTimeService;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public async Task<List<EstadoReclamoDto>> ListarEstadosAsync(int? idEmpresa = null, bool soloActivos = true)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEmpresa", idEmpresa);
            parameters.Add("@SoloActivos", soloActivos);

            var estados = await connection.QueryAsync<EstadoReclamoDto>(
                "sp_ReclamoEstado_Listar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return estados.ToList();
        }

        public async Task<EstadoReclamoDto?> ObtenerEstadoPorIdAsync(int idReclamoEstado)
        {
            using var connection = CreateConnection();

            var estado = await connection.QueryFirstOrDefaultAsync<EstadoReclamoDto>(
                "sp_ReclamoEstado_ObtenerPorId",
                new { IdReclamoEstado = idReclamoEstado },
                commandType: CommandType.StoredProcedure
            );

            return estado;
        }

        public async Task<EstadoReclamoDto> CrearEstadoAsync(CrearEstadoReclamoDto dto, string creadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@Codigo", dto.Codigo);
            parameters.Add("@Nombre", dto.Nombre);
            parameters.Add("@Descripcion", dto.Descripcion);
            parameters.Add("@Orden", dto.Orden);
            parameters.Add("@Color", dto.Color);
            parameters.Add("@EsEstadoFinal", dto.EsEstadoFinal);
            parameters.Add("@EsEliminable", dto.EsEliminable);
            parameters.Add("@IdEmpresa", dto.IdEmpresa);
            parameters.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parameters.Add("@CreadoPor", creadoPor);

            try
            {
                var estado = await connection.QueryFirstOrDefaultAsync<EstadoReclamoDto>(
                    "sp_ReclamoEstado_Crear",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return estado ?? throw new ApiException("Error al crear el estado");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<EstadoReclamoDto> ActualizarEstadoAsync(int idReclamoEstado, ActualizarEstadoReclamoDto dto, string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamoEstado", idReclamoEstado);
            parameters.Add("@Codigo", dto.Codigo);
            parameters.Add("@Nombre", dto.Nombre);
            parameters.Add("@Descripcion", dto.Descripcion);
            parameters.Add("@Orden", dto.Orden);
            parameters.Add("@Color", dto.Color);
            parameters.Add("@EsEstadoFinal", dto.EsEstadoFinal);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            try
            {
                var estado = await connection.QueryFirstOrDefaultAsync<EstadoReclamoDto>(
                    "sp_ReclamoEstado_Actualizar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return estado ?? throw new ApiException("Error al actualizar el estado");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<bool> EliminarEstadoAsync(int idReclamoEstado, string eliminadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamoEstado", idReclamoEstado);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EliminadoPor", eliminadoPor);

            try
            {
                var result = await connection.QueryFirstOrDefaultAsync<int>(
                    "sp_ReclamoEstado_Eliminar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return result == 1;
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<bool> ReordenarEstadosAsync(List<EstadoOrdenDto> estados, string editadoPor)
        {
            using var connection = CreateConnection();

            //Convertir la lista de estados a JSON
            var estadosJson = JsonSerializer.Serialize(estados);

            var parameters = new DynamicParameters();
            parameters.Add("@EstadosOrden", estadosJson);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            try
            {
                var result = await connection.QueryFirstOrDefaultAsync<int>(
                    "sp_ReclamoEstado_Reordenar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return result == 1;
            }
            catch (SqlException ex)
            {
                throw new ApiException($"Error al reordenar estados: {ex.Message}");
            }

            throw new NotImplementedException();

        }
        public async Task<EstadoReclamoDto> CambiarEstadoActivoAsync(int idReclamoEstado, bool activo, string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamoEstado", idReclamoEstado);
            parameters.Add("@Activo", activo);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            var estado = await connection.QueryFirstOrDefaultAsync<EstadoReclamoDto>(
                "sp_ReclamoEstado_CambiarEstado",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return estado ?? throw new ApiException("Error al cambiar el estado activo");
        }
    }
}
