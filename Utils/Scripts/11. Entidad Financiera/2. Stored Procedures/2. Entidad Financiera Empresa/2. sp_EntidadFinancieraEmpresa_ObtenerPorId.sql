USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraEmpresa_ObtenerPorId
    @IdEntidadFinancieraEmpresa INT
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
        ef.Direccion AS DireccionMaestra,
        ef.Descripcion,
        
        -- Configuración específica de la empresa
        efe.EmailNotificacion,
        efe.Telefono,
        efe.CanalAtencion,
        efe.LogoUrl,
        efe.LogoDarkUrl,
        
        efe.Visible,
        efe.Activo,
        
        -- Nombre de la empresa
        e.Nombre AS NombreEmpresa,
        
        efe.FechaCreacion,
        efe.CreadoPor,
        efe.FechaEdicion,
        efe.EditadoPor
        
    FROM 
		EntidadFinancieraEmpresa efe
    INNER JOIN EntidadFinanciera ef ON efe.IdEntidadFinanciera = ef.IdEntidadFinanciera
    INNER JOIN Empresa e ON efe.IdEmpresa = e.IdEmpresa
    WHERE 
		efe.IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa AND 
		efe.Eliminado = 0
END
GO