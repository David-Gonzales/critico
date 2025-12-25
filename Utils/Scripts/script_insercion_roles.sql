USE DB_ASBANC_DEV
GO

DECLARE @Usuario NVARCHAR(50) = 'SYSTEM'
DECLARE @FechaCreacion DATETIME = GETDATE()

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('SUPER_ADMIN', 'Super Administrador', 'Super Administrador del Sistema', 1, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('ADMIN', 'Administrador', 'Administrador del Sistema', 1, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('GESTOR_CONSULTA', 'Gestor de Consulta', 'Gestor de Consulta', 0, 1, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('PRACTICANTE', 'Practicante', 'Practicante del Módulo de Consultas', 0, 1, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('DEFENSOR', 'Defensor', 'Perfil que emite el documento de resolución', 0, 2, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('ANALISTA_BANCO', 'Analista Banco', 'Analista de banco que registrará las respuestas', 0, 2, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('ANALISTA_LEGAL', 'Analista Legal', 'Analista Legal', 0, 2, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('ANALISTA_ADMIN', 'Analista Administrativo', 'Analista Administrativo', 0, 2, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('ASISTENTE_CONSULTA', 'Asistente de Consulta', 'Encargado de responder las consultas de los usuarios', 0, 1, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('ABOGADO_PRINCIPAL', 'Abogado Principal', 'Abogado Principal', 0, 2, @FechaCreacion, @Usuario, 1, 0)

INSERT INTO Rol (Codigo, Nombre, Descripcion, EsSistema, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES ('ANALISTA_FINANCIERO', 'Analista Financiero', 'Encargado de revisar y elaborar los informes financieros', 0, 2, @FechaCreacion, @Usuario, 1, 0)

GO