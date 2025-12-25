USE DB_ASBANC_DEV
GO

DECLARE @IdGrupo INT

-- ================= ESTADO DEL RECLAMO =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_ESTADO_RECLAMO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'En Proceso', 1, 0, 'SEED'),
(@IdGrupo, 'Terminado', 2, 0, 'SEED'),
(@IdGrupo, 'Inadmisible', 3, 0, 'SEED')


-- ================= FUENTE ALOBANCO =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_FUENTE_ALOBANCO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Orden, CreadoPor) VALUES
(@IdGrupo, 'Recomendación de amigos o familiares', 1, 'SEED'),
(@IdGrupo, 'En la respuesta del banco sobre un reclamo', 2, 'SEED'),
(@IdGrupo, 'Facebook', 3, 'SEED'),
(@IdGrupo, 'Instagram', 4, 'SEED'),
(@IdGrupo, 'LinkedIn', 5, 'SEED'),
(@IdGrupo, 'TikTok', 6, 'SEED'),
(@IdGrupo, 'Ferias', 7, 'SEED'),
(@IdGrupo, 'Otros (Periódico, Bancos, ASBANC, Defensoría del cliente Financiero, etc)', 8, 'SEED'),
(@IdGrupo, 'Página web del Indecopi', 9, 'SEED'),
(@IdGrupo, 'Sede Central Indecopi', 10, 'SEED'),
(@IdGrupo, 'Prensa', 11, 'SEED')


-- ================= INSTANCIA =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_INSTANCIA'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'No presentó en ninguna instancia', 1, 0, 'SEED'),
(@IdGrupo, 'CPC (Comisión de Protección al Consumidor - Indecopi)', 2, 0, 'SEED'),
(@IdGrupo, 'SAC (Servicio de Atención al Ciudadano - Indecopi)', 3, 0, 'SEED'),
(@IdGrupo, 'Alóbanco', 4, 0, 'SEED'),
(@IdGrupo, 'PAU (Plataforma de Atención al Usuario - SBS)', 5, 0, 'SEED'),
(@IdGrupo, 'DCF (Defensor del Cliente Financiero)', 6, 0, 'SEED')


-- ================= MOTIVO DEL RECLAMO =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_MOTIVO_RECLAMO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Orden, CreadoPor) VALUES
(@IdGrupo, 'Aplicación de tipo de cambio', 1, 'SEED'),
(@IdGrupo, 'Cancelación de cuenta', 2, 'SEED'),
(@IdGrupo, 'Cobros indebidos de intereses, comisiones, gastos y tributos', 3, 'SEED'),
(@IdGrupo, 'Consulta', 4, 'SEED'),
(@IdGrupo, 'Demora en procedimientos/trámites', 5, 'SEED'),
(@IdGrupo, 'Demoras o incumplimiento en el envío de correspondencia', 6, 'SEED'),
(@IdGrupo, 'Disconformidad por notificaciones dirigidas a terceras personas', 7, 'SEED'),
(@IdGrupo, 'Entrega de billetes falsos', 8, 'SEED'),
(@IdGrupo, 'Fallas del sistema informático que dificultan operaciones y servicios', 9, 'SEED'),
(@IdGrupo, 'Inadecuada atención al usuario', 10, 'SEED'),
(@IdGrupo, 'Inadecuada o insuficiente información sobre operaciones, productos y servicios', 11, 'SEED'),
(@IdGrupo, 'Incumplimiento de cláusulas de los contratos, pólizas, condiciones, acuerdos', 12, 'SEED'),
(@IdGrupo, 'Información incorrecta o engañosa sobre operaciones, productos o servicios', 13, 'SEED'),
(@IdGrupo, 'Liquidaciones erradas', 14, 'SEED'),
(@IdGrupo, 'Material informativo incompleto o publicidad engañosa', 15, 'SEED'),
(@IdGrupo, 'Modificación de las tasas de intereses, comisiones, u otras condiciones pactadas', 16, 'SEED'),
(@IdGrupo, 'Operaciones en cuenta no reconocidas', 17, 'SEED'),
(@IdGrupo, 'Otros motivos', 18, 'SEED'),
(@IdGrupo, 'Problemas presentados con la tarjeta de crédito', 19, 'SEED'),
(@IdGrupo, 'Problemas referidos a programas de lealtad', 20, 'SEED'),
(@IdGrupo, 'Problemas referidos a seguros contratados por empresas del SF (fraude / desgravamen)', 21, 'SEED'),
(@IdGrupo, 'Problemas relacionados con los cajeros automáticos', 22, 'SEED'),
(@IdGrupo, 'Reporte indebido en la Central de Riesgos', 23, 'SEED'),
(@IdGrupo, 'Retenciones indebidas (incluye retenciones judiciales o de cobranza coactiva)', 24, 'SEED'),
(@IdGrupo, 'Transacciones no procesadas / mal realizadas', 25, 'SEED')


-- ================= TIPO DE RESPUESTA =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TIPO_RESPUESTA'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'A favor de la empresa', 1, 0, 'SEED'),
(@IdGrupo, 'A favor del usuario', 2, 0, 'SEED'),
(@IdGrupo, 'No aplica', 3, 0, 'SEED')


-- ================= TIPO DE PRODUCTO =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TIPO_PRODUCTO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Orden, CreadoPor) VALUES
(@IdGrupo, 'Cajeros automáticos', 1, 'SEED'),
(@IdGrupo, 'Crédito de consumo', 2, 'SEED'),
(@IdGrupo, 'Crédito Hipotecario para vivienda', 3, 'SEED'),
(@IdGrupo, 'Crédito Vehicular', 4, 'SEED'),
(@IdGrupo, 'Créditos a pequeñas empresas y microempresas', 5, 'SEED'),
(@IdGrupo, 'Cuenta a plazo', 6, 'SEED'),
(@IdGrupo, 'Cuenta Corriente', 7, 'SEED'),
(@IdGrupo, 'Cuenta CTS', 8, 'SEED'),
(@IdGrupo, 'Cuenta de Ahorro', 9, 'SEED'),
(@IdGrupo, 'Otras operaciones, servicios y/o productos', 10, 'SEED'),
(@IdGrupo, 'Seguro de Bancos (SBB)', 11, 'SEED'),
(@IdGrupo, 'Servicio de Atención al Usuario', 12, 'SEED'),
(@IdGrupo, 'Servicio de recaudaciones', 13, 'SEED'),
(@IdGrupo, 'Servicios varios', 14, 'SEED'),
(@IdGrupo, 'Tarjeta de crédito', 15, 'SEED'),
(@IdGrupo, 'Transferencias de fondos', 16, 'SEED')


-- ================= TIPO REQUERIMIENTO =================
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TIPO_REQUERIMIENTO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Reclamo', 1, 0, 'SEED'),
(@IdGrupo, 'Consulta', 2, 0, 'SEED')

-- ================= PARAMÉTROS ========================

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_EXTENSION_PERMITIVOS_ARCHIVO'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'EXTENSION_PERMITIVOS_ARCHIVO', '', '.jpg,.png,.jpeg,.doc,.docx,.sxw,.pdf,.txt,.ppt,.pptx,.xls,.xlsx', 'Formatos permitidos', 1, 0, 'SEED')

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_NOTIFICACION_CCO_CORREO'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'NOTIFICACION_CCO_CORREO', '', 'alobancoweb@asbanc.com.pe', 'Copia oculta (BCC) para los correos', 1, 0, 'SEED')

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_NOTIFICACION_FROM_CORREO'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'NOTIFICACION_FROM_CORREO', '', 'alobancoweb@asbanc.com.pe', 'Correo electrónico del administrador de Alóbanco', 1, 0, 'SEED')

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_NOTIFICACION_FROM_NOMBRE'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'NOTIFICACION_FROM_NOMBRE', '', 'ALÓBANCO', 'Nombre de la notificación', 1, 0, 'SEED')

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_NUMERO_MAXIMO_ARCHIVOS'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'NUMERO_MAXIMO_ARCHIVOS', '', '20', 'El número máximo de archivos que se pueden adjuntar ', 1, 0, 'SEED')

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_POLITICAS_TRATAMIENTO_DATOS_PERSONALES_CONTENIDO'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'POLITICAS_TRATAMIENTO_DATOS_PERSONALES_CONTENIDO', '', 'Usted al presentar un reclamo a través de la plataforma virtual de reclamos “Alóbanco” (en adelante, la plataforma) autoriza y otorga a la Asociación de Bancos del Perú (en adelante, ASBANC), en su condición de administrador tecnológico de la plataforma, su consentimiento libre, previo, expreso, inequívoco e informado para que recopile, registre, organice, almacene, conserve, elabore, bloquee, suprima, extraiga, consulte, utilice, transfiera, exporte, importe o procese (trate) de cualquier otra forma sus datos personales, conforme a Ley, pudiendo elaborar Bases de Datos (Bancos de Datos) con la finalidad de:

• Registrar reclamos vinculados a los productos y servicios bancarios y financieros que el reclamante de la plataforma haya contratado con la empresa financiera reclamada;
• Enviar a la empresa financiera reclamada el reclamo ingresado a través de la plataforma virtual para su respectiva atención, autorizando para ello, la transferencia de sus datos personales;
• Recibir, en la dirección electrónica que el reclamante indique en la plataforma, la respuesta que la empresa financiera reclamada emita sobre el reclamo virtual presentado;
• Invitar a los titulares de datos personales a participar de los estudios y encuestas de satisfacción y calidad del servicio;
• Invitar a los titulares de datos personales a participar en los cursos de educación financiera y capacitaciones (webinars, etc.) que realice ASBANC;
• Difundir los servicios que ASBANC brinde a los usuarios, y, 
• Almacenar y tratar sus datos personales con fines estadísticos y/o históricos.

La autorización que otorga el reclamante es por tiempo indefinido y estará vigente inclusive después de concluido el reclamo. ASBANC podrá dar tratamiento a los datos personales del reclamante de manera directa y a su vez brindará el soporte técnico y tecnológico a la plataforma la cual utiliza el servicio de hosting a través de infraestructura tecnológica contratada cuya ubicación se encuentra dentro del territorio de la República del Perú. Para ello, ASBANC garantiza que la infraestructura tecnológica cuenta con los estándares de protección legal de datos que a su vez garantizan un nivel suficiente de protección de los datos personales que se vayan a tratar, o por lo menos, equiparable a lo previsto por la Ley 29733 y su reglamento.

El reclamante declara haber sido informado que en caso de no otorgar este consentimiento, no podrá ingresar, ni registrar su reclamo a través de la plataforma. 

El reclamante podrá ejercer su derecho de revocar en cualquier momento su consentimiento, comunicando su decisión por escrito a ASBANC dirigido a la Gerencia de Relaciones con el Consumidor, en su domicilio ubicado en Av. San Borja Norte N° 523, distrito de San Borja, provincia y departamento de Lima, provincia y departamento de Lima, Perú o al correo electrónico alobanco@asbanc.com.pe. 

Asimismo, el reclamante declara que podrá ejercer sus derechos de información, acceso, rectificación, cancelación y oposición de acuerdo a lo dispuesto por la Ley de Protección de Datos Personales vigente y su Reglamento. ASBANC es titular y responsable de las Bases de Datos (Bancos de Datos) originadas por el tratamiento de los datos personales que recopile y/o trate y declara que ha adoptado los niveles de seguridad apropiados para el resguardo de la información, de acuerdo a Ley. 

Asimismo, declara que respeta los principios de legalidad, consentimiento, finalidad, proporcionalidad, calidad, disposición de recurso, nivel de protección adecuado, conforme a las disposiciones de la Ley de Protección de Datos vigente en Perú.', 'Contenido de Políticas y Privacidad', 1, 0, 'SEED')

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TAMANIO_MAXIMO_ARCHIVO'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'TAMANIO_MAXIMO_ARCHIVO', '', '25', 'El tamaño máximo en MB permitido por archivo ', 1, 0, 'SEED')

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TERMINOS_CONDICIONES_CONTENIDO'
INSERT INTO Parametrica (IdGrupoParametrica, Alias, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'TERMINOS_CONDICIONES_CONTENIDO', '', 'Usted al presentar un reclamo a través de la plataforma virtual de Alóbanco, declara haber leído y acepta las siguientes condiciones necesarias para la tramitación de su reclamo:
• Autoriza que la entidad financiera envíe la respuesta de su reclamo a su dirección de correo electrónico conforme a la políticas internas de su entidad financiera.
• Se dejarán sin efecto los reclamos presentados contra entidades que no forman parte del servicio de Alóbanco, si no cuenta con detalle de lo reclamado, si el detalle no es comprensible para poder continuar con el trámite y/o si sus datos de contacto se registraron de manera errónea en el formulario. 
• Tu reclamo será atendido en un plazo de 7 días hábiles, salvo que éste sea complejo, por lo cual, el plazo podría extenderse hasta el plazo legal, previa comunicación contigo. ', 'Contenido de los Términos y Condiciones', 1, 0, 'SEED')


-- ====================== GENERAL =================================
-- TIPO MONTO
SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TIPO_MONTO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Sol', 'S/', 'Sol peruano', 1, 0, 'SEED'),
(@IdGrupo, 'Dólar', '$', 'Dólar estadounidense', 2, 0, 'SEED'),
(@IdGrupo, 'Euro', '€', 'Euro', 3, 0, 'SEED')

-- TIPO DOCUMENTO

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TIPO_DOCUMENTO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Descripcion, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Documento Nacional de Identidad', 'DNI', 'Documento nacional de identidad', 1, 0, 'SEED'),
(@IdGrupo, 'Carnet Extranjería', 'CE', 'Carnet de extranjería', 2, 0, 'SEED'),
(@IdGrupo, 'Pasaporte', 'PASAPORTE', 'Pasaporte', 3, 0, 'SEED')

-- TIPO TELÉFONO CELULAR POR PAÍS

SELECT @IdGrupo = IdGrupoParametrica FROM GrupoParametrica WHERE Codigo = 'ALO_TIPO_TELEFONO'

INSERT INTO Parametrica (IdGrupoParametrica, Nombre, Valor, Orden, EsEliminable, CreadoPor) VALUES
(@IdGrupo, 'Afganistán', '+93', 1, 0, 'SEED'),
(@IdGrupo, 'Albania', '+355', 2, 0, 'SEED'),
(@IdGrupo, 'Alemania', '+49', 3, 0, 'SEED'),
(@IdGrupo, 'Andorra', '+376', 4, 0, 'SEED'),
(@IdGrupo, 'Angola', '+244', 5, 0, 'SEED'),
(@IdGrupo, 'Antigua y Barbuda', '+1-268', 6, 0, 'SEED'),
(@IdGrupo, 'Arabia Saudita', '+966', 7, 0, 'SEED'),
(@IdGrupo, 'Argelia', '+213', 8, 0, 'SEED'),
(@IdGrupo, 'Argentina', '+54', 9, 0, 'SEED'),
(@IdGrupo, 'Armenia', '+374', 10, 0, 'SEED'),
(@IdGrupo, 'Australia', '+61', 11, 0, 'SEED'),
(@IdGrupo, 'Austria', '+43', 12, 0, 'SEED'),
(@IdGrupo, 'Azerbaiyán', '+994', 13, 0, 'SEED'),
(@IdGrupo, 'Bahamas', '+1-242', 14, 0, 'SEED'),
(@IdGrupo, 'Bangladés', '+880', 15, 0, 'SEED'),
(@IdGrupo, 'Barbados', '+1-246', 16, 0, 'SEED'),
(@IdGrupo, 'Baréin', '+973', 17, 0, 'SEED'),
(@IdGrupo, 'Bélgica', '+32', 18, 0, 'SEED'),
(@IdGrupo, 'Belice', '+501', 19, 0, 'SEED'),
(@IdGrupo, 'Benín', '+229', 20, 0, 'SEED'),
(@IdGrupo, 'Bielorrusia', '+375', 21, 0, 'SEED'),
(@IdGrupo, 'Bolivia', '+591', 22, 0, 'SEED'),
(@IdGrupo, 'Bosnia y Herzegovina', '+387', 23, 0, 'SEED'),
(@IdGrupo, 'Botsuana', '+267', 24, 0, 'SEED'),
(@IdGrupo, 'Brasil', '+55', 25, 0, 'SEED'),
(@IdGrupo, 'Brunéi', '+673', 26, 0, 'SEED'),
(@IdGrupo, 'Bulgaria', '+359', 27, 0, 'SEED'),
(@IdGrupo, 'Burkina Faso', '+226', 28, 0, 'SEED'),
(@IdGrupo, 'Burundi', '+257', 29, 0, 'SEED'),
(@IdGrupo, 'Bután', '+975', 30, 0, 'SEED'),
(@IdGrupo, 'Cabo Verde', '+238', 31, 0, 'SEED'),
(@IdGrupo, 'Camboya', '+855', 32, 0, 'SEED'),
(@IdGrupo, 'Camerún', '+237', 33, 0, 'SEED'),
(@IdGrupo, 'Canadá', '+1', 34, 0, 'SEED'),
(@IdGrupo, 'Catar', '+974', 35, 0, 'SEED'),
(@IdGrupo, 'Chad', '+235', 36, 0, 'SEED'),
(@IdGrupo, 'Chile', '+56', 37, 0, 'SEED'),
(@IdGrupo, 'China', '+86', 38, 0, 'SEED'),
(@IdGrupo, 'Chipre', '+357', 39, 0, 'SEED'),
(@IdGrupo, 'Colombia', '+57', 40, 0, 'SEED'),
(@IdGrupo, 'Comoras', '+269', 41, 0, 'SEED'),
(@IdGrupo, 'Corea del Norte', '+850', 42, 0, 'SEED'),
(@IdGrupo, 'Corea del Sur', '+82', 43, 0, 'SEED'),
(@IdGrupo, 'Costa de Marfil', '+225', 44, 0, 'SEED'),
(@IdGrupo, 'Costa Rica', '+506', 45, 0, 'SEED'),
(@IdGrupo, 'Croacia', '+385', 46, 0, 'SEED'),
(@IdGrupo, 'Cuba', '+53', 47, 0, 'SEED'),
(@IdGrupo, 'Dinamarca', '+45', 48, 0, 'SEED'),
(@IdGrupo, 'Dominica', '+1-767', 49, 0, 'SEED'),
(@IdGrupo, 'Ecuador', '+593', 50, 0, 'SEED'),
(@IdGrupo, 'Egipto', '+20', 51, 0, 'SEED'),
(@IdGrupo, 'El Salvador', '+503', 52, 0, 'SEED'),
(@IdGrupo, 'Emiratos Árabes Unidos', '+971', 53, 0, 'SEED'),
(@IdGrupo, 'Eritrea', '+291', 54, 0, 'SEED'),
(@IdGrupo, 'Eslovaquia', '+421', 55, 0, 'SEED'),
(@IdGrupo, 'Eslovenia', '+386', 56, 0, 'SEED'),
(@IdGrupo, 'España', '+34', 57, 0, 'SEED'),
(@IdGrupo, 'Estados Unidos', '+1', 58, 0, 'SEED'),
(@IdGrupo, 'Estonia', '+372', 59, 0, 'SEED'),
(@IdGrupo, 'Etiopía', '+251', 60, 0, 'SEED'),
(@IdGrupo, 'Filipinas', '+63', 61, 0, 'SEED'),
(@IdGrupo, 'Finlandia', '+358', 62, 0, 'SEED'),
(@IdGrupo, 'Fiyi', '+679', 63, 0, 'SEED'),
(@IdGrupo, 'Francia', '+33', 64, 0, 'SEED'),
(@IdGrupo, 'Gabón', '+241', 65, 0, 'SEED'),
(@IdGrupo, 'Gambia', '+220', 66, 0, 'SEED'),
(@IdGrupo, 'Georgia', '+995', 67, 0, 'SEED'),
(@IdGrupo, 'Ghana', '+233', 68, 0, 'SEED'),
(@IdGrupo, 'Granada', '+1-473', 69, 0, 'SEED'),
(@IdGrupo, 'Grecia', '+30', 70, 0, 'SEED'),
(@IdGrupo, 'Guatemala', '+502', 71, 0, 'SEED'),
(@IdGrupo, 'Guyana', '+592', 72, 0, 'SEED'),
(@IdGrupo, 'Guinea', '+224', 73, 0, 'SEED'),
(@IdGrupo, 'Guinea-Bisáu', '+245', 74, 0, 'SEED'),
(@IdGrupo, 'Guinea Ecuatorial', '+240', 75, 0, 'SEED'),
(@IdGrupo, 'Haití', '+509', 76, 0, 'SEED'),
(@IdGrupo, 'Honduras', '+504', 77, 0, 'SEED'),
(@IdGrupo, 'Hungría', '+36', 78, 0, 'SEED'),
(@IdGrupo, 'India', '+91', 79, 0, 'SEED'),
(@IdGrupo, 'Indonesia', '+62', 80, 0, 'SEED'),
(@IdGrupo, 'Irak', '+964', 81, 0, 'SEED'),
(@IdGrupo, 'Irán', '+98', 82, 0, 'SEED'),
(@IdGrupo, 'Irlanda', '+353', 83, 0, 'SEED'),
(@IdGrupo, 'Islandia', '+354', 84, 0, 'SEED'),
(@IdGrupo, 'Islas Marshall', '+692', 85, 0, 'SEED'),
(@IdGrupo, 'Islas Salomón', '+677', 86, 0, 'SEED'),
(@IdGrupo, 'Israel', '+972', 87, 0, 'SEED'),
(@IdGrupo, 'Italia', '+39', 88, 0, 'SEED'),
(@IdGrupo, 'Jamaica', '+1-876', 89, 0, 'SEED'),
(@IdGrupo, 'Japón', '+81', 90, 0, 'SEED'),
(@IdGrupo, 'Jordania', '+962', 91, 0, 'SEED'),
(@IdGrupo, 'Kazajistán', '+7', 92, 0, 'SEED'),
(@IdGrupo, 'Kenia', '+254', 93, 0, 'SEED'),
(@IdGrupo, 'Kirguistán', '+996', 94, 0, 'SEED'),
(@IdGrupo, 'Kiribati', '+686', 95, 0, 'SEED'),
(@IdGrupo, 'Kuwait', '+965', 96, 0, 'SEED'),
(@IdGrupo, 'Laos', '+856', 97, 0, 'SEED'),
(@IdGrupo, 'Lesoto', '+266', 98, 0, 'SEED'),
(@IdGrupo, 'Letonia', '+371', 99, 0, 'SEED'),
(@IdGrupo, 'Líbano', '+961', 100, 0, 'SEED'),
(@IdGrupo, 'Liberia', '+231', 101, 0, 'SEED'),
(@IdGrupo, 'Libia', '+218', 102, 0, 'SEED'),
(@IdGrupo, 'Liechtenstein', '+423', 103, 0, 'SEED'),
(@IdGrupo, 'Lituania', '+370', 104, 0, 'SEED'),
(@IdGrupo, 'Luxemburgo', '+352', 105, 0, 'SEED'),
(@IdGrupo, 'Macedonia del Norte', '+389', 106, 0, 'SEED'),
(@IdGrupo, 'Madagascar', '+261', 107, 0, 'SEED'),
(@IdGrupo, 'Malasia', '+60', 108, 0, 'SEED'),
(@IdGrupo, 'Malaui', '+265', 109, 0, 'SEED'),
(@IdGrupo, 'Maldivas', '+960', 110, 0, 'SEED'),
(@IdGrupo, 'Malí', '+223', 111, 0, 'SEED'),
(@IdGrupo, 'Malta', '+356', 112, 0, 'SEED'),
(@IdGrupo, 'Marruecos', '+212', 113, 0, 'SEED'),
(@IdGrupo, 'Mauricio', '+230', 114, 0, 'SEED'),
(@IdGrupo, 'Mauritania', '+222', 115, 0, 'SEED'),
(@IdGrupo, 'México', '+52', 116, 0, 'SEED'),
(@IdGrupo, 'Micronesia', '+691', 117, 0, 'SEED'),
(@IdGrupo, 'Moldavia', '+373', 118, 0, 'SEED'),
(@IdGrupo, 'Mónaco', '+377', 119, 0, 'SEED'),
(@IdGrupo, 'Mongolia', '+976', 120, 0, 'SEED'),
(@IdGrupo, 'Montenegro', '+382', 121, 0, 'SEED'),
(@IdGrupo, 'Mozambique', '+258', 122, 0, 'SEED'),
(@IdGrupo, 'Namibia', '+264', 123, 0, 'SEED'),
(@IdGrupo, 'Nauru', '+674', 124, 0, 'SEED'),
(@IdGrupo, 'Nepal', '+977', 125, 0, 'SEED'),
(@IdGrupo, 'Nicaragua', '+505', 126, 0, 'SEED'),
(@IdGrupo, 'Níger', '+227', 127, 0, 'SEED'),
(@IdGrupo, 'Nigeria', '+234', 128, 0, 'SEED'),
(@IdGrupo, 'Noruega', '+47', 129, 0, 'SEED'),
(@IdGrupo, 'Nueva Zelanda', '+64', 130, 0, 'SEED'),
(@IdGrupo, 'Omán', '+968', 131, 0, 'SEED'),
(@IdGrupo, 'Países Bajos', '+31', 132, 0, 'SEED'),
(@IdGrupo, 'Pakistán', '+92', 133, 0, 'SEED'),
(@IdGrupo, 'Palaos', '+680', 134, 0, 'SEED'),
(@IdGrupo, 'Panamá', '+507', 135, 0, 'SEED'),
(@IdGrupo, 'Papúa Nueva Guinea', '+675', 136, 0, 'SEED'),
(@IdGrupo, 'Paraguay', '+595', 137, 0, 'SEED'),
(@IdGrupo, 'Perú', '+51', 138, 0, 'SEED'),
(@IdGrupo, 'Polonia', '+48', 139, 0, 'SEED'),
(@IdGrupo, 'Portugal', '+351', 140, 0, 'SEED'),
(@IdGrupo, 'Reino Unido', '+44', 141, 0, 'SEED'),
(@IdGrupo, 'República Centroafricana', '+236', 142, 0, 'SEED'),
(@IdGrupo, 'República Checa', '+420', 143, 0, 'SEED'),
(@IdGrupo, 'República del Congo', '+242', 144, 0, 'SEED'),
(@IdGrupo, 'República Democrática del Congo', '+243', 145, 0, 'SEED'),
(@IdGrupo, 'República Dominicana', '+1-809', 146, 0, 'SEED'),
(@IdGrupo, 'Ruanda', '+250', 147, 0, 'SEED'),
(@IdGrupo, 'Rumania', '+40', 148, 0, 'SEED'),
(@IdGrupo, 'Rusia', '+7', 149, 0, 'SEED'),
(@IdGrupo, 'Samoa', '+685', 150, 0, 'SEED'),
(@IdGrupo, 'San Cristóbal y Nieves', '+1-869', 151, 0, 'SEED'),
(@IdGrupo, 'San Marino', '+378', 152, 0, 'SEED'),
(@IdGrupo, 'San Vicente y las Granadinas', '+1-784', 153, 0, 'SEED'),
(@IdGrupo, 'Santa Lucía', '+1-758', 154, 0, 'SEED'),
(@IdGrupo, 'Santo Tomé y Príncipe', '+239', 155, 0, 'SEED'),
(@IdGrupo, 'Senegal', '+221', 156, 0, 'SEED'),
(@IdGrupo, 'Serbia', '+381', 157, 0, 'SEED'),
(@IdGrupo, 'Seychelles', '+248', 158, 0, 'SEED'),
(@IdGrupo, 'Sierra Leona', '+232', 159, 0, 'SEED'),
(@IdGrupo, 'Singapur', '+65', 160, 0, 'SEED'),
(@IdGrupo, 'Siria', '+963', 161, 0, 'SEED'),
(@IdGrupo, 'Somalia', '+252', 162, 0, 'SEED'),
(@IdGrupo, 'Sri Lanka', '+94', 163, 0, 'SEED'),
(@IdGrupo, 'Sudáfrica', '+27', 164, 0, 'SEED'),
(@IdGrupo, 'Sudán', '+249', 165, 0, 'SEED'),
(@IdGrupo, 'Sudán del Sur', '+211', 166, 0, 'SEED'),
(@IdGrupo, 'Suecia', '+46', 167, 0, 'SEED'),
(@IdGrupo, 'Suiza', '+41', 168, 0, 'SEED'),
(@IdGrupo, 'Surinam', '+597', 169, 0, 'SEED'),
(@IdGrupo, 'Tailandia', '+66', 170, 0, 'SEED'),
(@IdGrupo, 'Taiwán', '+886', 171, 0, 'SEED'),
(@IdGrupo, 'Tanzania', '+255', 172, 0, 'SEED'),
(@IdGrupo, 'Tayikistán', '+992', 173, 0, 'SEED'),
(@IdGrupo, 'Timor Oriental', '+670', 174, 0, 'SEED'),
(@IdGrupo, 'Togo', '+228', 175, 0, 'SEED'),
(@IdGrupo, 'Tonga', '+676', 176, 0, 'SEED'),
(@IdGrupo, 'Trinidad y Tobago', '+1-868', 177, 0, 'SEED'),
(@IdGrupo, 'Túnez', '+216', 178, 0, 'SEED'),
(@IdGrupo, 'Turkmenistán', '+993', 179, 0, 'SEED'),
(@IdGrupo, 'Turquía', '+90', 180, 0, 'SEED'),
(@IdGrupo, 'Tuvalu', '+688', 181, 0, 'SEED'),
(@IdGrupo, 'Ucrania', '+380', 182, 0, 'SEED'),
(@IdGrupo, 'Uganda', '+256', 183, 0, 'SEED'),
(@IdGrupo, 'Uruguay', '+598', 184, 0, 'SEED'),
(@IdGrupo, 'Uzbekistán', '+998', 185, 0, 'SEED'),
(@IdGrupo, 'Vanuatu', '+678', 186, 0, 'SEED'),
(@IdGrupo, 'Vaticano', '+39-06', 187, 0, 'SEED'),
(@IdGrupo, 'Venezuela', '+58', 188, 0, 'SEED'),
(@IdGrupo, 'Vietnam', '+84', 189, 0, 'SEED'),
(@IdGrupo, 'Yemen', '+967', 190, 0, 'SEED'),
(@IdGrupo, 'Yibuti', '+253', 191, 0, 'SEED'),
(@IdGrupo, 'Zambia', '+260', 192, 0, 'SEED'),
(@IdGrupo, 'Zimbabue', '+263', 193, 0, 'SEED');