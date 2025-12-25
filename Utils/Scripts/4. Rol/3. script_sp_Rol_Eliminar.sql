USE BD_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Rol_Eliminar')
    DROP PROCEDURE sp_Rol_Eliminar
GO

CREATE PROCEDURE sp_Rol_Eliminar
    @IdRol INT, @EditadoPor NVARCHAR(50), @FechaEdicion DATETIME
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
        
        IF EXISTS (SELECT 1 FROM Rol WHERE IdRol = @IdRol AND EsSistema = 1)
        BEGIN
            RAISERROR('No se puede eliminar un rol de sistema', 16, 1)
            RETURN
        END
        
        IF EXISTS (SELECT 1 FROM UsuarioRol WHERE IdRol = @IdRol AND Eliminado = 0)
        BEGIN
            RAISERROR('No se puede eliminar el rol porque tiene usuarios asignados', 16, 1)
            RETURN
        END
        
        UPDATE Rol
        SET 
            Eliminado = 1,
            Activo = 0,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE IdRol = @IdRol
        
        COMMIT TRANSACTION
        
        SELECT 1 AS Resultado, 'Rol eliminado correctamente' AS Mensaje
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO