USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Permiso_Listar')
	DROP PROCEDURE sp_Permiso_Listar
GO

CREATE PROCEDURE sp_Permiso_Listar
	@SoloActivos BIT = 1,
	@IncluirEliminados BIT = 0,
	@IdEmpresa INT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		p.IdPermiso, p.Codigo, p.Nombre, p.Descripcion, p.Modulo, 
		p.Recurso, p.Accion, p.IdEmpresa, e.Nombre AS NombreEmpresa, 
		p.FechaCreacion, p.CreadoPor, p.FechaEdicion, p.EditadoPor, p.Activo

	FROM 
		Permiso p
	LEFT JOIN
		Empresa e ON p.IdEmpresa = e.IdEmpresa

	WHERE
		(@SoloActivos = 0 OR p.Activo = 1) AND
		(@IncluirEliminados = 1 OR p.Eliminado = 0) AND
		(
			@IdEmpresa IS NULL 
			OR p.IdEmpresa = @IdEmpresa 
			OR p.IdEmpresa IS NULL
		)

	ORDER BY
		p.IdPermiso
END
GO