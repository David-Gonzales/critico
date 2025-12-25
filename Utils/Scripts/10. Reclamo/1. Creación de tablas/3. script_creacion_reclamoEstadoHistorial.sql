USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoEstadoHistorial')
BEGIN
	CREATE TABLE ReclamoEstadoHistorial (
		IdReclamoEstadoHistorial INT PRIMARY KEY IDENTITY(1,1),
		IdReclamo INT NOT NULL,
		IdEstadoAnterior INT NULL,
		IdEstadoNuevo INT NOT NULL,
		Motivo NVARCHAR(500) NULL,
		Observaciones NVARCHAR(MAX) NULL,
		FechaCambio DATETIME NOT NULL DEFAULT GETDATE(),
		CambiadoPor NVARCHAR(50) NOT NULL,
    
		CONSTRAINT FK_ReclamoEstadoHistorial_Reclamo FOREIGN KEY (IdReclamo) REFERENCES Reclamo(IdReclamo),

		CONSTRAINT FK_ReclamoEstadoHistorial_EstadoAnterior FOREIGN KEY (IdEstadoAnterior) REFERENCES ReclamoEstado(IdReclamoEstado),
		
		CONSTRAINT FK_ReclamoEstadoHistorial_EstadoNuevo FOREIGN KEY (IdEstadoNuevo) REFERENCES ReclamoEstado(IdReclamoEstado)
	)
	
	CREATE INDEX IX_ReclamoEstadoHistorial_Reclamo ON ReclamoEstadoHistorial(IdReclamo, FechaCambio DESC)

END
GO