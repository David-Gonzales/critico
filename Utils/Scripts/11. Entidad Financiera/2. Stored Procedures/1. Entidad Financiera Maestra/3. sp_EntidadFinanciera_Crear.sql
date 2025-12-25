USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinanciera_Crear
    @Codigo NVARCHAR(20),
    @Nombre NVARCHAR(200),
    @RUC NVARCHAR(11) = NULL,
    @RazonSocial NVARCHAR(300) = NULL,
    @SitioWeb NVARCHAR(200) = NULL,
    @Direccion NVARCHAR(500) = NULL,
    @Descripcion NVARCHAR(1000) = NULL,
    @AsignarATodasLasEmpresas BIT = 1,  -- Por defecto asignar a todas
    @FechaCreacion DATETIME,
    @CreadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdEntidadFinanciera INT
    
    -- Valido código único
    IF EXISTS (SELECT 1 FROM EntidadFinanciera WHERE Codigo = @Codigo AND Eliminado = 0)
    BEGIN
        RAISERROR('Ya existe una entidad financiera con ese código', 16, 1)
        RETURN
    END
    
    -- Valido RUC único si se proporciona
    IF @RUC IS NOT NULL AND EXISTS (SELECT 1 FROM EntidadFinanciera WHERE RUC = @RUC AND Eliminado = 0)
    BEGIN
        RAISERROR('Ya existe una entidad financiera con ese RUC', 16, 1)
        RETURN
    END
    
    INSERT INTO EntidadFinanciera (
        Codigo, Nombre, RUC, RazonSocial,
        SitioWeb, Direccion, Descripcion,
        FechaCreacion, CreadoPor
    )
    VALUES (
        @Codigo, @Nombre, @RUC, @RazonSocial,
        @SitioWeb, @Direccion, @Descripcion,
        @FechaCreacion, @CreadoPor
    )
    
    SET @IdEntidadFinanciera = SCOPE_IDENTITY()
    
    -- Si se solicita, asigno automáticamente a todas las empresas activas
    IF @AsignarATodasLasEmpresas = 1
    BEGIN
        INSERT INTO EntidadFinancieraEmpresa (
            IdEntidadFinanciera, IdEmpresa, Visible,
            FechaCreacion, CreadoPor
        )
        SELECT 
            @IdEntidadFinanciera,
            e.IdEmpresa,
            1 AS Visible,
            @FechaCreacion,
            @CreadoPor
        FROM Empresa e
        WHERE e.Eliminado = 0 AND e.Activo = 1
    END

    EXEC sp_EntidadFinanciera_ObtenerPorId @IdEntidadFinanciera
END
GO