-- ---------------------------------------------------------------------------------------------
-- 2024_A_BZU.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Mit der Klasse erarbeitetes Script
--
-- History:
-- 01-Feb-2024   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

-- Table Counts for sakila
-- -----------------------
SELECT 'Hallo', 'BZU', 5.8, 5*6;

SELECT count(3) AS Count FROM Film;
SELECT count(*) AS Count FROM Film;
SELECT count(film_id) AS Count FROM Film;


SELECT 'Film'    AS `Name`, count(*) AS `Anzahl` FROM `Film`
UNION
SELECT 'Store'   AS `Name`, count(*) AS `Anzahl` FROM `Store`
UNION
SELECT 'Payment' AS `Name`, count(*) AS `Anzahl` FROM `Payment`;


-- SELECT Statement
-- ----------------
SELECT * FROM film;
SELECT
	`F`.`film_id`              AS `ID`, 
    `F`.`title`                AS `Titel`, 
    `F`.`language_id`          AS `Läng Sprache`, 
    `F`.`original_language_id` AS `Org_Lang`,
    `S`.`manager_staff_id`     AS `Manager`
FROM 
	`Film`  AS `F`, 
    `Store` AS `S`;
    


