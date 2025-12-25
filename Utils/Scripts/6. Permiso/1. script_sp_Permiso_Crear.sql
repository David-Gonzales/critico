USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Permiso_Crear')
	DROP PROCEDURE sp_Permiso_Crear
GO

CREATE PROCEDURE sp_Permiso_Crear
	@Codigo VARCHAR(50),
	@Nombre VARCHAR(100),
	@Descripcion VARCHAR(500),
	@Modulo VARCHAR(50),
	@Recurso VARCHAR(50),
	@Accion VARCHAR(50),
	@IdEmpresa INT,
	@CreadoPor VARCHAR(50),
	@FechaCreacion DATETIME,
	@IdPermiso INT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

			IF EXISTS (SELECT 1 FROM Permiso Where Codigo = @Codigo AND Eliminado = 0)
			BEGIN
				RAISERROR('Ya existe un permiso con este código', 16, 1);
				RETURN
			END

			INSERT INTO Permiso
				(Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, IdEmpresa, CreadoPor, FechaCreacion)
			VALUES
				(@Codigo, @Nombre, @Descripcion, @Modulo, @Recurso, @Accion, @IdEmpresa, @CreadoPor, @FechaCreacion)

			SET @IdPermiso = SCOPE_IDENTITY()

			COMMIT TRANSACTION

		SELECT
			p.IdPermiso, p.Codigo, p.Nombre, p.Descripcion, p.Modulo, p.Recurso, p.Accion, 
			p.IdEmpresa, e.Nombre AS NombreEmpresa, 
			p.CreadoPor, p.FechaCreacion, p.Activo
		FROM Permiso p
		LEFT JOIN Empresa e ON p.IdEmpresa = e.IdEmpresa
		WHERE p.IdPermiso = @IdPermiso

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
	END CATCH
END
GO