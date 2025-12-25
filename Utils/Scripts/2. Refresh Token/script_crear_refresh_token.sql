USE BD_ASBANC_DEV
GO

CREATE TABLE RefreshToken (
    IdRefreshToken INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL,
    Token NVARCHAR(500) NOT NULL,
    Expiracion DATETIME NOT NULL,
    EsRevocado BIT NOT NULL DEFAULT 0,
    FechaRevocacion DATETIME NULL,
    
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
	CreadoPor NVARCHAR(50) NOT NULL,
	FechaEdicion DATETIME NULL,
	EditadoPor NVARCHAR(50) NULL,

	Activo BIT NOT NULL DEFAULT 1,
	Eliminado BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT FK_RefreshToken_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
)

CREATE INDEX IX_RefreshToken_Token ON RefreshToken(Token)
CREATE INDEX IX_RefreshToken_UsuarioId ON RefreshToken(IdUsuario)
GO