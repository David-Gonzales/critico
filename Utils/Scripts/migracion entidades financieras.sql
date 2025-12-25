USE DB_ASBANC_DEV
GO

-- =============================================
-- PASO 0: Verificar estado actual
-- =============================================
PRINT 'Estado actual:'
SELECT 'EntidadFinanciera' AS Tabla, COUNT(*) AS Cantidad FROM EntidadFinanciera WHERE Eliminado = 0
UNION ALL
SELECT 'Empresa' AS Tabla, COUNT(*) FROM Empresa WHERE Eliminado = 0
UNION ALL
SELECT 'Contactos' AS Tabla, COUNT(*) FROM EntidadFinancieraContacto WHERE Eliminado = 0
UNION ALL
SELECT 'Dominios' AS Tabla, COUNT(*) FROM EntidadFinancieraDominio WHERE Eliminado = 0
UNION ALL
SELECT 'Reclamos' AS Tabla, COUNT(*) FROM Reclamo WHERE Eliminado = 0
GO

-- =============================================
-- PASO 1: Respaldar datos actuales
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EntidadFinanciera_Backup')
BEGIN
    SELECT * INTO EntidadFinanciera_Backup FROM EntidadFinanciera
    PRINT 'Backup: EntidadFinanciera_Backup'
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EntidadFinancieraContacto_Backup')
BEGIN
    SELECT * INTO EntidadFinancieraContacto_Backup FROM EntidadFinancieraContacto
    PRINT 'Backup: EntidadFinancieraContacto_Backup'
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EntidadFinancieraDominio_Backup')
BEGIN
    SELECT * INTO EntidadFinancieraDominio_Backup FROM EntidadFinancieraDominio
    PRINT 'Backup: EntidadFinancieraDominio_Backup'
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Reclamo_Backup')
BEGIN
    SELECT * INTO Reclamo_Backup FROM Reclamo
    PRINT 'Backup: Reclamo_Backup'
END
GO

-- =============================================
-- PASO 2: Crear tabla EntidadFinancieraEmpresa
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EntidadFinancieraEmpresa')
BEGIN
    CREATE TABLE EntidadFinancieraEmpresa (
        IdEntidadFinancieraEmpresa INT IDENTITY(1,1) NOT NULL,
        IdEntidadFinanciera INT NOT NULL,
        IdEmpresa INT NOT NULL,
        
        -- Configuración específica por empresa
        EmailNotificacion NVARCHAR(200) NULL,
        Telefono NVARCHAR(20) NULL,
        CanalAtencion NVARCHAR(500) NULL,
        LogoUrl NVARCHAR(500) NULL,
        LogoDarkUrl NVARCHAR(500) NULL,
        
        -- Control de visibilidad y estado
        Visible BIT NOT NULL DEFAULT 1,
        
        -- Auditoría
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
        CreadoPor NVARCHAR(50) NOT NULL,
        FechaEdicion DATETIME NULL,
        EditadoPor NVARCHAR(50) NULL,
        Activo BIT NOT NULL DEFAULT 1,
        Eliminado BIT NOT NULL DEFAULT 0,
        
        CONSTRAINT PK_EntidadFinancieraEmpresa PRIMARY KEY CLUSTERED (IdEntidadFinancieraEmpresa ASC),
        CONSTRAINT FK_EntidadFinancieraEmpresa_EntidadFinanciera FOREIGN KEY (IdEntidadFinanciera) REFERENCES EntidadFinanciera(IdEntidadFinanciera),
        CONSTRAINT FK_EntidadFinancieraEmpresa_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa),
        CONSTRAINT UQ_EntidadFinancieraEmpresa_Entidad_Empresa UNIQUE (IdEntidadFinanciera, IdEmpresa)
    )
    
    CREATE INDEX IX_EntidadFinancieraEmpresa_Entidad ON EntidadFinancieraEmpresa(IdEntidadFinanciera)
    
    CREATE INDEX IX_EntidadFinancieraEmpresa_Empresa ON EntidadFinancieraEmpresa(IdEmpresa)

END
GO

-- =============================================
-- PASO 3: Migrar EntidadFinanciera a EntidadFinancieraEmpresa
-- =============================================
INSERT INTO EntidadFinancieraEmpresa (
    IdEntidadFinanciera, 
    IdEmpresa, 
    EmailNotificacion, 
    Telefono, 
    CanalAtencion,
    LogoUrl, 
    LogoDarkUrl,
    Visible,
    FechaCreacion, 
    CreadoPor
)
SELECT 
    ef.IdEntidadFinanciera,
    e.IdEmpresa,
    ef.EmailNotificacion,
    ef.Telefono,
    ef.CanalAtencion,
    ef.LogoUrl,
    ef.LogoDarkUrl,
    1 AS Visible,
    GETDATE(),
    'MIGRATION'
FROM EntidadFinanciera ef
CROSS JOIN Empresa e
WHERE 
	ef.Eliminado = 0 AND 
	e.Eliminado = 0 AND 
	NOT EXISTS (
      SELECT 1 FROM EntidadFinancieraEmpresa efe 
      WHERE 
		efe.IdEntidadFinanciera = ef.IdEntidadFinanciera AND 
		efe.IdEmpresa = e.IdEmpresa
  )

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' asignaciones creadas'
GO

-- =============================================
-- PASO 4: Migrar Contactos a EntidadFinancieraEmpresa
-- =============================================

-- 4.1: Eliminar FK existente
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_EntidadFinancieraContacto_EntidadFinanciera')
BEGIN
    ALTER TABLE EntidadFinancieraContacto 
    DROP CONSTRAINT FK_EntidadFinancieraContacto_EntidadFinanciera
    PRINT 'FK de Contactos eliminada'
END
GO

-- 4.2: Agregar nueva columna
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('EntidadFinancieraContacto') AND name = 'IdEntidadFinancieraEmpresa')
BEGIN
    ALTER TABLE EntidadFinancieraContacto 
    ADD IdEntidadFinancieraEmpresa INT NULL
    PRINT 'Columna IdEntidadFinancieraEmpresa agregada a Contactos'
END
GO

-- 4.3: Duplicar contactos para cada empresa
-- Primero, marcar los contactos existentes como de migración temporal
UPDATE EntidadFinancieraContacto 
SET EditadoPor = 'MIGRATION_OLD'
WHERE IdEntidadFinancieraEmpresa IS NULL

-- Insertar contactos duplicados para cada asignación EntidadFinancieraEmpresa
INSERT INTO EntidadFinancieraContacto (
    IdEntidadFinancieraEmpresa,
    NombreContacto,
    EmailContacto,
    FechaCreacion,
    CreadoPor,
    Activo,
    Eliminado
)
SELECT 
    efe.IdEntidadFinancieraEmpresa,
    c.NombreContacto,
    c.EmailContacto,
    GETDATE(),
    'MIGRATION',
    c.Activo,
    c.Eliminado
FROM EntidadFinancieraContacto_Backup c
INNER JOIN EntidadFinancieraEmpresa efe 
    ON c.IdEntidadFinanciera = efe.IdEntidadFinanciera
WHERE c.Eliminado = 0

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' contactos migrados'
GO

-- 4.4: Eliminar contactos viejos (los que tienen IdEntidadFinanciera)
DELETE FROM EntidadFinancieraContacto
WHERE EditadoPor = 'MIGRATION_OLD'

PRINT 'Contactos viejos eliminados'
GO

-- 4.5: Agregar nueva FK
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_EntidadFinancieraContacto_EntidadFinancieraEmpresa')
BEGIN
    ALTER TABLE EntidadFinancieraContacto 
    ADD CONSTRAINT FK_EntidadFinancieraContacto_EntidadFinancieraEmpresa 
        FOREIGN KEY (IdEntidadFinancieraEmpresa) 
        REFERENCES EntidadFinancieraEmpresa(IdEntidadFinancieraEmpresa)
    PRINT 'Nueva FK de Contactos agregada'
END
GO

-- 4.6: Eliminar columna vieja
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_EntidadFinancieraContacto_Entidad' AND object_id = OBJECT_ID('EntidadFinancieraContacto'))
BEGIN
    DROP INDEX IX_EntidadFinancieraContacto_Entidad ON EntidadFinancieraContacto
    PRINT 'Índice IX_EntidadFinancieraContacto_Entidad eliminado'
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('EntidadFinancieraContacto') AND name = 'IdEntidadFinanciera')
BEGIN
    ALTER TABLE EntidadFinancieraContacto DROP COLUMN IdEntidadFinanciera
    PRINT 'Columna IdEntidadFinanciera eliminada de Contactos'
END
GO

-- Crear nuevo índice apuntando a la nueva columna
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_EntidadFinancieraContacto_EntidadEmpresa' AND object_id = OBJECT_ID('EntidadFinancieraContacto'))
BEGIN
    CREATE INDEX IX_EntidadFinancieraContacto_EntidadEmpresa 
        ON EntidadFinancieraContacto(IdEntidadFinancieraEmpresa)
    PRINT 'Nuevo índice IX_EntidadFinancieraContacto_EntidadEmpresa creado'
END
GO

-- =============================================
-- PASO 5: Migrar Dominios a EntidadFinancieraEmpresa
-- =============================================

PRINT 'Migrando dominios...'
GO

-- 5.1: Eliminar FK existente
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_EntidadFinancieraDominio_EntidadFinanciera')
BEGIN
    ALTER TABLE EntidadFinancieraDominio 
    DROP CONSTRAINT FK_EntidadFinancieraDominio_EntidadFinanciera
    PRINT 'FK de Dominios eliminada'
END
GO

-- 5.2: Agregar nueva columna
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('EntidadFinancieraDominio') AND name = 'IdEntidadFinancieraEmpresa')
BEGIN
    ALTER TABLE EntidadFinancieraDominio 
    ADD IdEntidadFinancieraEmpresa INT NULL
    PRINT 'Columna IdEntidadFinancieraEmpresa agregada a Dominios'
END
GO

-- 5.3: Duplicar dominios para cada empresa
UPDATE EntidadFinancieraDominio 
SET EditadoPor = 'MIGRATION_OLD'
WHERE IdEntidadFinancieraEmpresa IS NULL

INSERT INTO EntidadFinancieraDominio (
    IdEntidadFinancieraEmpresa,
    Dominio,
    FechaCreacion,
    CreadoPor,
    Activo,
    Eliminado
)
SELECT 
    efe.IdEntidadFinancieraEmpresa,
    d.Dominio,
    GETDATE(),
    'MIGRATION',
    d.Activo,
    d.Eliminado
FROM EntidadFinancieraDominio_Backup d
INNER JOIN EntidadFinancieraEmpresa efe 
    ON d.IdEntidadFinanciera = efe.IdEntidadFinanciera
WHERE d.Eliminado = 0

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' dominios migrados'
GO

-- 5.4: Eliminar dominios viejos
DELETE FROM EntidadFinancieraDominio
WHERE EditadoPor = 'MIGRATION_OLD'

PRINT 'Dominios viejos eliminados'
GO

-- 5.5: Agregar nueva FK
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_EntidadFinancieraDominio_EntidadFinancieraEmpresa')
BEGIN
    ALTER TABLE EntidadFinancieraDominio 
    ADD CONSTRAINT FK_EntidadFinancieraDominio_EntidadFinancieraEmpresa 
        FOREIGN KEY (IdEntidadFinancieraEmpresa) 
        REFERENCES EntidadFinancieraEmpresa(IdEntidadFinancieraEmpresa)
    PRINT 'Nueva FK de Dominios agregada'
END
GO

-- 5.6: Eliminar columna vieja
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_EntidadFinancieraDominio_Entidad' AND object_id = OBJECT_ID('EntidadFinancieraDominio'))
BEGIN
    DROP INDEX IX_EntidadFinancieraDominio_Entidad ON EntidadFinancieraDominio
    PRINT 'Índice IX_EntidadFinancieraDominio_Entidad eliminado'
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('EntidadFinancieraDominio') AND name = 'IdEntidadFinanciera')
BEGIN
    ALTER TABLE EntidadFinancieraDominio DROP COLUMN IdEntidadFinanciera
    PRINT 'Columna IdEntidadFinanciera eliminada de Dominios'
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_EntidadFinancieraDominio_EntidadEmpresa' AND object_id = OBJECT_ID('EntidadFinancieraDominio'))
BEGIN
    CREATE INDEX IX_EntidadFinancieraDominio_EntidadEmpresa 
        ON EntidadFinancieraDominio(IdEntidadFinancieraEmpresa)
    PRINT 'Nuevo índice IX_EntidadFinancieraDominio_EntidadEmpresa creado'
END
GO

-- =============================================
-- PASO 6: Actualizar tabla Reclamo
-- =============================================


-- 6.1: Eliminar FK existente
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Reclamo_EntidadFinanciera')
BEGIN
    ALTER TABLE Reclamo DROP CONSTRAINT FK_Reclamo_EntidadFinanciera
    PRINT 'FK_Reclamo_EntidadFinanciera eliminada'
END
GO

-- 6.2: Agregar nueva columna
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Reclamo') AND name = 'IdEntidadFinancieraEmpresa')
BEGIN
    ALTER TABLE Reclamo ADD IdEntidadFinancieraEmpresa INT NULL
    PRINT 'Columna IdEntidadFinancieraEmpresa agregada a Reclamo'
END
GO

-- 6.3: Migrar datos
UPDATE r
SET r.IdEntidadFinancieraEmpresa = efe.IdEntidadFinancieraEmpresa
FROM Reclamo r
INNER JOIN EntidadFinancieraEmpresa efe 
    ON r.IdEntidadFinanciera = efe.IdEntidadFinanciera 
    AND r.IdEmpresa = efe.IdEmpresa
WHERE r.IdEntidadFinanciera IS NOT NULL
  AND r.IdEntidadFinancieraEmpresa IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' reclamos migrados'
GO

-- 6.4: Agregar nueva FK
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Reclamo_EntidadFinancieraEmpresa')
BEGIN
    ALTER TABLE Reclamo 
    ADD CONSTRAINT FK_Reclamo_EntidadFinancieraEmpresa 
        FOREIGN KEY (IdEntidadFinancieraEmpresa) 
        REFERENCES EntidadFinancieraEmpresa(IdEntidadFinancieraEmpresa)
    PRINT 'FK_Reclamo_EntidadFinancieraEmpresa agregada'
END
GO

-- =============================================
-- PASO 7: Limpiar EntidadFinanciera (Tabla Maestra)
-- =============================================

-- 7.1: Eliminar FK a Empresa
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_EntidadFinanciera_Empresa')
BEGIN
    ALTER TABLE EntidadFinanciera DROP CONSTRAINT FK_EntidadFinanciera_Empresa
    PRINT 'FK_EntidadFinanciera_Empresa eliminada'
END
GO

-- 7.2: Eliminar columnas que ahora están en EntidadFinancieraEmpresa

-- Primero eliminar todos los índices que dependan de las columnas a eliminar
DECLARE @IndexesToDrop TABLE (IndexName NVARCHAR(128))

-- Buscar índices que dependan de las columnas que vamos a eliminar
INSERT INTO @IndexesToDrop
SELECT DISTINCT i.name
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('EntidadFinanciera')
  AND c.name IN ('IdEmpresa', 'LogoUrl', 'LogoDarkUrl', 'CanalAtencion', 'EmailNotificacion', 'Telefono')
  AND i.is_primary_key = 0  -- No eliminar clave primaria
  AND i.is_unique_constraint = 0  -- No eliminar constraints únicos por ahora

-- Eliminar cada índice encontrado
DECLARE @IndexName NVARCHAR(128)
DECLARE index_cursor CURSOR FOR SELECT IndexName FROM @IndexesToDrop

OPEN index_cursor
FETCH NEXT FROM index_cursor INTO @IndexName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @DropIndexSQL NVARCHAR(MAX) = 'DROP INDEX ' + @IndexName + ' ON EntidadFinanciera'
    EXEC sp_executesql @DropIndexSQL
    PRINT 'Índice ' + @IndexName + ' eliminado'
    FETCH NEXT FROM index_cursor INTO @IndexName
END

CLOSE index_cursor
DEALLOCATE index_cursor
GO

DECLARE @ColumnasEliminar TABLE (Columna NVARCHAR(50))
INSERT INTO @ColumnasEliminar VALUES ('IdEmpresa'), ('LogoUrl'), ('LogoDarkUrl'), 
    ('CanalAtencion'), ('EmailNotificacion'), ('Telefono')

DECLARE @Columna NVARCHAR(50)
DECLARE columna_cursor CURSOR FOR SELECT Columna FROM @ColumnasEliminar

OPEN columna_cursor
FETCH NEXT FROM columna_cursor INTO @Columna

WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('EntidadFinanciera') AND name = @Columna)
    BEGIN
        DECLARE @SQL NVARCHAR(MAX) = 'ALTER TABLE EntidadFinanciera DROP COLUMN ' + @Columna
        EXEC sp_executesql @SQL
        PRINT 'Columna ' + @Columna + ' eliminada'
    END
    FETCH NEXT FROM columna_cursor INTO @Columna
END

CLOSE columna_cursor
DEALLOCATE columna_cursor
GO

-- =============================================
-- PASO 8: Verificación final
-- =============================================
PRINT 'Estado final:'
SELECT 'EntidadFinanciera (Maestra)' AS Tabla, COUNT(*) AS Cantidad 
FROM EntidadFinanciera WHERE Eliminado = 0
UNION ALL
SELECT 'EntidadFinancieraEmpresa (Asignaciones)', COUNT(*) 
FROM EntidadFinancieraEmpresa WHERE Eliminado = 0
UNION ALL
SELECT 'Contactos (por empresa)', COUNT(*) 
FROM EntidadFinancieraContacto WHERE Eliminado = 0
UNION ALL
SELECT 'Dominios (por empresa)', COUNT(*) 
FROM EntidadFinancieraDominio WHERE Eliminado = 0
UNION ALL
SELECT 'Reclamos migrados', COUNT(*) 
FROM Reclamo WHERE IdEntidadFinancieraEmpresa IS NOT NULL AND Eliminado = 0
GO


-- =====================================================

-- 1. Verificar que todos los reclamos tienen la nueva FK
SELECT 
    'Reclamos con nueva FK' AS Descripcion,
    COUNT(*) AS Cantidad
FROM Reclamo 
WHERE IdEntidadFinancieraEmpresa IS NOT NULL 
  AND Eliminado = 0

UNION ALL

-- 2. Verificar si quedó algún reclamo sin migrar
SELECT 
    'Reclamos SIN migrar (DEBE SER 0)' AS Descripcion,
    COUNT(*) AS Cantidad
FROM Reclamo 
WHERE IdEntidadFinancieraEmpresa IS NULL 
  AND Eliminado = 0

UNION ALL

-- 3. Verificar que cada entidad tiene 2 asignaciones (1 por empresa)
SELECT 
    'Entidades con asignaciones correctas (debe ser 36)' AS Descripcion,
    COUNT(*) AS Cantidad
FROM (
    SELECT IdEntidadFinanciera, COUNT(*) AS AsignacionesPorEntidad
    FROM EntidadFinancieraEmpresa
    WHERE Eliminado = 0
    GROUP BY IdEntidadFinanciera
    HAVING COUNT(*) = 2  -- Cada entidad tiene 2 empresas
) AS SubQuery

UNION ALL

-- 4. Verificar que EntidadFinanciera ya no tiene columnas viejas
SELECT 
    'Columnas eliminadas de EntidadFinanciera (debe ser 0)' AS Descripcion,
    COUNT(*) AS Cantidad
FROM sys.columns 
WHERE object_id = OBJECT_ID('EntidadFinanciera') 
  AND name IN ('IdEmpresa', 'LogoUrl', 'LogoDarkUrl', 'EmailNotificacion', 'Telefono', 'CanalAtencion')

UNION ALL

-- 5. Verificar que Contactos tiene nueva columna
SELECT 
    'Contactos con nueva FK (debe existir columna)' AS Descripcion,
    COUNT(*) AS Cantidad
FROM sys.columns 
WHERE object_id = OBJECT_ID('EntidadFinancieraContacto') 
  AND name = 'IdEntidadFinancieraEmpresa'

UNION ALL

-- 6. Verificar que Dominios tiene nueva columna
SELECT 
    'Dominios con nueva FK (debe existir columna)' AS Descripcion,
    COUNT(*) AS Cantidad
FROM sys.columns 
WHERE object_id = OBJECT_ID('EntidadFinancieraDominio') 
  AND name = 'IdEntidadFinancieraEmpresa'

