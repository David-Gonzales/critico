USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Parametrica_ObtenerPorId
    @IdParametrica INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
		p.IdParametrica,
        p.IdGrupoParametrica,
        gp.Codigo AS CodigoGrupo,
        gp.Nombre AS NombreGrupo,
        gp.TipoGrupo,
        p.Alias,
        p.Nombre,
        p.Valor,
        p.Descripcion,
        p.Orden,
        p.EsEliminable,
        p.EnUso,
        p.FechaCreacion,
        p.CreadoPor,
        p.FechaEdicion,
        p.EditadoPor,
        p.Activo
    FROM 
		Parametrica p
		INNER JOIN GrupoParametrica gp ON p.IdGrupoParametrica = gp.IdGrupoParametrica
    WHERE 
		p.IdParametrica = @IdParametrica AND 
		p.Eliminado = 0
END
GO