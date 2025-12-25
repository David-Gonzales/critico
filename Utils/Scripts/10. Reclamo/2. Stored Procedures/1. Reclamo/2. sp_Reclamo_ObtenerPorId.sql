USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_ObtenerPorId
    @IdReclamo INT,
    @IdEmpresa INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        r.*,
        
        -- Estado
        re.Codigo AS CodigoEstado,
        re.Nombre AS NombreEstado,
        re.Color AS ColorEstado,
        
        -- Entidad Financiera
		efe.IdEntidadFinancieraEmpresa,
        ef.Codigo AS CodigoEntidad,
        ef.Nombre AS NombreEntidadFinanciera,
        ef.RUC AS RUCEntidad,

		efe.LogoUrl AS LogoEntidad,
		efe.EmailNotificacion AS EmailEntidad,
        
        -- Empresa
        e.Nombre AS NombreEmpresa,
        
        -- Usuario asignado
        u.NombreUsuario AS NombreUsuarioAsignado,
        u.Nombres + ' ' + u.Apellidos AS NombreCompletoAsignado,
        
        -- Paramétricas
        pTipoProd.Nombre AS NombreTipoProducto,
        pTipoReq.Nombre AS NombreTipoRequerimiento,
        pMotivo.Nombre AS NombreMotivoReclamo,
        pTipoResp.Nombre AS NombreTipoRespuesta,
        pInstancia.Nombre AS NombreInstancia,
        pFuente.Nombre AS NombreFuente
        
    FROM 
		Reclamo r
		INNER JOIN ReclamoEstado re ON r.IdEstadoActual = re.IdReclamoEstado
		INNER JOIN EntidadFinancieraEmpresa efe ON r.IdEntidadFinancieraEmpresa = efe.IdEntidadFinancieraEmpresa
		INNER JOIN EntidadFinanciera ef ON efe.IdEntidadFinanciera = ef.IdEntidadFinanciera
		INNER JOIN Empresa e ON r.IdEmpresa = e.IdEmpresa
		LEFT JOIN Usuario u ON r.IdUsuarioAsignado = u.IdUsuario
		LEFT JOIN Parametrica pTipoProd ON r.IdTipoProducto = pTipoProd.IdParametrica
		LEFT JOIN Parametrica pTipoReq ON r.IdTipoRequerimiento = pTipoReq.IdParametrica
		LEFT JOIN Parametrica pMotivo ON r.IdMotivoReclamo = pMotivo.IdParametrica
		LEFT JOIN Parametrica pTipoResp ON r.IdTipoRespuesta = pTipoResp.IdParametrica
		LEFT JOIN Parametrica pInstancia ON r.IdInstancia = pInstancia.IdParametrica
		LEFT JOIN Parametrica pFuente ON r.IdFuente = pFuente.IdParametrica

    WHERE 
		r.IdReclamo = @IdReclamo AND 
		r.Eliminado = 0 AND 
		(@IdEmpresa IS NULL OR r.IdEmpresa = @IdEmpresa)
END
GO