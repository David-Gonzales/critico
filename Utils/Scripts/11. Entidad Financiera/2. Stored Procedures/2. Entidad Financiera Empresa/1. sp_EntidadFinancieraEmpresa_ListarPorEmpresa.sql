USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraEmpresa_ListarPorEmpresa
    @IdEmpresa INT,
    @SoloActivos BIT = 1,
    @SoloVisibles BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        -- Datos de la asignación
        efe.IdEntidadFinancieraEmpresa,
        efe.IdEntidadFinanciera,
        efe.IdEmpresa,
        
        -- Datos de la entidad maestra
        ef.Codigo,
        ef.Nombre,
        ef.RUC,
        ef.RazonSocial,
        ef.SitioWeb,
        ef.Direccion,
        ef.Descripcion,
        
        -- Configuración específica de la empresa
        efe.EmailNotificacion,
        efe.Telefono,
        efe.CanalAtencion,
        efe.LogoUrl,
        efe.LogoDarkUrl,
        
        efe.Visible,
        efe.Activo,
        
        efe.FechaCreacion,
        efe.CreadoPor,
        efe.FechaEdicion,
        efe.EditadoPor
        
    FROM 
		EntidadFinancieraEmpresa efe
    INNER JOIN EntidadFinanciera ef ON efe.IdEntidadFinanciera = ef.IdEntidadFinanciera
    WHERE 
		efe.IdEmpresa = @IdEmpresa AND
		efe.Eliminado = 0 AND
		ef.Eliminado = 0 AND
		(@SoloActivos = 0 OR efe.Activo = 1) AND
		(@SoloVisibles = 0 OR efe.Visible = 1)
    ORDER BY ef.Nombre
END
GO