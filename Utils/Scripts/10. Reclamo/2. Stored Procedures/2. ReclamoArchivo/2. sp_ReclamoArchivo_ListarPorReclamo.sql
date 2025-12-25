USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoArchivo_ListarPorReclamo
	@IdReclamo INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM ReclamoArchivo
    WHERE IdReclamo = @IdReclamo
		AND Eliminado = 0
	ORDER BY FechaSubida DESC
END
GO