USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinanciera_Actualizar
    @IdEntidadFinanciera INT,
    @Codigo NVARCHAR(20) = NULL,
    @Nombre NVARCHAR(200) = NULL,
    @RUC NVARCHAR(11) = NULL,
    @RazonSocial NVARCHAR(300) = NULL,
    @SitioWeb NVARCHAR(200) = NULL,
    @Direccion NVARCHAR(500) = NULL,
    @Descripcion NVARCHAR(1000) = NULL,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validp código único si se está actualizando
    IF @Codigo IS NOT NULL AND EXISTS (
        SELECT 1 FROM EntidadFinanciera 
        WHERE Codigo = @Codigo 
          AND IdEntidadFinanciera != @IdEntidadFinanciera
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('Ya existe una entidad financiera con ese código', 16, 1)
        RETURN
    END
    
    -- Valido RUC único si se está actualizando
    IF @RUC IS NOT NULL AND EXISTS (
        SELECT 1 FROM EntidadFinanciera 
        WHERE RUC = @RUC 
          AND IdEntidadFinanciera != @IdEntidadFinanciera
          AND Eliminado = 0
    )
    BEGIN
        RAISERROR('Ya existe una entidad financiera con ese RUC', 16, 1)
        RETURN
    END
    
    UPDATE EntidadFinanciera
    SET Codigo = ISNULL(@Codigo, Codigo),
        Nombre = ISNULL(@Nombre, Nombre),
        RUC = ISNULL(@RUC, RUC),
        RazonSocial = ISNULL(@RazonSocial, RazonSocial),
        SitioWeb = ISNULL(@SitioWeb, SitioWeb),
        Direccion = ISNULL(@Direccion, Direccion),
        Descripcion = ISNULL(@Descripcion, Descripcion),
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE IdEntidadFinanciera = @IdEntidadFinanciera

    EXEC sp_EntidadFinanciera_ObtenerPorId @IdEntidadFinanciera
END
GO