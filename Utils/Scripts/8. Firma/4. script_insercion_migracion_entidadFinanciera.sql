USE DB_ASBANC_DEV
GO

INSERT INTO EntidadFinanciera (
    Codigo, 
    Nombre, 
    EmailNotificacion,
    IdEmpresa,
    FechaCreacion,
    CreadoPor,
    Activo
)
SELECT 
    CAST(CodigoEntidadFinanciera AS NVARCHAR(20)) AS Codigo,
    Nombre,
    EmailNotificacion,
    1 AS IdEmpresa, -- 1 = DCF
    FechaCreacion,
    UsuarioCreacion,
    CASE WHEN CodigoEstado = 1 THEN 1 ELSE 0 END AS Activo
FROM [ASB_DCF_WEB_DEV].[Comun].[EntidadFinanciera]
WHERE CodigoEstado != -1