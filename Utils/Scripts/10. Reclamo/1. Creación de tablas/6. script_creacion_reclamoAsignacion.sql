USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoAsignacion')
BEGIN
	CREATE TABLE ReclamoAsignacion (
		IdReclamoAsignacion INT PRIMARY KEY IDENTITY(1,1),
		IdReclamo INT NOT NULL,
		IdUsuarioAnterior INT NULL,
		IdUsuarioNuevo INT NOT NULL,
		Motivo NVARCHAR(500) NULL,
		Prioridad NVARCHAR(20) NULL, -- "BAJA", "MEDIA", "ALTA", "URGENTE"
		FechaAsignacion DATETIME NOT NULL DEFAULT GETDATE(),
		AsignadoPor NVARCHAR(50) NOT NULL,
    
		CONSTRAINT FK_ReclamoAsignacion_Reclamo FOREIGN KEY (IdReclamo) REFERENCES Reclamo(IdReclamo),

		CONSTRAINT FK_ReclamoAsignacion_UsuarioAnterior FOREIGN KEY (IdUsuarioAnterior) REFERENCES Usuario(IdUsuario),

		CONSTRAINT FK_ReclamoAsignacion_UsuarioNuevo FOREIGN KEY (IdUsuarioNuevo) REFERENCES Usuario(IdUsuario)
	)

	CREATE INDEX IX_ReclamoAsignacion_Reclamo ON ReclamoAsignacion(IdReclamo)
	CREATE INDEX IX_ReclamoAsignacion_Usuario ON ReclamoAsignacion(IdUsuarioNuevo, FechaAsignacion DESC)

END
GO