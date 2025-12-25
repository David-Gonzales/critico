USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_CambiarEstado
    @IdReclamo INT,
    @IdEstadoNuevo INT,
    @Motivo NVARCHAR(500) = NULL,
    @Observaciones NVARCHAR(MAX) = NULL,
    @CambiadoPor NVARCHAR(50),
	@FechaCambio DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdEstadoAnterior INT
    
    -- Obtener estado actual
    SELECT @IdEstadoAnterior = IdEstadoActual
    FROM Reclamo
    WHERE IdReclamo = @IdReclamo
    
    IF @IdEstadoAnterior IS NULL
    BEGIN
        RAISERROR('Reclamo no encontrado', 16, 1)
        RETURN
    END
    
    -- Actualizar estado del reclamo
    UPDATE Reclamo
    SET IdEstadoActual = @IdEstadoNuevo,
        FechaEdicion = @FechaCambio,
        EditadoPor = @CambiadoPor
    WHERE IdReclamo = @IdReclamo
    
    -- Registrar en historial
    INSERT INTO ReclamoEstadoHistorial (
        IdReclamo, IdEstadoAnterior, IdEstadoNuevo,
        Motivo, Observaciones, FechaCambio, CambiadoPor
    )
    VALUES (
        @IdReclamo, @IdEstadoAnterior, @IdEstadoNuevo,
        @Motivo, @Observaciones, @FechaCambio, @CambiadoPor
    )
    
    -- Devolver reclamo actualizado
    EXEC sp_Reclamo_ObtenerPorId @IdReclamo
END
GO
