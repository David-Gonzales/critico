USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EntidadFinancieraDominio')
BEGIN
	CREATE TABLE EntidadFinancieraDominio (
		IdEntidadFinancieraDominio INT IDENTITY(1,1) NOT NULL,
        IdEntidadFinanciera INT NOT NULL,
        Dominio NVARCHAR(200) NOT NULL,

        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL,
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
        
        CONSTRAINT PK_EntidadFinancieraDominio PRIMARY KEY CLUSTERED (IdEntidadFinancieraDominio ASC),
        CONSTRAINT FK_EntidadFinancieraDominio_EntidadFinanciera FOREIGN KEY (IdEntidadFinanciera) 
            REFERENCES EntidadFinanciera(IdEntidadFinanciera)
    )
    
    CREATE INDEX IX_EntidadFinancieraDominio_Entidad ON EntidadFinancieraDominio(IdEntidadFinanciera)
END
GO