USE BD_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Rol_ObtenerPermisos')
    DROP PROCEDURE sp_Rol_ObtenerPermisos
GO

CREATE PROCEDURE sp_Rol_ObtenerPermisos
    @IdRol INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.IdPermiso, p.Codigo, p.Nombre, p.Descripcion, p.Modulo, p.Recurso, p.Accion, rp.IdRolPermiso, rp.Activo AS PermisoActivo
    FROM 
		Permiso p
    INNER JOIN 
		RolPermiso rp ON p.IdPermiso = rp.IdPermiso
    WHERE 
        rp.IdRol = @IdRol
        AND p.Eliminado = 0
        AND rp.Eliminado = 0
    ORDER BY 
		p.Modulo, p.Recurso, p.Accion
END
GO