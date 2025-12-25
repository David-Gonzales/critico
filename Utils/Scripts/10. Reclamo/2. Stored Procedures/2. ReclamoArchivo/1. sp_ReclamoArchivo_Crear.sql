USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoArchivo_Crear
	@IdReclamo INT,
	@NombreArchivo NVARCHAR(255),
	@NombreOriginal NVARCHAR(255),
	@RutaArchivo NVARCHAR(500),
	@TamañoBytes BIGINT,
	@ContentType NVARCHAR(100),
	@TipoArchivo NVARCHAR(50),
	@Descripcion NVARCHAR(500) = NULL,
	@SubidoPor NVARCHAR(50),
	@FechaSubida DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdReclamoArchivo INT
    
    INSERT INTO ReclamoArchivo (
        IdReclamo, NombreArchivo, NombreOriginal, RutaArchivo,
        TamañoBytes, ContentType, TipoArchivo, Descripcion,
        SubidoPor, FechaSubida
    )
    VALUES (
        @IdReclamo, @NombreArchivo, @NombreOriginal, @RutaArchivo,
        @TamañoBytes, @ContentType, @TipoArchivo, @Descripcion,
        @SubidoPor, @FechaSubida
    )
    
    SET @IdReclamoArchivo = SCOPE_IDENTITY()
    
    SELECT *
    FROM ReclamoArchivo
    WHERE IdReclamoArchivo = @IdReclamoArchivo
END
GO