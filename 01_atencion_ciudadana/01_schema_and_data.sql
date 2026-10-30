-- ============================================================
-- PROYECTO: Sistema de Atención Ciudadana
-- ARCHIVO: 01_schema_and_data.sql (DDL y DML)
-- AUTOR: José Humberto García Sánchez
-- ENTORNO: MySQL 8.0 / MySQL Workbench
-- DESCRIPCIÓN: Creación de base de datos, esquema relacional
--              con restricciones de integridad e inserción de datos.
-- ============================================================

CREATE DATABASE IF NOT EXISTS Atencion_Ciudadana;
USE Atencion_Ciudadana;

-- Limpieza preventiva de tablas respetando orden de llaves foráneas
DROP TABLE IF EXISTS reportes;
DROP TABLE IF EXISTS ciudadanos;
DROP TABLE IF EXISTS areas;

-- ------------------------------------------------------------
-- 1. TABLA: ciudadanos (Padrón de usuarios reportantes)
-- ------------------------------------------------------------
CREATE TABLE ciudadanos (
    id_ciudadano INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 2. TABLA: areas (Catálogo de áreas operativas municipales)
-- ------------------------------------------------------------
CREATE TABLE areas (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    nombre_area VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- 3. TABLA: reportes (Registro de incidencias y folios)
-- ------------------------------------------------------------
CREATE TABLE reportes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    id_ciudadano INT NOT NULL,
    id_area INT NOT NULL,
    tipo_problema VARCHAR(100) NOT NULL,
    colonia VARCHAR(100) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT fk_reportes_ciudadanos
        FOREIGN KEY (id_ciudadano) REFERENCES ciudadanos(id_ciudadano)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_reportes_areas
        FOREIGN KEY (id_area) REFERENCES areas(id_area)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- POBLADO DE DATOS INICIALES (DML)
-- ------------------------------------------------------------

-- Inserción en catálogo de ciudadanos
INSERT INTO ciudadanos (id_ciudadano, nombre, telefono) VALUES
(1, 'Carlos Gómez', '5551234567'),
(2, 'María López', '5559876543'),
(3, 'Juan Pérez', '5554567890'),
(4, 'Ana Martínez', '5550104567');

-- Inserción en catálogo de áreas operativas
INSERT INTO areas (id_area, nombre_area) VALUES
(1, 'Obras Públicas'),
(2, 'Agua y Alcantarillado'),
(3, 'Alumbrado Público');

-- Inserción de folios y reportes urbanos
INSERT INTO reportes (id_reporte, id_ciudadano, id_area, tipo_problema, colonia, estado) VALUES
(1, 1, 2, 'Fuga de agua', 'Centro', 'En proceso'),
(2, 2, 1, 'Bache profundo', 'Roma Norte', 'Resuelto'),
(3, 3, 3, 'Luminaria fundida', 'Roma Norte', 'Resuelto'),
(4, 1, 1, 'Falta de recolección de basura', 'Centro', 'Pendiente');