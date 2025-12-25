using Common.Exceptions;
using Common.Interfaces;
using Common.Settings;
using Dapper;
using DTOs.EntidadesFinancieras.Request;
using DTOs.EntidadesFinancieras.Response;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.EntidadesFinancieras
{
    public class EntidadFinancieraMaestraRepository : IEntidadFinancieraMaestraRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public EntidadFinancieraMaestraRepository(
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

        public async Task<List<EntidadFinancieraMaestraDto>> ListarEntidadesAsync(bool soloActivos = true)
        {
            using var connection = CreateConnection();

            var entidades = await connection.QueryAsync<EntidadFinancieraMaestraDto>(
                "sp_EntidadFinanciera_Listar",
                new { SoloActivos = soloActivos },
                commandType: CommandType.StoredProcedure
            );

            return entidades.ToList();
        }

        public async Task<EntidadFinancieraMaestraDto?> ObtenerEntidadPorIdAsync(int idEntidadFinanciera)
        {
            using var connection = CreateConnection();

            var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraMaestraDto>(
                "sp_EntidadFinanciera_ObtenerPorId",
                new { IdEntidadFinanciera = idEntidadFinanciera },
                commandType: CommandType.StoredProcedure
            );

            return entidad;
        }

        public async Task<EntidadFinancieraMaestraDto> CrearEntidadAsync(
            CrearEntidadFinancieraMaestraDto dto,
            string creadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@Codigo", dto.Codigo);
            parameters.Add("@Nombre", dto.Nombre);
            parameters.Add("@RUC", dto.RUC);
            parameters.Add("@RazonSocial", dto.RazonSocial);
            parameters.Add("@SitioWeb", dto.SitioWeb);
            parameters.Add("@Direccion", dto.Direccion);
            parameters.Add("@Descripcion", dto.Descripcion);
            parameters.Add("@AsignarATodasLasEmpresas", dto.AsignarATodasLasEmpresas);
            parameters.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parameters.Add("@CreadoPor", creadoPor);

            try
            {
                var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraMaestraDto>(
                    "sp_EntidadFinanciera_Crear",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return entidad ?? throw new ApiException("Error al crear la entidad financiera");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<EntidadFinancieraMaestraDto> ActualizarEntidadAsync(
            int idEntidadFinanciera,
            ActualizarEntidadFinancieraMaestraDto dto,
            string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinanciera", idEntidadFinanciera);
            parameters.Add("@Codigo", dto.Codigo);
            parameters.Add("@Nombre", dto.Nombre);
            parameters.Add("@RUC", dto.RUC);
            parameters.Add("@RazonSocial", dto.RazonSocial);
            parameters.Add("@SitioWeb", dto.SitioWeb);
            parameters.Add("@Direccion", dto.Direccion);
            parameters.Add("@Descripcion", dto.Descripcion);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            try
            {
                var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraMaestraDto>(
                    "sp_EntidadFinanciera_Actualizar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return entidad ?? throw new ApiException("Error al actualizar la entidad financiera");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<bool> EliminarEntidadAsync(int idEntidadFinanciera, string eliminadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinanciera", idEntidadFinanciera);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EliminadoPor", eliminadoPor);

            try
            {
                var result = await connection.QueryFirstOrDefaultAsync<int>(
                    "sp_EntidadFinanciera_Eliminar",
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

        public async Task<EntidadFinancieraMaestraDto> CambiarEstadoAsync(
            int idEntidadFinanciera,
            bool activo,
            string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinanciera", idEntidadFinanciera);
            parameters.Add("@Activo", activo);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraMaestraDto>(
                "sp_EntidadFinanciera_CambiarEstado",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return entidad ?? throw new ApiException("Error al cambiar el estado de la entidad financiera");
        }
    }
}
