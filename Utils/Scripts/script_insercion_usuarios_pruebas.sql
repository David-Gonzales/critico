--Creación de usuarios de prueba

DECLARE @Usuario NVARCHAR(50) = 'SYSTEM'
DECLARE @FechaCreacion DATETIME = GETDATE()
DECLARE @IdEmpresaDCF INT
DECLARE @IdEmpresaAloBanco INT
DECLARE @IdRolSuperAdmin INT
DECLARE @IdRolAdmin INT
DECLARE @IdRolGestorConsulta INT
DECLARE @IdRolDefensor INT

SELECT @IdEmpresaDCF = IdEmpresa FROM Empresa WHERE Codigo = 'DCF'
SELECT @IdEmpresaAloBanco = IdEmpresa FROM Empresa WHERE Codigo = 'ALOBANCO'

SELECT @IdRolSuperAdmin = IdRol FROM Rol WHERE Codigo = 'SUPER_ADMIN'
SELECT @IdRolAdmin = IdRol FROM Rol WHERE Codigo = 'ADMIN'
SELECT @IdRolGestorConsulta = IdRol FROM Rol WHERE Codigo = 'GESTOR_CONSULTA'
SELECT @IdRolDefensor = IdRol FROM Rol WHERE Codigo = 'DEFENSOR'

-- SUPER ADMINISTRADOR === Email: admin@asbanc.pe | Password: AdminAsbanc123!

DECLARE @IdSuperAdmin INT
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Email = 'admin@asbanc.pe')
BEGIN
    INSERT INTO Usuario (
        NombreUsuario,
        Email,
        PasswordHash,
        Nombres,
        Apellidos,
        Telefono,
        DocumentoIdentidad,
        RequiereDobleFactor,
        SecretoDobleFactor,
        IntentosFallidos,
		FechaBLoqueo,
        UltimoAcceso,
        IdEmpresa,
        FechaCreacion,
        CreadoPor,
        Activo,
        Eliminado
    )
    VALUES (
        'superadmin',
        'admin@asbanc.pe',
        '$2a$12$vW7p7NlS8rhZ0/ygTRxeJudMNlWnVOdFFzT3H4mPgLX4G4oWsB6yS',
        'Super',
        'Administrador',
        '999000001',
        '00000001',
        0,
        NULL,
        0,
        NULL,
        NULL,
        NULL,
        @FechaCreacion,
        @Usuario,
        1,
        0
    )
    
    SET @IdSuperAdmin = SCOPE_IDENTITY()
    
    INSERT INTO UsuarioRol (IdUsuario, IdRol, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdSuperAdmin, @IdRolSuperAdmin, @FechaCreacion, @Usuario, 1, 0)

    INSERT INTO UsuarioEmpresa (IdUsuario, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES 
        (@IdSuperAdmin, @IdEmpresaDCF, @FechaCreacion, @Usuario, 1, 0),
        (@IdSuperAdmin, @IdEmpresaAloBanco, @FechaCreacion, @Usuario, 1, 0)

END


-- ADMINISTRADOR ALÓ BANCO === Email: admin@alobanco.pe | Password: AdminAlobanco123!

DECLARE @IdAdminAloBanco INT
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Email = 'admin@alobanco.pe')
BEGIN
    INSERT INTO Usuario (
        NombreUsuario,
        Email,
        PasswordHash,
        Nombres,
        Apellidos,
        Telefono,
        DocumentoIdentidad,
        RequiereDobleFactor,
        SecretoDobleFactor,
        IntentosFallidos,
        FechaBLoqueo,
        UltimoAcceso,
        IdEmpresa,
        FechaCreacion,
        CreadoPor,
        Activo,
        Eliminado
    )
    VALUES (
        'admin.alobanco',
        'admin@alobanco.pe',
        '$2a$12$XfCqL0NbdyAHZZLlmTrp5uHz1ADTpPQwmBPy9iI0zQPgPEVtyDkJC',
        'Administrador',
        'AloBanco',
        '999000002',
        '00000002',
        0,
        NULL,
        0,
        NULL,
        NULL,
        @IdEmpresaAloBanco,
        @FechaCreacion,
        @Usuario,
        1,
        0
    )
    
    SET @IdAdminAloBanco = SCOPE_IDENTITY()

    INSERT INTO UsuarioRol (IdUsuario, IdRol, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdAdminAloBanco, @IdRolAdmin, @FechaCreacion, @Usuario, 1, 0)

    
    INSERT INTO UsuarioEmpresa (IdUsuario, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdAdminAloBanco, @IdEmpresaAloBanco, @FechaCreacion, @Usuario, 1, 0)
END



-- USUARIO ALÓ BANCO (Gestor de Consulta) === Email: julio@alobanco.pe | Password: Julio123!


DECLARE @IdUsuarioAloBanco INT
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Email = 'julio@alobanco.pe')
BEGIN
    INSERT INTO Usuario (
        NombreUsuario,
        Email,
        PasswordHash,
        Nombres,
        Apellidos,
        Telefono,
        DocumentoIdentidad,
        RequiereDobleFactor,
        SecretoDobleFactor,
        IntentosFallidos,
        FechaBLoqueo,
        UltimoAcceso,
        IdEmpresa,
        FechaCreacion,
        CreadoPor,
        Activo,
        Eliminado
    )
    VALUES (
        'julio.alobanco',
        'julio@alobanco.pe',
        '$2a$12$bT55ellTDJrmInThnJW6necwqVK/KKuenZT5V5VDVC4.Sev3qjhHS',
        'Julio',
        'García',
        '999000003',
        '12345678',
        0,
        NULL,
        0,
        NULL,
        NULL,
        @IdEmpresaAloBanco,
        @FechaCreacion,
        @Usuario,
        1,
        0
    )
    
    SET @IdUsuarioAloBanco = SCOPE_IDENTITY()
    
    INSERT INTO UsuarioRol (IdUsuario, IdRol, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdUsuarioAloBanco, @IdRolGestorConsulta, @FechaCreacion, @Usuario, 1, 0)
    
    INSERT INTO UsuarioEmpresa (IdUsuario, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdUsuarioAloBanco, @IdEmpresaAloBanco, @FechaCreacion, @Usuario, 1, 0)
END


-- ADMINISTRADOR DCF === Email: admin@dcf.pe | Password: AdminDcf123!


DECLARE @IdAdminDCF INT
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Email = 'admin@dcf.pe')
BEGIN
    INSERT INTO Usuario (
        NombreUsuario,
        Email,
        PasswordHash,
        Nombres,
        Apellidos,
        Telefono,
        DocumentoIdentidad,
        RequiereDobleFactor,
        SecretoDobleFactor,
        IntentosFallidos,
        FechaBLoqueo,
        UltimoAcceso,
        IdEmpresa,
        FechaCreacion,
        CreadoPor,
        Activo,
        Eliminado
    )
    VALUES (
        'admin.dcf',
        'admin@dcf.pe',
        '$2a$12$lEd7Gu4IFAajbFLaPecJN.ceGKIQEjIg3RoNowdHBIag0jEn2q.pS',
        'Administrador',
        'DCF',
        '999000004',
        '00000004',
        0,
        NULL,
        0,
        NULL,
        NULL,
        @IdEmpresaDCF,
        @FechaCreacion,
        @Usuario,
        1,
        0
    )
    
    SET @IdAdminDCF = SCOPE_IDENTITY()
    
    INSERT INTO UsuarioRol (IdUsuario, IdRol, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdAdminDCF, @IdRolAdmin, @FechaCreacion, @Usuario, 1, 0)

    INSERT INTO UsuarioEmpresa (IdUsuario, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdAdminDCF, @IdEmpresaDCF, @FechaCreacion, @Usuario, 1, 0)

END


-- USUARIO DCF (Defensor) === Email: rosa@dcf.pe | Password: Rosa123!


DECLARE @IdUsuarioDCF INT
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Email = 'rosa@dcf.pe')
BEGIN
    INSERT INTO Usuario (
        NombreUsuario,
        Email,
        PasswordHash,
        Nombres,
        Apellidos,
        Telefono,
        DocumentoIdentidad,
        RequiereDobleFactor,
        SecretoDobleFactor,
        IntentosFallidos,
        FechaBLoqueo,
        UltimoAcceso,
        IdEmpresa,
        FechaCreacion,
        CreadoPor,
        Activo,
        Eliminado
    )
    VALUES (
        'rosa.dcf',
        'rosa@dcf.pe',
        '$2a$12$lKfQqS2Tj6IS/4q.p9B/tOTeACcDB/qh/ludBidJo0.P1YH/D/UTa',
        'Rosa',
        'Martínez',
        '999000005',
        '87654321',
        0,
        NULL,
        0,
        NULL,
        NULL,
        @IdEmpresaDCF,
        @FechaCreacion,
        @Usuario,
        1,
        0
    )
    
    SET @IdUsuarioDCF = SCOPE_IDENTITY()
    INSERT INTO UsuarioRol (IdUsuario, IdRol, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdUsuarioDCF, @IdRolDefensor, @FechaCreacion, @Usuario, 1, 0)

	INSERT INTO UsuarioEmpresa (IdUsuario, IdEmpresa, FechaCreacion, CreadoPor, Activo, Eliminado)
    VALUES (@IdUsuarioDCF, @IdEmpresaDCF, @FechaCreacion, @Usuario, 1, 0)

END
GO

-- asigno TODOS los permisos a SUPER_ADMIN Y ADMIN

DECLARE @IdRolSuperAdmin INT
DECLARE @IdRolAdmin INT
DECLARE @IdPermiso INT
DECLARE @Usuario NVARCHAR(50) = 'SYSTEM'
DECLARE @FechaCreacion DATETIME = GETDATE()

SELECT @IdRolSuperAdmin = IdRol FROM Rol WHERE Codigo = 'SUPER_ADMIN'
SELECT @IdRolAdmin = IdRol FROM Rol WHERE Codigo = 'ADMIN'

DECLARE cursor_permisos_superadmin CURSOR FOR
SELECT IdPermiso FROM Permiso WHERE Activo = 1 AND Eliminado = 0

OPEN cursor_permisos_superadmin
FETCH NEXT FROM cursor_permisos_superadmin INTO @IdPermiso

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RolPermiso WHERE IdRol = @IdRolSuperAdmin AND IdPermiso = @IdPermiso)
    BEGIN
        INSERT INTO RolPermiso (IdRol, IdPermiso, FechaCreacion, CreadoPor, Activo, Eliminado)
        VALUES (@IdRolSuperAdmin, @IdPermiso, @FechaCreacion, @Usuario, 1, 0)
    END
    
    FETCH NEXT FROM cursor_permisos_superadmin INTO @IdPermiso
END

CLOSE cursor_permisos_superadmin
DEALLOCATE cursor_permisos_superadmin

-- Asigno permisos globales y de gestión al Admin

DECLARE cursor_permisos_admin CURSOR FOR
SELECT IdPermiso 
FROM Permiso 
WHERE Activo = 1 
  AND Eliminado = 0
  AND (
      IdEmpresa IS NULL
      OR Recurso IN ('USUARIO', 'ROL', 'PERMISO')
  )

OPEN cursor_permisos_admin
FETCH NEXT FROM cursor_permisos_admin INTO @IdPermiso

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RolPermiso WHERE IdRol = @IdRolAdmin AND IdPermiso = @IdPermiso)
    BEGIN
        INSERT INTO RolPermiso (IdRol, IdPermiso, FechaCreacion, CreadoPor, Activo, Eliminado)
        VALUES (@IdRolAdmin, @IdPermiso, @FechaCreacion, @Usuario, 1, 0)
    END
    
    FETCH NEXT FROM cursor_permisos_admin INTO @IdPermiso
END

CLOSE cursor_permisos_admin
DEALLOCATE cursor_permisos_admin

-- Asigno permisos de AloBanco al Gestor de Consulta

DECLARE @IdRolGestorConsulta INT
SELECT @IdRolGestorConsulta = IdRol FROM Rol WHERE Codigo = 'GESTOR_CONSULTA'

DECLARE cursor_permisos_gestor CURSOR FOR
SELECT IdPermiso 
FROM Permiso 
WHERE Activo = 1 
  AND Eliminado = 0
  AND (
      Recurso IN ('CONSULTA_ALO', 'GESTION_ALO', 'REPORTE_ALO')
      OR Codigo IN ('LOGIN', 'LOGOUT', 'REFRESH_TOKEN')
  )

OPEN cursor_permisos_gestor
FETCH NEXT FROM cursor_permisos_gestor INTO @IdPermiso

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RolPermiso WHERE IdRol = @IdRolGestorConsulta AND IdPermiso = @IdPermiso)
    BEGIN
        INSERT INTO RolPermiso (IdRol, IdPermiso, FechaCreacion, CreadoPor, Activo, Eliminado)
        VALUES (@IdRolGestorConsulta, @IdPermiso, @FechaCreacion, @Usuario, 1, 0)
    END
    
    FETCH NEXT FROM cursor_permisos_gestor INTO @IdPermiso
END

CLOSE cursor_permisos_gestor
DEALLOCATE cursor_permisos_gestor

-- Asigno permisos de DCF al Defensor

DECLARE @IdRolDefensor INT
SELECT @IdRolDefensor = IdRol FROM Rol WHERE Codigo = 'DEFENSOR'

DECLARE cursor_permisos_defensor CURSOR FOR
SELECT IdPermiso 
FROM Permiso 
WHERE Activo = 1 
  AND Eliminado = 0
  AND (
      Recurso IN ('RECLAMO', 'BANDEJA', 'REPORTE_DCF')
      OR Codigo IN ('LOGIN', 'LOGOUT', 'REFRESH_TOKEN', 'VERIFY_DIGITAL_SIGNATURE')
  )

OPEN cursor_permisos_defensor
FETCH NEXT FROM cursor_permisos_defensor INTO @IdPermiso

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RolPermiso WHERE IdRol = @IdRolDefensor AND IdPermiso = @IdPermiso)
    BEGIN
        INSERT INTO RolPermiso (IdRol, IdPermiso, FechaCreacion, CreadoPor, Activo, Eliminado)
        VALUES (@IdRolDefensor, @IdPermiso, @FechaCreacion, @Usuario, 1, 0)
    END
    
    FETCH NEXT FROM cursor_permisos_defensor INTO @IdPermiso
END

CLOSE cursor_permisos_defensor
DEALLOCATE cursor_permisos_defensor

GO