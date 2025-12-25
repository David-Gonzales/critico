USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_Eliminar
    @IdReclamo INT,
    @EliminadoPor NVARCHAR(50),
	@FechaEliminacion DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM Reclamo Where IdReclamo = @IdReclamo)
	BEGIN
		RAISERROR('Reclamo no encontrado', 16, 1)
		RETURN
	END
    
    -- SOFT DELETE
    UPDATE 
		Reclamo

    SET 
		Eliminado = 1,
		Activo = 0,
        EditadoPor = @EliminadoPor,
		FechaEdicion = @FechaEliminacion

    WHERE 
		IdReclamo = @IdReclamo
    
    SELECT 1 AS Success
END
GO