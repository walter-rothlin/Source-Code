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
    `last_name`, 
    `first_name`
FROM `sakila`.`actor`;


-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header
SELECT 
        `first_name` AS Vorname,
        `last_name`  AS Nachname
FROM `sakila`.`actor`;


-- 1.3) Sortiert die Resultat-Tabelle von 1.2 nach Nachname, Vorname
SELECT 
        `first_name` AS Vorname,
        `last_name`  AS Nachname
FROM `sakila`.`actor`
ORDER BY
    last_name,
    first_name DESC;


-- 1.4) Liste alle Schauspieler-Nachnamen sortiert auf
SELECT 
        `last_name`  AS Nachname
FROM `sakila`.`actor`
ORDER BY
    last_name;


-- 1.5) Liste alle Schauspieler-Nachnamen auf (jeder Nachname aber nur einmal)
SELECT DISTINCT
        `last_name`  AS Nachname
FROM `sakila`.`actor`
ORDER BY
    last_name;

-- 1.6) Von wie vielen Schauspieler hat es DVD im Store?
SELECT 
        COUNT(`last_name`) AS `Anzahl Schauspieler`
FROM `sakila`.`actor`;

SELECT 
        COUNT(3) AS `Anzahl Schauspieler`
FROM `sakila`.`actor`;


-- 1.7) Wieviele verschiedene Nachnamen gibt es bei den Schauspielern
SELECT 
        COUNT(DISTINCT `last_name`) AS `Anzahl Schauspieler`
FROM `sakila`.`actor`;


-- 1.8) Liste alle Schauspielern (Vorname und Nachname) auf, welche Kirsten zum Vornamen heissen? Sortiere diese
--      nach Nachnamen absteigend und nach Vorname aufsteigend
SELECT 
        `first_name` AS Vorname,
        `last_name`  AS Nachname
FROM `sakila`.`actor`
WHERE `first_name` = 'Kirsten'
ORDER BY
    last_name DESC,
    first_name;


-- 1.9) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICK zum Vornamen heissen oder ein SS im Vornamen haben oder deren Vorname genau 4 Buchstaben lang ist.
--      Sortiert nach first_name und last_name
SELECT 
        `first_name` AS Vorname,
        `last_name`  AS Nachname
FROM `sakila`.`actor`
WHERE `first_name`  LIKE BINARY 'NICK'            OR   -- Nick (case-insensitive)
	   `first_name` LIKE BINARY '%SS%' OR   -- % 0 .. n Zeichen     binary Chase-Sensitive
       `first_name` LIKE '___'              -- _ genau ein Zeichen
ORDER BY
    `last_name` DESC,
    `first_name`;


-- 1.10) Liste alle Schauspielern (Vorname und Nachname) auf, bei welchen der Nachname mit BER beginnt oder deren Vorname mit NA endet
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html
SELECT 
        `first_name` AS Vorname,
        `last_name`  AS Nachname
FROM  `actor`
WHERE `first_name` REGEXP "^BER";


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



-- 13.04.23
DROP VIEW IF EXISTS Adress_liste;
CREATE VIEW Adress_liste AS 
	SELECT 
		a.address  AS Strasse,
		ci.city    AS Ort,
		co.country AS Land
	FROM address AS a
	INNER JOIN city AS ci ON a.city_id = ci.city_id
	INNER JOIN country AS co ON ci.country_id = co.country_id
    ORDER BY ci.city;


SELECT 
    ADRESS_LISTE.Strasse,
    ADRESS_LISTE.Land
FROM (
	SELECT 
		a.address  AS Strasse,
		ci.city    AS Ort,
		co.country AS Land
	FROM address AS a
	INNER JOIN city AS ci ON a.city_id = ci.city_id
	INNER JOIN country AS co ON ci.country_id = co.country_id) AS ADRESS_LISTE;
    
SELECT * FROM adress_liste;


SELECT
     f.title                 AS Film_Titel,
     -- f.language_id AS Sprache_id,
     l.name                  AS Sprache,
     -- f.original_language_id  AS `Original Sprache ID`,
     ol.name                 AS `Original Sprache`
FROM film AS f
INNER JOIN language      AS l  ON f.language_id               = l.language_id
LEFT OUTER JOIN language AS ol ON f.original_language_id      = ol.language_id;


SELECT
    c.city     AS `Stadt NAME`,
    co.country AS Land
FROM city AS c, country AS co
WHERE c.country_id = co.country_id;
