USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Parametrica_Listar
    @IdGrupoParametrica INT = NULL,
	@Nombre VARCHAR(500) NULL,
    @Dominio NVARCHAR(100) = NULL,
	@IdEmpresa INT = NULL,
	@Estado BIT = NULL,
    @SoloActivos BIT = 1

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
		p.IdParametrica,
        p.IdGrupoParametrica,
        gp.Codigo AS CodigoGrupo,
        gp.Nombre AS NombreGrupo,
        gp.TipoGrupo,
		gp.IdEmpresa,
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
		p.Eliminado = 0 AND 
		gp.Eliminado = 0 AND 
		(
            (@Estado IS NOT NULL AND p.Activo = @Estado) -- Si se manda @Estado aplico este filtro
            OR 
            (@Estado IS NULL AND (@SoloActivos = 0 OR p.Activo = 1)) -- Si no, uso la lógica anterior
        ) AND
		(@IdGrupoParametrica IS NULL OR p.IdGrupoParametrica = @IdGrupoParametrica) AND 
		(@Dominio IS NULL OR gp.Codigo = @Dominio) AND
		(@Nombre IS NULL OR p.Nombre LIKE '%' + @Nombre + '%') AND
		(@IdEmpresa IS NULL OR gp.IdEmpresa = @IdEmpresa OR gp.IdEmpresa IS NULL)
	ORDER BY 
		gp.Nombre, p.Orden, p.Nombre
END
GO