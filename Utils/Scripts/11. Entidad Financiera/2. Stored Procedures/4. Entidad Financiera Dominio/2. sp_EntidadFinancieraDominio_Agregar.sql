USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraDominio_Agregar
    @IdEntidadFinancieraEmpresa INT,
    @Dominio NVARCHAR(200),
    @FechaCreacion DATETIME,
    @CreadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @IdEntidadFinancieraDominio INT
    
    -- Valido que la EntidadFinancieraEmpresa existe
    IF NOT EXISTS (
        SELECT 1 FROM EntidadFinancieraEmpresa 
        WHERE 
			IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa AND 
			Eliminado = 0
    )
    BEGIN
        RAISERROR('La entidad financiera empresa no existe', 16, 1)
        RETURN
    END
    
    -- Valido que no existe el mismo dominio
    IF EXISTS (
        SELECT 1 FROM EntidadFinancieraDominio 
        WHERE 
			IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa AND 
			Dominio = @Dominio AND 
			Eliminado = 0
    )
    BEGIN
        RAISERROR('Ya existe ese dominio para esta entidad', 16, 1)
        RETURN
    END
    
    INSERT INTO EntidadFinancieraDominio (
        IdEntidadFinancieraEmpresa,
        Dominio,
        FechaCreacion,
        CreadoPor
    )
    VALUES (
        @IdEntidadFinancieraEmpresa,
        @Dominio,
        @FechaCreacion,
        @CreadoPor
    )
    
    SET @IdEntidadFinancieraDominio = SCOPE_IDENTITY()
    
    SELECT 
        IdEntidadFinancieraDominio,
        IdEntidadFinancieraEmpresa,
        Dominio,
        FechaCreacion,
        CreadoPor,
        Activo
    FROM 
		EntidadFinancieraDominio
    WHERE 
		IdEntidadFinancieraDominio = @IdEntidadFinancieraDominio
END
GO