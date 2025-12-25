USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EntidadFinancieraContacto')
BEGIN
	CREATE TABLE EntidadFinancieraContacto (
		IdEntidadFinancieraContacto INT IDENTITY(1,1) NOT NULL,
        IdEntidadFinanciera INT NOT NULL,
        NombreContacto NVARCHAR(200) NOT NULL,
        EmailContacto NVARCHAR(200) NOT NULL,
        
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL,
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
        
        CONSTRAINT PK_EntidadFinancieraContacto PRIMARY KEY CLUSTERED (IdEntidadFinancieraContacto ASC),
        CONSTRAINT FK_EntidadFinancieraContacto_EntidadFinanciera FOREIGN KEY (IdEntidadFinanciera) 
            REFERENCES EntidadFinanciera(IdEntidadFinanciera)
    )
    
    CREATE INDEX IX_EntidadFinancieraContacto_Entidad ON EntidadFinancieraContacto(IdEntidadFinanciera)
END
GO