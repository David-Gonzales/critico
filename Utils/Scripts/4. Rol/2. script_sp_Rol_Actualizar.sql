USE DB_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Rol_Actualizar')
    DROP PROCEDURE sp_Rol_Actualizar
GO

CREATE PROCEDURE sp_Rol_Actualizar
    @IdRol INT, @Codigo NVARCHAR(50), @Nombre NVARCHAR(100), @Descripcion NVARCHAR(500) = NULL, @IdEmpresa INT, @EditadoPor NVARCHAR(50), @FechaEdicion DATETIME
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
            RAISERROR('No se puede modificar un rol de sistema', 16, 1)
            RETURN
        END
        
        IF EXISTS (SELECT 1 FROM Rol WHERE Codigo = @Codigo AND IdRol != @IdRol AND Eliminado = 0)
        BEGIN
            RAISERROR('Ya existe otro rol con ese código', 16, 1)
            RETURN
        END
        
        UPDATE 
			Rol
        SET 
            Codigo = @Codigo,
            Nombre = @Nombre,
            Descripcion = @Descripcion,
			IdEmpresa = @IdEmpresa,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE 
			IdRol = @IdRol
        
        COMMIT TRANSACTION
        
        SELECT 
            r.IdRol, r.Codigo, r.Nombre, r.Descripcion, r.EsSistema, r.IdEmpresa, e.Nombre AS NombreEmpresa, r.FechaCreacion, r.CreadoPor, r.FechaEdicion, r.EditadoPor, r.Activo, r.Eliminado
        FROM 
			Rol r
		LEFT JOIN 
			Empresa e ON r.IdEmpresa = e.IdEmpresa
        WHERE 
			IdRol = @IdRol
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO