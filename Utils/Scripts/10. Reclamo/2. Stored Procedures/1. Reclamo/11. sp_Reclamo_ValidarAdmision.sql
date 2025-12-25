USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_ValidarAdmision
    @IdReclamo INT,
    @EsAdmitido BIT,
    @Motivo NVARCHAR(2000),
    @Observaciones NVARCHAR(MAX) = NULL,
    @ValidadoPor NVARCHAR(50),
    @FechaValidacion DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdEstadoActual INT
    DECLARE @IdEstadoNuevo INT
    DECLARE @CodigoEstadoActual NVARCHAR(100)
    DECLARE @IdEmpresa INT
    
	-- Obtengo el estado actual y la empresa del reclamo
    SELECT 
        @IdEstadoActual = r.IdEstadoActual,
        @CodigoEstadoActual = re.Codigo,
        @IdEmpresa = r.IdEmpresa
    FROM 
		Reclamo r 
		INNER JOIN ReclamoEstado re ON r.IdEstadoActual = re.IdReclamoEstado
    WHERE 
		r.IdReclamo = @IdReclamo AND 
		r.Eliminado = 0
    
    IF @IdEstadoActual IS NULL
		BEGIN
			RAISERROR('Reclamo no encontrado', 16, 1)
			RETURN
		END

	-- Valido que el reclamo esté en estado "REGISTRADO o EN PPROCESO/REVISIÓN"
    IF NOT (@CodigoEstadoActual LIKE '%_REGISTRADO' OR @CodigoEstadoActual LIKE '%_EN_PROCESO')
	BEGIN
		RAISERROR('El reclamo debe estar en estado de registro o revisión para ser validado', 16, 1)
		RETURN
	END

	-- Determino nuevo estado según decisión
    IF @EsAdmitido = 1
	BEGIN
		-- Buscar estado que termine en "ADMITIDO" o "EN PROCESO"
		SELECT TOP 1 @IdEstadoNuevo = IdReclamoEstado
		FROM ReclamoEstado
		WHERE 
			IdEmpresa = @IdEmpresa AND 
			(Codigo LIKE '%_ADMITIDO' OR Codigo LIKE '%_EN_PROCESO') AND 
			Activo = 1 AND 
			Eliminado = 0
		ORDER BY Orden ASC
	END

    ELSE
	BEGIN
		-- Busco el estado que termine en "INADMISIBLE" o "DENEGADO"
		SELECT TOP 1 @IdEstadoNuevo = IdReclamoEstado
		FROM ReclamoEstado
		WHERE 
			IdEmpresa = @IdEmpresa AND 
			(Codigo LIKE '%_INADMISIBLE' OR Codigo LIKE '%_DENEGADO') AND 
			Activo = 1 AND 
			Eliminado = 0
		ORDER BY Orden DESC
	END
	
	IF @IdEstadoNuevo IS NULL
		BEGIN
			RAISERROR('No se encontró un estado válido para la decisión de admisión', 16, 1)
			RETURN
		END
    
    -- Actualizo y termino registando en el historial
    UPDATE Reclamo
	SET 
		IdEstadoActual = @IdEstadoNuevo,
		FechaEdicion = @FechaValidacion,
		EditadoPor = @ValidadoPor
	WHERE 
		IdReclamo = @IdReclamo
    
    INSERT INTO ReclamoEstadoHistorial (
        IdReclamo, IdEstadoAnterior, IdEstadoNuevo,
        Motivo, Observaciones, FechaCambio, CambiadoPor )
    VALUES (
        @IdReclamo, @IdEstadoActual, @IdEstadoNuevo,
        @Motivo, @Observaciones, @FechaValidacion, @ValidadoPor )
    
    EXEC sp_Reclamo_ObtenerPorId @IdReclamo
END
GO