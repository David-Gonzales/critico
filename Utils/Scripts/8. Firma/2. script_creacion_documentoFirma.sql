USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DocumentoFirma')
BEGIN
	CREATE TABLE DocumentoFirma (
		IdDocumentoFirma INT PRIMARY KEY IDENTITY(1,1),
    
		TipoDocumento NVARCHAR(50) NOT NULL,
		IdDocumento INT NOT NULL,
    
		IdFirma INT NOT NULL,
		IdUsuarioFirmante INT NOT NULL,
    
		PasswordValidado BIT NOT NULL DEFAULT 0,
		MetodoValidacion NVARCHAR(50) DEFAULT 'PASSWORD',
    
		IpAddress NVARCHAR(50) NULL,
		UserAgent NVARCHAR(500) NULL,
		Observaciones NVARCHAR(500) NULL,
    
		FechaFirma DATETIME NOT NULL DEFAULT GETDATE(),
    
		CONSTRAINT FK_DocumentoFirma_Firma FOREIGN KEY (IdFirma) REFERENCES Firma(IdFirma),
		CONSTRAINT FK_DocumentoFirma_Usuario FOREIGN KEY (IdUsuarioFirmante) REFERENCES Usuario(IdUsuario)
	)

	CREATE INDEX IX_DocumentoFirma_Documento ON DocumentoFirma(TipoDocumento, IdDocumento)
	CREATE INDEX IX_DocumentoFirma_Usuario ON DocumentoFirma(IdUsuarioFirmante, FechaFirma)
	CREATE INDEX IX_DocumentoFirma_Fecha ON DocumentoFirma(FechaFirma DESC)
END
GO