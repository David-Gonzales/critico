USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraDominio_ListarPorEntidadEmpresa
    @IdEntidadFinancieraEmpresa INT
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT 
        d.IdEntidadFinancieraDominio,
        d.IdEntidadFinancieraEmpresa,
        d.Dominio,
        d.FechaCreacion,
        d.CreadoPor,
        d.FechaEdicion,
        d.EditadoPor,
        d.Activo
    FROM 
		EntidadFinancieraDominio d
    WHERE 
		d.IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa AND 
		d.Eliminado = 0 AND 
		d.Activo = 1
    ORDER BY d.Dominio
END
GO