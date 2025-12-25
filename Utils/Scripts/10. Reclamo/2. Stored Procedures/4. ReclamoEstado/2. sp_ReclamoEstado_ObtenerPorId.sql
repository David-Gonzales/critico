USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoEstado_ObtenerPorId
	@IdReclamoEstado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        re.IdReclamoEstado,
        re.Codigo,
        re.Nombre,
        re.Descripcion,
        re.Orden,
        re.Color,
        re.EsEstadoFinal,
        re.EsEliminable,
		re.EsEstadoSistema,
        re.IdEmpresa,
        e.Nombre AS NombreEmpresa,
        
        -- Se verifica si está en uso
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM Reclamo 
                WHERE IdEstadoActual = re.IdReclamoEstado 
                  AND Eliminado = 0
            ) THEN CAST(1 AS BIT)
            ELSE CAST(0 AS BIT)
        END AS EnUso,
        
        re.FechaCreacion,
        re.CreadoPor,
        re.FechaEdicion,
        re.EditadoPor,
        re.Activo
        
    FROM 
		ReclamoEstado re
    INNER JOIN Empresa e ON re.IdEmpresa = e.IdEmpresa

    WHERE 
		re.IdReclamoEstado = @IdReclamoEstado AND
		re.Eliminado = 0
    ORDER BY re.IdEmpresa, re.Orden
END
GO