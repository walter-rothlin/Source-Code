-- ---------------------------------------------------------------------------------------------
-- 2023_BWI_A21.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/2023_BWI_A21.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Aufgaben und Loesungen zu DML
--
-- History:
-- 04-Apr-2023   Walter Rothlin      Initial Version (Select)
-- 11-Apr-2023   Walter Rothlin		 Joins
-- ---------------------------------------------------------------------------------------------



-- Select mit Order by, Where-Clauses and Group by
-- ===============================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT
     first_name,
     last_name
FROM actor;

-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header
SELECT
     `first_name` AS `Vorname`,
     `last_name`  AS `Nachname`
FROM `sakila`.`actor`;


-- 1.3) Sortiert die Resultat-Tabelle von 1.2 nach Nachname, Vorname
SELECT
     `first_name` AS `Vorname`,
     `last_name`  AS `Nachname`
FROM `actor`
ORDER BY `Nachname`, `Vorname`;


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

-- 1.6) Von wie vielen Schauspieler hat oder hatte es eine DVD?
SELECT
     COUNT(`last_name`) AS Anzahl 
FROM `actor`;

SELECT
     COUNT(3) AS Anzahl 
FROM `actor`;

-- 1.7) Wieviele verschiedene Nachnamen gibt es bei den Schauspielern
SELECT
    COUNT( DISTINCT `last_name`) AS Anzahl 
FROM `actor`;

-- 1.8) Liste alle Schauspielern (Vorname und Nachname) auf, welche Kirsten zum Vornamen heissen? Sortiere diese
--      nach Nachnamen absteigend (Z..A) und nach Vorname aufsteigend (A..Z)
SELECT 
    `first_name`  AS `Vorname`, 
    `last_name`   AS `Nachname`
FROM
    `actor`
WHERE
    `first_name` = 'Kirsten'
ORDER BY
    `last_name` DESC,
    `first_name`;

-- 1.9) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICK zum Vornamen heissen 
--        oder ein SS im Vornamen haben 
--        oder deren Vorname genau 4 Buchstaben lang ist.
--      Sortiert nach first_name und last_name
SELECT 
    first_name AS FName,
    last_name  AS LName
FROM 
    actor
WHERE
    -- in where-clause koennen keine Alias verwendet werden
    -- FName      = 'NICK'            OR
    first_name = 'NICK'           OR   -- Nick (case-insensitive)
    first_name LIKE BINARY '%SS%' OR   -- % 0 .. n Zeichen     binary Chase-Sensitive
    first_name LIKE '___'              -- _ genau ein Zeichen
ORDER BY
    FName,   -- hier koennen ALIAS verwendet werden
    LName;


-- 1.10) Liste alle Schauspielern (Vorname und Nachname) auf, 
--       bei welchen der Nachname mit BER beginnt oder deren Vorname 
--       mit NA endet
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html




-- 1.11) Liste film_id, title, rating, special_features von der Tabelle film 
--       auf. Was ist der Type der Attribute rating und special_features?




-- 1.11.1) Liste film_id, title, rating, special_features von der Tabelle film 
--       auf. Filtern Sie wo rating PG und special_features Trailers sind?


-- 1.12) Erstellen Sie eine Liste der bezahlten Betraege (FROM payment), 
--       sortiert nach Betraege




-- 1.12.1) Erstellen Sie eine Liste (mit Vor- und Nachnamen) der bezahlten 
--         Betraege (FROM payment), sortiert nach Betraege   
SELECT 
     P.customer_id AS Cust_ID,
     C.first_name  AS Vornamne,
     C.last_name   AS Nachname,
     sum(`P`.`amount`)    AS `Betrag`,
     count(`P`.`amount`)  AS `Anzahl Kaeufe`
 FROM payment AS P
 INNER JOIN customer AS C ON P.customer_id = C.customer_id
 GROUP BY P.customer_id
 ORDER BY Betrag DESC;










-- 1.13) Erstellen Sie eine Liste aller Kunden_id mit deren Umsaetzen 
--       und Anzahl Rechnungen (FROM payment), sortiert nach customer_id und Betraege   








-- 1.13.1) Erstellen Sie eine Liste aller Kunden_id, Vor- und Nachnamen 
-- mit deren Umsaetzen und Anzahl Rechnungen (FROM payment), 
-- sortiert nach Umsaetzen (hoechster zu oberst).
-- Wer sind unsere 'besten' (umsatzstaerksten) Kunden












-- 1.13.2) Erstellen Sie eine Liste Kunden_id, Vor- und Nachnamen mit 
--         deren Umsaetzen (FROM payment), ordnen Sie die Liste nach den 
--         Umsaetzen (Bester Kunde zuoberst)
--         Nur von den Kunden mit ID < 5













-- 1.13.3) Erstellen Sie eine Liste mit Kunden_id mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit einem Umsatz > 170













-- 1.13.4) Erstellen Sie eine Liste Kunden_id, Vor- und Nachnamen mit 
--         deren Umsaetzen (FROM payment), ordnen Sie die Liste nach den 
--         Umsaetzen (Bester Kunde zuoberst)
--         Nur von den Kunden mit einem Umsatz > 170



















-- 1.14.1) Erstellen Sie eine Listen mit allen Staedten und die dazugehoerenden Laender.



-- ============================
-- Joins in der Lektion 11.4.23
-- ============================
SELECT
     ci.city_id     AS ID,
     ci.city        AS Ortsname,
     -- ci.country_id  AS Land_ID,
     co.country     AS Landesname
FROM city AS ci
INNER JOIN country AS co ON ci.country_id = co.country_id;

SELECT
     ci.city_id     AS ID,
     ci.city        AS Ortsname,
     -- ci.country_id  AS Land_ID,
     co.country     AS Landesname
FROM city AS ci, country AS co
WHERE ci.country_id = co.country_id;

DROP VIEW IF EXISTS film_languages;
CREATE VIEW film_languages AS 
	SELECT 
		 f.film_id     AS Film_ID,
		 f.title       AS Titel,
		 -- f.language_id AS Sprache_ID,
		 -- f.original_language_id AS Original_Sprache,
		 l.name        AS Sprache,
		 ol.name       AS Original_Sprache
	FROM film AS f
	INNER JOIN language AS l ON f.language_id = l.language_id
	LEFT OUTER JOIN language AS ol ON f.original_language_id = ol.language_id;
	-- WHERE l.name != 'English';


SELECT * FROM language;