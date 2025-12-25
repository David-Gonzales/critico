USE DB_ASBANC_DEV
GO

-- ============== Grupos de AloBanco
-- DOMINIO 
INSERT INTO GrupoParametrica (Codigo, Nombre, Descripcion, TipoGrupo, IdEmpresa, CreadoPor) VALUES
('ALO_ESTADO_RECLAMO', 'Estado del reclamo', 'Estados de reclamos para AloBanco', 'DOMINIO', 1, 'SEED'),
('ALO_FUENTE_ALOBANCO', 'Fuente AloBanco', 'Cómo se enteró el usuario de AlóBanco', 'DOMINIO', 1, 'SEED'),
('ALO_INSTANCIA', 'Instancia', 'Instancias donde se puede presentar un reclamo', 'DOMINIO', NULL, 'SEED'),
('ALO_MOTIVO_RECLAMO', 'Motivo del Reclamo / Consulta', 'Motivos por los cuales se presenta un reclamo', 'DOMINIO', 1, 'SEED'),
('ALO_TIPO_RESPUESTA', 'Tipo de Respuesta', 'Resultado de la resolución del reclamo', 'DOMINIO', 1, 'SEED'),
('ALO_TIPO_PRODUCTO', 'Tipo de Producto / Servicio / Operación', 'Categorías de productos financieros', 'DOMINIO', 1, 'SEED'),
('ALO_TIPO_REQUERIMIENTO', 'Tipo requerimiento', 'Tipo de solicitud: Reclamo o Consulta', 'DOMINIO', 1, 'SEED')
GO

-- PARÁMETROS
INSERT INTO GrupoParametrica (Codigo, Nombre, Descripcion, TipoGrupo, IdEmpresa, CreadoPor) VALUES
('ALO_EXTENSION_PERMITIVOS_ARCHIVO', 'EXTENSION_PERMITIVOS_ARCHIVO', 'Formatos permitidos', 'PARAMETRO', 1, 'SEED'),
('ALO_NOTIFICACION_CCO_CORREO', 'NOTIFICACION_CCO_CORREO', 'Copia oculta (BCC) para los correos', 'PARAMETRO', 1, 'SEED'),
('ALO_NOTIFICACION_FROM_CORREO', 'NOTIFICACION_FROM_CORREO', 'Correo electrónico del administrador de Alóbanco', 'PARAMETRO', 1, 'SEED'),
('ALO_NOTIFICACION_FROM_NOMBRE', 'NOTIFICACION_FROM_NOMBRE', 'Nombre de la notificación', 'PARAMETRO', 1, 'SEED'),
('ALO_NUMERO_MAXIMO_ARCHIVOS', 'NUMERO_MAXIMO_ARCHIVOS', 'El número máximo de archivos que se pueden adjuntar', 'PARAMETRO', 1, 'SEED'),
('ALO_POLITICAS_TRATAMIENTO_DATOS_PERSONALES_CONTENIDO', 'POLITICAS_TRATAMIENTO_DATOS_PERSONALES_CONTENIDO', 'Contenido de Políticas y Privacidad', 'PARAMETRO', 1, 'SEED'),
('ALO_TAMANIO_MAXIMO_ARCHIVO', 'TAMANIO_MAXIMO_ARCHIVO', 'El tamaño máximo en MB permitido por archivo', 'PARAMETRO', 1, 'SEED'),
('ALO_TERMINOS_CONDICIONES_CONTENIDO', 'TERMINOS_CONDICIONES_CONTENIDO', 'Contenido de los Términos y Condiciones', 'PARAMETRO', 1, 'SEED')
GO

-- GENERAL
INSERT INTO GrupoParametrica (Codigo, Nombre, Descripcion, TipoGrupo, IdEmpresa, CreadoPor) VALUES
('ALO_TIPO_MONTO', 'Tipo de Monto', 'Tipo de moneda', 'GENERAL', 1, 'SEED'),
('ALO_TIPO_DOCUMENTO', 'Tipo de Documento', 'Tipo de documento de identidad', 'GENERAL', 1, 'SEED'),
('ALO_TIPO_TELEFONO', 'Tipo de Teléfono', 'Código de teléfono celular por país', 'GENERAL', 1, 'SEED')
GO

-- ============= Grupos de DCF
INSERT INTO GrupoParametrica (Codigo, Nombre, Descripcion, TipoGrupo, IdEmpresa, CreadoPor) VALUES
('DCF_APLICACION_GENERAL', 'APLICACION GENERAL - DCF', 'Parámetros generales del sistema DCF', 'APLICACION', 2, 'SEED'),
('DCF_APLICACION_CONSULTAS', 'APLICACION DE GESTIÓN DE CONSULTAS - DCF', 'Parámetros del módulo de consultas DCF', 'APLICACION', 2, 'SEED'),
('DCF_APLICACION_RECLAMOS', 'APLICACION DE GESTIÓN DE RECLAMOS - DCF', 'Parámetros del módulo de reclamos DCF', 'APLICACION', 2, 'SEED')
GO

-- GENERAL
INSERT INTO GrupoParametrica (Codigo, Nombre, Descripcion, TipoGrupo, IdEmpresa, CreadoPor) VALUES
('DCF_TIPO_PERSONA', 'Tipo de Persona', 'Tipo de persona', 'GENERAL', 2, 'SEED'),
('DCF_TIPO_DOCUMENTO', 'Tipo de Documento', 'Tipo de documento de identidad', 'GENERAL', 2, 'SEED'),
('DCF_TIPO_CANAL', 'Tipo de Canal', 'Tipo de canal', 'GENERAL', 2, 'SEED'),
('DCF_TIPO_PRODUCTO', 'Tipo de Producto', 'Tipo de producto', 'GENERAL', 2, 'SEED'),
('DCF_TIPO_IMPORTE', 'Tipo de Importe', 'Tipo de moneda', 'GENERAL', 2, 'SEED')
GO


SELECT * FROM GrupoParametrica ORDER BY TipoGrupo, IdEmpresa, Codigo
GO