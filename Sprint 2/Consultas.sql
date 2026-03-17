-- ============================================================
-- SCRIPT DE CONSULTAS Y VALIDACIÓN DE BASE DE DATOS
-- ============================================================


-- ============================================================
-- SECCIÓN 1: CONTEO DE REGISTROS POR TABLA
-- ============================================================

-- Conteo individual por tabla
SELECT 'equipos'                AS tabla, COUNT(*) AS total FROM equipos
UNION ALL
SELECT 'tecnicos',                         COUNT(*)         FROM tecnicos
UNION ALL
SELECT 'tipo_novedad',                     COUNT(*)         FROM tipo_novedad
UNION ALL
SELECT 'repuestos',                        COUNT(*)         FROM repuestos
UNION ALL
SELECT 'componentes',                      COUNT(*)         FROM componentes
UNION ALL
SELECT 'intervenciones',                   COUNT(*)         FROM intervenciones
UNION ALL
SELECT 'intervencion_tecnico',             COUNT(*)         FROM intervencion_tecnico
UNION ALL
SELECT 'detalle_intervencion',             COUNT(*)         FROM detalle_intervencion
ORDER BY tabla;


-- ============================================================
-- SECCIÓN 2: LISTADO COMPLETO DE INTERVENCIONES CON JOINs
-- ============================================================

-- Vista completa: intervención + equipo + tipo de novedad + técnico(s)
-- Un técnico por fila; si hay varios técnicos, la intervención aparece repetida
SELECT
    i.id_intervencion,
    i.fecha,
    i.hora_parada,

    -- Equipo
    e.id_equipo,
    e.nombre                            AS equipo_nombre,
    e.fabricante                        AS equipo_fabricante,
    e.marca                             AS equipo_marca,
    e.modelo                            AS equipo_modelo,
    e.anio                              AS equipo_anio,

    -- Tipo de novedad
    tn.id_tipo                          AS tipo_novedad_id,
    tn.nombre                           AS tipo_novedad_nombre,

    -- Técnico
    t.id_tecnico,
    t.nombre                            AS tecnico_nombre,
    t.entidad                           AS tecnico_entidad,

    i.descripcion                       AS intervencion_descripcion

FROM intervenciones i
LEFT JOIN equipos              e  ON i.fk_id_equipo       = e.id_equipo
LEFT JOIN tipo_novedad         tn ON i.fk_id_tipo_novedad  = tn.id_tipo
LEFT JOIN intervencion_tecnico it ON i.id_intervencion     = it.fk_id_intervencion
LEFT JOIN tecnicos             t  ON it.fk_id_tecnico      = t.id_tecnico
ORDER BY i.fecha DESC NULLS LAST, i.id_intervencion;


-- ============================================================
-- SECCIÓN 3: VALIDACIÓN DE NULLs POR COLUMNA Y TABLA
-- ============================================================

-- ----------------------------------------------------------
-- 3.1 Tabla: equipos
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas,
    COUNT(*) FILTER (WHERE fabricante   IS NULL)    AS nulos_fabricante,
    COUNT(*) FILTER (WHERE marca        IS NULL)    AS nulos_marca,
    COUNT(*) FILTER (WHERE modelo       IS NULL)    AS nulos_modelo,
    COUNT(*) FILTER (WHERE anio         IS NULL)    AS nulos_anio
FROM equipos;

-- ----------------------------------------------------------
-- 3.2 Tabla: tecnicos
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas,
    COUNT(*) FILTER (WHERE entidad      IS NULL)    AS nulos_entidad
FROM tecnicos;

-- ----------------------------------------------------------
-- 3.3 Tabla: tipo_novedad
-- (no tiene columnas nullable más allá de la PK, se valida integridad)
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas
FROM tipo_novedad;

-- ----------------------------------------------------------
-- 3.4 Tabla: repuestos
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas,
    COUNT(*) FILTER (WHERE referencia   IS NULL)    AS nulos_referencia,
    COUNT(*) FILTER (WHERE descripcion  IS NULL)    AS nulos_descripcion
FROM repuestos;

-- ----------------------------------------------------------
-- 3.5 Tabla: componentes
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas,
    COUNT(*) FILTER (WHERE datos_tecnicos IS NULL)  AS nulos_datos_tecnicos
FROM componentes;

-- ----------------------------------------------------------
-- 3.6 Tabla: intervenciones
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas,
    COUNT(*) FILTER (WHERE fk_id_equipo      IS NULL)   AS nulos_fk_id_equipo,
    COUNT(*) FILTER (WHERE fecha             IS NULL)   AS nulos_fecha,
    COUNT(*) FILTER (WHERE hora_parada       IS NULL)   AS nulos_hora_parada,
    COUNT(*) FILTER (WHERE descripcion       IS NULL)   AS nulos_descripcion
FROM intervenciones;

-- ----------------------------------------------------------
-- 3.7 Tabla: intervencion_tecnico
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas,
    COUNT(*) FILTER (WHERE fk_id_tecnico IS NULL)   AS nulos_fk_id_tecnico
FROM intervencion_tecnico;

-- ----------------------------------------------------------
-- 3.8 Tabla: detalle_intervencion
-- ----------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_filas,
    COUNT(*) FILTER (WHERE fk_id_componente IS NULL)    AS nulos_fk_id_componente,
    COUNT(*) FILTER (WHERE fk_id_repuesto   IS NULL)    AS nulos_fk_id_repuesto,
    COUNT(*) FILTER (WHERE cantidad_usada   IS NULL)    AS nulos_cantidad_usada
FROM detalle_intervencion;


-- ============================================================
-- SECCIÓN 4: ANÁLISIS POR FK EN INTERVENCIONES
-- ============================================================
-- Cada FK tiene tres bloques: CONTEO, RANKING y BÚSQUEDA.
-- En búsqueda reemplaza el valor tras '=' por el ID que necesites.
-- ============================================================


-- ----------------------------------------------------------
-- 4.1 FK: fk_id_equipo  (equipos → intervenciones)
-- ----------------------------------------------------------

-- CONTEO: intervenciones por equipo (incluyendo NULL)
SELECT
    e.id_equipo,
    e.nombre                        AS equipo_nombre,
    COUNT(i.id_intervencion)        AS total_intervenciones
FROM intervenciones i
LEFT JOIN equipos e ON i.fk_id_equipo = e.id_equipo
GROUP BY e.id_equipo, e.nombre
ORDER BY e.id_equipo;

-- RANKING: equipos con más intervenciones primero
SELECT
    COALESCE(e.nombre, '-- Sin equipo asignado --')     AS equipo_nombre,
    COUNT(i.id_intervencion)                            AS total_intervenciones,
    RANK() OVER (ORDER BY COUNT(i.id_intervencion) DESC) AS ranking
FROM intervenciones i
LEFT JOIN equipos e ON i.fk_id_equipo = e.id_equipo
GROUP BY e.id_equipo, e.nombre
ORDER BY ranking;

-- BÚSQUEDA: todas las intervenciones de un equipo específico (reemplaza el ID)
SELECT
    i.id_intervencion,
    i.fecha,
    i.hora_parada,
    i.descripcion,
    tn.nombre   AS tipo_novedad,
    t.nombre    AS tecnico
FROM intervenciones i
LEFT JOIN tipo_novedad         tn ON i.fk_id_tipo_novedad  = tn.id_tipo
LEFT JOIN intervencion_tecnico it ON i.id_intervencion     = it.fk_id_intervencion
LEFT JOIN tecnicos             t  ON it.fk_id_tecnico      = t.id_tecnico
WHERE i.fk_id_equipo = 1   -- <<< reemplaza por el id_equipo deseado
ORDER BY i.fecha DESC NULLS LAST;


-- ----------------------------------------------------------
-- 4.2 FK: fk_id_tipo_novedad  (tipo_novedad → intervenciones)
-- ----------------------------------------------------------

-- CONTEO: intervenciones por tipo de novedad
SELECT
    tn.id_tipo,
    tn.nombre                       AS tipo_novedad_nombre,
    COUNT(i.id_intervencion)        AS total_intervenciones
FROM intervenciones i
JOIN tipo_novedad tn ON i.fk_id_tipo_novedad = tn.id_tipo
GROUP BY tn.id_tipo, tn.nombre
ORDER BY tn.id_tipo;

-- RANKING: tipos de novedad más frecuentes primero
SELECT
    tn.nombre                                               AS tipo_novedad_nombre,
    COUNT(i.id_intervencion)                                AS total_intervenciones,
    RANK() OVER (ORDER BY COUNT(i.id_intervencion) DESC)    AS ranking
FROM intervenciones i
JOIN tipo_novedad tn ON i.fk_id_tipo_novedad = tn.id_tipo
GROUP BY tn.id_tipo, tn.nombre
ORDER BY ranking;

-- BÚSQUEDA: todas las intervenciones de un tipo de novedad específico (reemplaza el ID)
SELECT
    i.id_intervencion,
    i.fecha,
    i.hora_parada,
    i.descripcion,
    COALESCE(e.nombre, '-- Sin equipo --')  AS equipo,
    t.nombre                                AS tecnico
FROM intervenciones i
LEFT JOIN equipos              e  ON i.fk_id_equipo        = e.id_equipo
LEFT JOIN intervencion_tecnico it ON i.id_intervencion     = it.fk_id_intervencion
LEFT JOIN tecnicos             t  ON it.fk_id_tecnico      = t.id_tecnico
WHERE i.fk_id_tipo_novedad = 1   -- <<< reemplaza por el id_tipo deseado
ORDER BY i.fecha DESC NULLS LAST;


-- ----------------------------------------------------------
-- 4.3 FK: fk_id_tecnico  (tecnicos → intervencion_tecnico → intervenciones)
-- ----------------------------------------------------------

-- CONTEO: intervenciones por técnico (incluyendo NULL)
SELECT
    t.id_tecnico,
    t.nombre                        AS tecnico_nombre,
    COUNT(it.fk_id_intervencion)    AS total_intervenciones
FROM intervencion_tecnico it
LEFT JOIN tecnicos t ON it.fk_id_tecnico = t.id_tecnico
GROUP BY t.id_tecnico, t.nombre
ORDER BY t.id_tecnico;

-- RANKING: técnicos con más intervenciones primero
SELECT
    COALESCE(t.nombre, '-- Sin técnico asignado --')        AS tecnico_nombre,
    COUNT(it.fk_id_intervencion)                            AS total_intervenciones,
    RANK() OVER (ORDER BY COUNT(it.fk_id_intervencion) DESC) AS ranking
FROM intervencion_tecnico it
LEFT JOIN tecnicos t ON it.fk_id_tecnico = t.id_tecnico
GROUP BY t.id_tecnico, t.nombre
ORDER BY ranking;

-- BÚSQUEDA: todas las intervenciones de un técnico específico (reemplaza el ID)
SELECT
    i.id_intervencion,
    i.fecha,
    i.hora_parada,
    i.descripcion,
    COALESCE(e.nombre, '-- Sin equipo --')  AS equipo,
    tn.nombre                               AS tipo_novedad
FROM intervencion_tecnico it
JOIN intervenciones            i  ON it.fk_id_intervencion = i.id_intervencion
LEFT JOIN equipos              e  ON i.fk_id_equipo        = e.id_equipo
LEFT JOIN tipo_novedad         tn ON i.fk_id_tipo_novedad  = tn.id_tipo
WHERE it.fk_id_tecnico = 1   -- <<< reemplaza por el id_tecnico deseado
ORDER BY i.fecha DESC NULLS LAST;


-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================