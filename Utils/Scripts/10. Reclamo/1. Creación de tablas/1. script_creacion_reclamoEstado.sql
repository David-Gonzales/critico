USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoEstado')
BEGIN
	CREATE TABLE ReclamoEstado (
		IdReclamoEstado INT PRIMARY KEY IDENTITY(1,1),
		Codigo NVARCHAR(50) NOT NULL UNIQUE,
		Nombre NVARCHAR(100) NOT NULL,
		Descripcion NVARCHAR(500) NULL,
		Orden INT NOT NULL,
		Color NVARCHAR(20) NULL,
		EsEstadoFinal BIT NOT NULL DEFAULT 0,
		EsEliminable BIT NOT NULL DEFAULT 0,
		EsEstadoSistema BIT NOT NULL DEFAULT 0,

		IdEmpresa INT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,

		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,

    
		CONSTRAINT FK_ReclamoEstado_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa)
	)

	CREATE INDEX IX_ReclamoEstado_Codigo ON ReclamoEstado(Codigo)
	CREATE INDEX IX_ReclamoEstado_Empresa ON ReclamoEstado(IdEmpresa)
END
GO