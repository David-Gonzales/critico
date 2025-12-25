USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Usuario')
BEGIN
	CREATE TABLE Usuario (
		IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
		NombreUsuario NVARCHAR(50) NOT NULL UNIQUE,
		Email NVARCHAR(100) NOT NULL UNIQUE,
		PasswordHash NVARCHAR(255) NOT NULL,
		Nombres NVARCHAR(100) NOT NULL,
		Apellidos NVARCHAR(100) NOT NULL,
		Telefono NVARCHAR(20) NULL,
		DocumentoIdentidad NVARCHAR(20) NULL,

		RequiereDobleFactor BIT NOT NULL DEFAULT 0,
		SecretoDobleFactor NVARCHAR(255) NULL,

		IntentosFallidos INT NOT NULL DEFAULT 0,
		FechaBloqueo DATETIME NULL,
		UltimoAcceso DATETIME NULL,

		IdEmpresa INT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,

	)

	CREATE INDEX IX_Usuario_Email ON Usuario(Email)
	CREATE INDEX IX_Usuario_NombreUsuario ON Usuario(NombreUsuario)
	CREATE INDEX IX_Usuario_Activo_Eliminado ON Usuario(Activo, Eliminado)

END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Rol')
BEGIN
	CREATE TABLE Rol (
		IdRol INT IDENTITY(1,1) PRIMARY KEY,
		Codigo NVARCHAR(50) NOT NULL UNIQUE,
		Nombre NVARCHAR(100) NOT NULL,
		Descripcion NVARCHAR(500) NULL,
		EsSistema BIT NOT NULL DEFAULT 0,

		IdEmpresa INT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,
	)

	CREATE INDEX IX_Rol_Codigo ON Rol(Codigo)
	CREATE INDEX IX_Rol_Activo_Eliminado ON Rol(Activo, Eliminado)

END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Permiso')
BEGIN
	CREATE TABLE Permiso (
		IdPermiso INT IDENTITY(1,1) PRIMARY KEY,
		Codigo NVARCHAR(50) NOT NULL UNIQUE,
		Nombre NVARCHAR(100) NOT NULL,
		Descripcion NVARCHAR(500) NULL,
		Modulo NVARCHAR(50) NOT NULL,
		Recurso NVARCHAR(50) NOT NULL,
		Accion NVARCHAR(50) NOT NULL,

		IdEmpresa INT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,
	)

	CREATE INDEX IX_Permiso_Codigo ON Permiso(Codigo)
	CREATE INDEX IX_Permiso_Modulo ON Permiso(Modulo)
	CREATE INDEX IX_Permiso_Activo_Eliminado ON Permiso(Activo, Eliminado)

END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RolPermiso')
BEGIN
	CREATE TABLE RolPermiso (
		IdRolPermiso INT IDENTITY(1,1) PRIMARY KEY,
		IdRol INT NOT NULL,
		IdPermiso INT NOT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,

		CONSTRAINT FK_RolPermiso_Rol FOREIGN KEY (IdRol) REFERENCES Rol(IdRol),
		CONSTRAINT FK_RolPermiso_Permiso FOREIGN KEY (IdPermiso) REFERENCES Permiso(IdPermiso),

		CONSTRAINT UQ_RolPermiso_IdRol_IdPermiso UNIQUE (IdRol, IdPermiso)
	)

	CREATE INDEX IX_RolPermiso_IdRol ON RolPermiso(IdRol)
	CREATE INDEX IX_RolPermiso_IdPermiso ON RolPermiso(IdPermiso)

END
GO


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'UsuarioRol')
BEGIN
	CREATE TABLE UsuarioRol (
		IdUsuarioRol INT IDENTITY(1,1) PRIMARY KEY,
		IdUsuario INT NOT NULL,
		IdRol INT NOT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,

		CONSTRAINT FK_UsuarioRol_IdUsuario FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
		CONSTRAINT FK_UsuarioRol_IdRol FOREIGN KEY (IdRol) REFERENCES Rol(IdRol),

		CONSTRAINT UQ_UsuarioRol_IdUsuario_IdRol UNIQUE (IdUsuario, IdRol)
	)

	CREATE INDEX IX_UsuarioRol_IdUsuario ON UsuarioRol(IdUsuario)
	CREATE INDEX IX_UsuarioRol_IdRol ON UsuarioRol(IdRol)
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Menu')
BEGIN
    CREATE TABLE Menu (
        IdMenu INT IDENTITY(1,1) PRIMARY KEY,
        IdMenuPadre INT NULL,
        Codigo NVARCHAR(50) NOT NULL UNIQUE,
        Nombre NVARCHAR(100) NOT NULL,
        Icono NVARCHAR(50) NULL,
        URL NVARCHAR(200) NULL,
        Orden INT NOT NULL DEFAULT 0,
	SoloAdmin BIT NOT NULL DEFAULT 0,

	IdEmpresa INT NULL,
        
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL,
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
  
        CONSTRAINT FK_Menu_MenuPadre FOREIGN KEY (IdMenuPadre) REFERENCES Menu(IdMenu)
    )
    
    CREATE INDEX IX_Menu_Codigo ON Menu(Codigo)
    CREATE INDEX IX_Menu_Activo_Eliminado ON Menu(Activo, Eliminado)
    CREATE INDEX IX_Menu_IdMenuPadre ON Menu(IdMenuPadre)
    CREATE INDEX IX_Menu_Orden ON Menu(Orden)
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MenuPermiso')
BEGIN
    CREATE TABLE MenuPermiso (
        IdMenuPermiso INT IDENTITY(1,1) PRIMARY KEY,
        IdMenu INT NOT NULL,
        IdPermiso INT NOT NULL,
        
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL,
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
        
        CONSTRAINT FK_MenuPermiso_Menu FOREIGN KEY (IdMenu) REFERENCES Menu(IdMenu),
        CONSTRAINT FK_MenuPermiso_Permiso FOREIGN KEY (IdPermiso) REFERENCES Permiso(IdPermiso),
        
        CONSTRAINT UQ_MenuPermiso_Menu_Permiso UNIQUE (IdMenu, IdPermiso)
    )
    
    CREATE INDEX IX_MenuPermiso_IdMenu ON MenuPermiso(IdMenu)
    CREATE INDEX IX_MenuPermiso_IdPermiso ON MenuPermiso(IdPermiso)
    CREATE INDEX IX_MenuPermiso_Activo_Eliminado ON MenuPermiso(Activo, Eliminado)
END
GO

--Creaci n de la relaci n multitenant con empresa

ALTER TABLE Usuario
ADD CONSTRAINT FK_Usuario_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa)
GO

CREATE INDEX IX_Usuario_IdEmpresa ON Usuario(IdEmpresa)
GO


ALTER TABLE Rol
ADD CONSTRAINT FK_Rol_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa)
GO

CREATE INDEX IX_Rol_IdEmpresa ON Rol(IdEmpresa)
GO


ALTER TABLE Permiso
ADD CONSTRAINT FK_Permiso_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa)
GO

CREATE INDEX IX_Permiso_IdEmpresa ON Permiso(IdEmpresa)
GO


ALTER TABLE Menu
ADD CONSTRAINT FK_Menu_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa)
GO

CREATE INDEX IX_Menu_IdEmpresa ON Menu(IdEmpresa)
GO