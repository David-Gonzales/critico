USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinanciera_Eliminar
    @IdEntidadFinanciera INT,
    @FechaEdicion DATETIME,
    @EliminadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verifico si está en uso
    IF EXISTS (
        SELECT 1 FROM EntidadFinancieraEmpresa 
        WHERE IdEntidadFinanciera = @IdEntidadFinanciera 
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('No se puede eliminar porque la entidad está asignada a una o más empresas.', 16, 1)
        RETURN
    END
    
    UPDATE 
		EntidadFinanciera
    SET 
		Eliminado = 1,
        Activo = 0,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EliminadoPor
    WHERE 
		IdEntidadFinanciera = @IdEntidadFinanciera
    
    SELECT 1 AS Success
END
GO