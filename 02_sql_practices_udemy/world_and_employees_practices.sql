-- ============================================================
-- REPOSICIONAMIENTO DE FUNDAMENTOS SQL Y PRÁCTICAS
-- ARCHIVO: world_and_employees_practices.sql
-- AUTOR: José Humberto García Sánchez
-- DATABASES: world, employees
-- ENTORNO: MySQL 8.0 / MySQL Workbench
-- ============================================================

-- ============================================================
-- SECCIÓN 1: ANÁLISIS DEMOGRÁFICO Y GEOGRÁFICO (world)
-- ============================================================
USE world;

-- 1.1 Proyección con cálculo directo de densidad poblacional
SELECT 
    Name AS 'Pais', 
    Population AS 'Poblacion', 
    SurfaceArea AS 'Superficie_Km2', 
    ROUND(Population / SurfaceArea, 2) AS 'Densidad_Poblacional'
FROM country
WHERE SurfaceArea > 0
ORDER BY Densidad_Poblacional DESC
LIMIT 10;

-- 1.2 Agregación por continente con filtrado de medias elevadas (GROUP BY + HAVING)
SELECT 
    Continent AS 'Continente',
    COUNT(*) AS 'Total_Paises',
    ROUND(AVG(LifeExpectancy), 2) AS 'Esperanza_Vida_Promedio'
FROM country
GROUP BY Continent
HAVING AVG(LifeExpectancy) > 70
ORDER BY Esperanza_Vida_Promedio DESC;

-- 1.3 Subconsulta correlacionada en WHERE
-- Identifica países con área territorial mayor al promedio de su propio continente
SELECT 
    c1.Name AS 'Pais', 
    c1.Continent AS 'Continente',
    c1.SurfaceArea AS 'Superficie'
FROM country c1
WHERE c1.SurfaceArea > (
    SELECT AVG(c2.SurfaceArea) 
    FROM country c2
    WHERE c2.Continent = c1.Continent
);

-- 1.4 Validación de existencia mediante el operador EXISTS
-- Filtra únicamente los países que cuentan con al menos una metrópolis > 8M habitantes
SELECT c.Name AS 'Pais'
FROM country c
WHERE EXISTS (
    SELECT 1
    FROM city ci
    WHERE ci.CountryCode = c.Code
      AND ci.Population > 8000000
);

-- ============================================================
-- SECCIÓN 2: GESTIÓN DE RECURSOS HUMANOS (employees)
-- ============================================================
USE employees;

-- 2.1 Búsqueda de patrones en nombres mediante LIKE
SELECT 
    emp_no AS 'ID_Empleado',
    first_name AS 'Nombre',
    last_name AS 'Apellido',
    hire_date AS 'Fecha_Contratacion'
FROM employees
WHERE first_name LIKE 'P%o'
  AND gender = 'F';

-- 2.2 Unificación de tablas (JOIN) y filtrado contra promedio dinámico
-- Identifica empleados cuyo salario supera el promedio global de la nómina
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS Empleado,
    s.salary AS Salario
FROM employees e
INNER JOIN salaries s 
    ON e.emp_no = s.emp_no
WHERE s.salary > (
    SELECT AVG(salary) 
    FROM salaries
)
ORDER BY s.salary DESC
LIMIT 10;