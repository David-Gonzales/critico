SELECT 
    CASE 
        WHEN IdEmpresa IS NULL THEN 'GLOBALES'
        WHEN IdEmpresa = (SELECT IdEmpresa FROM Empresa WHERE Codigo = 'DCF') THEN 'DCF'
        WHEN IdEmpresa = (SELECT IdEmpresa FROM Empresa WHERE Codigo = 'ALOBANCO') THEN 'ALOBANCO'
    END AS TipoPermiso,
    COUNT(*) AS TotalPermisos
FROM Permiso
WHERE Eliminado = 0
GROUP BY IdEmpresa
ORDER BY TipoPermiso