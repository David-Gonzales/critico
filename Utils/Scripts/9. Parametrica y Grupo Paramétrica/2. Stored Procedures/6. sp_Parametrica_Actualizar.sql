USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Parametrica_Actualizar
    @IdParametrica INT,
    @Alias NVARCHAR(100) = NULL,
    @Nombre NVARCHAR(500),
    @Valor NVARCHAR(MAX) = NULL,
    @Descripcion NVARCHAR(1000) = NULL,
    @Orden INT = NULL,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE Parametrica
    SET 
		Alias = ISNULL(@Alias, Alias),
        Nombre = ISNULL(@Nombre, Nombre),
        Valor = ISNULL(@Valor, Valor),
        Descripcion = ISNULL(@Descripcion, Descripcion),
        Orden = ISNULL(@Orden, Orden),
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE 
		IdParametrica = @IdParametrica

	EXEC sp_Parametrica_ObtenerPorId @IdParametrica
END
GO