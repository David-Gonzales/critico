USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoArchivo_ObtenerPorId
	@IdReclamoArchivo INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM ReclamoArchivo
    WHERE IdReclamoArchivo = @IdReclamoArchivo AND Eliminado = 0
END
GO