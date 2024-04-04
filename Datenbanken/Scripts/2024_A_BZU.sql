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
    

-- ---------------------------------------------------------------------------------------------
-- AufgabenLoesungen_1_SELECT.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/AufgabenLoesungen_1_SELECT.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Aufgaben und Loesungen zu DML
--
-- History:
-- 15-May-2020   Walter Rothlin      Initial Version
-- 02-Feb-2021   Walter Rothlin	     Adapted for BWI-A19
-- 09-Jun-2021   Walter Rothlin      Explained "Safe Updates"
-- 18-Jun-2021   Walter Rothlin      Added more functions
-- 18-Feb-2022   Walter Rothlin      Minor changes
-- 11-Mar-2022   Walter Rothlin      Minor corrections
-- 17-Mar-2022	 Walter Rothlin      Added Date_Format Str_To_Date section
-- 20-Mar-2022	 Walter Rothlin      Added DATE and TIME functions
-- 25-Mar-2022	 Walter Rothlin      Added Variablen
-- 10-Feb-2023	 Walter Rothlin      Added SET and ENUM in Where-Clause
-- 16-Feb-2023	 Walter Rothlin      Changed GROUP-BY questions
-- 09-Mar-2023   Walter Rothlin      Changed Lichtenstein auf Andora
-- 04-Apr-2023   Walter Rothlin      Added special types and 1.11.1), 1.8.1)
-- 18-Apr-2023   Walter Rothlin      Added more Fct and Proc and fixed DELIMITER in Fct
-- 25-Apr-2023   Walter Rothlin      Added more Functions 10.3.1 and 10.3.2
-- 28-Apr-2023   Walter Rothlin      Added getAge() Aktuelles Alter berechnen, wenn Todestag dann Alter fixiert, sonst NOW() - Birthday (Nur Jahre)
-- 17-May-2023   Walter Rothlin      Changed LEFT/RIGHT JOIN to LEFT/RIGHT OUTER JOIN
-- ---------------------------------------------------------------------------------------------
INSERT INTO `actor` (`actor_id`, `first_name`, `last_name`) VALUES 
     (201, 'Walter', 'Rothlin'),
     (202, 'Walter', 'Rothlin');


UPDATE `actor` SET `first_name` = 'Walter Max'    WHERE (`actor_id` = 201);
UPDATE `actor` SET `first_name` = 'Walter Albert' WHERE (`actor_id` = 202);

DELETE FROM `actor` WHERE (`actor_id` > 200);

SELECT * FROM `actor`;

-- Select mit Order by, Where-Clauses and Group by
-- ===============================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT
    `first_name` AS `Vorname`,
    `last_name`  As `Nachname`
FROM `actor`;


SELECT
    actor_id,
    first_name,
    last_name,
    DATE_FORMAT(last_update, '%W') AS `Wochentag`,
    DATE_FORMAT(last_update, '%W, %d.%m.%Y') AS `Letze Aenderung`
FROM actor
WHERE DATE_FORMAT(last_update, '%W') != 'Wednesday';


SELECT
	f.film_id                AS Id,
	f.title                  AS Title,
    f.language_id            AS Sprache,
	f.original_language_id   AS Originalsprache
FROM
     film AS f;
     
   
   
DROP VIEW IF EXISTS film_languages;
CREATE VIEW film_languages AS
	SELECT
		 f.film_id        AS Id,
		 f.title          AS Title,
		 lang.`name`      AS Sprache,
		 orgLang.`name`   AS Originalsprache
	FROM
		 film AS f
	INNER      JOIN language AS lang    ON f.language_id          = lang.language_id
	LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;
    
SELECT * FROM film_languages;
