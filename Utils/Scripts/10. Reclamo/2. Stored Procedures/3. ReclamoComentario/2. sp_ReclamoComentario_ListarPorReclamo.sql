USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoComentario_ListarPorReclamo
	@IdReclamo INT,
	@IncluirInternos BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM ReclamoComentario
    WHERE IdReclamo = @IdReclamo
		AND Eliminado = 0
		AND (@IncluirInternos = 1 OR EsInterno = 0)
	ORDER BY FechaComentario DESC
END
GO