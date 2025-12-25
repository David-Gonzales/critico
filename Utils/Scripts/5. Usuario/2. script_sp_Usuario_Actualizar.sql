USE DB_ASBANC_DEV
GO

IF EXISTS ( SELECT * FROM sys.procedures WHERE name = 'sp_Usuario_Actualizar' )
	DROP PROCEDURE sp_Usuario_Actualizar
GO

CREATE PROCEDURE sp_Usuario_Actualizar
	@IdUsuario INT,
	@NombreUsuario NVARCHAR(50),
    @Email NVARCHAR(100),
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Telefono NVARCHAR(20) = NULL,
    @DocumentoIdentidad NVARCHAR(20) = NULL,
    @EditadoPor NVARCHAR(50),
	@FechaEdicion DATETIME,
    @RolesIds NVARCHAR(MAX), -- ids separados por coma
    @EmpresasIds NVARCHAR(MAX) -- ids separados por coma
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION
			
			IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario AND Eliminado = 0)
			BEGIN
				RAISERROR('Este usuario no existe', 16, 1)
				RETURN
			END

			IF EXISTS (SELECT 1 FROM Usuario WHERE NombreUsuario = @NombreUsuario AND IdUsuario != @IdUsuario AND Eliminado = 0)
			BEGIN
				RAISERROR('Este nombre de usuario ya existe', 16, 1)
				RETURN
			END

			IF EXISTS (SELECT 1 FROM Usuario WHERE Email = @Email AND IdUsuario != @IdUsuario AND Eliminado = 0)
			BEGIN
				RAISERROR('Este email ya est  registrado', 16, 1)
				RETURN
			END

			UPDATE Usuario 
			SET 
				NombreUsuario = @NombreUsuario,
				Email = @Email,
				Nombres = @Nombres,
				Apellidos = @Apellidos,
				Telefono = @Telefono,
				DocumentoIdentidad = @DocumentoIdentidad,
				FechaEdicion = @FechaEdicion,
				EditadoPor = @EditadoPor
			WHERE 
				IdUsuario = @IdUsuario

			--elimino roles existentes
			UPDATE UsuarioRol SET Eliminado = 1 WHERE IdUsuario = @IdUsuario

			--creo nuevos roles
			IF @RolesIds IS NOT NULL AND @RolesIds != ''
			BEGIN
				MERGE UsuarioRol AS target
				USING (SELECT CAST(value AS INT) AS IdRol FROM STRING_SPLIT(@RolesIds, ',') WHERE value != '') AS source
				ON target.IdUsuario = @IdUsuario AND target.IdRol = source.IdRol
				WHEN MATCHED THEN
					UPDATE SET Eliminado = 0, Activo = 1, EditadoPor = @EditadoPor, FechaEdicion = @FechaEdicion
				WHEN NOT MATCHED BY TARGET THEN
					INSERT (IdUsuario, IdRol, CreadoPor, FechaCreacion, Activo, Eliminado)
					VALUES (@IdUsuario, source.IdRol, @EditadoPor, @FechaEdicion, 1, 0);
			END

			--lo mismo para empresas
			UPDATE UsuarioEmpresa SET Eliminado = 1 WHERE IdUsuario = @IdUsuario
        
			IF @EmpresasIds IS NOT NULL AND @EmpresasIds != ''
			BEGIN
				MERGE UsuarioEmpresa AS target
				USING (SELECT CAST(value AS INT) AS IdEmpresa FROM STRING_SPLIT(@EmpresasIds, ',') WHERE value != '') AS source
				ON target.IdUsuario = @IdUsuario AND target.IdEmpresa = source.IdEmpresa
				WHEN MATCHED THEN
					UPDATE SET Eliminado = 0, Activo = 1, EditadoPor = @EditadoPor, FechaEdicion = @FechaEdicion
				WHEN NOT MATCHED BY TARGET THEN
					INSERT (IdUsuario, IdEmpresa, CreadoPor, FechaCreacion, Activo, Eliminado)
					VALUES (@IdUsuario, source.IdEmpresa, @EditadoPor, @FechaEdicion, 1, 0);
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