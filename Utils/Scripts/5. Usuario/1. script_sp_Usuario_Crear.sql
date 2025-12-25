USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Usuario_Crear' )
	DROP PROCEDURE sp_Usuario_Crear
GO

CREATE PROCEDURE sp_Usuario_Crear
	@NombreUsuario NVARCHAR(50),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(255),
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Telefono NVARCHAR(20) = NULL,
    @DocumentoIdentidad NVARCHAR(20) = NULL,
    @CreadoPor NVARCHAR(50),
	@FechaCreacion DATETIME,
    @RolesIds NVARCHAR(MAX), -- ids separados por coma
    @EmpresasIds NVARCHAR(MAX), -- ids separados por coma
    @IdUsuario INT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION
			
			IF EXISTS (SELECT 1 FROM Usuario WHERE NombreUsuario = @NombreUsuario AND Eliminado = 0)
			BEGIN
				RAISERROR('Este nombre de usuario ya existe', 16, 1)
				RETURN
			END

			IF EXISTS (SELECT 1 FROM Usuario WHERE Email = @Email AND Eliminado = 0)
			BEGIN
				RAISERROR('Este email ya está registrado', 16, 1)
				RETURN
			END

			INSERT INTO Usuario (
				NombreUsuario, Email, PasswordHash, Nombres, Apellidos,
				Telefono, DocumentoIdentidad, CreadoPor, FechaCreacion, Activo, Eliminado
			)
			VALUES (
				@NombreUsuario, @Email, @PasswordHash, @Nombres, @Apellidos,
				@Telefono, @DocumentoIdentidad, @CreadoPor, @FechaCreacion, 1, 0
			)

			SET @IdUsuario = SCOPE_IDENTITY()

			--adigno los roles y los separo por coma
			IF @RolesIds IS NOT NULL AND @RolesIds != ''
			BEGIN
				INSERT INTO UsuarioRol (IdUsuario, IdRol, CreadoPor, FechaCreacion, Activo, Eliminado)
				SELECT @IdUsuario, CAST(value AS INT), @CreadoPor, @FechaCreacion, 1, 0
				FROM STRING_SPLIT(@RolesIds, ',')
				WHERE value != ''
			END

			--lo mismo para empresas
			IF @EmpresasIds IS NOT NULL AND @EmpresasIds != ''
			BEGIN
				INSERT INTO UsuarioEmpresa (IdUsuario, IdEmpresa, CreadoPor, FechaCreacion, Activo, Eliminado)
				SELECT @IdUsuario, CAST(value AS INT), @CreadoPor, @FechaCreacion, 1, 0
				FROM STRING_SPLIT(@EmpresasIds, ',')
				WHERE value != ''
			END

			COMMIT TRANSACTION
			EXEC sp_Usuario_ObtenerPorId @IdUsuario

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
	END CATCH
END
GO