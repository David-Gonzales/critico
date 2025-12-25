USE DB_ASBANC_DEV
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_Rol_Listar')
	DROP PROCEDURE sp_Rol_Listar
GO

CREATE PROCEDURE sp_Rol_Listar
	@SoloActivos BIT = 1, 
	@IncluirEliminados BIT = 0, 
	@IdEmpresa INT = NULL, 
	@ExcluirSuperAdmin BIT = 0
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		r.IdRol, r.Codigo, r.Nombre, r.Descripcion, r.EsSistema, r.IdEmpresa, 
		e.Nombre AS NombreEmpresa, r.FechaCreacion, r.CreadoPor, r.FechaEdicion,
		r.EditadoPor, r.Activo
	FROM
		Rol r
	LEFT JOIN 
		Empresa e ON r.IdEmpresa = e.IdEmpresa
	WHERE
		(@SoloActivos = 0 OR r.Activo = 1) AND
		(@IncluirEliminados = 1 OR r.Eliminado = 0) AND
		(
			@IdEmpresa IS NULL 
			OR r.IdEmpresa = @IdEmpresa 
			OR r.IdEmpresa IS NULL
		) AND
		(
			@ExcluirSuperAdmin = 0 
            OR r.Codigo != 'SUPER_ADMIN'
		)
	ORDER BY r.IdRol
END
GO