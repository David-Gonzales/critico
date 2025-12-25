USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_Reclamo_ObtenerSiguienteCodigo
    @IdEmpresa INT,
    @Año INT,
	@Prefijo NVARCHAR(10),
	@NuevoCodigo NVARCHAR(20) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @NuevoCorrelativo INT
    
    --MERGE para INSERT-or-UPDATE atómico con validación de seguridad
    MERGE ReclamoSecuencia WITH (HOLDLOCK, SERIALIZABLE) AS target
    USING (SELECT @IdEmpresa AS IdEmpresa, @Año AS Año) AS source
    ON target.IdEmpresa = source.IdEmpresa AND target.Año = source.Año

	-- Si existe, incrementar
	WHEN MATCHED THEN
        UPDATE SET 
            UltimoCorrelativo = UltimoCorrelativo + 1,
            FechaActualizacion = GETDATE()

	-- Si no existe, validar si hay reclamos previos y usar ese número como base
    WHEN NOT MATCHED THEN
        INSERT (IdEmpresa, Año, UltimoCorrelativo, FechaActualizacion)
        VALUES (
            @IdEmpresa, 
            @Año, 
            -- VALIDACIÓN: Si hay reclamos existentes, partir desde ese número
            ISNULL((
                SELECT MAX(
                    CAST(
                        SUBSTRING(CodigoReclamo, 
                                  CHARINDEX('-', CodigoReclamo, CHARINDEX('-', CodigoReclamo) + 1) + 1, 
                                  6
                        ) AS INT
                    )
                )
                FROM Reclamo WITH (NOLOCK)
                WHERE IdEmpresa = @IdEmpresa 
                  AND YEAR(FechaCreacion) = @Año
                  AND CodigoReclamo LIKE '%-%-______'
                  AND Eliminado = 0
			), 0) + 1,  -- Si no hay reclamos, empezar en 1
			GETDATE()
    );

	-- Obtener el valor actualizado
    SELECT @NuevoCorrelativo = UltimoCorrelativo
    FROM ReclamoSecuencia WITH (NOLOCK)
    WHERE IdEmpresa = @IdEmpresa AND Año = @Año

	SET @NuevoCodigo = @Prefijo + '-' + CAST (@Año AS nvarchar(4)) + '-' + RIGHT('000000' + CAST(@NuevoCorrelativo AS nvarchar(6)), 6)
    
	RETURN 0

END
GO