USE BD_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Rol_CambiarEstado')
    DROP PROCEDURE sp_Rol_CambiarEstado
GO

CREATE PROCEDURE sp_Rol_CambiarEstado
    @IdRol INT, @Activo BIT, @EditadoPor NVARCHAR(50), @FechaEdicion DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        IF NOT EXISTS (SELECT 1 FROM Rol WHERE IdRol = @IdRol AND Eliminado = 0)
        BEGIN
            RAISERROR('El rol no existe', 16, 1)
            RETURN
        END
        
        UPDATE Rol
        SET 
            Activo = @Activo,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE IdRol = @IdRol
        
        COMMIT TRANSACTION
        
        SELECT 1 AS Resultado, 'El estado se actualizó correctamente' AS Mensaje
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO