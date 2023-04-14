-- ---------------------------------------------------------------------------------------------
-- AufgabenLoesungen_1_SELECT.sql
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
-- ---------------------------------------------------------------------------------------------



-- Select mit Order by und Where-Clause
-- ====================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT
    `first_name`,
    `last_name`
FROM `sakila`.`actor`;

-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header
SELECT
    `first_name` AS `Vorname`,
    `last_name`  AS `Nachname`
FROM `actor`;


-- 1.3) Sortiert die Resultat-Tabelle von 1.2 nach Nachname, Vorname
SELECT
    `first_name` AS `Vorname`,
    `last_name`  AS `Nachname`
FROM `actor`
ORDER BY `first_name`, `last_name`;



SELECT
    `first_name` AS `Vorname`,
    `last_name`  AS `Nachname`
FROM `actor`
ORDER BY `Vorname`, `Nachname`;

-- 1.4) Liste alle Schauspieler-Nachnamen sortiert auf
SELECT
    `last_name`  AS `Nachname`
FROM `actor`
ORDER BY `Nachname`;


-- 1.5) Liste alle Schauspieler-Nachnamen auf (jeder Nachname aber nur einmal)
SELECT DISTINCT
    `last_name`  AS `Nachname`
FROM `actor`
ORDER BY `Nachname`;


-- 1.6) Von wie vielen Schauspieler hat es DVD im Store?
SELECT
    COUNT(`last_name`) AS `Anzahl Schauspieler`
FROM `actor`;

SELECT
    COUNT(*) AS `Anzahl Schauspieler`
FROM `actor`;

SELECT
    COUNT(3) AS `Anzahl Schauspieler`
FROM `actor`;

SELECT
    COUNT('Anzahl') AS `Anzahl Schauspieler`
FROM `actor`;

-- 1.7) Wieviele verschiedene Nachnamen gibt es bei den Schauspielern
SELECT
    COUNT(DISTINCT `last_name`) AS `Anzahl Schauspieler`
FROM `actor`;


-- 1.8) Liste alle Schauspielern (Vorname und Nachname) auf, welche Kirsten zum Vornamen heissen? Sortiere diese
--      nach Nachnamen absteigend (Z..A) und nach Vorname aufsteigend (A..Z)
SELECT
    `FIRST_NAME` AS `Vorname`,
    `last_name`  AS `Nachname`
FROM `actor`
WHERE first_name = 'KirsTen'
ORDER BY `Nachname` DESC, `Vorname`;

-- 1.9) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICK zum Vornamen heissen oder ein SS im Vornamen haben oder deren Vorname genau 4 Buchstaben lang ist.
--      Sortiert nach first_name und last_name
SELECT
    `FIRST_NAME` AS `Vorname`,
    `last_name`  AS `Nachname`
FROM `actor`
WHERE first_name = 'NICK' or
	  first_name LIKE BINARY '%SS%' or 
      first_name LIKE  '____' 
ORDER BY `Nachname` DESC, `Vorname`;



-- 1.10) Liste alle Schauspielern (Vorname und Nachname) auf, bei welchen der Nachname mit BER beginnt oder deren Vorname mit NA endet
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html









-- 1.11) Liste film_id, title, rating, special_features von der Tabelle film auf.
--       Was ist der Type der Attribute rating und special_features?








-- 1.12) Erstellen Sie eine Listen der bezahlten Betraege (FROM payment), sortiert nach customer_id und Betraege









-- 1.12.1) Erstellen Sie eine Listen (mit Vor- und Nachnamen) der bezahlten Betraege (FROM payment), sortiert nach customer_id und Betraege   












-- 1.13) Erstellen Sie eine Listen aller Kunden_id mit deren Umsaetzen (FROM payment), sortiert nach customer_id und Betraege   











-- 1.13.1) Erstellen Sie eine Listen aller Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment), sortiert nach customer_id und Betraege   














-- 1.14) Erstellen Sie eine Listen Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit ID < 5














-- 1.14) Erstellen Sie eine Listen Kunden_id mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit einem Umsatz > 170

















-- 1.14.1) Erstellen Sie eine Listen Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit einem Umsatz > 170























-- 1.14.2) Erstellen Sie eine Listen mit allen Staedten und die dazugehoerenden Laender.



-- 14.04.23
-- ========
SELECT
      adr.address        AS Strasse,
      -- adr.city_id     AS Stadt_ID,
      ci.city            AS Stadt,
      -- ci.country_id   AS Land_ID,
      co.country         AS Land
FROM address AS adr
INNER JOIN city    AS ci ON adr.city_id   = ci.city_id
INNER JOIN country AS co ON ci.country_id = co.country_id;

CREATE VIEW film_sprachen AS
	SELECT
		 f.title                   AS Titel,
		 -- f.language_id          AS Sprach_ID,
		 l.name                    AS Sprache,
		 -- f.original_language_id AS Original_Sprache_ID,
		 ol.name                   AS Original_Sprache
	FROM film AS f
	INNER JOIN language      AS l  ON f.language_id           = l.language_id
	LEFT OUTER JOIN language AS ol ON f.original_language_id  = ol.language_id;


SELECT 
	ci.city         AS Stadt,
	ci.country_id   AS Land_ID,
    co.country      AS Land
FROM city AS ci, country AS co
WHERE ci.country_id = co.country_id;



