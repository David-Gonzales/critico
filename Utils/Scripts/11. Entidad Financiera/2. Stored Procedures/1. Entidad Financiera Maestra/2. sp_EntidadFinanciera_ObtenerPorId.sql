USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinanciera_ObtenerPorId
    @IdEntidadFinanciera INT
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
        
        -- # asignaciones
        (SELECT COUNT(*) 
         FROM 
			EntidadFinancieraEmpresa efe 
         WHERE 
			efe.IdEntidadFinanciera = ef.IdEntidadFinanciera AND 
			efe.Eliminado = 0
        ) AS NumeroEmpresasAsignadas,
        
        ef.FechaCreacion,
        ef.CreadoPor,
        ef.FechaEdicion,
        ef.EditadoPor,
        ef.Activo
        
    FROM 
		EntidadFinanciera ef
    WHERE 
		ef.IdEntidadFinanciera = @IdEntidadFinanciera AND 
		ef.Eliminado = 0
END
GO