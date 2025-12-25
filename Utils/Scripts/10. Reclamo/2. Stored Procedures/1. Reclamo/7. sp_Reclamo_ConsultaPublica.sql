USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_ConsultaPublica
    @NumeroDocumento NVARCHAR(20),
    @CodigoReclamo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        r.CodigoReclamo,
		r.NumeroDocumento,
		r.FechaCreacion,

		re.Nombre AS NombreEstado,
		re.Color AS ColorEstado,

		r.FechaLimiteRespuesta,

		ef.Nombre AS NombreEntidadFinanciera,
		efe.LogoUrl AS LogoEntidad,

		r.NumeroResolucion,
		r.FechaResolucion
        
    FROM Reclamo r
		INNER JOIN ReclamoEstado re ON r.IdEstadoActual = re.IdReclamoEstado
		INNER JOIN EntidadFinancieraEmpresa efe ON r.IdEntidadFinancieraEmpresa = efe.IdEntidadFinanciera
		INNER JOIN EntidadFinanciera ef ON efe.IdEntidadFinanciera = ef.IdEntidadFinanciera
    WHERE 
		r.NumeroDocumento = @NumeroDocumento AND 
		r.CodigoReclamo = @CodigoReclamo AND 
		r.Eliminado = 0 AND 
		r.Activo = 1
END
GO