USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Parametrica')
BEGIN
	CREATE TABLE Parametrica (
		IdParametrica INT PRIMARY KEY IDENTITY(1,1),
        IdGrupoParametrica INT NOT NULL,
        
        Alias NVARCHAR(100) NULL,
        Nombre NVARCHAR(500) NOT NULL,
        Valor NVARCHAR(MAX) NULL,
        Descripcion NVARCHAR(1000) NULL,
        Orden INT NULL,
        
        EsEliminable BIT NOT NULL DEFAULT 1,
        EnUso BIT NOT NULL DEFAULT 0,
        
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL DEFAULT 'SISTEMA',
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
        
        CONSTRAINT FK_Parametrica_Grupo FOREIGN KEY (IdGrupoParametrica) REFERENCES GrupoParametrica(IdGrupoParametrica)
	)

	CREATE INDEX IX_Parametrica_Grupo ON Parametrica(IdGrupoParametrica, Activo)
    CREATE INDEX IX_Parametrica_Alias ON Parametrica(Alias)

END
GO