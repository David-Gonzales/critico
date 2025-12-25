USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Usuario_Listar')
	DROP PROCEDURE sp_Usuario_Listar
GO

CREATE PROCEDURE sp_Usuario_Listar
	@SoloActivos BIT = 1,
	@IncluirEliminados BIT = 0,
	@IdEmpresa INT = NULL,
	@ExcluirSuperAdmin BIT = 0
AS
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT
		u.IdUsuario, u.NombreUsuario, u.Email, u.Nombres, u.Apellidos, u.Telefono, u.DocumentoIdentidad, u.IdEmpresa, u.RequiereDobleFactor, u.IntentosFallidos, 
		u.FechaBloqueo, u.UltimoAcceso, u.FechaCreacion, u.CreadoPor, u.FechaEdicion, u.EditadoPor, u.Activo
	FROM 
		Usuario u
	LEFT JOIN 
		UsuarioEmpresa ue ON u.IdUsuario = ue.IdUsuario
    LEFT JOIN 
		UsuarioRol ur ON u.IdUsuario = ur.IdUsuario
    LEFT JOIN 
		Rol r ON ur.IdRol = r.IdRol

	WHERE
        (@SoloActivos = 0 OR u.Activo = 1) AND
        (@IncluirEliminados = 1 OR u.Eliminado = 0) AND
        (
            @IdEmpresa IS NULL 
            OR u.IdEmpresa = @IdEmpresa 
            OR ue.IdEmpresa = @IdEmpresa
        ) AND
        (
            @ExcluirSuperAdmin = 0 
            OR r.Codigo != 'SUPER_ADMIN'
            OR r.Codigo IS NULL
        )

	ORDER BY
		IdUsuario
END
GO