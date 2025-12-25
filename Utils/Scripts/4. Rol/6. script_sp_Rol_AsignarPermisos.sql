USE BD_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Rol_AsignarPermisos')
    DROP PROCEDURE sp_Rol_AsignarPermisos
GO

CREATE PROCEDURE sp_Rol_AsignarPermisos
    @IdRol INT,
    @PermisosIds NVARCHAR(MAX), -- serán ids separados por coma
    @EditadoPor NVARCHAR(50),
	@FechaEdicion DATETIME
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
        
        -- Marco todos los permisos actuales como eliminados
        UPDATE RolPermiso
        SET 
            Eliminado = 1,
            Activo = 0,
            FechaEdicion = @FechaEdicion,
            EditadoPor = @EditadoPor
        WHERE IdRol = @IdRol
        
        -- tt con ids de permisos
        DECLARE @PermisosTable TABLE (PermisoId INT)
        
        INSERT INTO @PermisosTable (PermisoId)
        SELECT CAST(value AS INT)
        FROM STRING_SPLIT(@PermisosIds, ',')
        WHERE value != ''
        
        -- inserto o reactivo permisos
        MERGE RolPermiso AS target
        USING @PermisosTable AS source
        ON target.IdRol = @IdRol AND target.IdPermiso = source.PermisoId
        WHEN MATCHED THEN
            UPDATE SET 
                Eliminado = 0,
                Activo = 1,
                FechaEdicion = @FechaEdicion,
                EditadoPor = @EditadoPor
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (IdRol, IdPermiso, CreadoPor, FechaCreacion, Activo, Eliminado)
            VALUES (@IdRol, source.PermisoId, @EditadoPor, @FechaEdicion, 1, 0);
        
        COMMIT TRANSACTION
        
        -- Retornar los permisos actualizados
        SELECT 
            p.IdPermiso, p.Codigo, p.Nombre, p.Descripcion, p.Modulo, p.Recurso, p.Accion, 
			rp.IdRolPermiso, rp.Activo AS PermisoActivo
        FROM 
			Permiso p
        INNER JOIN 
			RolPermiso rp ON p.IdPermiso = rp.IdPermiso
        WHERE 
            rp.IdRol = @IdRol
            AND p.Eliminado = 0
            AND rp.Eliminado = 0
        ORDER BY p.Modulo, p.Recurso, p.Accion
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO