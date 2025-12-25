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
    public class EntidadFinancieraEmpresaRepository : IEntidadFinancieraEmpresaRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public EntidadFinancieraEmpresaRepository(
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

        public async Task<List<EntidadFinancieraEmpresaDto>> ListarPorEmpresaAsync(
            int idEmpresa,
            bool soloActivos = true,
            bool soloVisibles = true)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEmpresa", idEmpresa);
            parameters.Add("@SoloActivos", soloActivos);
            parameters.Add("@SoloVisibles", soloVisibles);

            var entidades = await connection.QueryAsync<EntidadFinancieraEmpresaDto>(
                "sp_EntidadFinancieraEmpresa_ListarPorEmpresa",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return entidades.ToList();
        }

        public async Task<EntidadFinancieraEmpresaDto?> ObtenerPorIdAsync(
            int idEntidadFinancieraEmpresa,
            bool incluirRelaciones = false)
        {
            using var connection = CreateConnection();

            var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraEmpresaDto>(
                "sp_EntidadFinancieraEmpresa_ObtenerPorId",
                new { IdEntidadFinancieraEmpresa = idEntidadFinancieraEmpresa },
                commandType: CommandType.StoredProcedure
            );

            if (entidad != null && incluirRelaciones)
            {
                // Cargo contactos y dominios
                entidad.Contactos = await ObtenerContactosAsync(idEntidadFinancieraEmpresa);
                entidad.Dominios = await ObtenerDominiosAsync(idEntidadFinancieraEmpresa);
            }

            return entidad;
        }

        public async Task<EntidadFinancieraEmpresaDto> AsignarEntidadAsync(
            int idEmpresa,
            AsignarEntidadFinancieraDto dto,
            string creadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinanciera", dto.IdEntidadFinanciera);
            parameters.Add("@IdEmpresa", idEmpresa);
            parameters.Add("@EmailNotificacion", dto.EmailNotificacion);
            parameters.Add("@Telefono", dto.Telefono);
            parameters.Add("@CanalAtencion", dto.CanalAtencion);
            parameters.Add("@LogoUrl", dto.LogoUrl);
            parameters.Add("@LogoDarkUrl", dto.LogoDarkUrl);
            parameters.Add("@Visible", dto.Visible);
            parameters.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parameters.Add("@CreadoPor", creadoPor);

            try
            {
                var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraEmpresaDto>(
                    "sp_EntidadFinancieraEmpresa_Asignar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return entidad ?? throw new ApiException("Error al asignar la entidad financiera");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<EntidadFinancieraEmpresaDto> ActualizarConfigAsync(
            int idEntidadFinancieraEmpresa,
            ActualizarConfigEntidadDto dto,
            string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinancieraEmpresa", idEntidadFinancieraEmpresa);
            parameters.Add("@EmailNotificacion", dto.EmailNotificacion);
            parameters.Add("@Telefono", dto.Telefono);
            parameters.Add("@CanalAtencion", dto.CanalAtencion);
            parameters.Add("@LogoUrl", dto.LogoUrl);
            parameters.Add("@LogoDarkUrl", dto.LogoDarkUrl);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraEmpresaDto>(
                "sp_EntidadFinancieraEmpresa_ActualizarConfig",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return entidad ?? throw new ApiException("Error al actualizar la configuración");
        }

        public async Task<bool> DesasignarEntidadAsync(int idEntidadFinancieraEmpresa, string eliminadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinancieraEmpresa", idEntidadFinancieraEmpresa);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EliminadoPor", eliminadoPor);

            try
            {
                var result = await connection.QueryFirstOrDefaultAsync<int>(
                    "sp_EntidadFinancieraEmpresa_Desasignar",
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

        public async Task<EntidadFinancieraEmpresaDto> CambiarEstadoAsync(
            int idEntidadFinancieraEmpresa,
            bool activo,
            string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinancieraEmpresa", idEntidadFinancieraEmpresa);
            parameters.Add("@Activo", activo);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EditadoPor", editadoPor);

            var entidad = await connection.QueryFirstOrDefaultAsync<EntidadFinancieraEmpresaDto>(
                "sp_EntidadFinancieraEmpresa_CambiarEstado",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return entidad ?? throw new ApiException("Error al cambiar el estado");
        }

        // Contactos

        public async Task<List<ContactoDto>> ObtenerContactosAsync(int idEntidadFinancieraEmpresa)
        {
            using var connection = CreateConnection();

            var contactos = await connection.QueryAsync<ContactoDto>(
                "sp_EntidadFinancieraContacto_ListarPorEntidadEmpresa",
                new { IdEntidadFinancieraEmpresa = idEntidadFinancieraEmpresa },
                commandType: CommandType.StoredProcedure
            );

            return contactos.ToList();
        }

        public async Task<ContactoDto> AgregarContactoAsync(
            int idEntidadFinancieraEmpresa,
            CrearContactoDto dto,
            string creadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinancieraEmpresa", idEntidadFinancieraEmpresa);
            parameters.Add("@NombreContacto", dto.NombreContacto);
            parameters.Add("@EmailContacto", dto.EmailContacto);
            parameters.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parameters.Add("@CreadoPor", creadoPor);

            try
            {
                var contacto = await connection.QueryFirstOrDefaultAsync<ContactoDto>(
                    "sp_EntidadFinancieraContacto_Agregar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return contacto ?? throw new ApiException("Error al agregar el contacto");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<bool> EliminarContactoAsync(int idContacto, string eliminadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdContacto", idContacto);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EliminadoPor", eliminadoPor);

            var result = await connection.QueryFirstOrDefaultAsync<int>(
                "sp_EntidadFinancieraContacto_Eliminar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return result == 1;
        }

        // Dominios

        public async Task<List<DominioDto>> ObtenerDominiosAsync(int idEntidadFinancieraEmpresa)
        {
            using var connection = CreateConnection();

            var dominios = await connection.QueryAsync<DominioDto>(
                "sp_EntidadFinancieraDominio_ListarPorEntidadEmpresa",
                new { IdEntidadFinancieraEmpresa = idEntidadFinancieraEmpresa },
                commandType: CommandType.StoredProcedure
            );

            return dominios.ToList();
        }

        public async Task<DominioDto> AgregarDominioAsync(
            int idEntidadFinancieraEmpresa,
            CrearDominioDto dto,
            string creadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEntidadFinancieraEmpresa", idEntidadFinancieraEmpresa);
            parameters.Add("@Dominio", dto.Dominio);
            parameters.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parameters.Add("@CreadoPor", creadoPor);

            try
            {
                var dominio = await connection.QueryFirstOrDefaultAsync<DominioDto>(
                    "sp_EntidadFinancieraDominio_Agregar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return dominio ?? throw new ApiException("Error al agregar el dominio");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<bool> EliminarDominioAsync(int idDominio, string eliminadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdDominio", idDominio);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);
            parameters.Add("@EliminadoPor", eliminadoPor);

            var result = await connection.QueryFirstOrDefaultAsync<int>(
                "sp_EntidadFinancieraDominio_Eliminar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return result == 1;
        }

    }
}
