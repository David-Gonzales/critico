USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraEmpresa_Asignar
    @IdEntidadFinanciera INT,
    @IdEmpresa INT,
    @EmailNotificacion NVARCHAR(200) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @CanalAtencion NVARCHAR(500) = NULL,
    @LogoUrl NVARCHAR(500) = NULL,
    @LogoDarkUrl NVARCHAR(500) = NULL,
    @Visible BIT = 1,
    @FechaCreacion DATETIME,
    @CreadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdEntidadFinancieraEmpresa INT
    
    -- Valido que la entidad financiera existe
    IF NOT EXISTS (SELECT 1 FROM EntidadFinanciera WHERE IdEntidadFinanciera = @IdEntidadFinanciera AND Eliminado = 0)
    BEGIN
        RAISERROR('La entidad financiera no existe', 16, 1)
        RETURN
    END
    
    -- Valido que la empresa existe
    IF NOT EXISTS (SELECT 1 FROM Empresa WHERE IdEmpresa = @IdEmpresa AND Eliminado = 0)
    BEGIN
        RAISERROR('La empresa no existe', 16, 1)
        RETURN
    END
    
    -- Valido que no esté ya asignada
    IF EXISTS (
        SELECT 1 FROM EntidadFinancieraEmpresa 
        WHERE IdEntidadFinanciera = @IdEntidadFinanciera 
          AND IdEmpresa = @IdEmpresa 
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('Esta entidad ya está asignada a la empresa', 16, 1)
        RETURN
    END
    
    INSERT INTO EntidadFinancieraEmpresa (
        IdEntidadFinanciera, IdEmpresa,
        EmailNotificacion, Telefono, CanalAtencion,
        LogoUrl, LogoDarkUrl, Visible,
        FechaCreacion, CreadoPor
    )
    VALUES (
        @IdEntidadFinanciera, @IdEmpresa,
        @EmailNotificacion, @Telefono, @CanalAtencion,
        @LogoUrl, @LogoDarkUrl, @Visible,
        @FechaCreacion, @CreadoPor
    )
    
    SET @IdEntidadFinancieraEmpresa = SCOPE_IDENTITY()
    
    EXEC sp_EntidadFinancieraEmpresa_ObtenerPorId @IdEntidadFinancieraEmpresa
END
GO