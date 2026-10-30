-- ============================================================
-- PROYECTO: Sistema de Atención Ciudadana
-- ARCHIVO: 02_advanced_queries.sql (Consultas Analíticas)
-- AUTOR: José Humberto García Sánchez
-- ENTORNO: MySQL 8.0 / MySQL Workbench
-- ============================================================

USE Atencion_Ciudadana;

-- ============================================================
-- MÓDULO 1: AUDITORÍA OPERATIVA Y CONTROL DE SLA
-- ============================================================

-- CASO DE USO 1: Monitoreo de folios no resueltos para priorización en cuadrillas
SELECT 
    id_reporte AS 'Folio',
    tipo_problema AS 'Incidencia',
    colonia AS 'Ubicacion',
    estado AS 'Estatus'
FROM reportes
WHERE estado != 'Resuelto'
ORDER BY id_reporte ASC;

-- CASO DE USO 2: Evaluación del tiempo transcurrido (SLA) para reportes de fecha corte '2026-10-01'
SELECT 
    id_reporte AS 'Folio',
    tipo_problema AS 'Incidencia',
    estado AS 'Estatus',
    DATEDIFF('2026-10-26', '2026-10-01') AS 'Dias_Transcurridos'
FROM reportes
WHERE estado NOT IN ('Resuelto');

-- CASO DE USO 3: Concentración de volumen de reportes por colonia
SELECT 
    colonia AS 'Ubicacion',
    COUNT(*) AS 'Total_Reportes'
FROM reportes
GROUP BY colonia
ORDER BY Total_Reportes DESC;

-- ============================================================
-- MÓDULO 2: INTEGRACIÓN MULTI-TABLA (CRUCES RELACIONALES)
-- ============================================================

-- CASO DE USO 4: Tablero consolidado de atención (Reporte + Ciudadano + Área Responsable)
SELECT 
    r.id_reporte AS 'Folio',
    r.tipo_problema AS 'Incidencia',
    c.nombre AS 'Ciudadano',
    c.telefono AS 'Contacto',
    a.nombre_area AS 'Area_Responsable',
    r.estado AS 'Estatus'
FROM reportes r
INNER JOIN ciudadanos c 
    ON r.id_ciudadano = c.id_ciudadano
INNER JOIN areas a 
    ON r.id_area = a.id_area;

-- CASO DE USO 5: Auditoría de participación ciudadana mediante LEFT JOIN
-- Identifica ciudadanos registrados en el padrón que no han generado reportes
SELECT 
    c.id_ciudadano AS 'ID_Ciudadano',
    c.nombre AS 'Ciudadano',
    c.telefono AS 'Contacto',
    r.id_reporte AS 'Folio_Reporte',
    COALESCE(r.tipo_problema, 'Sin reporte registrado') AS 'Estado_Actividad'
FROM ciudadanos c
LEFT JOIN reportes r 
    ON c.id_ciudadano = r.id_ciudadano;

-- ============================================================
-- MÓDULO 3: ANALÍTICA AVANZADA Y SUBCONSULTAS
-- ============================================================

-- CASO DE USO 6: Detección de usuarios reincidentes (Subconsulta en HAVING)
-- Filtra ciudadanos que han registrado más de 1 reporte en el sistema
SELECT 
    id_ciudadano AS 'ID',
    nombre AS 'Ciudadano',
    telefono AS 'Contacto'
FROM ciudadanos
HAVING (
    SELECT COUNT(*)
    FROM reportes
    WHERE reportes.id_ciudadano = ciudadanos.id_ciudadano
) > 1;

-- CASO DE USO 7: Auditoría dinámica de último reporte levantado por usuario (Subconsulta en SELECT)
SELECT 
    id_ciudadano AS 'ID',
    nombre AS 'Ciudadano',
    telefono AS 'Contacto',
    (
        SELECT tipo_problema 
        FROM reportes 
        WHERE id_ciudadano = ciudadanos.id_ciudadano 
        ORDER BY id_reporte DESC 
        LIMIT 1
    ) AS 'Ultima_Incidencia'
FROM ciudadanos;

-- CASO DE USO 8: Identificación de reportes críticos por área (Subconsulta Correlacionada en WHERE)
-- Selecciona folios cuyo número de reporte es superior o igual al promedio de su propia área operativa
SELECT 
    r1.id_reporte AS 'Folio',
    r1.tipo_problema AS 'Incidencia',
    r1.id_area AS 'ID_Area',
    r1.estado AS 'Estatus'
FROM reportes r1
WHERE r1.id_reporte >= (
    SELECT AVG(id_reporte)
    FROM reportes
    WHERE id_area = r1.id_area
);

-- CASO DE USO 9: Consolidación unificada de sectores prioritarios (Operador UNION)
-- Une reportes de la colonia 'Centro' con folios en estatus 'Pendiente' eliminando duplicados
SELECT id_reporte AS 'Folio', tipo_problema AS 'Incidencia', colonia AS 'Ubicacion', estado AS 'Estatus'
FROM reportes
WHERE colonia = 'Centro'
UNION
SELECT id_reporte, tipo_problema, colonia, estado
FROM reportes
WHERE estado = 'Pendiente';