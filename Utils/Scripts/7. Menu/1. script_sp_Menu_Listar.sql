USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Menu_Listar')
	DROP PROCEDURE sp_Menu_Listar
GO

CREATE PROCEDURE sp_Menu_Listar
	@SoloActivos BIT = 1,
	@IncluirEliminados BIT = 0,
	@IdEmpresa INT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		m.IdMenu, m.IdMenuPadre, m.Codigo, m.Nombre, m.Icono, m.URL, 
		m.Orden, m.IdEmpresa, e.Nombre AS NombreEmpresa, 
		m.FechaCreacion, m.CreadoPor, m.FechaEdicion, m.EditadoPor, m.Activo

	FROM 
		Menu m
	LEFT JOIN
		Empresa e ON m.IdEmpresa = e.IdEmpresa

	WHERE
		(@SoloActivos = 0 OR m.Activo = 1) AND
		(@IncluirEliminados = 1 OR m.Eliminado = 0) AND
		(
			@IdEmpresa IS NULL 
			OR m.IdEmpresa = @IdEmpresa 
			OR m.IdEmpresa IS NULL
		)

	ORDER BY
		m.IdMenu
END
GO