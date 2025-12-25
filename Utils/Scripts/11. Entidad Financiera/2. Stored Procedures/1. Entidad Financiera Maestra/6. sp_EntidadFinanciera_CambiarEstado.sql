USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinanciera_CambiarEstado
    @IdEntidadFinanciera INT,
    @Activo BIT,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE EntidadFinanciera
    SET 
		Activo = @Activo,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE 
		IdEntidadFinanciera = @IdEntidadFinanciera
    
    EXEC sp_EntidadFinanciera_ObtenerPorId @IdEntidadFinanciera
END
GO