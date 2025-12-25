USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_Asignar
    @IdReclamo INT,
    @IdUsuarioNuevo INT,
    @Motivo NVARCHAR(500) = NULL,
    @Prioridad NVARCHAR(20) = NULL,
    @AsignadoPor NVARCHAR(50),
	@FechaAsignacion DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdUsuarioAnterior INT
    
    -- Obtener usuario anterior
    SELECT @IdUsuarioAnterior = IdUsuarioAsignado
    FROM Reclamo
    WHERE IdReclamo = @IdReclamo
    
    -- Actualizar asignación
    UPDATE Reclamo
    SET IdUsuarioAsignado = @IdUsuarioNuevo,
        FechaAsignacion = @FechaAsignacion,
        FechaEdicion = @FechaAsignacion,
        EditadoPor = @AsignadoPor
    WHERE IdReclamo = @IdReclamo
    
    -- Registrar en historial de asignaciones
    INSERT INTO ReclamoAsignacion (
        IdReclamo, IdUsuarioAnterior, IdUsuarioNuevo,
        Motivo, Prioridad, FechaAsignacion, AsignadoPor
    )
    VALUES (
        @IdReclamo, @IdUsuarioAnterior, @IdUsuarioNuevo,
        @Motivo, @Prioridad, @FechaAsignacion, @AsignadoPor
    )
    
    -- Devolver reclamo actualizado
    EXEC sp_Reclamo_ObtenerPorId @IdReclamo
END
GO