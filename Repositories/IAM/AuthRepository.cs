using Common.Interfaces;
using Common.Models;
using Common.Settings;
using Dapper;
using DTOs.IAM.Auth;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.IAM
{
    public class AuthRepository : IAuthRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public AuthRepository(DatabaseSettings databaseSettings, IDateTimeService dateTimeService)
        {
            _connectionString = databaseSettings.GetConnectionString;
            _dateTimeService = dateTimeService;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public async Task<Usuario?> ObtenerUsuarioPorEmailAsync(string email)
        {
            using var connection = CreateConnection();

            var sql = @"
                SELECT 
                    
                    IdUsuario, NombreUsuario, Email, PasswordHash, 
                    Nombres, Apellidos, Telefono, DocumentoIdentidad,
                    IdEmpresa, RequiereDobleFactor, SecretoDobleFactor, 
                    IntentosFallidos, FechaBloqueo, UltimoAcceso,
                    FechaCreacion, CreadoPor, FechaEdicion, EditadoPor, 
                    Activo, Eliminado

                FROM Usuario 
                WHERE Email = @Email 
                AND Activo = 1 
                AND Eliminado = 0";

            return await connection.QueryFirstOrDefaultAsync<Usuario>(sql, new { Email = email });
        }

        public async Task<List<string>> ObtenerRolesUsuarioAsync(int idUsuario, int? idEmpresa = null)
        {
            using var connection = CreateConnection();

            var sql = @"
                SELECT DISTINCT r.Codigo
                FROM Rol r
                INNER JOIN UsuarioRol ur ON r.IdRol = ur.IdRol
                WHERE ur.IdUsuario = @IdUsuario
                AND r.Activo = 1
                AND r.Eliminado = 0
                AND ur.Activo = 1
                AND ur.Eliminado = 0
                AND (@IdEmpresa IS NULL OR r.IdEmpresa = @IdEmpresa OR r.IdEmpresa IS NULL)";

            var roles = await connection.QueryAsync<string>(sql, new { IdUsuario = idUsuario, IdEmpresa = idEmpresa });
            return roles.ToList();
        }

        public async Task<List<EmpresaDto>> ObtenerEmpresasUsuarioAsync(int idUsuario)
        {
            using var connection = CreateConnection();

            var sql = @"
                SELECT e.IdEmpresa, e.Codigo, e.Nombre
                FROM Empresa e
                INNER JOIN UsuarioEmpresa ue ON e.IdEmpresa = ue.IdEmpresa
                WHERE ue.IdUsuario = @IdUsuario
                AND e.Activo = 1
                AND e.Eliminado = 0
                AND ue.Activo = 1
                AND ue.Eliminado = 0
                ORDER BY e.Nombre";

            var empresas = await connection.QueryAsync<EmpresaDto>(sql, new { IdUsuario = idUsuario });
            return empresas.ToList();
        }

        public async Task GuardarRefreshTokenAsync(int idUsuario, string token, DateTime expiracion)
        {
            using var connection = CreateConnection();

            var revocarSql = @"
                UPDATE RefreshToken 
                SET EsRevocado = 1,
                    FechaRevocacion = @FechaEdicion,
                    EditadoPor = 'SISTEMA',
                    FechaEdicion = @FechaEdicion
                WHERE IdUsuario = @IdUsuario 
                AND EsRevocado = 0
                AND Eliminado = 0";

            await connection.ExecuteAsync(revocarSql, new { IdUsuario = idUsuario, FechaEdicion = _dateTimeService.NowPeru });

            var insertSql = @"
                INSERT INTO RefreshToken (
                    IdUsuario, Token, Expiracion, CreadoPor, FechaCreacion, Activo, Eliminado
                )
                VALUES (
                    @IdUsuario, @Token, @Expiracion, 'SISTEMA', @FechaCreacion, 1, 0
                )";

            await connection.ExecuteAsync(insertSql, new
            {
                IdUsuario = idUsuario,
                Token = token,
                Expiracion = expiracion,
                FechaCreacion = _dateTimeService.NowPeru
            });
        }

        public async Task<RefreshToken?> ObtenerRefreshTokenAsync(string token)
        {
            using var connection = CreateConnection();

            var sql = @"
                SELECT * FROM RefreshToken 
                WHERE Token = @Token 
                AND EsRevocado = 0
                AND Eliminado = 0";

            return await connection.QueryFirstOrDefaultAsync<RefreshToken>(sql, new { Token = token });
        }

        public async Task RevocarRefreshTokenAsync(string token, string editadoPor)
        {
            using var connection = CreateConnection();

            var sql = @"
                UPDATE RefreshToken 
                SET EsRevocado = 1,
                    FechaRevocacion = @FechaEdicion,
                    EditadoPor = @EditadoPor,
                    FechaEdicion = @FechaEdicion
                WHERE Token = @Token";

            await connection.ExecuteAsync(sql, new { Token = token, EditadoPor = editadoPor, FechaEdicion = _dateTimeService.NowPeru });
        }
    }
}
