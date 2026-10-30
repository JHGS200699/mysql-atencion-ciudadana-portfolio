# Sistema de Gestión y Analítica de Atención Ciudadana (MySQL)

## Contexto del Proyecto y Problemática Operativa
El crecimiento urbano en los municipios genera un flujo constante de reportes de incidencias públicas (fugas de agua potable, baches, fallas en alumbrado público y recolección de residuos). Sin un sistema centralizado, los gobiernos locales enfrentan cuellos de botella en la asignación de folios, falta de visibilidad en los tiempos de respuesta (SLA) y dificultad para identificar zonas con infraestructura crítica recurrente.

Este proyecto implementa una solución de base de datos relacional y capa analítica en MySQL orientada a:
1. Normalizar el registro e integración de ciudadanos, catálogos operativos y reportes urbanos.
2. Automatizar el ruteo de incidencias hacia las dependencias municipales correspondientes.
3. Proporcionar consultas de analítica descriptiva y diagnóstica para la toma de decisiones basada en datos.

---

## Arquitectura de Datos y Modelo Relacional
La base de datos está diseñada bajo la Tercera Forma Normal (3NF) para garantizar la integridad referencial y eliminar redundancias.

### Entidades Principales:
* **`ciudadanos`**: Registro central de reportantes (Padrón municipal).
  * `id_ciudadano` (INT, PK, AUTO_INCREMENT)
  * `nombre` (VARCHAR)
  * `telefono` (VARCHAR)
* **`areas`**: Catálogo de dependencias operativas municipales encargadas del mantenimiento.
  * `id_area` (INT, PK, AUTO_INCREMENT)
  * `nombre_area` (VARCHAR)
* **`reportes`**: Tabla de hechos central que consolida los folios recibidos.
  * `id_reporte` (INT, PK, AUTO_INCREMENT)
  * `id_ciudadano` (INT, FK -> ciudadanos.id_ciudadano)
  * `id_area` (INT, FK -> areas.id_area)
  * `tipo_problema` (VARCHAR)
  * `colonia` (VARCHAR)
  * `estado` (ENUM/VARCHAR: 'Pendiente', 'En proceso', 'Resuelto')

---

## Estructura del Repositorio

```text
mysql-atencion-ciudadana-portfolio/
├── 01_esquema_y_datos.sql      <-- DDL & DML: Definición de esquemas, llaves foráneas e inserción de datos
├── 02_consultas_avanzadas.sql  <-- DQL: Consultas complejas, subconsultas y análisis de negocio
└── README.md                   <-- Documentación técnica ejecutiva