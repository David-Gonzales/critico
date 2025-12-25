SELECT 
    ISNULL(M2.IdMenu, M1.IdMenu) AS IdMenu,
    M1.Codigo AS CodigoModulo,
    M1.Nombre AS NombreModulo,
    ISNULL(M2.Codigo, 'NULL') AS CodigoSubmodulo,
    ISNULL(M2.Nombre, 'NULL') AS NombreSubmodulo,
    ISNULL(M2.URL, M1.URL) AS Ruta
FROM Menu M1
LEFT JOIN Menu M2 ON M1.IdMenu = M2.IdMenuPadre
WHERE M1.IdMenuPadre IS NULL
ORDER BY M1.Orden, M2.Orden