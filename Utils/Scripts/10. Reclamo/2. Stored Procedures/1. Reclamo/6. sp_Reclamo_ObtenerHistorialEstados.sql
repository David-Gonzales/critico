USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_ObtenerHistorialEstados
    @IdReclamo INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        h.IdReclamoEstadoHistorial,
		h.IdReclamo,
		h.IdEstadoAnterior,
		reAnterior.Nombre AS NombreEstadoAnterior,
		h.IdEstadoNuevo,
		reNuevo.Nombre AS NombreEstadoNuevo,
		h.Motivo,
		h.Observaciones,
		h.FechaCambio,
		h.CambiadoPor
        
    FROM ReclamoEstadoHistorial h
		LEFT JOIN ReclamoEstado reAnterior ON h.IdEstadoAnterior = reAnterior.IdReclamoEstado
		INNER JOIN ReclamoEstado reNuevo ON h.IdEstadoNuevo = reNuevo.IdReclamoEstado
    WHERE 
		h.IdReclamo = @IdReclamo
    ORDER BY 
		h.FechaCambio DESC
END
GO