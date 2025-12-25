USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_ReclamoEstado_Reordenar
	@EstadosOrden NVARCHAR(MAX), -- !Ojito: JSON: [{"IdReclamoEstado":1,"Orden":1},...]
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
	
	DECLARE @EsEliminable BIT
    DECLARE @EsEstadoSistema BIT

	CREATE TABLE #TempOrden (
        IdReclamoEstado INT,
        Orden INT
    )

	-- Inserto desde un JSON
    INSERT INTO #TempOrden (IdReclamoEstado, Orden)
    SELECT IdReclamoEstado, Orden
    FROM OPENJSON(@EstadosOrden)
    WITH (
        IdReclamoEstado INT '$.IdReclamoEstado',
        Orden INT '$.Orden'
    )
    
    -- Actualizo el orden
    UPDATE 
		re
    SET 
		re.Orden = t.Orden,
        re.FechaEdicion = @FechaEdicion,
        re.EditadoPor = @EditadoPor
    FROM 
		ReclamoEstado re
    
	INNER JOIN #TempOrden t ON re.IdReclamoEstado = t.IdReclamoEstado
    
    DROP TABLE #TempOrden
    
    SELECT 1 AS Success

END
GO