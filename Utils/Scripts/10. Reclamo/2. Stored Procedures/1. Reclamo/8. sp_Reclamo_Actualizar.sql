USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_Actualizar
	@IdReclamo INT,
    
    -- Reclamante
    @TipoPersona NVARCHAR(20) = NULL,
    @TipoDocumento NVARCHAR(20) = NULL,
    @NumeroDocumento NVARCHAR(20) = NULL,
    @NombresReclamante NVARCHAR(200) = NULL,
    @ApellidosReclamante NVARCHAR(200) = NULL,
	@FechaNacimiento DATE = NULL,
    @RazonSocial NVARCHAR(300) = NULL,
    @RepresentanteLegalNombres NVARCHAR(200) = NULL,
    @RepresentanteLegalDNI NVARCHAR(20) = NULL,
    @EmailReclamante NVARCHAR(200) = NULL,
    @TelefonoReclamante NVARCHAR(20) = NULL,
    @OtroTelefonoReclamante NVARCHAR(20) = NULL,
    @DireccionReclamante NVARCHAR(500) = NULL,
    
    -- Canal (DCF)
    @TipoCanal NVARCHAR(50) = NULL,
    
    -- Entidad y producto
    @IdEntidadFinancieraEmpresa INT = NULL,
    @IdTipoProducto INT = NULL,
    @NumeroProducto NVARCHAR(50) = NULL,
    @NumeroReclamoEntidad NVARCHAR(50) = NULL,
    @FechaRegistroEntidad DATE = NULL,
    
    -- Tipo y motivo
    @IdTipoRequerimiento INT = NULL,
    @IdMotivoReclamo INT = NULL,
    
    -- Hechos
    @FechaHechos DATE = NULL,
    @HoraHechos TIME = NULL,
    @DescripcionHechos NVARCHAR(MAX) = NULL,
    @Caso NVARCHAR(MAX) = NULL,
    @MontoReclamado DECIMAL(18,2) = NULL,
    @MonedaReclamado NVARCHAR(10) = NULL,
    
    -- Solución
    @SolucionSolicitada NVARCHAR(MAX) = NULL,
    @ResultadoEsperado NVARCHAR(500) = NULL,
    
	-- Reclamo en otra instancia (AloBanco)
    @PresentoReclamoOtraInstancia BIT = NULL,
    @IdInstancia INT = NULL,
    @FechaPresentacionOtraInstancia DATE = NULL,
    
    -- Fuente (AloBanco)
    @IdFuente INT = NULL,
    @ComoSeEnteroAlobanco NVARCHAR(500) = NULL,
    
    -- Auditoría
    @EditadoPor NVARCHAR(50),
	@FechaEdicion DATETIME
AS
BEGIN
    SET NOCOUNT ON;

	-- Valido si se actrualiza la EntidadFinancieraEmpresa verifico que esta perteneza a la misma empresa

	IF @IdEntidadFinancieraEmpresa IS NOT NULL
    BEGIN
        DECLARE @IdEmpresaReclamo INT
        SELECT @IdEmpresaReclamo = IdEmpresa FROM Reclamo WHERE IdReclamo = @IdReclamo
        
        IF NOT EXISTS (
            SELECT 1 FROM EntidadFinancieraEmpresa 
            WHERE IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa
              AND IdEmpresa = @IdEmpresaReclamo
              AND Eliminado = 0
        )
        BEGIN
            RAISERROR('La entidad financiera no está asignada a esta empresa', 16, 1)
            RETURN
        END
    END
    
    UPDATE Reclamo 

	SET
        TipoPersona = ISNULL(@TipoPersona, TipoPersona),
        TipoDocumento = ISNULL(@TipoDocumento, TipoDocumento),
        NumeroDocumento = ISNULL(@NumeroDocumento, NumeroDocumento),
        NombresReclamante = ISNULL(@NombresReclamante, NombresReclamante),
        ApellidosReclamante = ISNULL(@ApellidosReclamante, ApellidosReclamante),
		FechaNacimiento = ISNULL(@FechaNacimiento, FechaNacimiento),
        RazonSocial = ISNULL(@RazonSocial, RazonSocial),
        RepresentanteLegalNombres = ISNULL(@RepresentanteLegalNombres, RepresentanteLegalNombres),
        RepresentanteLegalDNI = ISNULL(@RepresentanteLegalDNI, RepresentanteLegalDNI),
        EmailReclamante = ISNULL(@EmailReclamante, EmailReclamante),
        TelefonoReclamante = ISNULL(@TelefonoReclamante, TelefonoReclamante),
        OtroTelefonoReclamante = ISNULL(@OtroTelefonoReclamante, OtroTelefonoReclamante),
        DireccionReclamante = ISNULL(@DireccionReclamante, DireccionReclamante),
        TipoCanal = ISNULL(@TipoCanal, TipoCanal),
        IdEntidadFinancieraEmpresa = ISNULL(@IdEntidadFinancieraEmpresa, IdEntidadFinancieraEmpresa),
        IdTipoProducto = ISNULL(@IdTipoProducto, IdTipoProducto),
        NumeroProducto = ISNULL(@NumeroProducto, NumeroProducto),
        NumeroReclamoEntidad = ISNULL(@NumeroReclamoEntidad, NumeroReclamoEntidad),
        FechaRegistroEntidad = ISNULL(@FechaRegistroEntidad, FechaRegistroEntidad),
        IdTipoRequerimiento = ISNULL(@IdTipoRequerimiento, IdTipoRequerimiento),
        IdMotivoReclamo = ISNULL(@IdMotivoReclamo, IdMotivoReclamo),
        FechaHechos = ISNULL(@FechaHechos, FechaHechos),
        HoraHechos = ISNULL(@HoraHechos, HoraHechos),
        DescripcionHechos = ISNULL(@DescripcionHechos, DescripcionHechos),
        Caso = ISNULL(@Caso, Caso),
        MontoReclamado = ISNULL(@MontoReclamado, MontoReclamado),
        MonedaReclamado = ISNULL(@MonedaReclamado, MonedaReclamado),
        SolucionSolicitada = ISNULL(@SolucionSolicitada, SolucionSolicitada),
        ResultadoEsperado = ISNULL(@ResultadoEsperado, ResultadoEsperado),
        PresentoReclamoOtraInstancia = ISNULL(@PresentoReclamoOtraInstancia, PresentoReclamoOtraInstancia),
        IdInstancia = ISNULL(@IdInstancia, IdInstancia),
        FechaPresentacionOtraInstancia = ISNULL(@FechaPresentacionOtraInstancia, FechaPresentacionOtraInstancia),
        IdFuente = ISNULL(@IdFuente, IdFuente),
        ComoSeEnteroAlobanco = ISNULL(@ComoSeEnteroAlobanco, ComoSeEnteroAlobanco),
        EditadoPor = @EditadoPor,
		FechaEdicion = @FechaEdicion
     
	 EXEC sp_Reclamo_ObtenerPorId @IdReclamo
END
GO