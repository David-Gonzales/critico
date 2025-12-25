USE DB_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Permiso_Eliminar')
    DROP PROCEDURE sp_Permiso_Eliminar
GO

CREATE PROCEDURE sp_Permiso_Eliminar
    @IdPermiso INT, @EditadoPor NVARCHAR(50), @FechaEdicion DATETIME
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
        
		IF EXISTS (SELECT 1 FROM RolPermiso WHERE IdPermiso = @IdPermiso AND Eliminado = 0)
        BEGIN
            RAISERROR('No se puede eliminar el permiso porque tiene roles asignados', 16, 1)
            RETURN
        END
        
        UPDATE 
			Permiso
        SET 
            Eliminado = 1,
            Activo = 0,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE 
			IdPermiso = @IdPermiso
        
        COMMIT TRANSACTION
        
        SELECT 1 AS Resultado, 'Permiso eliminado correctamente' AS Mensaje
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO