-- ---------------------------------------------------------------------------------------------
-- 2024_B_BZU.sql
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
SELECT 'Film' AS `Table`, count(*) AS `Count` FROM `film`
UNION
SELECT 'Store' AS `Table`, count(*) AS `Count` FROM `store`;



-- SELECT Statement
-- ----------------
SELECT 'Hallo' AS `Anrede`, 'BZU!' AS `Wer`, 5.56 AS `Betrag`, 7*8 AS `Total Betrag`;
SELECT * FROM film;
SELECT
	`film_id`               AS `ID`, 
    `title`                 AS `Titel`,
    `language_id`           AS `Sprache`, 
    `original_language_id`  AS `Original Sprache`
FROM `film`;

