USE DB_ASBANC_DEV
GO

DECLARE @Usuario NVARCHAR(50) = 'SYSTEM'
DECLARE @FechaCreacion DATETIME = GETDATE()

INSERT INTO Empresa (Codigo, Nombre, Descripcion, CreadoPor, FechaCreacion)
VALUES	('ALOBANCO', 'ALOBANCO - Servicio de atención de reclamos financieros', 'Sistema de consultas y atención ciudadana', @Usuario, @FechaCreacion),
		('DCF', 'DCF - Defensoría del Cliente Financiero', 'Sistema de gestión de reclamos financieros', @Usuario, @FechaCreacion)
GO