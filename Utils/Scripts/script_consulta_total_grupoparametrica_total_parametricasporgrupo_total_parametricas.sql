USE DB_ASBANC_DEV
GO

-- Total de grupos
SELECT 
    TipoGrupo,
    COUNT(*) AS TotalGrupos
FROM GrupoParametrica
GROUP BY TipoGrupo
GO

-- Total de paramétricas por grupo
SELECT 
    gp.Nombre AS Grupo,
    gp.TipoGrupo,
    COUNT(p.IdParametrica) AS TotalParametricas
FROM GrupoParametrica gp
LEFT JOIN Parametrica p ON gp.IdGrupoParametrica = p.IdGrupoParametrica
GROUP BY gp.Nombre, gp.TipoGrupo
ORDER BY gp.TipoGrupo, gp.Nombre
GO

-- Ver todas las paramétricas
SELECT 
    gp.Nombre AS Grupo,
    p.Nombre,
    p.Alias,
    p.Valor,
    p.EsEliminable
FROM Parametrica p
INNER JOIN GrupoParametrica gp ON p.IdGrupoParametrica = gp.IdGrupoParametrica
ORDER BY gp.TipoGrupo, p.Orden
GO
