USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraContacto_Agregar
    @IdEntidadFinancieraEmpresa INT,
    @NombreContacto NVARCHAR(200),
    @EmailContacto NVARCHAR(200),
    @FechaCreacion DATETIME,
    @CreadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @IdEntidadFinancieraContacto INT
    
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
    
    -- Valido que no existe un contacto con el mismo email
    IF EXISTS (
        SELECT 1 FROM EntidadFinancieraContacto 
        WHERE 
			IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa AND 
			EmailContacto = @EmailContacto AND 
			Eliminado = 0
    )
    BEGIN
        RAISERROR('Ya existe un contacto con ese email para esta entidad', 16, 1)
        RETURN
    END
    
    INSERT INTO EntidadFinancieraContacto (
        IdEntidadFinancieraEmpresa,
        NombreContacto,
        EmailContacto,
        FechaCreacion,
        CreadoPor
    )
    VALUES (
        @IdEntidadFinancieraEmpresa,
        @NombreContacto,
        @EmailContacto,
        @FechaCreacion,
        @CreadoPor
    )
    
    SET @IdEntidadFinancieraContacto = SCOPE_IDENTITY()
    
    SELECT 
        IdEntidadFinancieraContacto,
        IdEntidadFinancieraEmpresa,
        NombreContacto,
        EmailContacto,
        FechaCreacion,
        CreadoPor,
        Activo
    FROM 
		EntidadFinancieraContacto
    WHERE 
		IdEntidadFinancieraContacto = @IdEntidadFinancieraContacto
END
GO