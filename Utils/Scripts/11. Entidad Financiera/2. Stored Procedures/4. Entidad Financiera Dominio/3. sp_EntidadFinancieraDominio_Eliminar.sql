USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraDominio_Eliminar
    @IdEntidadFinancieraDominio INT,
    @FechaEdicion DATETIME,
    @EliminadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE 
		EntidadFinancieraDominio
    SET 
		Eliminado = 1,
        Activo = 0,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EliminadoPor
    WHERE 
		IdEntidadFinancieraDominio = @IdEntidadFinancieraDominio
    
    SELECT 1 AS Success
END
GO