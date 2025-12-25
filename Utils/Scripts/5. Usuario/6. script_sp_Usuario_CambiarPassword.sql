USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Usuario_CambiarPassword')
	DROP PROCEDURE sp_Usuario_CambiarPassword
GO

CREATE PROCEDURE sp_Usuario_CambiarPassword
	@IdUsuario INT, @PasswordHash NVARCHAR(255), @EditadoPor NVARCHAR(50), @FechaEdicion DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario AND Eliminado = 0)
        BEGIN
            RAISERROR('Este usuario no existe', 16, 1)
            RETURN
        END

		UPDATE 
			Usuario
        SET 
            PasswordHash = @PasswordHash,
            EditadoPor = @EditadoPor,
			FechaEdicion = @FechaEdicion,
            IntentosFallidos = 0,
            FechaBloqueo = NULL
        WHERE 
			IdUsuario = @IdUsuario
        
        SELECT 1 AS Resultado, 'Contraseña actualizada exitosamente' AS Mensaje

	END TRY
	
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
	END CATCH
END
GO