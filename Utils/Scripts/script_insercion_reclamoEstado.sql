USE DB_ASBANC_DEV
GO

DECLARE @Usuario NVARCHAR(50) = 'SYSTEM'
DECLARE @FechaCreacion DATETIME = GETDATE()

-- ESTADOS DE ALOBANCO
INSERT INTO ReclamoEstado (Codigo, Nombre, Descripcion, Orden, Color, EsEstadoFinal, EsEliminable, EsEstadoSistema, IdEmpresa, FechaCreacion, CreadoPor) VALUES
	('ALO_EN_PROCESO', 'En Proceso', 'Reclamo en proceso de atención', 1, 'azul', 0, 0, 1, 1, @FechaCreacion, @Usuario),
	('ALO_TERMINADO', 'Terminado', 'Reclamo finalizado', 2, 'verde', 1, 0, 0, 1, @FechaCreacion, @Usuario),
	('ALO_INADMISIBLE', 'Inadmisible', 'Reclamo no cumple requisitos', 3, 'rojo', 1, 0, 1, 1, @FechaCreacion, @Usuario)

-- ESTADOS DE DCF
INSERT INTO ReclamoEstado (Codigo, Nombre, Descripcion, Orden, Color, EsEstadoFinal, EsEliminable, EsEstadoSistema, IdEmpresa, FechaCreacion, CreadoPor) VALUES
	('DCF_REGISTRADO', 'Registrado', 'Reclamo recién ingresado', 1, 'gris', 0, 0, 1, 2, @FechaCreacion, @Usuario),
	('DCF_ADMITIDO', 'Reclamo Admitido', 'Reclamo admitido para tramitar', 2, 'verde', 0, 0, 1, 2, @FechaCreacion, @Usuario),
	('DCF_DENEGADO', 'Solicitud Denegada', 'Reclamo no admitido', 3, 'rojo', 1, 0, 1, 2, @FechaCreacion, @Usuario),
	('DCF_ASIGNADO', 'Reclamo Asignado', 'Reclamo asignado a analista', 4, 'azul', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_ENVIADO_BANCO', 'Reclamo Enviado al Banco', 'Notificado a entidad financiera', 5, 'amarillo', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_CONCILIACION_PROPUESTA', 'Conciliación Propuesta', 'Propuesta de conciliación enviada', 6, 'naranja', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_CONCILIACION_ACEPTADA', 'Conciliación Aceptada', 'Conciliación aceptada por ambas partes', 7, 'verde', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_CONCILIACION_RECHAZADA', 'Conciliación Rechazada', 'Conciliación rechazada', 8, 'rojo', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_DESCARGOS_PRESENTADOS', 'Descargos Presentados', 'Banco presentó descargos', 9, 'azul', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_RESOLUCION_EMITIDA', 'Resolución Emitida', 'Resolución final emitida', 10, 'verde', 1, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_SUBSANACION_PENDIENTE', 'Subsanación Pendiente', 'Esperando documentos adicionales', 11, 'naranja', 0, 0, 1, 2, @FechaCreacion, @Usuario),
	('DCF_SUBSANACION_REVISION', 'Subsanación en Revisión', 'Revisando documentos subsanados', 12, 'amarillo', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_CONCILIACION_ACTA_PENDIENTE', 'Conciliación con Acta Pendiente', 'Pendiente firma de acta de conciliación', 13, 'naranja', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_CONCILIACION_INFORMADA', 'Conciliación Informada al Cliente', 'Cliente notificado de conciliación', 14, 'azul', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_CONCILIACION_ACTA_FIRMADA', 'Conciliación con Acta Firmada', 'Acta de conciliación firmada', 15, 'verde', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_INFORME_FINANCIERO_PENDIENTE', 'Informe Financiero Pendiente', 'Pendiente informe financiero', 16, 'naranja', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_INFORME_FINANCIERO_COMPLETADO', 'Informe Financiero Completado', 'Informe financiero completado', 17, 'azul', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_PROYECTO_PENDIENTE_APROBACION', 'Proyecto Pendiente de Aprobación', 'Proyecto de resolución pendiente de aprobación', 18, 'amarillo', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_HOJA_ANALISIS_PENDIENTE', 'Hoja de Análisis Pendiente', 'Pendiente hoja de análisis', 19, 'naranja', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_APROBADO_FIRMA', 'Aprobado para Firma', 'Documento aprobado para firma', 20, 'verde', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_PROYECTO_RESOLUCION_APROBADO', 'Proyecto de Resolución Aprobado', 'Proyecto de resolución aprobado', 21, 'verde', 0, 0, 0, 2, @FechaCreacion, @Usuario),
	('DCF_HOJA_ANALISIS_APROBADO', 'Hoja de Análisis Aprobado', 'Hoja de análisis aprobada', 22, 'verde', 0, 0, 0, 2, @FechaCreacion, @Usuario)
GO
