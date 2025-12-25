USE BD_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Empresa')
BEGIN
	CREATE TABLE Empresa (
		IdEmpresa INT IDENTITY(1,1) PRIMARY KEY,
		Codigo NVARCHAR(50) NOT NULL UNIQUE,
		Nombre NVARCHAR(100) NOT NULL,
		Descripcion NVARCHAR(500) NULL,
    
		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,
	)
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'UsuarioEmpresa')
BEGIN
	CREATE TABLE UsuarioEmpresa (
		IdUsuarioEmpresa INT IDENTITY(1,1) PRIMARY KEY,
		IdUsuario INT NOT NULL,
		IdEmpresa INT NOT NULL,
    
		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,

		CONSTRAINT FK_UsuarioEmpresa_Usuario FOREIGN KEY(IdUsuario) REFERENCES Usuario(IdUsuario),
		CONSTRAINT FK_UsuarioEmpresa_Empresa FOREIGN KEY(IdEmpresa) REFERENCES Empresa(IdEmpresa),

		CONSTRAINT UQ_UsuarioEmpresa_IdUsuario_IdEmpresa UNIQUE(IdUsuario, IdEmpresa)
	)

	CREATE INDEX IX_UsuarioEmpresa_IdUsuario ON UsuarioEmpresa(IdUsuario)
	CREATE INDEX IX_UsuarioEmpresa_IdEmpresa ON UsuarioEmpresa(IdEmpresa)

END
GO