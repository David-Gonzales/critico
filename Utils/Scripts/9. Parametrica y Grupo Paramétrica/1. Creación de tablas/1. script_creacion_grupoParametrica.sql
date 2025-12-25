USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'GrupoParametrica')
BEGIN
	CREATE TABLE GrupoParametrica (
		IdGrupoParametrica INT PRIMARY KEY IDENTITY(1,1),
        Codigo NVARCHAR(100) NOT NULL UNIQUE,
        Nombre NVARCHAR(200) NOT NULL,
        Descripcion NVARCHAR(500) NULL,
        TipoGrupo NVARCHAR(50) NOT NULL, -- "DOMINIO" o "APLICACION"
        IdEmpresa INT NULL,
        
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL DEFAULT 'SISTEMA',
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
        
        CONSTRAINT FK_GrupoParametrica_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa)
	)

	CREATE INDEX IX_GrupoParametrica_Tipo ON GrupoParametrica(TipoGrupo, IdEmpresa)
END
GO