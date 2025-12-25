USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_Crear
    -- Datos básicos
    @CodigoReclamo NVARCHAR(20),
    @IdEmpresa INT,
    
    -- Reclamante
    @TipoPersona NVARCHAR(20) = NULL,
    @TipoDocumento NVARCHAR(20),
    @NumeroDocumento NVARCHAR(20),
    @NombresReclamante NVARCHAR(200),
    @ApellidosReclamante NVARCHAR(200) = NULL,
	@FechaNacimiento DATE = NULL,
    @RazonSocial NVARCHAR(300) = NULL,
    @RepresentanteLegalNombres NVARCHAR(200) = NULL,
    @RepresentanteLegalDNI NVARCHAR(20) = NULL,
    @EmailReclamante NVARCHAR(200),
    @TelefonoReclamante NVARCHAR(20) = NULL,
    @OtroTelefonoReclamante NVARCHAR(20) = NULL,
    @DireccionReclamante NVARCHAR(500) = NULL,
    
    -- Canal (DCF)
    @TipoCanal NVARCHAR(50) = NULL,
    
    -- Entidad y producto
    @IdEntidadFinancieraEmpresa INT,
    @IdTipoProducto INT = NULL,
    @NumeroProducto NVARCHAR(50) = NULL,
    @NumeroReclamoEntidad NVARCHAR(50) = NULL,
    @FechaRegistroEntidad DATE = NULL,
    
    -- Tipo y motivo
    @IdTipoRequerimiento INT = NULL,
    @IdMotivoReclamo INT = NULL,
    
    -- Hechos
    @FechaHechos DATE,
    @HoraHechos TIME = NULL,
    @DescripcionHechos NVARCHAR(MAX),
    @Caso NVARCHAR(MAX) = NULL,
    @MontoReclamado DECIMAL(18,2) = NULL,
    @MonedaReclamado NVARCHAR(10) = NULL,
    
    -- Solución
    @SolucionSolicitada NVARCHAR(MAX),
    @ResultadoEsperado NVARCHAR(500) = NULL,
    
    -- Estado inicial
    @IdEstadoActual INT,
    @DiasPlazo INT = 30,
    
    -- Reclamo en otra instancia (AloBanco)
    @PresentoReclamoOtraInstancia BIT = NULL,
    @IdInstancia INT = NULL,
    @FechaPresentacionOtraInstancia DATE = NULL,
    
    -- Fuente (AloBanco)
    @IdFuente INT = NULL,
    @ComoSeEnteroAlobanco NVARCHAR(500) = NULL,
    
    -- Auditoría
    @CreadoPor NVARCHAR(50),
	@FechaCreacion DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdReclamo INT
    DECLARE @FechaLimiteRespuesta DATETIME
    
	-- Valido que la EntidadFinancieraEmpresa existe y pertenece a la empresa seleccionada
	IF NOT EXISTS (
        SELECT 1 FROM EntidadFinancieraEmpresa 
        WHERE IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa
          AND IdEmpresa = @IdEmpresa
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('La entidad financiera no está asignada a esta empresa', 16, 1)
        RETURN
    END

    -- Calcular fecha límite (días hábiles)
    SET @FechaLimiteRespuesta = DATEADD(DAY, @DiasPlazo, @FechaCreacion)
    
    INSERT INTO Reclamo (
        CodigoReclamo, TipoPersona, TipoDocumento, NumeroDocumento,
        NombresReclamante, ApellidosReclamante, FechaNacimiento, RazonSocial,
        RepresentanteLegalNombres, RepresentanteLegalDNI,
        EmailReclamante, TelefonoReclamante, OtroTelefonoReclamante,
        DireccionReclamante, TipoCanal,
        IdEntidadFinancieraEmpresa, IdTipoProducto, NumeroProducto,
        NumeroReclamoEntidad, FechaRegistroEntidad,
        IdTipoRequerimiento, IdMotivoReclamo,
        FechaHechos, HoraHechos, DescripcionHechos, Caso,
        MontoReclamado, MonedaReclamado,
        SolucionSolicitada, ResultadoEsperado,
        IdEstadoActual, FechaLimiteRespuesta, DiasPlazo,
        PresentoReclamoOtraInstancia, IdInstancia, FechaPresentacionOtraInstancia,
        IdFuente, ComoSeEnteroAlobanco,
        IdEmpresa, FechaCreacion, CreadoPor
    )
    VALUES (
        @CodigoReclamo, @TipoPersona, @TipoDocumento, @NumeroDocumento,
        @NombresReclamante, @ApellidosReclamante, @FechaNacimiento, @RazonSocial,
        @RepresentanteLegalNombres, @RepresentanteLegalDNI,
        @EmailReclamante, @TelefonoReclamante, @OtroTelefonoReclamante,
        @DireccionReclamante, @TipoCanal,
        @IdEntidadFinancieraEmpresa, @IdTipoProducto, @NumeroProducto,
        @NumeroReclamoEntidad, @FechaRegistroEntidad,
        @IdTipoRequerimiento, @IdMotivoReclamo,
        @FechaHechos, @HoraHechos, @DescripcionHechos, @Caso,
        @MontoReclamado, @MonedaReclamado,
        @SolucionSolicitada, @ResultadoEsperado,
        @IdEstadoActual, @FechaLimiteRespuesta, @DiasPlazo,
        @PresentoReclamoOtraInstancia, @IdInstancia, @FechaPresentacionOtraInstancia,
        @IdFuente, @ComoSeEnteroAlobanco,
        @IdEmpresa, @FechaCreacion, @CreadoPor
    )
    
    SET @IdReclamo = SCOPE_IDENTITY()
    
    -- Registrar en historial de estados
    INSERT INTO ReclamoEstadoHistorial (
        IdReclamo, IdEstadoAnterior, IdEstadoNuevo,
        Motivo, FechaCambio, CambiadoPor
    )
    VALUES (
        @IdReclamo, NULL, @IdEstadoActual,
        'Estado inicial al crear el reclamo', @FechaCreacion, @CreadoPor
    )
    
    -- Devolver el reclamo creado
    SELECT 
        r.*,
        re.Nombre AS NombreEstado,
        re.Color AS ColorEstado,

        ef.Nombre AS NombreEntidadFinanciera,
        e.Nombre AS NombreEmpresa
    FROM 
		Reclamo r
    INNER JOIN 
		ReclamoEstado re ON r.IdEstadoActual = re.IdReclamoEstado
    INNER JOIN 
		EntidadFinancieraEmpresa efe ON r.IdEntidadFinancieraEmpresa = efe.IdEntidadFinancieraEmpresa
	INNER JOIN
		EntidadFinanciera ef ON efe.IdEntidadFinanciera = ef.IdEntidadFinanciera
    INNER JOIN 
		Empresa e ON r.IdEmpresa = e.IdEmpresa
    WHERE 
		r.IdReclamo = @IdReclamo
END
GO