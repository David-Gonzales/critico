USE DB_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Permiso_Actualizar')
    DROP PROCEDURE sp_Permiso_Actualizar
GO

CREATE PROCEDURE sp_Permiso_Actualizar
    @IdPermiso INT,
	@Codigo NVARCHAR(50), 
	@Nombre NVARCHAR(100), 
	@Descripcion NVARCHAR(500) = NULL, 
	@Modulo NVARCHAR(50), 
	@Recurso NVARCHAR(50),
	@Accion NVARCHAR(50),
	@IdEmpresa INT,
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
        
		IF EXISTS (SELECT 1 FROM Permiso WHERE Codigo = @Codigo AND IdPermiso != @IdPermiso AND Eliminado = 0)
        BEGIN
            RAISERROR('Ya existe otro permiso con ese código', 16, 1)
            RETURN
        END
        
        UPDATE 
			Permiso
        SET 
            Codigo = @Codigo,
            Nombre = @Nombre,
            Descripcion = @Descripcion,
			Modulo = @Modulo,
			Recurso = @Recurso,
			Accion = @Accion,
			IdEmpresa = @IdEmpresa,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE 
			IdPermiso = @IdPermiso
        
        COMMIT TRANSACTION
        
        SELECT 
            p.IdPermiso, p.Codigo, p.Nombre, p.Descripcion, p.Modulo, p.Recurso, p.Accion, 
            p.IdEmpresa, e.Nombre AS NombreEmpresa,
            p.FechaCreacion, p.CreadoPor, p.FechaEdicion, p.EditadoPor, p.Activo
        FROM 
			Permiso p
        LEFT JOIN 
			Empresa e ON p.IdEmpresa = e.IdEmpresa
        WHERE 
			p.IdPermiso = @IdPermiso
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

