USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoEstado_Crear
	@Codigo NVARCHAR(50),
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(500) = NULL,
    @Orden INT = NULL,
    @Color NVARCHAR(20),
    @EsEstadoFinal BIT = 0,
    @EsEliminable BIT = 1,
    @IdEmpresa INT,
    @FechaCreacion DATETIME,
    @CreadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
	
	DECLARE @IdReclamoEstado INT

	-- Si el usuario no especifica el orden, que se use el siguiente disponible
    IF @Orden IS NULL
    BEGIN
        SELECT @Orden = ISNULL(MAX(Orden), 0) + 1
        FROM ReclamoEstado
        WHERE IdEmpresa = @IdEmpresa
    END
    
	-- Valido si ya existe el código a crear
    IF EXISTS (
        SELECT 1 FROM ReclamoEstado 
        WHERE Codigo = @Codigo 
          AND IdEmpresa = @IdEmpresa 
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('Ya existe un estado con ese código en esta empresa', 16, 1)
        RETURN
    END

	INSERT INTO ReclamoEstado (
        Codigo, Nombre, Descripcion, Orden, Color,
        EsEstadoFinal, EsEliminable, IdEmpresa,
        FechaCreacion, CreadoPor
    )
    VALUES (
        @Codigo, @Nombre, @Descripcion, @Orden, @Color,
        @EsEstadoFinal, @EsEliminable, @IdEmpresa,
        @FechaCreacion, @CreadoPor
    )
    
    SET @IdReclamoEstado = SCOPE_IDENTITY()

	EXEC sp_ReclamoEstado_ObtenerPorId @IdReclamoEstado
END
GO