USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoAmpliacionPlazo')
BEGIN
	CREATE TABLE ReclamoAmpliacionPlazo (
		IdReclamoAmpliacionPlazo INT PRIMARY KEY IDENTITY(1,1),
		IdReclamo INT NOT NULL,
		DiasAmpliados INT NOT NULL,
		Motivo NVARCHAR(500) NOT NULL,
		FechaLimiteAnterior DATETIME NOT NULL,
		FechaLimiteNueva DATETIME NOT NULL,
		FechaAmpliacion DATETIME NOT NULL DEFAULT GETDATE(),
		AmpliadoPor NVARCHAR(50) NOT NULL,
		FechaComunicacionAmpliacion DATETIME NULL,
    
		CONSTRAINT FK_ReclamoAmpliacionPlazo_Reclamo FOREIGN KEY (IdReclamo) REFERENCES Reclamo(IdReclamo)
	)

	CREATE INDEX IX_ReclamoAmpliacionPlazo_Reclamo ON ReclamoAmpliacionPlazo(IdReclamo)

END
GO