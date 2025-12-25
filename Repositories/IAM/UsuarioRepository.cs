using Common.Interfaces;
using Common.Settings;
using Dapper;
using DTOs.IAM.Empresas;
using DTOs.IAM.Roles;
using DTOs.IAM.Usuarios;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.IAM
{
    public class UsuarioRepository : IUsuarioRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public UsuarioRepository(DatabaseSettings databaseSettings, IDateTimeService dateTimeService)
        {
            _connectionString = databaseSettings.GetConnectionString;
            _dateTimeService = dateTimeService;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public async Task<IEnumerable<UsuarioDto>> ListarAsync(bool soloActivos = true, bool incluirEliminados = false, int? idEmpresa = null, bool excluirSuperAdmin = false)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                SoloActivos = soloActivos,
                IncluirEliminados = incluirEliminados,
                IdEmpresa = idEmpresa,
                ExcluirSuperAdmin = excluirSuperAdmin
            };

            return await connection.QueryAsync<UsuarioDto>(
                "sp_Usuario_Listar",
                parametros,
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<UsuarioDetalleDto> ObtenerPorIdAsync(int idUsuario)
        {
            using var connection = CreateConnection();

            var parametros = new { IdUsuario = idUsuario };

            using var multi = await connection.QueryMultipleAsync(
                "sp_Usuario_ObtenerPorId",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            var usuario = await multi.ReadFirstOrDefaultAsync<UsuarioDetalleDto>();
            if (usuario != null)
            {
                usuario.Roles = (await multi.ReadAsync<RolSimpleDto>()).ToList();
                usuario.Empresas = (await multi.ReadAsync<EmpresaSimpleDto>()).ToList();
            }

            return usuario;
        }

        public async Task<UsuarioDetalleDto> CrearAsync(CrearUsuarioDto dto, string passwordHash, string creadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new DynamicParameters();
            parametros.Add("@NombreUsuario", dto.NombreUsuario);
            parametros.Add("@Email", dto.Email);
            parametros.Add("@PasswordHash", passwordHash);
            parametros.Add("@Nombres", dto.Nombres);
            parametros.Add("@Apellidos", dto.Apellidos);
            parametros.Add("@Telefono", dto.Telefono);
            parametros.Add("@DocumentoIdentidad", dto.DocumentoIdentidad);
            parametros.Add("@CreadoPor", creadoPor);
            parametros.Add("@FechaCreacion", _dateTimeService.NowPeru);
            parametros.Add("@RolesIds", string.Join(",", dto.RolesIds));
            parametros.Add("@EmpresasIds", string.Join(",", dto.EmpresasIds));
            parametros.Add("@IdUsuario", dbType: DbType.Int32, direction: ParameterDirection.Output);

            using var multi = await connection.QueryMultipleAsync(
                "sp_Usuario_Crear",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            var usuario = await multi.ReadFirstOrDefaultAsync<UsuarioDetalleDto>();
            if (usuario != null)
            {
                usuario.Roles = (await multi.ReadAsync<RolSimpleDto>()).ToList();
                usuario.Empresas = (await multi.ReadAsync<EmpresaSimpleDto>()).ToList();
            }

            return usuario;
        }

        public async Task<UsuarioDetalleDto> ActualizarAsync(ActualizarUsuarioDto dto, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdUsuario = dto.IdUsuario,
                NombreUsuario = dto.NombreUsuario,
                Email = dto.Email,
                Nombres = dto.Nombres,
                Apellidos = dto.Apellidos,
                Telefono = dto.Telefono,
                DocumentoIdentidad = dto.DocumentoIdentidad,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru,
                RolesIds = string.Join(",", dto.RolesIds),
                EmpresasIds = string.Join(",", dto.EmpresasIds)
            };

            using var multi = await connection.QueryMultipleAsync(
                "sp_Usuario_Actualizar",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            var usuario = await multi.ReadFirstOrDefaultAsync<UsuarioDetalleDto>();
            if (usuario != null)
            {
                usuario.Roles = (await multi.ReadAsync<RolSimpleDto>()).ToList();
                usuario.Empresas = (await multi.ReadAsync<EmpresaSimpleDto>()).ToList();
            }

            return usuario;
        }

        public async Task<bool> CambiarPasswordAsync(int idUsuario, string passwordHash, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdUsuario = idUsuario,
                PasswordHash = passwordHash,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            var resultado = await connection.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Usuario_CambiarPassword",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado?.Resultado == 1;
        }

        public async Task<bool> CambiarEstadoAsync(int idUsuario, bool activo, string editadoPor)
        {
            using var connection = CreateConnection();

            var parametros = new
            {
                IdUsuario = idUsuario,
                Activo = activo,
                EditadoPor = editadoPor,
                FechaEdicion = _dateTimeService.NowPeru
            };

            var resultado = await connection.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Usuario_CambiarEstado",
                parametros,
                commandType: CommandType.StoredProcedure
            );

            return resultado?.Resultado == 1;
        }
    }
}
