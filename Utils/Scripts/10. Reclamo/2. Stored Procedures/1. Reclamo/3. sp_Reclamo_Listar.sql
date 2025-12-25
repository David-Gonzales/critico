USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_Listar
    @IdEmpresa INT = NULL,
    @IdEstado INT = NULL,
	@IdEntidadFinancieraEmpresa INT = NULL,
    @IdUsuarioAsignado INT = NULL,
    @NumeroDocumento NVARCHAR(20) = NULL,
    @CodigoReclamo NVARCHAR(20) = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL,
    @SoloActivos BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        r.IdReclamo,
        r.CodigoReclamo,
        r.NumeroDocumento,
        r.NombresReclamante,
        r.ApellidosReclamante,
        r.RazonSocial,
        r.EmailReclamante,
        r.TelefonoReclamante,
        r.FechaHechos,
        r.MontoReclamado,
        r.MonedaReclamado,
        r.FechaCreacion,
        r.FechaLimiteRespuesta,
        r.DiasPlazo,
        r.DiasAmpliados,
        
        -- Estado
        re.Codigo AS CodigoEstado,
        re.Nombre AS NombreEstado,
        re.Color AS ColorEstado,
        
        -- Entidad Financiera
		r.IdEntidadFinancieraEmpresa,
		efe.IdEntidadFinanciera,
        ef.Nombre AS NombreEntidadFinanciera,
		efe.LogoUrl AS LogoEntidad,
        
        -- Empresa
        e.Nombre AS NombreEmpresa,
        
        -- Usuario asignado
        CASE 
            WHEN u.IdUsuario IS NOT NULL 
            THEN u.Nombres + ' ' + u.Apellidos 
            ELSE 'Sin asignar' 
        END AS NombreUsuarioAsignado,
        
        -- Indicador de vencimiento
        CASE 
            WHEN r.FechaLimiteRespuesta < GETDATE() THEN 'VENCIDO'
            WHEN DATEDIFF(DAY, GETDATE(), r.FechaLimiteRespuesta) <= 5 THEN 'POR_VENCER'
            ELSE 'VIGENTE'
        END AS EstadoVencimiento
        
    FROM 
		Reclamo r
		INNER JOIN ReclamoEstado re ON r.IdEstadoActual = re.IdReclamoEstado
		INNER JOIN EntidadFinancieraEmpresa efe ON r.IdEntidadFinancieraEmpresa = efe.IdEntidadFinancieraEmpresa
		INNER JOIN EntidadFinanciera ef ON efe.IdEntidadFinanciera = ef.IdEntidadFinanciera
		INNER JOIN Empresa e ON r.IdEmpresa = e.IdEmpresa
		LEFT JOIN Usuario u ON r.IdUsuarioAsignado = u.IdUsuario
    
    WHERE 
		r.Eliminado = 0 AND
		(@SoloActivos = 0 OR r.Activo = 1) AND
		(@IdEmpresa IS NULL OR r.IdEmpresa = @IdEmpresa) AND
		(@IdEstado IS NULL OR r.IdEstadoActual = @IdEstado) AND
		(@IdEntidadFinancieraEmpresa IS NULL OR r.IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa) AND
		(@IdUsuarioAsignado IS NULL OR r.IdUsuarioAsignado = @IdUsuarioAsignado) AND
		(@NumeroDocumento IS NULL OR r.NumeroDocumento = @NumeroDocumento) AND
		(@CodigoReclamo IS NULL OR r.CodigoReclamo LIKE '%' + @CodigoReclamo + '%') AND
		(@FechaDesde IS NULL OR r.FechaCreacion >= @FechaDesde) AND
		(@FechaHasta IS NULL OR r.FechaCreacion <= @FechaHasta)
    
    ORDER BY r.FechaCreacion DESC
END
GO