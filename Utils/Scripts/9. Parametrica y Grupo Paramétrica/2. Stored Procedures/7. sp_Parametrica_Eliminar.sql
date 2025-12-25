USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Parametrica_Eliminar
    @IdParametrica INT,
    @FechaEdicion DATETIME,
    @EliminadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @EsEliminable BIT
    DECLARE @EnUso BIT

	SELECT 
		@EsEliminable = EsEliminable
    FROM 
		Parametrica
    WHERE 
		IdParametrica = @IdParametrica

	IF @EsEliminable = 0
    BEGIN
        RAISERROR('Esta paramétrica es del sistema y no se puede eliminar', 16, 1)
        RETURN
    END

	SET @EnUso = 0
    
    IF EXISTS (
        SELECT 1 FROM Reclamo 
        WHERE (IdTipoProducto = @IdParametrica 
            OR IdMotivoReclamo = @IdParametrica 
            OR IdTipoRespuesta = @IdParametrica 
            OR IdInstancia = @IdParametrica 
            OR IdFuente = @IdParametrica
            OR IdTipoRequerimiento = @IdParametrica)
          AND Eliminado = 0
    )
    BEGIN
        SET @EnUso = 1
    END
    
    IF @EnUso = 1
    BEGIN
        RAISERROR('No se puede eliminar porque está siendo utilizada en reclamos registrados', 16, 1)
        RETURN
    END

	UPDATE 
		Parametrica
    SET 
		Eliminado = 1,
        Activo = 0,
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EliminadoPor
    WHERE 
		IdParametrica = @IdParametrica
    
    SELECT 1 AS Success

END
GO