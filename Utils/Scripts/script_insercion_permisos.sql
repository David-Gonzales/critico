-- Carga inicial de permisos del sistema

DECLARE @Usuario NVARCHAR(50) = 'SYSTEM'
DECLARE @FechaCreacion DATETIME = GETDATE()
DECLARE @IdEmpresaDCF INT
DECLARE @IdEmpresaAloBanco INT

SELECT @IdEmpresaAloBanco = IdEmpresa FROM Empresa WHERE Codigo = 'ALOBANCO'
SELECT @IdEmpresaDCF = IdEmpresa FROM Empresa WHERE Codigo = 'DCF'


-- 1. PERMISOS GLOBALES (Compartidos por ambas empresas)

-- Usuarios
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_USUARIOS', 'Ver Usuarios', 'Permite listar y visualizar usuarios del sistema', 'USUARIOS', 'USUARIO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_USUARIOS', 'Crear Usuarios', 'Permite crear nuevos usuarios en el sistema', 'USUARIOS', 'USUARIO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_USUARIOS', 'Editar Usuarios', 'Permite modificar datos de usuarios existentes', 'USUARIOS', 'USUARIO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_USUARIOS', 'Eliminar Usuarios', 'Permite eliminar usuarios del sistema', 'USUARIOS', 'USUARIO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0),
('CAMBIAR_PASSWORD_USUARIOS', 'Cambiar Contraseña de Usuarios', 'Permite cambiar la contraseña de otros usuarios', 'USUARIOS', 'USUARIO', 'CAMBIAR_PASSWORD', @FechaCreacion, @Usuario, 1, 0),
('ACTIVAR_DESACTIVAR_USUARIOS', 'Activar/Desactivar Usuarios', 'Permite activar o desactivar usuarios', 'USUARIOS', 'USUARIO', 'ACTIVAR_DESACTIVAR', @FechaCreacion, @Usuario, 1, 0)

-- Roles
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_ROLES', 'Ver Roles', 'Permite listar y visualizar roles del sistema', 'ROLES', 'ROL', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_ROLES', 'Crear Roles', 'Permite crear nuevos roles en el sistema', 'ROLES', 'ROL', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_ROLES', 'Editar Roles', 'Permite modificar roles existentes', 'ROLES', 'ROL', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_ROLES', 'Eliminar Roles', 'Permite eliminar roles del sistema', 'ROLES', 'ROL', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Permisos
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_PERMISOS', 'Ver Permisos', 'Permite visualizar la matriz de permisos', 'PERMISOS', 'PERMISO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('ASIGNAR_PERMISOS', 'Asignar Permisos', 'Permite asignar permisos a roles', 'PERMISOS', 'PERMISO', 'ASIGNAR', @FechaCreacion, @Usuario, 1, 0)

-- Módulo de autenticación
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('LOGIN', 'Iniciar Sesión', 'Permite autenticarse en el sistema', 'AUTENTICACION', 'AUTH', 'LOGIN', @FechaCreacion, @Usuario, 1, 0),
('LOGOUT', 'Cerrar Sesión', 'Permite cerrar sesión en el sistema', 'AUTENTICACION', 'AUTH', 'LOGOUT', @FechaCreacion, @Usuario, 1, 0),
('REFRESH_TOKEN', 'Renovar Token', 'Permite renovar el token de acceso', 'AUTENTICACION', 'AUTH', 'REFRESH_TOKEN', @FechaCreacion, @Usuario, 1, 0),
('RESET_PASSWORD', 'Restablecer Contraseña', 'Permite solicitar restablecimiento de contraseña', 'AUTENTICACION', 'AUTH', 'RESET_PASSWORD', @FechaCreacion, @Usuario, 1, 0),
('VERIFY_2FA', 'Verificar 2FA', 'Permite verificar autenticación de dos factores', 'AUTENTICACION', 'AUTH', 'VERIFY_2FA', @FechaCreacion, @Usuario, 1, 0),
('VERIFY_DIGITAL_SIGNATURE', 'Verificar Firma Digital', 'Permite verificar firma digital de documentos', 'AUTENTICACION', 'AUTH', 'VERIFY_DIGITAL_SIGNATURE', @FechaCreacion, @Usuario, 1, 0)

-- 2. PERMISOS DE ALOBANCO

-- Gestión
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_GESTION_ALO', 'Ver Gestión', 'Permite visualizar módulo de gestión AloBanco', 'GESTION_ALOBANCO', 'GESTION_ALO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_GESTION_ALO', 'Crear Gestión', 'Permite crear nuevas gestiones en AloBanco', 'GESTION_ALOBANCO', 'GESTION_ALO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_GESTION_ALO', 'Editar Gestión', 'Permite modificar gestiones en AloBanco', 'GESTION_ALOBANCO', 'GESTION_ALO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_GESTION_ALO', 'Eliminar Gestión', 'Permite eliminar gestiones en AloBanco', 'GESTION_ALOBANCO', 'GESTION_ALO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Consulta
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_CONSULTA_ALO', 'Ver Consultas', 'Permite visualizar consultas ciudadanas', 'CONSULTA_ALOBANCO', 'CONSULTA_ALO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_CONSULTA_ALO', 'Crear Consultas', 'Permite registrar nuevas consultas', 'CONSULTA_ALOBANCO', 'CONSULTA_ALO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('RESPONDER_CONSULTA_ALO', 'Responder Consultas', 'Permite responder consultas ciudadanas', 'CONSULTA_ALOBANCO', 'CONSULTA_ALO', 'RESPONDER', @FechaCreacion, @Usuario, 1, 0),
('CERRAR_CONSULTA_ALO', 'Cerrar Consultas', 'Permite cerrar consultas resueltas', 'CONSULTA_ALOBANCO', 'CONSULTA_ALO', 'CERRAR', @FechaCreacion, @Usuario, 1, 0)

-- Reportes
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_REPORTES_ALO', 'Ver Reportes', 'Permite visualizar reportes de AloBanco', 'REPORTES_ALOBANCO', 'REPORTE_ALO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('GENERAR_REPORTES_ALO', 'Generar Reportes', 'Permite generar reportes personalizados', 'REPORTES_ALOBANCO', 'REPORTE_ALO', 'GENERAR', @FechaCreacion, @Usuario, 1, 0),
('EXPORTAR_REPORTES_ALO', 'Exportar Reportes', 'Permite exportar reportes a Excel/PDF', 'REPORTES_ALOBANCO', 'REPORTE_ALO', 'EXPORTAR', @FechaCreacion, @Usuario, 1, 0)

-- Administración - Entidades Financieras
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_ENTIDADES_ALO', 'Ver Entidades Financieras', 'Permite visualizar entidades financieras', 'ADMINISTRACION_ENTIDADES_FINANCIERAS_ALOBANCO', 'ENTIDAD_FINANCIERA', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_ENTIDADES_ALO', 'Crear Entidades Financieras', 'Permite registrar nuevas entidades', 'ADMINISTRACION_ENTIDADES_FINANCIERAS_ALOBANCO', 'ENTIDAD_FINANCIERA', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_ENTIDADES_ALO', 'Editar Entidades Financieras', 'Permite modificar entidades financieras', 'ADMINISTRACION_ENTIDADES_FINANCIERAS_ALOBANCO', 'ENTIDAD_FINANCIERA', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_ENTIDADES_ALO', 'Eliminar Entidades Financieras', 'Permite eliminar entidades financieras', 'ADMINISTRACION_ENTIDADES_FINANCIERAS_ALOBANCO', 'ENTIDAD_FINANCIERA', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Administración - Paramétricas
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_PARAMETRICAS_ALO', 'Ver Paramétricas', 'Permite visualizar tablas paramétricas', 'ADMINISTRACION_PARAMETRICAS_ALOBANCO', 'PARAMETRICA', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_PARAMETRICAS_ALO', 'Crear Paramétricas', 'Permite crear registros en paramétricas', 'ADMINISTRACION_PARAMETRICAS_ALOBANCO', 'PARAMETRICA', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_PARAMETRICAS_ALO', 'Editar Paramétricas', 'Permite modificar paramétricas', 'ADMINISTRACION_PARAMETRICAS_ALOBANCO', 'PARAMETRICA', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_PARAMETRICAS_ALO', 'Eliminar Paramétricas', 'Permite eliminar registros de paramétricas', 'ADMINISTRACION_PARAMETRICAS_ALOBANCO', 'PARAMETRICA', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Administración - Notificaciones
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_NOTIFICACIONES_ALO', 'Ver Notificaciones', 'Permite visualizar notificaciones de AloBanco', 'ADMINISTRACION_NOTIFICACIONES_ALOBANCO', 'NOTIFICACION_ALO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_NOTIFICACIONES_ALO', 'Crear Notificaciones', 'Permite crear plantillas de notificaciones', 'ADMINISTRACION_NOTIFICACIONES_ALOBANCO', 'NOTIFICACION_ALO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_NOTIFICACIONES_ALO', 'Editar Notificaciones', 'Permite modificar notificaciones', 'ADMINISTRACION_NOTIFICACIONES_ALOBANCO', 'NOTIFICACION_ALO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_NOTIFICACIONES_ALO', 'Eliminar Notificaciones', 'Permite eliminar notificaciones', 'ADMINISTRACION_NOTIFICACIONES_ALOBANCO', 'NOTIFICACION_ALO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Administración - Parámetros
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_PARAMETROS_ALO', 'Ver Parámetros', 'Permite visualizar parámetros de AloBanco', 'ADMINISTRACION_PARAMETROS_ALOBANCO', 'PARAMETRO_ALO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_PARAMETROS_ALO', 'Crear Parámetros', 'Permite crear parámetros de sistema', 'ADMINISTRACION_PARAMETROS_ALOBANCO', 'PARAMETRO_ALO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_PARAMETROS_ALO', 'Editar Parámetros', 'Permite modificar parámetros del sistema', 'ADMINISTRACION_PARAMETROS_ALOBANCO', 'PARAMETRO_ALO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_PARAMETROS_ALO', 'Eliminar Parámetros', 'Permite eliminar parámetros del sistema', 'ADMINISTRACION_PARAMETROS_ALOBANCO', 'PARAMETRO_ALO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)


-- 3. PERMISOS DE DCF

-- Reclamos
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_RECLAMOS_DCF', 'Ver Reclamos', 'Permite visualizar reclamos en DCF', 'RECLAMOS_DCF', 'RECLAMO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_RECLAMOS_DCF', 'Crear Reclamos', 'Permite registrar nuevos reclamos en DCF', 'RECLAMOS_DCF', 'RECLAMO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_RECLAMOS_DCF', 'Editar Reclamos', 'Permite modificar reclamos en DCF', 'RECLAMOS_DCF', 'RECLAMO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_RECLAMOS_DCF', 'Eliminar Reclamos', 'Permite eliminar reclamos en DCF', 'RECLAMOS_DCF', 'RECLAMO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0),
('ASIGNAR_RECLAMOS_DCF', 'Asignar Reclamos', 'Permite asignar reclamos a analistas', 'RECLAMOS_DCF', 'RECLAMO', 'ASIGNAR', @FechaCreacion, @Usuario, 1, 0),
('APROBAR_RECLAMOS_DCF', 'Aprobar Reclamos', 'Permite aprobar resoluciones de reclamos', 'RECLAMOS_DCF', 'RECLAMO', 'APROBAR', @FechaCreacion, @Usuario, 1, 0),
('RECHAZAR_RECLAMOS_DCF', 'Rechazar Reclamos', 'Permite rechazar reclamos', 'RECLAMO_DCF', 'RECLAMO', 'RECHAZAR', @FechaCreacion, @Usuario, 1, 0),
('FIRMAR_RECLAMOS_DCF', 'Firmar Reclamos', 'Permite firmar digitalmente resoluciones', 'RECLAMOS_DCF', 'RECLAMO', 'FIRMAR', @FechaCreacion, @Usuario, 1, 0)

-- Configuración - Notificaciones
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_NOTIFICACIONES_DCF', 'Ver Notificaciones', 'Permite visualizar configuración de notificaciones', 'CONFIGURACION_NOTIFICACIONES_DCF', 'NOTIFICACION_DCF', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_NOTIFICACIONES_DCF', 'Crear Notificaciones', 'Permite crear plantillas de notificaciones', 'CONFIGURACION_NOTIFICACIONES_DCF', 'NOTIFICACION_DCF', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_NOTIFICACIONES_DCF', 'Editar Notificaciones', 'Permite modificar plantillas de notificaciones', 'CONFIGURACION_NOTIFICACIONES_DCF', 'NOTIFICACION_DCF', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_NOTIFICACIONES_DCF', 'Eliminar Notificaciones', 'Permite eliminar plantillas de notificaciones', 'CONFIGURACION_NOTIFICACIONES_DCF', 'NOTIFICACION_DCF', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Configuración DCF - Parámetros
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_PARAMETROS_DCF', 'Ver Parámetros', 'Permite visualizar parámetros del sistema DCF', 'CONFIGURACION_PARAMETROS_DCF', 'PARAMETRO_DCF', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_PARAMETROS_DCF', 'Crear Parámetros', 'Permite crear parámetros del sistema DCF', 'CONFIGURACION_PARAMETROS_DCF', 'PARAMETRO_DCF', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_PARAMETROS_DCF', 'Editar Parámetros', 'Permite modificar parámetros del sistema DCF', 'CONFIGURACION_PARAMETROS_DCF', 'PARAMETRO_DCF', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_PARAMETROS_DCF', 'Eliminar Parámetros', 'Permite eliminar parámetros del sistema DCF', 'CONFIGURACION_PARAMETROS_DCF', 'PARAMETRO_DCF', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Configuración DCF - Catálogos
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_CATALOGOS_DCF', 'Ver Catálogos', 'Permite visualizar catálogos del sistema', 'CONFIGURACION_CATALOGOS_DCF', 'CATALOGO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_CATALOGOS_DCF', 'Crear Catálogos', 'Permite crear nuevos catálogos', 'CONFIGURACION_CATALOGOS_DCF', 'CATALOGO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_CATALOGOS_DCF', 'Editar Catálogos', 'Permite modificar catálogos existentes', 'CONFIGURACION_CATALOGOS_DCF', 'CATALOGO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_CATALOGOS_DCF', 'Eliminar Catálogos', 'Permite eliminar catálogos', 'CONFIGURACION_CATALOGOS_DCF', 'CATALOGO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Configuración DCF - Entidades
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_ENTIDADES_DCF', 'Ver Entidades', 'Permite visualizar entidades financieras', 'CONFIGURACION_ENTIDADES_DCF', 'ENTIDAD', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_ENTIDADES_DCF', 'Crear Entidades', 'Permite registrar nuevas entidades financieras', 'CONFIGURACION_ENTIDADES_DCF', 'ENTIDAD', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_ENTIDADES_DCF', 'Editar Entidades', 'Permite modificar entidades financieras', 'CONFIGURACION_ENTIDADES_DCF', 'ENTIDAD', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_ENTIDADES_DCF', 'Eliminar Entidades', 'Permite eliminar entidades financieras', 'CONFIGURACION_ENTIDADES_DCF', 'ENTIDAD', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Configuración DCF - Firmas
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_FIRMAS_DCF', 'Ver Firmas', 'Permite visualizar configuración de firmas digitales', 'CONFIGURACION_FIRMAS_DCF', 'FIRMA', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_FIRMAS_DCF', 'Crear Firmas', 'Permite registrar nuevas firmas digitales', 'CONFIGURACION_FIRMAS_DCF', 'FIRMA', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_FIRMAS_DCF', 'Editar Firmas', 'Permite modificar configuración de firmas', 'CONFIGURACION_FIRMAS_DCF', 'FIRMA', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_FIRMAS_DCF', 'Eliminar Firmas', 'Permite eliminar firmas digitales', 'CONFIGURACION_FIRMAS_DCF', 'FIRMA', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Configuración DCF - Tipos de Requerimiento
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_TIPOS_REQUERIMIENTO_DCF', 'Ver Tipos de Requerimiento', 'Permite visualizar tipos de requerimiento', 'CONFIGURACION_TIPOS_REQUERIMIENTO_DCF', 'TIPO_REQUERIMIENTO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_TIPOS_REQUERIMIENTO_DCF', 'Crear Tipos de Requerimiento', 'Permite crear nuevos tipos de requerimiento', 'CONFIGURACION_TIPOS_REQUERIMIENTO_DCF', 'TIPO_REQUERIMIENTO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_TIPOS_REQUERIMIENTO_DCF', 'Editar Tipos de Requerimiento', 'Permite modificar tipos de requerimiento', 'CONFIGURACION_TIPOS_REQUERIMIENTO_DCF', 'TIPO_REQUERIMIENTO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_TIPOS_REQUERIMIENTO_DCF', 'Eliminar Tipos de Requerimiento', 'Permite eliminar tipos de requerimiento', 'CONFIGURACION_TIPOS_REQUERIMIENTO_DCF', 'TIPO_REQUERIMIENTO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Configuración DCF - Feriados
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_FERIADOS_DCF', 'Ver Feriados', 'Permite visualizar calendario de feriados', 'CONFIGURACION_FERIADOS_DCF', 'FERIADO', 'VER', @FechaCreacion, @Usuario, 1, 0),
('CREAR_FERIADOS_DCF', 'Crear Feriados', 'Permite registrar nuevos feriados', 'CONFIGURACION_FERIADOS_DCF', 'FERIADO', 'CREAR', @FechaCreacion, @Usuario, 1, 0),
('EDITAR_FERIADOS_DCF', 'Editar Feriados', 'Permite modificar feriados existentes', 'CONFIGURACION_FERIADOS_DCF', 'FERIADO', 'EDITAR', @FechaCreacion, @Usuario, 1, 0),
('ELIMINAR_FERIADOS_DCF', 'Eliminar Feriados', 'Permite eliminar feriados', 'CONFIGURACION_FERIADOS_DCF', 'FERIADO', 'ELIMINAR', @FechaCreacion, @Usuario, 1, 0)

-- Consultas DCF - Bandeja
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_BANDEJA_DCF', 'Ver Bandeja', 'Permite visualizar bandeja de entrada de reclamos', 'CONSULTAS_BANDEJA_DCF', 'BANDEJA', 'VER', @FechaCreacion, @Usuario, 1, 0),
('EXPORTAR_BANDEJA_DCF', 'Exportar Bandeja', 'Permite exportar datos de la bandeja', 'CONSULTAS_BANDEJA_DCF', 'BANDEJA', 'EXPORTAR', @FechaCreacion, @Usuario, 1, 0)

-- Consultas DCF - Reportes
INSERT INTO Permiso (Codigo, Nombre, Descripcion, Modulo, Recurso, Accion, FechaCreacion, CreadoPor, Activo, Eliminado)
VALUES 
('VER_REPORTES_DCF', 'Ver Reportes', 'Permite visualizar reportes del sistema DCF', 'CONSULTAS_REPORTES_DCF', 'REPORTE_DCF', 'VER', @FechaCreacion, @Usuario, 1, 0),
('GENERAR_REPORTES_DCF', 'Generar Reportes', 'Permite generar reportes personalizados', 'CONSULTAS_REPORTES_DCF', 'REPORTE_DCF', 'GENERAR', @FechaCreacion, @Usuario, 1, 0),
('EXPORTAR_REPORTES_DCF', 'Exportar Reportes', 'Permite exportar reportes a Excel/PDF', 'CONSULTAS_REPORTES_DCF', 'REPORTE_DCF', 'EXPORTAR', @FechaCreacion, @Usuario, 1, 0)


UPDATE Permiso 
SET IdEmpresa = @IdEmpresaDCF
WHERE Recurso IN ('RECLAMO', 'NOTIFICACION_DCF', 'PARAMETRO_DCF', 'CATALOGO', 'ENTIDAD', 
                  'FIRMA', 'TIPO_REQUERIMIENTO', 'FERIADO', 'BANDEJA', 'REPORTE_DCF')

UPDATE Permiso 
SET IdEmpresa = @IdEmpresaAloBanco
WHERE Recurso IN ('GESTION_ALO', 'CONSULTA_ALO', 'REPORTE_ALO', 'ENTIDAD_FINANCIERA', 
                  'PARAMETRICA', 'NOTIFICACION_ALO', 'PARAMETRO_ALO')

GO