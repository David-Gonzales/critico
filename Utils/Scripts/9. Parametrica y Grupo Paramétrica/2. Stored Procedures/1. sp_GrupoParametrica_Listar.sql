USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_GrupoParametrica_Listar
    @IdEmpresa INT = NULL,
    @TipoGrupo NVARCHAR(50) = NULL, -- "DOMINIO" o "APLICACION"
    @SoloActivos BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        gp.IdGrupoParametrica,
        gp.Codigo,
        gp.Nombre,
        gp.Descripcion,
        gp.TipoGrupo,
        gp.IdEmpresa,
        e.Nombre AS NombreEmpresa,
        gp.FechaCreacion,
        gp.CreadoPor,
        gp.FechaEdicion,
        gp.EditadoPor,
        gp.Activo,
        
        -- Contar paramétricas activas
        (SELECT COUNT(*) 
         FROM Parametrica p 
         WHERE p.IdGrupoParametrica = gp.IdGrupoParametrica 
           AND p.Activo = 1 
           AND p.Eliminado = 0) AS TotalParametricas
    
    FROM GrupoParametrica gp
    LEFT JOIN Empresa e ON gp.IdEmpresa = e.IdEmpresa
    WHERE gp.Eliminado = 0
      AND (@SoloActivos = 0 OR gp.Activo = 1)
      AND (@IdEmpresa IS NULL OR gp.IdEmpresa = @IdEmpresa OR gp.IdEmpresa IS NULL)
      AND (@TipoGrupo IS NULL OR gp.TipoGrupo = @TipoGrupo)
    ORDER BY gp.TipoGrupo, gp.IdEmpresa, gp.Nombre
END
GO