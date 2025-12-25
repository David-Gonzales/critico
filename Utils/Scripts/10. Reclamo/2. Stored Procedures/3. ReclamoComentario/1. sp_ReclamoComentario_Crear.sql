USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoComentario_Crear
	@IdReclamo INT,
	@Comentario NVARCHAR(MAX),
	@EsInterno BIT,
	@ComentadoPor NVARCHAR(50),
	@FechaComentario DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdReclamoComentario INT
    
    INSERT INTO ReclamoComentario (
        IdReclamo, Comentario, EsInterno, ComentadoPor, FechaComentario
    )
    VALUES (
        @IdReclamo, @Comentario, @EsInterno, @ComentadoPor, @FechaComentario
    )
    
    SET @IdReclamoComentario = SCOPE_IDENTITY()
    
    SELECT *
    FROM ReclamoComentario
    WHERE IdReclamoComentario = @IdReclamoComentario
END
GO