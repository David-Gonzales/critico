USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinanciera_Listar
    @SoloActivos BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ef.IdEntidadFinanciera,
        ef.Codigo,
        ef.Nombre,
        ef.RUC,
        ef.RazonSocial,
        ef.SitioWeb,
        ef.Direccion,
        ef.Descripcion,
        
        -- # empresas que tienen asignada esta entidad
        (SELECT COUNT(*) 
         FROM EntidadFinancieraEmpresa efe 
         WHERE efe.IdEntidadFinanciera = ef.IdEntidadFinanciera 
           AND efe.Eliminado = 0
        ) AS NumeroEmpresasAsignadas,
        
        ef.FechaCreacion,
        ef.CreadoPor,
        ef.FechaEdicion,
        ef.EditadoPor,
        ef.Activo
        
    FROM EntidadFinanciera ef
    WHERE ef.Eliminado = 0
      AND (@SoloActivos = 0 OR ef.Activo = 1)
    ORDER BY ef.Nombre
END
GO