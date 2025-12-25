USE DB_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Rol_ObtenerPorId')
	DROP PROCEDURE sp_Rol_ObtenerPorId
GO

CREATE PROCEDURE sp_Rol_ObtenerPorId
	@IdRol INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		r.IdRol, r.Codigo, r.Nombre, r.Descripcion, r.EsSistema, r.IdEmpresa, e.Nombre AS NombreEmpresa, r.FechaCreacion, r.CreadoPor, r.FechaEdicion, r.EditadoPor, r.Activo, r.Eliminado
	FROM 
		Rol r
	LEFT JOIN
			Empresa e ON r.IdEmpresa = e.IdEmpresa
	WHERE
		r.IdRol = @IdRol AND r.Eliminado = 0
END
GO
