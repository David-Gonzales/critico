USE DB_ASBANC_DEV
GO

DECLARE @Usuario NVARCHAR(50) = 'SYSTEM'
DECLARE @FechaCreacion DATETIME = GETDATE()
DECLARE @IdPadre INT
DECLARE @IdEmpresaAlo INT, @IdEmpresaDcf INT;

SELECT @IdEmpresaAlo = IdEmpresa FROM Empresa WHERE Codigo = 'ALOBANCO';
SELECT @IdEmpresaDcf = IdEmpresa FROM Empresa WHERE Codigo = 'DCF';


--MENUS DE ALOBANCO (Administración, Gestión de reclamos, Consulta de reclamos, Reporte de reclamos, CMS)

IF @IdEmpresaAlo IS NOT NULL
BEGIN
	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'ALO_ADMIN', 'Administración', '', NULL, 100, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)
	
		SET @IdPadre = SCOPE_IDENTITY();
				
					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_PERMISO', 'Permiso', '', '/alobanco/administracion/permiso', 101, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)
				
					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_PERFIL', 'Perfil', '', '/alobanco/administracion/perfil', 102, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_USUARIO', 'Usuario', '', '/alobanco/administracion/usuario', 103, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_ENTIDADES', 'Entidades Financieras', '', '/alobanco/administracion/entidades-financieras', 104, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_PARAMETRICAS', 'Paramétricas', '', '/alobanco/administracion/parametricas', 105, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_NOTIFICACIONES', 'Notificaciones', '', '/alobanco/administracion/notificaciones', 106, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_NOTICIAS', 'Noticias', '', '/alobanco/administracion/noticias', 107, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_SEO', 'SEO', '', '/alobanco/administracion/seo', 108, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_PARAMETROS', 'Parámetros', '', '/alobanco/administracion/parametros', 109, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_ADMIN_BANNER', 'Banner', '', '/alobanco/administracion/banner', 110, @IdEmpresaAlo, 1, @FechaCreacion, @Usuario, 1, 0)


	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'ALO_GESTION_RECLAMOS', 'Gestión de Reclamos', '', '/alobanco/gestion-reclamos', 200, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'ALO_CONSULTA_RECLAMOS', 'Consulta de Reclamos', '', '/alobanco/consulta-reclamos', 300, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'ALO_REPORTE_RECLAMOS', 'Reporte Reclamos', '', '/alobanco/reporte-reclamos', 400, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'ALO_CMS', 'CMS', '', NULL, 500, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

		SET @IdPadre = SCOPE_IDENTITY();

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_PREGUNTAS', 'Preguntas Frecuentes', '', '/alobanco/cms/preguntas-frecuentes', 501, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)
				
					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_ACERCA', 'Acerca de', '', '/alobanco/cms/acerca-de', 502, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_BLOG_ENTRADAS', 'Blog – Entradas', '', '/alobanco/cms/blog-entradas', 503, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_BLOG_CATEG', 'Blog – Categorías', '', '/alobanco/cms/blog-categorias', 504, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_BLOG_PAG', 'Blog – Página', '', '/alobanco/cms/blog-pagina', 505, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_FORMULARIO', 'Formulario Reclamos', '', '/alobanco/cms/formulario-reclamos', 506, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_CABECERA_PIE', 'Cabecera / Pie de Página', '', '/alobanco/cms/cabecera-pie', 507, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_PAG_INICIO', 'Página de Inicio', '', '/alobanco/cms/pagina-inicio', 508, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_TESTIMONIOS', 'Testimonios', '', '/alobanco/cms/testimonios', 509, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'ALO_CMS_VIDEO_TESTIMONIOS', 'Video Testimonios', '', '/alobanco/cms/video-testimonios', 510, @IdEmpresaAlo, 0, @FechaCreacion, @Usuario, 1, 0)

END



--MENUS DE DCF (Seguridad, Gestión de Consultas, Gestión de Reclamos)

IF @IdEmpresaDcf IS NOT NULL
BEGIN
	
	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'DCF_SEG', 'Seguridad', '', NULL, 600, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

		SET @IdPadre = SCOPE_IDENTITY();

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_PERMISO', 'Permiso', '', '/dcf/seguridad/permiso', 601, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_PERFIL', 'Perfil', '', '/dcf/seguridad/perfil', 602, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_USUARIO', 'Usuario', '', '/dcf/seguridad/usuario', 603, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_NOTIFICACIONES', 'Notificaciones', '', '/dcf/seguridad/notificaciones', 604, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_PARAMETROS', 'Parámetros', '', '/dcf/seguridad/parametros', 605, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_CATALOGO', 'Catálogo', '', '/dcf/seguridad/catalogo', 606, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_ELEMENTO_CATALOGO', 'Elemento Catálogo', '', '/dcf/seguridad/elemento-catalogo', 607, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_SEG_ENTIDAD', 'Entidad Financiera', '', '/dcf/seguridad/entidad-financiera', 608, @IdEmpresaDcf, 1, @FechaCreacion, @Usuario, 1, 0)


	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'DCF_CONSULTAS', 'Gestión de Consultas', '', NULL, 700, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

		SET @IdPadre = SCOPE_IDENTITY();

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_CONSULTAS_BANDEJA', 'Bandeja de Consultas', '', '/dcf/gestion-consultas/bandeja', 701, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_CONSULTAS_REPORTES', 'Reportes de Consultas', '', '/dcf/gestion-consultas/reportes', 702, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)


	INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
	VALUES (NULL, 'DCF_RECLAMOS', 'Gestión de Reclamos', '', NULL, 800, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

		SET @IdPadre = SCOPE_IDENTITY();

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_RECLAMOS_BANDEJA', 'Bandeja de Reclamos', '', '/dcf/gestion-reclamos/bandeja', 801, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_RECLAMOS_REGISTRO', 'Registro de Reclamos', '', '/dcf/gestion-reclamos/registro', 802, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_RECLAMOS_REPORTES', 'Reportes de Reclamos', '', '/dcf/gestion-reclamos/reportes', 803, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_RECLAMOS_APROBADOS_FIRMA', 'Aprobados para Firma', '', '/dcf/gestion-reclamos/aprobados-firma', 804, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_RECLAMOS_CAUSA_RAIZ', 'Reporte Causa Raíz', '', '/dcf/gestion-reclamos/causa-raiz', 805, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

					INSERT INTO Menu (IdMenuPadre, Codigo, Nombre, Icono, URL, Orden, IdEmpresa, SoloAdmin, FechaCreacion, CreadoPor, Activo, Eliminado)
					VALUES (@IdPadre, 'DCF_RECLAMOS_PENDIENTES', 'Reclamos Pendientes', '', '/dcf/gestion-reclamos/pendientes', 806, @IdEmpresaDcf, 0, @FechaCreacion, @Usuario, 1, 0)

END
GO