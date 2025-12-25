USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Permiso_ObtenerPorId')
	DROP PROCEDURE sp_Permiso_ObtenerPorId
GO

CREATE PROCEDURE sp_Permiso_ObtenerPorId
	@IdPermiso INT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		p.IdPermiso, p.Codigo, p.Nombre, p.Descripcion, p.Modulo, p.Recurso, p.Accion, p.IdEmpresa, e.Nombre AS NombreEmpresa, p.FechaCreacion, p.CreadoPor, p.FechaEdicion, p.EditadoPor, p.Activo

	FROM 
		Permiso p
	LEFT JOIN
		Empresa e ON p.IdEmpresa = e.IdEmpresa

	WHERE
		p.IdPermiso = @IdPermiso AND p.Eliminado = 0
END
GO