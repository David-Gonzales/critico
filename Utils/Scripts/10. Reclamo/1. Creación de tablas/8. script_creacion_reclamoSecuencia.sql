USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReclamoSecuencia')
BEGIN
	CREATE TABLE ReclamoSecuencia (
		IdReclamoSecuencia INT PRIMARY KEY IDENTITY(1,1),
		IdEmpresa INT NOT NULL,
		Año INT NOT NULL,
		UltimoCorrelativo INT NOT NULL DEFAULT 0,
		FechaActualizacion DATETIME NOT NULL DEFAULT GETDATE()
    
		CONSTRAINT UQ_ReclamoSecuencia_Empresa_Año UNIQUE (IdEmpresa, Año)
	)

	CREATE INDEX IX_ReclamoSecuencia_Empresa_Año ON ReclamoSecuencia(IdEmpresa, Año)

END
GO