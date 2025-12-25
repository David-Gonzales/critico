using Common.Settings;
using Dapper;
using DTOs.IAM.Auth.Firma;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.IAM
{
    public class FirmaRepository : IFirmaRepository
    {
        private readonly string _connectionString;

        public FirmaRepository(DatabaseSettings databaseSettings)
        {
            _connectionString = databaseSettings.GetConnectionString;
        }

        private IDbConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public async Task<FirmaDto> ObtenerFirmaActivaPorUsuarioAsync(int idUsuario)
        {
            using var connection = CreateConnection();

            var sql = @"
                SELECT TOP 1
                    f.IdFirma,
                    f.IdUsuario,
                    f.NombreCompleto,
                    f.Cargo,
                    f.DocumentoIdentidad,
                    f.IdEntidadFinanciera,
                    ef.Nombre AS NombreEntidad,
                    f.NombreArchivo,
                    f.RutaArchivo,
                    f.ContentType,
                    f.IdEmpresa,
                    e.Nombre AS NombreEmpresa,
                    f.FechaCreacion,
                    f.CreadoPor,
                    f.Activo
                FROM Firma f
                LEFT JOIN EntidadFinanciera ef ON f.IdEntidadFinanciera = ef.IdEntidadFinanciera
                LEFT JOIN Empresa e ON f.IdEmpresa = e.IdEmpresa
                WHERE f.IdUsuario = @IdUsuario
                  AND f.Activo = 1
                  AND f.Eliminado = 0
                ORDER BY f.FechaCreacion DESC";

            return await connection.QueryFirstOrDefaultAsync<FirmaDto>(sql, new { IdUsuario = idUsuario });
        }

        public async Task<DocumentoFirmaDto> RegistrarFirmaDocumentoAsync(DocumentoFirmaDto dto)
        {
            using var connection = CreateConnection();

            var sql = @"
                INSERT INTO DocumentoFirma (
                    TipoDocumento, IdDocumento, IdFirma, IdUsuarioFirmante,
                    PasswordValidado, MetodoValidacion, IpAddress, FechaFirma
                )
                VALUES (
                    @TipoDocumento, @IdDocumento, @IdFirma, @IdUsuarioFirmante,
                    @PasswordValidado, @MetodoValidacion, @IpAddress, GETDATE()
                );
                
                SELECT 
                    df.IdDocumentoFirma,
                    df.TipoDocumento,
                    df.IdDocumento,
                    df.IdFirma,
                    df.IdUsuarioFirmante,
                    u.NombreUsuario AS NombreUsuarioFirmante,
                    df.PasswordValidado,
                    df.MetodoValidacion,
                    df.IpAddress,
                    df.FechaFirma
                FROM DocumentoFirma df
                INNER JOIN Usuario u ON df.IdUsuarioFirmante = u.IdUsuario
                WHERE df.IdDocumentoFirma = SCOPE_IDENTITY()";

            return await connection.QueryFirstOrDefaultAsync<DocumentoFirmaDto>(sql, dto);
        }
    }
}
