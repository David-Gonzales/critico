USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Rol_Crear' )
    DROP PROCEDURE sp_Rol_Crear
GO

CREATE PROCEDURE sp_Rol_Crear
    @Codigo NVARCHAR(50), @Nombre NVARCHAR(100), @Descripcion NVARCHAR(500) = NULL, @EsSistema BIT = 0, @IdEmpresa INT, @CreadoPor NVARCHAR(50), @FechaCreacion DATETIME, @IdRol INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        IF EXISTS (SELECT 1 FROM Rol WHERE Codigo = @Codigo AND Eliminado = 0)
        BEGIN
            RAISERROR('Ya existe un rol con ese código', 16, 1)
            RETURN
        END
        
        INSERT INTO Rol 
            (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, CreadoPor, FechaCreacion, Activo, Eliminado)
        
        VALUES 
            (@Codigo, @Nombre, @Descripcion, @EsSistema, @IdEmpresa, @CreadoPor, @FechaCreacion, 1, 0)
        
        SET @IdRol = SCOPE_IDENTITY()
        
        COMMIT TRANSACTION
        
        SELECT 
            r.IdRol, r.Codigo, r.Nombre, r.Descripcion, r.EsSistema, r.IdEmpresa, e.Nombre AS NombreEmpresa, r.FechaCreacion, r.CreadoPor, r.Activo
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