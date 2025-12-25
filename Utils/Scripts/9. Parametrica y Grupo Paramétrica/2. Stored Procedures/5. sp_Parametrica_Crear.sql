USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Parametrica_Crear
    @IdGrupoParametrica INT,
    @Alias NVARCHAR(100) = NULL,
    @Nombre NVARCHAR(500),
    @Valor NVARCHAR(MAX) = NULL,
    @Descripcion NVARCHAR(1000) = NULL,
    @Orden INT = NULL,
    @EsEliminable BIT = 1,
    @FechaCreacion DATETIME,
    @CreadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @IdParametrica INT
    
	IF @Orden IS NULL
    BEGIN
        SELECT @Orden = ISNULL(MAX(Orden), 0) + 1
        FROM Parametrica
        WHERE IdGrupoParametrica = @IdGrupoParametrica
    END
    
    INSERT INTO Parametrica (
        IdGrupoParametrica, Alias, Nombre, Valor, Descripcion,
        Orden, EsEliminable, FechaCreacion, CreadoPor
    )
    VALUES (
        @IdGrupoParametrica, @Alias, @Nombre, @Valor, @Descripcion,
        @Orden, @EsEliminable, @FechaCreacion, @CreadoPor
    )
    
    SET @IdParametrica = SCOPE_IDENTITY()

	EXEC sp_Parametrica_ObtenerPorId @IdParametrica
END
GO