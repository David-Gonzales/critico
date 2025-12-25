USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoComentario')
BEGIN
	CREATE TABLE ReclamoComentario (
		IdReclamoComentario INT PRIMARY KEY IDENTITY(1,1),
		IdReclamo INT NOT NULL,
		Comentario NVARCHAR(MAX) NOT NULL,
		EsInterno BIT NOT NULL DEFAULT 1, -- true=interno, false=visible al reclamante
		FechaComentario DATETIME NOT NULL DEFAULT GETDATE(),
		ComentadoPor NVARCHAR(50) NOT NULL,
		Eliminado BIT NOT NULL DEFAULT 0,
    
		CONSTRAINT FK_ReclamoComentario_Reclamo FOREIGN KEY (IdReclamo) REFERENCES Reclamo(IdReclamo)
	)

	CREATE INDEX IX_ReclamoComentario_Reclamo ON ReclamoComentario(IdReclamo, FechaComentario DESC)

END
GO