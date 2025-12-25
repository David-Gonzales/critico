USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoArchivo')
BEGIN
	CREATE TABLE ReclamoArchivo (
		IdReclamoArchivo INT PRIMARY KEY IDENTITY(1,1),
		IdReclamo INT NOT NULL,
		NombreArchivo NVARCHAR(255) NOT NULL,
		NombreOriginal NVARCHAR(255) NOT NULL,
		RutaArchivo NVARCHAR(500) NOT NULL,
		TamañoBytes BIGINT NOT NULL,
		ContentType NVARCHAR(100) NOT NULL,
		TipoArchivo NVARCHAR(50) NOT NULL, -- "EVIDENCIA", "RESOLUCION", "NOTIFICACION", "SUBSANACION"
		Descripcion NVARCHAR(500) NULL,
		FechaSubida DATETIME NOT NULL DEFAULT GETDATE(),
		SubidoPor NVARCHAR(50) NOT NULL,
		Eliminado BIT NOT NULL DEFAULT 0,
    
		CONSTRAINT FK_ReclamoArchivo_Reclamo FOREIGN KEY (IdReclamo) REFERENCES Reclamo(IdReclamo)
	)

	CREATE INDEX IX_ReclamoArchivo_Reclamo ON ReclamoArchivo(IdReclamo)

END
GO