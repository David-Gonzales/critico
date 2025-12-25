USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraEmpresa_CambiarEstado
    @IdEntidadFinancieraEmpresa INT,
    @Activo BIT,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE 
		EntidadFinancieraEmpresa
    SET 
		Activo = @Activo,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE 
		IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa
    
    EXEC sp_EntidadFinancieraEmpresa_ObtenerPorId @IdEntidadFinancieraEmpresa
END
GO