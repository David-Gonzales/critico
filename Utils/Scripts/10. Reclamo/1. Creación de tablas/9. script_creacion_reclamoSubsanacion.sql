USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoSubsanacion')
BEGIN
	CREATE TABLE ReclamoSubsanacion (
		IdReclamoSubsanacion INT PRIMARY KEY IDENTITY(1,1),
		IdReclamo INT NOT NULL,
		
		-- Información solicitada
        InformacionRequerida NVARCHAR(MAX) NOT NULL,
        DiasParaSubsanar INT NOT NULL,
        FechaSolicitud DATETIME NOT NULL,
        FechaLimiteSubsanacion DATETIME NOT NULL,

		-- Respuesta del usuario
        InformacionProporcionada NVARCHAR(MAX) NULL,
        FechaRespuesta DATETIME NULL,

		-- Estado
        EstadoSubsanacion NVARCHAR(50) NOT NULL,

		-- Observaciones
        Observaciones NVARCHAR(MAX) NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL,
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
    
		CONSTRAINT FK_ReclamoSubsanacion_Reclamo FOREIGN KEY (IdReclamo) 
            REFERENCES Reclamo(IdReclamo)
	)

	CREATE INDEX IX_ReclamoSubsanacion_Reclamo ON ReclamoSubsanacion(IdReclamo)
    CREATE INDEX IX_ReclamoSubsanacion_Estado ON ReclamoSubsanacion(EstadoSubsanacion)
    CREATE INDEX IX_ReclamoSubsanacion_FechaLimite ON ReclamoSubsanacion(FechaLimiteSubsanacion)

END
GO