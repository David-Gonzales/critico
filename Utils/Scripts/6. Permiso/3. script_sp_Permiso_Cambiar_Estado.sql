USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Permiso_CambiarEstado')
	DROP PROCEDURE sp_Permiso_CambiarEstado
GO

CREATE PROCEDURE sp_Permiso_CambiarEstado
	@IdPermiso INT,
    @Activo BIT,
    @EditadoPor NVARCHAR(50),
    @FechaEdicion DATETIME
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

			IF NOT EXISTS (SELECT 1 FROM Permiso WHERE IdPermiso = @IdPermiso AND Eliminado = 0)
			BEGIN
				RAISERROR('El permiso no existe', 16, 1)
				RETURN
			END

		UPDATE 
			Permiso
        SET 
            Activo = @Activo,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE 
			IdPermiso = @IdPermiso

		COMMIT TRANSACTION

		SELECT
			1 AS Resultado, 'Estado del permiso actualizado correctamente' AS Mensaje

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
	END CATCH
END
GO