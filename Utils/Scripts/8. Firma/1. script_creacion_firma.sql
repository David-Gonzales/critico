USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Firma')
BEGIN
	CREATE TABLE Firma (
		IdFirma INT IDENTITY(1,1) PRIMARY KEY,

		IdUsuario INT NOT NULL,
		IdEntidadFinanciera INT NULL,

		NombreCompleto NVARCHAR(200) NOT NULL,
		Cargo NVARCHAR(100) NULL,
		DocumentoIdentidad NVARCHAR(20) NULL,

		NombreArchivo NVARCHAR(255) NOT NULL,
		RutaArchivo NVARCHAR(500) NULL,
		ContentType NVARCHAR(50) DEFAULT 'image/png',
		TamañoBytes BIGINT NULL,

		IdEmpresa INT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,

		CONSTRAINT FK_Firma_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
		CONSTRAINT FK_Firma_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa)

	)

	CREATE INDEX IX_Firma_Usuario ON Firma(IdUsuario, Activo)
	CREATE INDEX IX_Firma_Empresa ON Firma(IdEmpresa)

END
GO