USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Parametrica_CambiarEstado
    @IdParametrica INT,
	@Activo BIT,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE Parametrica
    SET Activo = @Activo,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE IdParametrica = @IdParametrica

	EXEC sp_Parametrica_ObtenerPorId @IdParametrica

END
GO