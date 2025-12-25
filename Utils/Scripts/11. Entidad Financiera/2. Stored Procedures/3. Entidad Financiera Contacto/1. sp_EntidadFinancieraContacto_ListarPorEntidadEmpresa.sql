USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraContacto_ListarPorEntidadEmpresa
    @IdEntidadFinancieraEmpresa INT
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT 
        c.IdEntidadFinancieraContacto,
        c.IdEntidadFinancieraEmpresa,
        c.NombreContacto,
        c.EmailContacto,
        c.FechaCreacion,
        c.CreadoPor,
        c.FechaEdicion,
        c.EditadoPor,
        c.Activo
    FROM EntidadFinancieraContacto c
    WHERE c.IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa
      AND c.Eliminado = 0
      AND c.Activo = 1
    ORDER BY c.NombreContacto
END
GO