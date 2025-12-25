using Common.Exceptions;
using DTOs.Reclamos.Request;
using DTOs.Reclamos.Response;
using Microsoft.AspNetCore.Http;
using Repositories.Reclamos;
using Services.Common;
using Services.Storage;

namespace Services.Reclamos
{
    public class ReclamoService : IReclamoService
    {
        private readonly IReclamoRepository _reclamoRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IBlobStorageService _blobStorageService;

        public ReclamoService(
            IReclamoRepository reclamoRepository,
            IHttpContextAccessor httpContextAccessor,
            IBlobStorageService blobStorageService)
        {
            _reclamoRepository = reclamoRepository;
            _httpContextAccessor = httpContextAccessor;
            _blobStorageService = blobStorageService;
        }

        private string ObtenerUsuarioActual()
        {
            var httpContext = _httpContextAccessor.HttpContext;
            return httpContext?.User?.Identity?.Name ?? "SYSTEM";
        }

        public async Task<ReclamoDto> CrearReclamoAsync(CrearReclamoDto dto)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            // Validar que el usuario tenga acceso a la empresa
            if(!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(dto.IdEmpresa))
                    throw new ApiException("No tiene acceso a la empresa especificada");
            }

            // Validaciones de negocio
            ValidarDatosReclamante(dto);

            var usuarioActual = ObtenerUsuarioActual();
            var reclamo = await _reclamoRepository.CrearReclamoAsync(dto, usuarioActual);

            if (reclamo == null)
                throw new ApiException("Error al crear el reclamo");

            return reclamo;
        }

        public async Task<ReclamoDto> ObtenerReclamoPorIdAsync(int idReclamo)
        {
            int? idEmpresa = null;
            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            // Si no es super admin, filtrar por empresas del usuario
            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (empresasUsuario.Count == 1)
                    idEmpresa = empresasUsuario.First();
                // Si tiene múltiples empresas pero no es super admin, 
                // puede ver reclamos de cualquiera de sus empresas (idEmpresa = null en el SP maneja esto)
            }

            var reclamo = await _reclamoRepository.ObtenerPorIdAsync(idReclamo, idEmpresa);

            if (reclamo == null)
                throw new ApiException("Reclamo no encontrado");

            // Validación adicional de acceso
            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
                if (!empresasUsuario.Contains(reclamo.IdEmpresa))
                    throw new ApiException("No tiene acceso a este reclamo");
            }

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

            var httpContext = _httpContextAccessor.HttpContext;
            var esSuperAdmin = TenantHelper.EsSuperAdmin(httpContext);

            // Validar acceso por empresa
            if (!esSuperAdmin)
            {
                var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);

                if (idEmpresa.HasValue)
                {
                    // Usuario especificó una empresa, validar que tenga acceso
                    if (!empresasUsuario.Contains(idEmpresa.Value))
                        throw new ApiException("No tiene acceso a la empresa solicitada");
                }
                else
                {
                    if (empresasUsuario.Count == 1)
                    {
                        // Si solo tiene una empresa, filtrar por ella automáticamente
                        idEmpresa = empresasUsuario.First();
                    }
                    // Si tiene múltiples empresas, mostrar todas (idEmpresa sigue siendo null)
                }
            }

            var reclamos = await _reclamoRepository.ListarReclamosAsync(
                idEmpresa,
                idEstado,
                idEntidadFinancieraEmpresa,
                idUsuarioAsignado,
                numeroDocumento,
                codigoReclamo,
                fechaDesde,
                fechaHasta,
                soloActivos
            );

            // TODO: Filtro adicional si el usuario tiene múltiples empresas pero no es super admin
            //if (!esSuperAdmin && !idEmpresa.HasValue)
            //{
            //    var empresasUsuario = TenantHelper.ObtenerEmpresasUsuarioActual(httpContext);
            //    reclamos = reclamos.Where(r => empresasUsuario.Contains(r.IdEmpresa)).ToList();
            //}

            return reclamos;
        }

        public async Task<ReclamoDto> CambiarEstadoAsync(int idReclamo, CambiarEstadoReclamoDto dto)
        {
            var reclamoExistente = await ObtenerReclamoPorIdAsync(idReclamo);

            var usuarioActual = ObtenerUsuarioActual();
            var reclamo = await _reclamoRepository.CambiarEstadoAsync(idReclamo, dto, usuarioActual);

            if (reclamo == null)
                throw new ApiException("Error al cambiar el estado del reclamo");

            return reclamo;
        }

        public async Task<ReclamoDto> AsignarReclamoAsync(int idReclamo, AsignarReclamoDto dto)
        {
            var reclamoExistente = await ObtenerReclamoPorIdAsync(idReclamo);

            var usuarioExiste = await _reclamoRepository.ValidarUsuarioExisteAsync(dto.IdUsuarioNuevo);
            if (!usuarioExiste)
                throw new ApiException("El usuario especificado no existe o está inactivo");

            var tieneAcceso = await _reclamoRepository.ValidarUsuarioTieneAccesoEmpresaAsync( 
                dto.IdUsuarioNuevo,
                reclamoExistente.IdEmpresa
            );
            if (!tieneAcceso)
                throw new ApiException("Este usuario no tiene acceso a la empresa del reclamo");

            var usuarioActual = ObtenerUsuarioActual();
            var reclamo = await _reclamoRepository.AsignarReclamoAsync(idReclamo, dto, usuarioActual);

            if (reclamo == null)
                throw new ApiException("Error al asignar el reclamo");

            return reclamo;
        }

        private void ValidarDatosReclamante(CrearReclamoDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.TipoPersona) || (dto.TipoPersona != "NATURAL" && dto.TipoPersona != "JURIDICA"))
                throw new ApiException("Tipo de persona inválido. Valores permitidos: NATURAL, JURIDICA");

            if (dto.TipoPersona == "JURIDICA")
            {
                if (string.IsNullOrWhiteSpace(dto.RazonSocial))
                    throw new ApiException("La razón social es requerida para personas jurídicas");

                if (string.IsNullOrWhiteSpace(dto.RepresentanteLegalNombres))
                    throw new ApiException("El nombre del representante legal es requerido para personas jurídicas");

                if (string.IsNullOrWhiteSpace(dto.RepresentanteLegalDNI))
                    throw new ApiException("El DNI del representante legal es requerido para personas jurídicas");
            }
            else
            {
                if (string.IsNullOrWhiteSpace(dto.NombresReclamante))
                    throw new ApiException("El nombre del reclamante es requerido");

                if (string.IsNullOrWhiteSpace(dto.ApellidosReclamante))
                    throw new ApiException("Los apellidos del reclamante son requeridos");
            }
        }

        private void ValidarDatosReclamanteParcial(ActualizarReclamoDto dto)
        {

            if (dto.TipoPersona == "JURIDICA")
            {
                if (string.IsNullOrWhiteSpace(dto.RazonSocial))
                    throw new ApiException("La razón social es requerida para personas jurídicas");

                if (string.IsNullOrWhiteSpace(dto.RepresentanteLegalNombres))
                    throw new ApiException("El nombre del representante legal es requerido para personas jurídicas");

                if (string.IsNullOrWhiteSpace(dto.RepresentanteLegalDNI))
                    throw new ApiException("El DNI del representante legal es requerido para personas jurídicas");
            }
            else if (dto.TipoPersona == "NATURAL")
            {
                if (string.IsNullOrWhiteSpace(dto.NombresReclamante))
                    throw new ApiException("El nombre del reclamante es requerido");

                if (string.IsNullOrWhiteSpace(dto.ApellidosReclamante))
                    throw new ApiException("Los apellidos del reclamante son requeridos");
            }
            else
            {
                throw new ApiException("Tipo de persona inválido. Valores permitidos: NATURAL, JURIDICA");
            }
        }

        public async Task<ReclamoArchivoDto> SubirArchivoAsync(int idReclamo, SubirArchivoReclamoDto dto)
        {
            //Valido que el reclamo existe y el usuario tiene acceso
            var reclamoExistente = await ObtenerReclamoPorIdAsync(idReclamo);

            const long maxSizeBytes = 25 * 1024 * 1024; // 25 MB TODO: Traer de tabla paramétrica

            if (dto.TamañoBytes > maxSizeBytes)
                throw new ApiException("El tamaño del archivo excede el límite permitido de 25 MB");

            var extensionesPermitidas = new List<string> { ".pdf", ".doc", ".docx", ".jpg", "jpeg", ".png", ".xlsx", ".xls" }; // TODO: Traer de tabla paramétrica
            var extensionArchivo = Path.GetExtension(dto.NombreArchivo).ToLower();
            
            if(!extensionesPermitidas.Contains(extensionArchivo))
                throw new ApiException($"El tipo de este archivo no está permitido. Extensiones válidas: {string.Join(", ", extensionesPermitidas)}");

            // Genero nombre único para evitar colisiones
            var extension = Path.GetExtension(dto.NombreArchivo);
            var nombreUnico = $"{Guid.NewGuid()}{extension}";

            // Estructura de carpetas organizadas por empresa y reclamo
            var folder = $"reclamos/{reclamoExistente.IdEmpresa}/{reclamoExistente.CodigoReclamo}";

            //Subo el archivo a Azure Blob Storage
            string urlArchivo;
            using ( var stream = dto.ArchivoStream)
            {
                urlArchivo = await _blobStorageService.UploadFileAsync(
                    nombreUnico,
                    dto.ContentType,
                    stream,
                    folder
                );
            }

            // Creo dto con la url de azure
            var dtoConUrl = new SubirArchivoReclamoDto
            {
                NombreArchivo = dto.NombreArchivo,
                ContentType = dto.ContentType,
                TamañoBytes = dto.TamañoBytes,
                RutaArchivo = urlArchivo
            };

            var usuarioActual = ObtenerUsuarioActual();
            var archivo = await _reclamoRepository.SubirArchivoAsync(idReclamo, dto, usuarioActual);

            if (archivo == null)
                throw new ApiException("Error al subir el archivo");

            return archivo;
        }
        public async Task<List<ReclamoArchivoDto>> ObtenerArchivosAsync(int idReclamo)
        {
            await ObtenerReclamoPorIdAsync(idReclamo);

            return await _reclamoRepository.ObtenerArchivosAsync(idReclamo);
        }
        public async Task<(Stream FileStream, string ContentType, string FileName)> DescargarArchivoAsync(int idReclamo, int idReclamoArchivo)
        {
            await ObtenerReclamoPorIdAsync(idReclamo);

            var archivo = await _reclamoRepository.ObtenerArchivoPorIdAsync(idReclamoArchivo);
            if (archivo == null || archivo.IdReclamo != idReclamo)
                throw new ApiException("Archivo no encontrado");

            var (fileStream, contentType, fileName) = await _blobStorageService.DownloadFileAsync(archivo.RutaArchivo);

            return (fileStream, contentType, archivo.NombreArchivo);
        }

        public async Task<ReclamoComentarioDto> AgregarComentarioAsync(int idReclamo, AgregarComentarioDto dto)
        {
            await ObtenerReclamoPorIdAsync(idReclamo);

            var usuarioActual = ObtenerUsuarioActual();
            var comentario = await _reclamoRepository.AgregarComentarioAsync(idReclamo, dto, usuarioActual);
            
            if (comentario == null)
                throw new ApiException("Error al agregar el comentario");

            return comentario;
        }
        public async Task<List<ReclamoComentarioDto>> ObtenerComentariosAsync(int idReclamo)
        {
            await ObtenerReclamoPorIdAsync(idReclamo);
            
            // TODO: Si el usuario no es staff, solo mostrar comentarios públicos (EsInterno = false)
            return await _reclamoRepository.ObtenerComentariosAsync(idReclamo, incluirInternos: true);
        }
        public async Task<List<ReclamoEstadoHistorialDto>> ObtenerHistorialEstadosAsync(int idReclamo)
        {
            await ObtenerReclamoPorIdAsync(idReclamo);
            return await _reclamoRepository.ObtenerHistorialEstadosAsync(idReclamo);
        }
        public async Task<ConsultaEstadoReclamoDto?> ConsultarEstadoReclamoPublicoAsync(string numeroDocumento, string codigoReclamo)
        {
            return await _reclamoRepository.ConsultarEstadoPublicoAsync(numeroDocumento, codigoReclamo);
        }

        public async Task<ReclamoDto> ActualizarReclamoAsync(int idReclamo, ActualizarReclamoDto dto)
        {
            var reclamoExistente = await ObtenerReclamoPorIdAsync(idReclamo);

            if (dto.TipoPersona != null)
                ValidarDatosReclamanteParcial(dto);
            

            if (dto.IdEntidadFinancieraEmpresa.HasValue)
            {
                // TODO: Validar que la entidad financiera existe
            }

            // Validar IdTipoProducto si se está actualizando
            if (dto.IdTipoProducto.HasValue)
            {
                // TODO: Validar que el tipo de producto existe en Parametrica
            }

            var usuarioActual = ObtenerUsuarioActual();
            var reclamo = await _reclamoRepository.ActualizarReclamoAsync(idReclamo, dto, usuarioActual);

            if (reclamo == null)
                throw new ApiException("Error al actualizar el reclamo");

            return reclamo;
        }

        public async Task<bool> EliminarReclamoAsync(int idReclamo)
        {
            var reclamoExistente = await ObtenerReclamoPorIdAsync(idReclamo);

            var usuarioActual = ObtenerUsuarioActual();
            var resultado = await _reclamoRepository.EliminarReclamoAsync(idReclamo, usuarioActual);

            if (!resultado)
                throw new ApiException("Error al eliminar el reclamo");

            return true;
        }

        public async Task<ReclamoDto> ValidarAdmisionAsync(int idReclamo, ValidarAdmisionReclamoDto dto)
        {

            var reclamoExistente = await ObtenerReclamoPorIdAsync(idReclamo);

            // TODO: Validar permisos por rol específico (solo usuarios con rol de "Analista" o "Supervisor" pueden validar)

            var usuarioActual = ObtenerUsuarioActual();
            var reclamo = await _reclamoRepository.ValidarAdmisionAsync(idReclamo, dto, usuarioActual);

            if (reclamo == null)
                throw new ApiException("Error al validar la admisión del reclamo");

            // TODO: Enviar notificación al reclamante
            // if (dto.EsAdmitido)
            //     await _notificationService.NotificarAdmisionAsync(reclamo);
            // else
            //     await _notificationService.NotificarDenegacionAsync(reclamo, dto.Motivo);

            return reclamo;
        }

        public async Task<ReclamoConSubsanacionDto> SolicitarSubsanacionAsync(int idReclamo, SolicitarSubsanacionDto dto)
        {

            var reclamoExistente = await ObtenerReclamoPorIdAsync(idReclamo);

            // TODO: Traer los días para subsanar de la tabla Paramétrica
            if (dto.DiasParaSubsanar < 1 || dto.DiasParaSubsanar > 30)
                throw new ApiException("El plazo para subsanar debe estar entre 1 y 30 días");

            var usuarioActual = ObtenerUsuarioActual();
            var reclamo = await _reclamoRepository.SolicitarSubsanacionAsync(idReclamo, dto, usuarioActual);

            if (reclamo == null)
                throw new ApiException("Error al solicitar la subsanación");

            // TODO: Enviar notificación al reclamante con la información requerida
            // await _notificationService.NotificarSubsanacionAsync(reclamo);

            return reclamo;
        }
    }
}
