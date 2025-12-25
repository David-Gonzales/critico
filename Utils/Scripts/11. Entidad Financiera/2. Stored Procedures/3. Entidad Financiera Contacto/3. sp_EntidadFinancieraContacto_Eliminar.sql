USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraContacto_Eliminar
    @IdEntidadFinancieraContacto INT,
    @FechaEdicion DATETIME,
    @EliminadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE EntidadFinancieraContacto
    SET Eliminado = 1,
        Activo = 0,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EliminadoPor
    WHERE IdEntidadFinancieraContacto = @IdEntidadFinancieraContacto
    
    SELECT 1 AS Success
END
GO