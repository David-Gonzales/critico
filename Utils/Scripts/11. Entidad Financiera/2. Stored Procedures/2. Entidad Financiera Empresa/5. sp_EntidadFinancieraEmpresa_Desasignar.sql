USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraEmpresa_Desasignar
    @IdEntidadFinancieraEmpresa INT,
    @FechaEdicion DATETIME,
    @EliminadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verifico si está en uso en reclamos
    IF EXISTS (
        SELECT 1 FROM Reclamo 
        WHERE IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa 
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('No se puede desasignar porque hay reclamos asociados a esta entidad financiera', 16, 1)
        RETURN
    END
    
    UPDATE 
		EntidadFinancieraEmpresa
    SET 
		Eliminado = 1,
        Activo = 0,
        Visible = 0,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EliminadoPor
    WHERE 
		IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa
    
    SELECT 1 AS Success
END
GO