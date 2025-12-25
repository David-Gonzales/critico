USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoEstado_Eliminar
	@IdReclamoEstado INT,
    @FechaEdicion DATETIME,
    @EliminadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
	
	DECLARE @EsEliminable BIT
    DECLARE @EsEstadoSistema BIT

	-- Verifico si es eliminable y si es del sistema
    SELECT 
        @EsEliminable = EsEliminable,
        @EsEstadoSistema = EsEstadoSistema
    FROM ReclamoEstado
    WHERE IdReclamoEstado = @IdReclamoEstado
    
    IF @EsEstadoSistema = 1
    BEGIN
        RAISERROR('Este estado es del sistema y no se puede eliminar', 16, 1)
        RETURN
    END
    
    IF @EsEliminable = 0
    BEGIN
        RAISERROR('Este estado no se puede eliminar', 16, 1)
        RETURN
    END
    
    -- Verifico si está en uso
    IF EXISTS (
        SELECT 1 FROM Reclamo 
        WHERE IdEstadoActual = @IdReclamoEstado 
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('No se puede eliminar porque hay reclamos en este estado', 16, 1)
        RETURN
    END
    
    UPDATE 
		ReclamoEstado
    SET 
		Eliminado = 1,
        Activo = 0,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EliminadoPor
    WHERE 
		IdReclamoEstado = @IdReclamoEstado
    
    SELECT 1 AS Success

END
GO