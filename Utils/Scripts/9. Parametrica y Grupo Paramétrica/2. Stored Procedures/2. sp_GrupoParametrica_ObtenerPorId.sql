USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_GrupoParametrica_ObtenerPorId
    @IdGrupoParametrica INT
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
        gp.Activo
    FROM 
		GrupoParametrica gp
		LEFT JOIN Empresa e ON gp.IdEmpresa = e.IdEmpresa
    WHERE 
		gp.IdGrupoParametrica = @IdGrupoParametrica AND 
		gp.Eliminado = 0
END
GO