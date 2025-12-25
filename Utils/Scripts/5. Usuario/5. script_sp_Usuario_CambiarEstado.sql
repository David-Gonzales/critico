USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Usuario_CambiarEstado')
	DROP PROCEDURE sp_Usuario_CambiarEstado
GO

CREATE PROCEDURE sp_Usuario_CambiarEstado
	@IdUsuario INT, @Activo BIT, @EditadoPor NVARCHAR(50), @FechaEdicion DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario AND Eliminado = 0)
		BEGIN
            RAISERROR('El usuario no existe', 16, 1)
            RETURN
        END

		UPDATE
			Usuario
        SET 
            Activo = @Activo,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE 
			IdUsuario = @IdUsuario

		SELECT 1 AS Resultado, 'Estado actualizado exitosamente' AS Mensaje

	END TRY

	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
	END CATCH
END
GO