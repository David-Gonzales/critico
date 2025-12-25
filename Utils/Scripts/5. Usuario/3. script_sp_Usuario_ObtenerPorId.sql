USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Usuario_ObtenerPorId')
	DROP PROCEDURE sp_Usuario_ObtenerPorId
GO

CREATE PROCEDURE sp_Usuario_ObtenerPorId
	@IdUsuario INT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		IdUsuario, NombreUsuario, Email, Nombres, Apellidos, Telefono, DocumentoIdentidad, RequiereDobleFactor, IntentosFallidos, 
		FechaBloqueo, UltimoAcceso, FechaCreacion, CreadoPor, FechaEdicion, EditadoPor, Activo
	FROM 
		Usuario
	WHERE
		@IdUsuario = IdUsuario 
		AND Eliminado = 0


	SELECT
		r.IdRol, r.Codigo, r.Nombre
	FROM
		Rol r
	INNER JOIN UsuarioRol ur ON ur.IdRol = r.IdRol
	WHERE ur.IdUsuario = @IdUsuario
	AND r.Activo = 1
	AND r.Eliminado = 0
	AND ur.Activo = 1
	AND ur.Eliminado = 0


	SELECT
		e.IdEmpresa, e.Codigo, e.Nombre
	FROM
		Empresa e
	INNER JOIN UsuarioEmpresa ue ON ue.IdEmpresa = e.IdEmpresa
	WHERE ue.IdUsuario = @IdUsuario
	AND e.Activo = 1
	AND e.Eliminado = 0
	AND ue.Activo = 1
	AND ue.Eliminado = 0

END
GO