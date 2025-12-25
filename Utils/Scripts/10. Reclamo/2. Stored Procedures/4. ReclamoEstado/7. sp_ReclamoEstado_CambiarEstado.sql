USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoEstado_CambiarEstado
	@IdReclamoEstado INT,
    @Activo BIT,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
	
	UPDATE 
		ReclamoEstado
    SET 
		Activo = @Activo,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE 
		IdReclamoEstado = @IdReclamoEstado
    
    EXEC sp_ReclamoEstado_ObtenerPorId @IdReclamoEstado

END
GO