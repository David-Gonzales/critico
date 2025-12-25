USE DB_ASBANC_DEV
GO

CREATE OR ALTER PROCEDURE sp_EntidadFinancieraEmpresa_ActualizarConfig
    @IdEntidadFinancieraEmpresa INT,
    @EmailNotificacion NVARCHAR(200) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @CanalAtencion NVARCHAR(500) = NULL,
    @LogoUrl NVARCHAR(500) = NULL,
    @LogoDarkUrl NVARCHAR(500) = NULL,
    @FechaEdicion DATETIME,
    @EditadoPor NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE 
		EntidadFinancieraEmpresa
    SET 
		EmailNotificacion = ISNULL(@EmailNotificacion, EmailNotificacion),
        Telefono = ISNULL(@Telefono, Telefono),
        CanalAtencion = ISNULL(@CanalAtencion, CanalAtencion),
        LogoUrl = ISNULL(@LogoUrl, LogoUrl),
        LogoDarkUrl = ISNULL(@LogoDarkUrl, LogoDarkUrl),
        FechaEdicion = @FechaEdicion,
        EditadoPor = @EditadoPor
    WHERE IdEntidadFinancieraEmpresa = @IdEntidadFinancieraEmpresa
    
    EXEC sp_EntidadFinancieraEmpresa_ObtenerPorId @IdEntidadFinancieraEmpresa
END
GO