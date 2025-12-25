USE DB_ASBANC_DEV
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Reclamo')
BEGIN
	CREATE TABLE Reclamo (
		IdReclamo INT PRIMARY KEY IDENTITY(1,1),
		CodigoReclamo NVARCHAR(20) NOT NULL UNIQUE,
    
		-- Reclamante
		TipoPersona NVARCHAR(20) NULL,
		TipoDocumento NVARCHAR(20) NOT NULL,
		NumeroDocumento NVARCHAR(20) NOT NULL,
    
		-- Si es Persona Natural
		NombresReclamante NVARCHAR(200) NOT NULL,
		ApellidosReclamante NVARCHAR(200) NULL,
		FechaNacimiento DATE NULL, -- AloBanco
    
		-- Si es Persona Jurídica (empresa)
		RazonSocial NVARCHAR(300) NULL, 
		RepresentanteLegalNombres NVARCHAR(200) NULL,
		RepresentanteLegalDNI NVARCHAR(20) NULL,
    
		-- Datos de contacto
		EmailReclamante NVARCHAR(200) NOT NULL,
		TelefonoReclamante NVARCHAR(20) NULL, ------------------*----------celular
		OtroTelefonoReclamante NVARCHAR(20) NULL, -- AloBanco ------------*---------telefonocasa
		DireccionReclamante NVARCHAR(500) NULL,
    
		-- Tipo de canal (DCF)
		TipoCanal NVARCHAR(50) NULL,
    
		-- Entidad financiera y producto
		IdEntidadFinanciera INT NOT NULL,
		IdTipoProducto INT NULL, -- FK a Parametrica (TIPO_PRODUCTO)
		NumeroProducto NVARCHAR(50) NULL, 
		NumeroReclamoEntidad NVARCHAR(50) NULL, -- Número interno del banco
		FechaRegistroEntidad DATE NULL, -- Cuándo el banco lo registró
    
		-- Tipo y motivo
		IdTipoRequerimiento INT NULL, -- FK a Parametrica (TIPO_REQUERIMIENTO)
		IdMotivoReclamo INT NULL, -- FK a Parametrica (MOTIVO_RECLAMO)
    
		-- Hechos
		FechaHechos DATE NOT NULL,
		HoraHechos TIME NULL, -- AloBanco
		DescripcionHechos NVARCHAR(MAX) NOT NULL,
		Caso NVARCHAR(MAX) NULL, -- AloBanco: "Cuéntanos tu caso" 
		MontoReclamado DECIMAL(18,2) NULL,
		MonedaReclamado NVARCHAR(10) NULL,
    
		-- Solución esperada
		SolucionSolicitada NVARCHAR(MAX) NOT NULL,
		ResultadoEsperado NVARCHAR(500) NULL, -- AloBanco: dropdown
    
		-- Estado y plazos
		IdEstadoActual INT NOT NULL,
		FechaLimiteRespuesta DATETIME NULL,
		FechaComunicacionAmpliacion DATETIME NULL,
		FechaFinAtencion DATETIME NULL,
		DiasPlazo INT NOT NULL DEFAULT 30,
		DiasAmpliados INT NOT NULL DEFAULT 0,
    
		-- Asignación
		IdUsuarioAsignado INT NULL,
		FechaAsignacion DATETIME NULL,
    
		-- Resolución
		NumeroResolucion NVARCHAR(50) NULL,
		FechaResolucion DATETIME NULL,
		IdTipoRespuesta INT NULL, -- FK a Parametrica (TIPO_RESPUESTA)
    
		-- Reclamo en otra instancia (AloBanco)
		PresentoReclamoOtraInstancia BIT NULL,
		IdInstancia INT NULL, -- FK a Parametrica (INSTANCIA)
		FechaPresentacionOtraInstancia DATE NULL,
    
		-- Fuente (AloBanco - cómo se enteró)
		IdFuente INT NULL, -- FK a Parametrica (FUENTE_ALOBANCO)
		ComoSeEnteroAlobanco NVARCHAR(500) NULL,
    
		IdEmpresa INT NOT NULL,

		FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
		CreadoPor NVARCHAR(50) NOT NULL,
		FechaEdicion DATETIME NULL,
		EditadoPor NVARCHAR(50) NULL,
		Activo BIT NOT NULL DEFAULT 1,
		Eliminado BIT NOT NULL DEFAULT 0,
    
		-- Foreign Keys
		CONSTRAINT FK_Reclamo_EntidadFinanciera FOREIGN KEY (IdEntidadFinanciera) 
			REFERENCES EntidadFinanciera(IdEntidadFinanciera),
		CONSTRAINT FK_Reclamo_EstadoActual FOREIGN KEY (IdEstadoActual) 
			REFERENCES ReclamoEstado(IdReclamoEstado),
		CONSTRAINT FK_Reclamo_UsuarioAsignado FOREIGN KEY (IdUsuarioAsignado) 
			REFERENCES Usuario(IdUsuario),
		CONSTRAINT FK_Reclamo_Empresa FOREIGN KEY (IdEmpresa) 
			REFERENCES Empresa(IdEmpresa),
		CONSTRAINT FK_Reclamo_TipoProducto FOREIGN KEY (IdTipoProducto) 
			REFERENCES Parametrica(IdParametrica),
		CONSTRAINT FK_Reclamo_TipoRequerimiento FOREIGN KEY (IdTipoRequerimiento) 
			REFERENCES Parametrica(IdParametrica),
		CONSTRAINT FK_Reclamo_MotivoReclamo FOREIGN KEY (IdMotivoReclamo) 
			REFERENCES Parametrica(IdParametrica),
		CONSTRAINT FK_Reclamo_TipoRespuesta FOREIGN KEY (IdTipoRespuesta) 
			REFERENCES Parametrica(IdParametrica),
		CONSTRAINT FK_Reclamo_Instancia FOREIGN KEY (IdInstancia) 
			REFERENCES Parametrica(IdParametrica),
		CONSTRAINT FK_Reclamo_Fuente FOREIGN KEY (IdFuente) 
			REFERENCES Parametrica(IdParametrica)
	)

	CREATE INDEX IX_Reclamo_Codigo ON Reclamo(CodigoReclamo)
	CREATE INDEX IX_Reclamo_NumeroDocumento ON Reclamo(NumeroDocumento)
	CREATE INDEX IX_Reclamo_Estado ON Reclamo(IdEstadoActual)
	CREATE INDEX IX_Reclamo_Asignado ON Reclamo(IdUsuarioAsignado)
	CREATE INDEX IX_Reclamo_Empresa ON Reclamo(IdEmpresa)
	CREATE INDEX IX_Reclamo_FechaCreacion ON Reclamo(FechaCreacion DESC)
	CREATE INDEX IX_Reclamo_EntidadFinanciera ON Reclamo(IdEntidadFinanciera)
	CREATE INDEX IX_Reclamo_GeneracionCodigo ON Reclamo(IdEmpresa, FechaCreacion DESC) INCLUDE (CodigoReclamo);
END
GO