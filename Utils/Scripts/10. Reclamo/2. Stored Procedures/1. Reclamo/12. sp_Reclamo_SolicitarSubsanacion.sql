USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_SolicitarSubsanacion
    @IdReclamo INT,
    @InformacionRequerida NVARCHAR(MAX),
    @DiasParaSubsanar INT,
    @Observaciones NVARCHAR(MAX) = NULL,
    @SolicitadoPor NVARCHAR(50),
    @FechaSolicitud DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdEstadoActual INT
    DECLARE @IdEstadoNuevo INT
    DECLARE @IdEmpresa INT
	DECLARE @FechaLimiteSubsanacion DATETIME
    DECLARE @IdReclamoSubsanacion INT
    
	-- Obtengo el estado actual y la empresa del reclamo
    SELECT 
        @IdEstadoActual = IdEstadoActual,
        @IdEmpresa = IdEmpresa
    FROM 
		Reclamo  
    WHERE 
		IdReclamo = @IdReclamo AND 
		Eliminado = 0
    
    IF @IdEstadoActual IS NULL
	BEGIN
		RAISERROR('Reclamo no encontrado', 16, 1)
		RETURN
	END

	--Busco el estado nuevo SUBSANACIÓN PENDIENTE
	SELECT TOP 1 @IdEstadoNuevo = IdReclamoEstado
    FROM ReclamoEstado
    WHERE 
		IdEmpresa = @IdEmpresa AND 
		Codigo LIKE '%_SUBSANACION_PENDIENTE' AND
		Activo = 1 AND 
		Eliminado = 0
    ORDER BY Orden ASC
    
    IF @IdEstadoNuevo IS NULL
    BEGIN
        RAISERROR('No se encontró el estado SUBSANACIÓN PENDIENTE configurado', 16, 1)
        RETURN
    END


	-- Calculo la fecha límite de subsanación
    SET @FechaLimiteSubsanacion = DATEADD(DAY, @DiasParaSubsanar, @FechaSolicitud)
    
    -- Registro la solicitud de subsanación
    INSERT INTO ReclamoSubsanacion (
        IdReclamo, InformacionRequerida, DiasParaSubsanar,
        FechaSolicitud, FechaLimiteSubsanacion, EstadoSubsanacion,
        Observaciones, FechaCreacion, CreadoPor
    )
    VALUES (
        @IdReclamo, @InformacionRequerida, @DiasParaSubsanar,
        @FechaSolicitud, @FechaLimiteSubsanacion, 'PENDIENTE',
        @Observaciones, @FechaSolicitud, @SolicitadoPor
    )
    
    SET @IdReclamoSubsanacion = SCOPE_IDENTITY()
    
    -- Actualizo el estado del reclamo y lo registro en el historial
    UPDATE Reclamo
    SET 
		IdEstadoActual = @IdEstadoNuevo,
        FechaEdicion = @FechaSolicitud,
        EditadoPor = @SolicitadoPor
    WHERE 
		IdReclamo = @IdReclamo
    
    INSERT INTO ReclamoEstadoHistorial (
        IdReclamo, IdEstadoAnterior, IdEstadoNuevo,
        Motivo, Observaciones, FechaCambio, CambiadoPor
    )
    VALUES (
        @IdReclamo, @IdEstadoActual, @IdEstadoNuevo,
        'Se solicitó subsanación de información', @InformacionRequerida, 
        @FechaSolicitud, @SolicitadoPor
    )
    
    -- Devolvo el reclamo actualizado + info de subsanación
    SELECT 
        r.*,
        s.IdReclamoSubsanacion,
        s.InformacionRequerida,
        s.DiasParaSubsanar,
        s.FechaLimiteSubsanacion,
        s.EstadoSubsanacion
    FROM 
		Reclamo r
    INNER JOIN ReclamoSubsanacion s ON s.IdReclamoSubsanacion = @IdReclamoSubsanacion
    WHERE 
		r.IdReclamo = @IdReclamo AND 
		s.IdReclamoSubsanacion = @IdReclamoSubsanacion
END
GO