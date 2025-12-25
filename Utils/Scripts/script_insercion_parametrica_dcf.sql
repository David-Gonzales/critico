USE DB_ASBANC_DEV
GO

DECLARE @IdGrupo INT

-- ================= APLICACION GENERAL - DCF =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_APLICACION_GENERAL'

INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'TAMANO_ARCHIVO_ADJUNTO', 'Tamaño de Archivos en MB', '25', 'Tamaño máximo de archivos adjuntos', 1, 0, 'SEED'),
(@IdGrupo, 'EMAIL_NOTIFICACIONES_FROM', 'Correo con el que se realiza el envío de las notificaciones', 'noreply@asbanc.com.pe', 'Email remitente de notificaciones', 2, 0, 'SEED'),
(@IdGrupo, 'USER_GENERICO_AUDIT', 'Usuario genérico que se utilizará en los campos de auditoría', 'user_consulta@asbanc.com.pe', 'Usuario por defecto para auditoría', 3, 0, 'SEED')


-- ================= APLICACION DE GESTIÓN DE CONSULTAS - DCF =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_APLICACION_CONSULTAS'

INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'CONSULTA_EMAIL_NOTIFICACIONES_TO', 'Correo de destino de las consultas registradas', NULL, 'Email destinatario para consultas', 1, 0, 'SEED')


-- ================= APLICACION DE GESTIÓN DE RECLAMOS - DCF =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_APLICACION_RECLAMOS'

INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'RECLAMO_EMAIL_NOTIFICACIONES_TO', 'Correo de destino de los reclamos registrados', NULL, 'Email destinatario para reclamos', 1, 0, 'SEED'),
(@IdGrupo, 'RUTA_ARCHIVO_ADJUNTO', 'Ruta del servidor donde se guardarán los archivos adjuntos', '~/App_Data/Reclamos', 'Path de almacenamiento de archivos', 2, 0, 'SEED'),
(@IdGrupo, 'TIPOS_ARCHIVOS_ADJUNTOS', 'TIPOS DE ARCHIVOS PERMITIDOS PARA LOS ADJUNTOS', 'DOC|DOCX|PDF|JPG|PNG', 'Extensiones permitidas', 3, 0, 'SEED'),
(@IdGrupo, 'TIPOS_ARCHIVOS_ADJUNTOS_EXT', 'TIPOS DE ARCHIVOS PERMITIDOS PARA LOS ADJUNTOS DE LOS RECLAMOS EXTERNOS', 'DOC|DOCX|PDF|XLSX|JPG|PNG', 'Extensiones permitidas (externos)', 4, 0, 'SEED'),
(@IdGrupo, 'TAMANO_ARCHIVO_ADJUNTO_EXT', 'Tamaño de Archivos en MB para reclamos externos', '30', 'Tamaño máximo archivos externos', 5, 0, 'SEED'),
(@IdGrupo, 'DIAS_TOTALES_PROCESO_RECLAMO', 'Días totales que dura el proceso de gestión de reclamos', '60', 'Plazo total del proceso', 6, 0, 'SEED'),
(@IdGrupo, 'DIAS_CARGA_DOCUMENTOS', 'Plazo para la cantidad de días que deberá cargar los documentos faltantes', '1', 'Días para subsanar', 7, 0, 'SEED'),
(@IdGrupo, 'URL_CARGA_DOCUMENTORECLAMO', 'Url que se usará en el correo al solicitar documentos faltantes en el reclamo', 'https://dcf.pe/estado-de-tu-reclamo', 'URL pública de seguimiento', 8, 0, 'SEED'),
(@IdGrupo, 'RUTA_ADJUNTOS_SOLICITAINFORMACION', 'Ruta de adjuntos en el correo de solicitar información', 'E:\ASBANC\WEB\ASB_INTRANET_DCF_PROD\Adjuntos\', 'Path de adjuntos de solicitud', 9, 0, 'SEED'),
(@IdGrupo, 'RUTA_ARCHIVO_ADJUNTO_RESOLUCION', 'Ruta del servidor donde se guardarán los archivos de imágenes', '~/App_Data/Resolucion', 'Path de resoluciones', 10, 0, 'SEED'),
(@IdGrupo, 'TIPOS_ARCHIVOS_ADJUNTOS_RESOLUCION', 'Tipos de archivos de imágenes permitidos', 'PNG|TIF|JPG|JPEG|BMP', 'Extensiones de imágenes', 11, 0, 'SEED'),
(@IdGrupo, 'FLAG_CAUSARAIZ', 'Flag que mostrará los ddl de causa raíz', '0', 'Mostrar causa raíz (0=No, 1=Sí)', 12, 0, 'SEED'),
(@IdGrupo, 'CC_CORREOCONSULTA', 'Correos en copia para respuesta de correos', NULL, 'CC de notificaciones', 13, 0, 'SEED')


-- ====================== GENERAL =================================
-- TIPO PERSONA
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_TIPO_PERSONA'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Persona Natural', 'PERSONA NATURAL', 'Ser humano individual responsable personalmente con todo su patrimonio', 1, 0, 'SEED'),
(@IdGrupo, 'Persona Jurídica', 'PERSONA JURÍDICA', 'Entidad (empresa, asociación) con existencia propia, que responde con su patrimonio empresarial, separando sus bienes de los de sus socios, lo que ofrece una responsabilidad limitada.', 2, 0, 'SEED')

-- TIPO DOCUMENTO

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_TIPO_DOCUMENTO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Documento Nacional de Identidad', 'DNI', 'Documento nacional de identidad', 1, 0, 'SEED'),
(@IdGrupo, 'Carnet de Extranjería', 'Carnet Extranjería', 'Carnet de extranjería', 2, 0, 'SEED'),
(@IdGrupo, 'Pasaporte', 'Pasaporte', 'Pasaporte', 3, 0, 'SEED'),
(@IdGrupo, 'Cédula Diplómática', 'Cédula Diplómática', 'Cédula diplómática', 4, 0, 'SEED')


-- TIPO CANAL
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_TIPO_CANAL'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Presencial', 'PRESENCIAL', 'Presencial', 1, 0, 'SEED'),
(@IdGrupo, 'Call Center', 'CALL CENTER', 'Call center', 2, 0, 'SEED'),
(@IdGrupo, 'Correo', 'CORREO', 'Correo', 3, 0, 'SEED'),
(@IdGrupo, 'Web', 'WEB', 'Web', 4, 0, 'SEED')

-- TIPO PRODUCTO

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_TIPO_PRODUCTO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Depósitos de Ahorros', 'DEPÓSITOS DE AHORROS', 'Depósitos de ahorros', 1, 0, 'SEED'),
(@IdGrupo, 'Depósitos a Plazo', 'DEPÓSITOS A PLAZO', 'Depósitos a plazo', 2, 0, 'SEED'),
(@IdGrupo, 'Cuenta Corriente', 'CUENTA CORRIENTE', 'Cuenta corriente', 3, 0, 'SEED'),
(@IdGrupo, 'Depósitos por Compensación por Tiempo de Servicios', 'DEPÓSITOS POR COMPENSACIÓN POR TIEMPO DE SERVICIOS', 'Depósitos por compensación por tiempo de servicios', 4, 0, 'SEED'),
(@IdGrupo, 'Tarjetas de Débito', 'TARJETAS DE DÉBITO', 'Tarjetas de débito', 5, 0, 'SEED'),
(@IdGrupo, 'Tarjetas de Crédito', 'TARJETAS DE CRÉDITO', 'Tarjetas de crédito', 6, 0, 'SEED'),
(@IdGrupo, 'Créditos Comerciales y Microempresas', 'CREDITOS COMERCIALES Y MICROEMPRESAS', 'Créditos comerciales y microempresas', 7, 0, 'SEED'),
(@IdGrupo, 'Créditos de Consumo', 'CRÉDITOS DE CONSUMO', 'Créditos de consumo', 8, 0, 'SEED'),
(@IdGrupo, 'Créditos Hipotecarios', 'CRÉDITOS HIPOTECARIOS', 'Créditos hipotecarios', 9, 0, 'SEED'),
(@IdGrupo, 'Arrendamiento Financiero', 'ARRENDAMIENTO FINANCIERO', 'Arrendamiento financiero', 10, 0, 'SEED'),
(@IdGrupo, 'Factoring y/o Descuento', 'FACTORING Y/O DESCUENTO', 'Factoring y/o descuento', 11, 0, 'SEED'),
(@IdGrupo, 'Cartas Fianza / Fianzas', 'CARTAS FIANZA / FIANZAS', 'Cartas fianza / fianzas', 12, 0, 'SEED'),
(@IdGrupo, 'Avales y Otras Garantías', 'AVALES Y OTRAS GARANTIAS', 'Avales y otras garantías', 13, 0, 'SEED'),
(@IdGrupo, 'Fideicomisos', 'FIDEICOMISOS', 'Fideicomisos', 14, 0, 'SEED'),
(@IdGrupo, 'Cajas de Seguridad', 'CAJAS DE SEGURIDAD', 'Cajas de seguridad', 15, 0, 'SEED'),
(@IdGrupo, 'Transferencia de Fondos', 'TRANSFERENCIA DE FONDOS', 'Transferencia de fondos', 16, 0, 'SEED'),
(@IdGrupo, 'Banca Electrónica', 'BANCA ELECTRONICA', 'Banca electrónica', 17, 0, 'SEED'),
(@IdGrupo, 'Cajeros Automáticos', 'CAJEROS AUTOMÁTICOS', 'Cajeros automáticos', 18, 0, 'SEED'),
(@IdGrupo, 'Custodia', 'CUSTODIA', 'Custodia', 19, 0, 'SEED'),
(@IdGrupo, 'Servicios de Canje', 'SERVICIOS DE CANJE', 'Servicios de canje', 20, 0, 'SEED'),
(@IdGrupo, 'Servicios Varios', 'SERVICIOS VARIOS (INCLUYE CARGOS AUTOMATICOS, SERVICIO DE RECAUDACIONES, PAGOS DE SERVICIOS, CAMBIOS, COBRANZAS, SIMILARES)', 'Servicios varios (incluye cargos automáticos, servicio de recaudaciones, pagos de servicios, cambios, cobranzas, similares)', 21, 0, 'SEED'),
(@IdGrupo, 'Problemas Referidos al Servicio de Atención al Usuario del Sistema de Seguros', 'PROBLEMAS REFERIDOS AL SERVICIO DE ATENCION AL USUARIO DEL SISTEMA DE SEGUROS', 'Problemas referidos al servicio de atención al usuario del sistema de seguros', 22, 0, 'SEED'),
(@IdGrupo, 'Jubilación con Pensión Mínima', 'JUBILACIÓN CON PENSIÓN MÍNIMA', 'Jubilación con pensión mínima', 23, 0, 'SEED'),
(@IdGrupo, 'Pensión de Invalidez', 'PENSION DE INVALIDEZ', 'Pensión de invalidez', 24, 0, 'SEED'),
(@IdGrupo, 'Otras Operaciones, Servicios y/o Productos', 'OTRAS OPERACIONES, SERVICIOS Y/O PRODUCTOS', 'Otras operaciones, servicios y/o productos', 25, 0, 'SEED'),
(@IdGrupo, 'Fondos Mutuos', 'FONDOS MUTUOS', 'Fondos mutuos', 26, 0, 'SEED'),
(@IdGrupo, 'Consulta / Información', 'CONSULTA / INFORMACION', 'Consulta / información', 27, 0, 'SEED'),
(@IdGrupo, 'Sin Concretar', 'SIN CONCRETAR', 'Sin concretar', 28, 0, 'SEED')

-- TIPO IMPORTE

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'DCF_TIPO_IMPORTE'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Soles', '(S/)', 'Sol peruano', 1, 0, 'SEED'),
(@IdGrupo, 'Dólares', '(US$)', 'Dólar estadounidense', 2, 0, 'SEED'),
(@IdGrupo, 'Euros', '(€)', 'Euro', 3, 0, 'SEED'),
(@IdGrupo, 'No aplica', '', 'No aplica', 4, 0, 'SEED')


GO