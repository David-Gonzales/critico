using Common.Exceptions;
using Common.Interfaces;
using Common.Settings;
using Dapper;
using DTOs.Reclamos.Request;
using DTOs.Reclamos.Response;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Repositories.Reclamos
{
    public class ReclamoRepository : IReclamoRepository
    {
        private readonly string _connectionString;
        private readonly IDateTimeService _dateTimeService;

        public ReclamoRepository(
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

        public async Task<string> GenerarCodigoReclamoAsync(
            int idEmpresa,
            IDbConnection connection,
            IDbTransaction transaction)
        {
            
            var sqlEmpresa = @"
                SELECT Codigo
                FROM Empresa
                WHERE IdEmpresa = @IdEmpresa";

            var codigoEmpresa = await connection.QueryFirstOrDefaultAsync<string>(
                sqlEmpresa,
                new { IdEmpresa = idEmpresa },
                transaction
            );

            if(String.IsNullOrEmpty(codigoEmpresa))
                throw new ApiException("Empresa no encontrada para generar el código de reclamo.");

            string prefijo = codigoEmpresa switch
            {
                "ALOBANCO" => "ALO",
                "DCF" => "DCF",
                _ => throw new ApiException($"El código de empresa '{codigoEmpresa}' no tiene un prefijo de reclamo configurado.")
            };

            var año = _dateTimeService.NowPeru.Year;

            // Hilo seguro por empresa

            var parameters = new DynamicParameters();
            parameters.Add("@IdEmpresa", idEmpresa);
            parameters.Add("@Año", año);
            parameters.Add("@Prefijo", prefijo);
            parameters.Add("@NuevoCodigo", dbType: DbType.String, direction: ParameterDirection.Output, size: 20);

            await connection.ExecuteAsync(
                "sp_Reclamo_ObtenerSiguienteCodigo",
                parameters,
                transaction: transaction,
                commandType: CommandType.StoredProcedure
            );

            var nuevoCodigo = parameters.Get<string>("@NuevoCodigo");

            if (string.IsNullOrEmpty(nuevoCodigo))
                throw new ApiException("Error al generar el código de reclamo.");


            return nuevoCodigo;
        }

        public async Task<ReclamoDto> CrearReclamoAsync(CrearReclamoDto dto, string creadoPor)
        {
            using var connection = CreateConnection();
            await (connection as SqlConnection)!.OpenAsync();

            using var transaction = connection.BeginTransaction();

            try
            {
                //Generar código con bloqueo granular por empresa
                var codigoReclamo = await GenerarCodigoReclamoAsync(dto.IdEmpresa, connection, transaction);

                var estadoInicial = await connection.QueryFirstAsync<int>(@"
                    SELECT TOP 1 IdReclamoEstado 
                    FROM ReclamoEstado 
                    WHERE IdEmpresa = @IdEmpresa 
                      AND Activo = 1 
                      AND Eliminado = 0
                    ORDER BY Orden ASC",
                        
                    new { dto.IdEmpresa },
                    transaction
                );

                if (estadoInicial == 0)
                    throw new ApiException("No se encontró un estado inicial válido para el reclamo.");

                var parameters = new DynamicParameters();
                parameters.Add("@CodigoReclamo", codigoReclamo);
                parameters.Add("@IdEmpresa", dto.IdEmpresa);

                parameters.Add("@TipoPersona", dto.TipoPersona);
                parameters.Add("@TipoDocumento", dto.TipoDocumento);
                parameters.Add("@NumeroDocumento", dto.NumeroDocumento);
                parameters.Add("@NombresReclamante", dto.NombresReclamante);
                parameters.Add("@ApellidosReclamante", dto.ApellidosReclamante);
                parameters.Add("@FechaNacimiento", dto.FechaNacimiento);
                parameters.Add("@RazonSocial", dto.RazonSocial);
                parameters.Add("@RepresentanteLegalNombres", dto.RepresentanteLegalNombres);
                parameters.Add("@RepresentanteLegalDNI", dto.RepresentanteLegalDNI);
                parameters.Add("@EmailReclamante", dto.EmailReclamante);
                parameters.Add("@TelefonoReclamante", dto.TelefonoReclamante);
                parameters.Add("@OtroTelefonoReclamante", dto.OtroTelefonoReclamante);
                parameters.Add("@DireccionReclamante", dto.DireccionReclamante);

                parameters.Add("@TipoCanal", dto.TipoCanal);

                parameters.Add("@IdEntidadFinancieraEmpresa", dto.IdEntidadFinancieraEmpresa);
                parameters.Add("@IdTipoProducto", dto.IdTipoProducto);
                parameters.Add("@NumeroProducto", dto.NumeroProducto);
                parameters.Add("@NumeroReclamoEntidad", dto.NumeroReclamoEntidad);
                parameters.Add("@FechaRegistroEntidad", dto.FechaRegistroEntidad);

                parameters.Add("@IdTipoRequerimiento", dto.IdTipoRequerimiento);
                parameters.Add("@IdMotivoReclamo", dto.IdMotivoReclamo);

                parameters.Add("@FechaHechos", dto.FechaHechos);
                parameters.Add("@HoraHechos", dto.HoraHechos);
                parameters.Add("@DescripcionHechos", dto.DescripcionHechos);
                parameters.Add("@Caso", dto.Caso);
                parameters.Add("@MontoReclamado", dto.MontoReclamado);
                parameters.Add("@MonedaReclamado", dto.MonedaReclamado);

                parameters.Add("@SolucionSolicitada", dto.SolucionSolicitada);
                parameters.Add("@ResultadoEsperado", dto.ResultadoEsperado);

                parameters.Add("@IdEstadoActual", estadoInicial);
                parameters.Add("@DiasPlazo", 30); // Por defecto 30 días para la entidad financiera. El frontend debería poder setear este número al que requiera.

                parameters.Add("@PresentoReclamoOtraInstancia", dto.PresentoReclamoOtraInstancia);
                parameters.Add("@IdInstancia", dto.IdInstancia);
                parameters.Add("@FechaPresentacionOtraInstancia", dto.FechaPresentacionOtraInstancia);

                parameters.Add("@IdFuente", dto.IdFuente);
                parameters.Add("@ComoSeEnteroAlobanco", dto.ComoSeEnteroAlobanco);

                parameters.Add("@CreadoPor", creadoPor);
                parameters.Add("@FechaCreacion", _dateTimeService.NowPeru);

                var reclamo = await connection.QueryFirstOrDefaultAsync<ReclamoDto>(
                    "sp_Reclamo_Crear",
                    parameters,
                    commandType: CommandType.StoredProcedure,
                    transaction: transaction
                );

                if( reclamo == null)
                    throw new ApiException("Error al crear el reclamo.");

                transaction.Commit();

                return reclamo;
            }
            catch (Exception)
            {
                transaction.Rollback();
                throw;
            }
        }

        public async Task<ReclamoDto> ObtenerPorIdAsync(int idReclamo, int? idEmpresa = null)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@IdEmpresa", idEmpresa);

            var reclamo = await connection.QueryFirstOrDefaultAsync<ReclamoDto>(
                "sp_Reclamo_ObtenerPorId",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return reclamo;
        }

        public async Task<List<ReclamoListDto>> ListarReclamosAsync(
            int? idEmpresa = null,
            int? idEstado = null,
            int? idEntidadFinancieraEmpresa = null,
            int? idUsuarioAsignado = null,
            string? numeroDocumento = null,
            string? codigoReclamo = null,
            DateTime? fechaDesde = null,
            DateTime? fechaHasta = null,
            bool soloActivos = true)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdEmpresa", idEmpresa);
            parameters.Add("@IdEstado", idEstado);
            parameters.Add("@IdEntidadFinancieraEmpresa", idEntidadFinancieraEmpresa);
            parameters.Add("@IdUsuarioAsignado", idUsuarioAsignado);
            parameters.Add("@NumeroDocumento", numeroDocumento);
            parameters.Add("@CodigoReclamo", codigoReclamo);
            parameters.Add("@FechaDesde", fechaDesde);
            parameters.Add("@FechaHasta", fechaHasta);
            parameters.Add("@SoloActivos", soloActivos);

            var reclamos = await connection.QueryAsync<ReclamoListDto>(
                "sp_Reclamo_Listar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return reclamos.ToList();
        }

        public async Task<ReclamoDto> CambiarEstadoAsync(
            int idReclamo,
            CambiarEstadoReclamoDto dto,
            string cambiadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@IdEstadoNuevo", dto.IdEstadoNuevo);
            parameters.Add("@Motivo", dto.Motivo);
            parameters.Add("@Observaciones", dto.Observaciones);
            parameters.Add("@CambiadoPor", cambiadoPor);
            parameters.Add("@FechaCambio", _dateTimeService.NowPeru);

            var reclamo = await connection.QueryFirstOrDefaultAsync<ReclamoDto>(
                "sp_Reclamo_CambiarEstado",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return reclamo;
        }

        public async Task<ReclamoDto> AsignarReclamoAsync(
            int idReclamo,
            AsignarReclamoDto dto,
            string asignadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@IdUsuarioNuevo", dto.IdUsuarioNuevo);
            parameters.Add("@Motivo", dto.Motivo);
            parameters.Add("@Prioridad", dto.Prioridad);
            parameters.Add("@AsignadoPor", asignadoPor);
            parameters.Add("@FechaAsignacion", _dateTimeService.NowPeru);

            var reclamo = await connection.QueryFirstOrDefaultAsync<ReclamoDto>(
                "sp_Reclamo_Asignar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return reclamo;
        }

        public async Task<ReclamoArchivoDto> SubirArchivoAsync(
            int idReclamo,
            SubirArchivoReclamoDto dto,
            string subidoPor)
        {
            using var connection = CreateConnection();

            var extension = Path.GetExtension(dto.NombreArchivo);
            var nombreArchivo = $"{Guid.NewGuid()}{extension}";

            var rutaBase = "~/App_Data/Reclamos"; // TODO: Tengo que obtener de paramétricas
            var rutaCompleta = Path.Combine(rutaBase, nombreArchivo);

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@NombreArchivo", nombreArchivo);
            parameters.Add("@NombreOriginal", dto.NombreArchivo);
            parameters.Add("@RutaArchivo", rutaCompleta);
            parameters.Add("@TamañoBytes", dto.TamañoBytes);
            parameters.Add("@ContentType", dto.ContentType);
            parameters.Add("@SubidoPor", subidoPor);
            parameters.Add("@FechaSubida", _dateTimeService.NowPeru);

            var archivo = await connection.QueryFirstOrDefaultAsync<ReclamoArchivoDto>(
                "sp_ReclamoArchivo_Crear",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return archivo;
        }

        public async Task<List<ReclamoArchivoDto>> ObtenerArchivosAsync(int idReclamo)
        {
            using var connection = CreateConnection();

            var archivos = await connection.QueryAsync<ReclamoArchivoDto>(
                "sp_ReclamoArchivo_ListarPorReclamo",
                new { IdReclamo = idReclamo },
                commandType: CommandType.StoredProcedure
                );

            return archivos.ToList();
        }

        public async Task<ReclamoArchivoDto?> ObtenerArchivoPorIdAsync(int idReclamoArchivo)
        {
            using var connection = CreateConnection();

            var archivo = await connection.QueryFirstOrDefaultAsync<ReclamoArchivoDto>(
                "sp_ReclamoArchivo_ObtenerPorId",
                new { IdReclamoArchivo = idReclamoArchivo },
                commandType: CommandType.StoredProcedure
                );

            return archivo;
        }

        public async Task<ReclamoComentarioDto> AgregarComentarioAsync(
            int idReclamo,
            AgregarComentarioDto dto,
            string comentadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@Comentario", dto.Comentario);
            parameters.Add("@EsInterno", dto.EsInterno);
            parameters.Add("@ComentadoPor", comentadoPor);
            parameters.Add("@FechaComentario", _dateTimeService.NowPeru);

            var comentario = await connection.QueryFirstOrDefaultAsync<ReclamoComentarioDto>(
                "sp_ReclamoComentario_Crear",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return comentario;
        }

        public async Task<List<ReclamoComentarioDto>> ObtenerComentariosAsync(int idReclamo, bool incluirInternos = true)
        {
            using var connection = CreateConnection();

            var comentarios = await connection.QueryAsync<ReclamoComentarioDto>(
                "sp_ReclamoComentario_ListarPorReclamo",
                new { IdReclamo = idReclamo, IncluirInternos = incluirInternos },
                commandType: CommandType.StoredProcedure
            );

            return comentarios.ToList();
        }

        public async Task<List<ReclamoEstadoHistorialDto>> ObtenerHistorialEstadosAsync(int idReclamo) 
        {
            using var connection = CreateConnection();

            var historial = await connection.QueryAsync<ReclamoEstadoHistorialDto>(
                "sp_Reclamo_ObtenerHistorialEstados",
                new { IdReclamo = idReclamo },
                commandType: CommandType.StoredProcedure
            );

            return historial.ToList();
        }

        public async Task<ConsultaEstadoReclamoDto?> ConsultarEstadoPublicoAsync(
            string numeroDocumento, 
            string codigoReclamo)
        {
            using var connection = CreateConnection();

            var resultado = await connection.QueryFirstOrDefaultAsync<ConsultaEstadoReclamoDto>(
                "sp_Reclamo_ConsultaPublica",
                new { NumeroDocumento = numeroDocumento, CodigoReclamo = codigoReclamo },
                commandType: CommandType.StoredProcedure
            );

            return resultado;
        }

        public async Task<ReclamoDto> ActualizarReclamoAsync(
            int idReclamo,
            ActualizarReclamoDto dto,
            string editadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);

            parameters.Add("@TipoPersona", dto.TipoPersona);
            parameters.Add("@TipoDocumento", dto.TipoDocumento);
            parameters.Add("@NumeroDocumento", dto.NumeroDocumento);
            parameters.Add("@NombresReclamante", dto.NombresReclamante);
            parameters.Add("@ApellidosReclamante", dto.ApellidosReclamante);
            parameters.Add("@FechaNacimiento", dto.FechaNacimiento);
            parameters.Add("@RazonSocial", dto.RazonSocial);
            parameters.Add("@RepresentanteLegalNombres", dto.RepresentanteLegalNombres);
            parameters.Add("@RepresentanteLegalDNI", dto.RepresentanteLegalDNI);
            parameters.Add("@EmailReclamante", dto.EmailReclamante);
            parameters.Add("@TelefonoReclamante", dto.TelefonoReclamante);
            parameters.Add("@OtroTelefono", dto.OtroTelefono);
            parameters.Add("@DireccionReclamante", dto.DireccionReclamante);

            parameters.Add("@TipoCanal", dto.TipoCanal);

            parameters.Add("@IdEntidadFinancieraEmpresa", dto.IdEntidadFinancieraEmpresa);
            parameters.Add("@IdTipoProducto", dto.IdTipoProducto);
            parameters.Add("@NumeroProducto", dto.NumeroProducto);
            parameters.Add("@NumeroReclamoEntidad", dto.NumeroReclamoEntidad);
            parameters.Add("@FechaRegistroEntidad", dto.FechaRegistroEntidad);

            parameters.Add("@IdTipoRequerimiento", dto.IdTipoRequerimiento);
            parameters.Add("@IdMotivoReclamo", dto.IdMotivoReclamo);

            parameters.Add("@FechaHechos", dto.FechaHechos);
            parameters.Add("@HoraHechos", dto.HoraHechos);
            parameters.Add("@DescripcionHechos", dto.DescripcionHechos);
            parameters.Add("@Caso", dto.Caso);
            parameters.Add("@MontoReclamado", dto.MontoReclamado);
            parameters.Add("@MonedaReclamado", dto.MonedaReclamado);

            parameters.Add("@SolucionSolicitada", dto.SolucionSolicitada);
            parameters.Add("@ResultadoEsperado", dto.ResultadoEsperado);

            parameters.Add("@PresentoReclamoOtraInstancia", dto.PresentoReclamoOtraInstancia);
            parameters.Add("@IdInstancia", dto.IdInstancia);
            parameters.Add("@FechaPresentacionOtraInstancia", dto.FechaPresentacionOtraInstancia);

            parameters.Add("@IdFuente", dto.IdFuente);
            parameters.Add("@ComoSeEnteroAlobanco", dto.ComoSeEnteroAlobanco);

            parameters.Add("@EditadoPor", editadoPor);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);

            try
            {
                var reclamo = await connection.QueryFirstOrDefaultAsync<ReclamoDto>(
                    "sp_Reclamo_Actualizar",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return reclamo ?? throw new ApiException("Error al actualizar el reclamo");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<bool> EliminarReclamoAsync(int idReclamo, string eliminadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@EliminadoPor", eliminadoPor);
            parameters.Add("@FechaEdicion", _dateTimeService.NowPeru);

            var result = await connection.QueryFirstOrDefaultAsync<int>(
                "sp_Reclamo_Eliminar",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return result == 1;
        }

        public async Task<bool> ValidarUsuarioExisteAsync(int idUsuario)
        {
            using var connection = CreateConnection();

            var existe = await connection.QueryFirstOrDefaultAsync<int>(@"
                SELECT COUNT(1) 
                FROM Usuario 
                WHERE IdUsuario = @IdUsuario 
                    AND Activo = 1 
                    AND Eliminado = 0",

                new { IdUsuario = idUsuario }
            );

            return existe > 0;
        }

        public async Task<bool> ValidarUsuarioTieneAccesoEmpresaAsync(int idUsuario, int idEmpresa)
        {
            using var connection = CreateConnection();

            var tieneAcceso = await connection.QueryFirstOrDefaultAsync<int>(@"
                SELECT COUNT(1)
                FROM UsuarioEmpresa ue
                WHERE ue.IdUsuario = @IdUsuario
                  AND ue.IdEmpresa = @IdEmpresa
                  AND ue.Activo = 1",
               
                new { IdUsuario = idUsuario, IdEmpresa = idEmpresa }
            );

            return tieneAcceso > 0;
        }

        public async Task<ReclamoDto> ValidarAdmisionAsync(
            int idReclamo,
            ValidarAdmisionReclamoDto dto,
            string validadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@EsAdmitido", dto.EsAdmitido);
            parameters.Add("@Motivo", dto.Motivo);
            parameters.Add("@Observaciones", dto.Observaciones);
            parameters.Add("@ValidadoPor", validadoPor);
            parameters.Add("@FechaValidacion", _dateTimeService.NowPeru);

            try
            {
                var reclamo = await connection.QueryFirstOrDefaultAsync<ReclamoDto>(
                    "sp_Reclamo_ValidarAdmision",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return reclamo ?? throw new ApiException("Error al validar la admisión del reclamo");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

        public async Task<ReclamoConSubsanacionDto> SolicitarSubsanacionAsync(
            int idReclamo,
            SolicitarSubsanacionDto dto,
            string solicitadoPor)
        {
            using var connection = CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@IdReclamo", idReclamo);
            parameters.Add("@InformacionRequerida", dto.InformacionRequerida);
            parameters.Add("@DiasParaSubsanar", dto.DiasParaSubsanar);
            parameters.Add("@Observaciones", dto.Observaciones);
            parameters.Add("@SolicitadoPor", solicitadoPor);
            parameters.Add("@FechaSolicitud", _dateTimeService.NowPeru);

            try
            {
                var reclamo = await connection.QueryFirstOrDefaultAsync<ReclamoConSubsanacionDto>(
                    "sp_Reclamo_SolicitarSubsanacion",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                return reclamo ?? throw new ApiException("Error al solicitar la subsanación");
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new ApiException(ex.Message);
            }
        }

    }
}
