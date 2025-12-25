USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoEstado_Actualizar
	@IdReclamoEstado INT,
	@Codigo NVARCHAR(50) = NULL,
    @Nombre NVARCHAR(100) = NULL,
    @Descripcion NVARCHAR(500) = NULL,
    @Orden INT = NULL,
    @Color NVARCHAR(20) = NULL,
    @EsEstadoFinal BIT = NULL,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
	
	DECLARE @IdEmpresa INT
	DECLARE @EsEstadoSistema BIT
    DECLARE @CodigoActual NVARCHAR(50)

	-- Obtengo info del estado
    SELECT 
        @IdEmpresa = IdEmpresa,
        @EsEstadoSistema = EsEstadoSistema,
        @CodigoActual = Codigo
    FROM ReclamoEstado
    WHERE IdReclamoEstado = @IdReclamoEstado

	--No permito cambiar código de estados del sistema
    IF @EsEstadoSistema = 1 AND @Codigo IS NOT NULL AND @Codigo != @CodigoActual
    BEGIN
        RAISERROR('No se puede modificar el código de un estado del sistema', 16, 1)
        RETURN
    END

	-- Valido el código único
    IF @Codigo IS NOT NULL AND EXISTS (
        SELECT 1 FROM ReclamoEstado 
        WHERE Codigo = @Codigo 
          AND IdEmpresa = @IdEmpresa 
          AND IdReclamoEstado != @IdReclamoEstado
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('Ya existe un estado con ese código en esta empresa', 16, 1)
        RETURN
    END

	UPDATE ReclamoEstado
    SET 
		Codigo = ISNULL(@Codigo, Codigo),
        Nombre = ISNULL(@Nombre, Nombre),
        Descripcion = ISNULL(@Descripcion, Descripcion),
        Orden = ISNULL(@Orden, Orden),
        Color = ISNULL(@Color, Color),
        EsEstadoFinal = ISNULL(@EsEstadoFinal, EsEstadoFinal),
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE 
		IdReclamoEstado = @IdReclamoEstado
    
    EXEC sp_ReclamoEstado_ObtenerPorId @IdReclamoEstado


END
GO