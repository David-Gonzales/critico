USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EntidadFinanciera')
BEGIN
	CREATE TABLE EntidadFinanciera (
		IdEntidadFinanciera INT PRIMARY KEY IDENTITY(1,1),
        Codigo NVARCHAR(20) NOT NULL,
        Nombre NVARCHAR(200) NOT NULL,
        RUC NVARCHAR(11) NULL,
        RazonSocial NVARCHAR(300) NULL,
        
        -- Contacto
        EmailNotificacion NVARCHAR(200) NULL,
        Telefono NVARCHAR(20) NULL,
        Direccion NVARCHAR(500) NULL,
        SitioWeb NVARCHAR(200) NULL,
        CanalAtencion NVARCHAR(500) NULL,
        
        -- Branding
        LogoUrl NVARCHAR(500) NULL,
        LogoDarkUrl NVARCHAR(500) NULL,
        
        Descripcion NVARCHAR(1000) NULL,
        
        IdEmpresa INT NULL,
        
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL,
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
        
        CONSTRAINT PK_EntidadFinanciera PRIMARY KEY CLUSTERED (IdEntidadFinanciera ASC),
        CONSTRAINT UQ_EntidadFinanciera_Codigo UNIQUE NONCLUSTERED (Codigo ASC),
        CONSTRAINT FK_EntidadFinanciera_Empresa FOREIGN KEY (IdEmpresa) 
            REFERENCES Empresa(IdEmpresa)
	)

	CREATE INDEX IX_EntidadFinanciera_Codigo ON EntidadFinanciera(Codigo)
	CREATE INDEX IX_EntidadFinanciera_Empresa ON EntidadFinanciera(IdEmpresa)
END
GO