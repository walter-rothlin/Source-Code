-- ---------------------------------------------------------------------------------------------
-- BWI23_Walter_Rothlin_YYYY_MM_DD.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Script mit Studiengruppe entwickelt und Aufgaben gelöst
--
-- History:
-- 18_Mar-2025   Walter Rothlin      Initial Version
-- 01-Apr-2025   Walter Rothlin	     SELECT-Statment
-- ---------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------
-- SELECT statments
-- ---------------------------------------------------------------------------------------------
UPDATE `actor` 
SET `first_name` = 'Ed', `last_name` = 'Chase' 
WHERE `actor_id` = 3;



SELECT
	 `a`.`actor_id`    AS `ID`,
	 `a`.`first_name`  AS `Vorname`,
	 `a`.`last_name`   AS `Nachname`,
	 `a`.`last_update` AS `Letzmals geändert`,
	 date_format(`a`.`last_update`, '%W %d.%m.%Y %T') AS `Format_1`,
     now() AS Heute
FROM `actor` AS `a`
-- WHERE LEFT(`a`.`first_name`, 1) = 'E'
-- WHERE `actor_id` IN (3, 5, 7)
-- WHERE `a`.`first_name` LIKE BINARY '_E_E%'
-- WHERE date_format(`a`.`last_update`, '%Y') = '2025'
WHERE `a`.`last_update` > STR_TO_DATE('01.02.2025', '%d.%m.%Y')

ORDER BY `actor_id` DESC;


SELECT
     `a`.`first_name`  AS `Vorname`,
	 `a`.`last_name`   AS `Nachname`,
      LEFT(`a`.`first_name`, 1)  AS `Inital`,
      CONCAT(LEFT(`a`.`first_name`, 1), '.', `a`.`last_name`)   AS `Inital_Name`
FROM `actor` AS `a`;

SELECT 
	`Land`, 
    count(`FK`) AS `Anzahl Städte` FROM (
		SELECT
			`ci`.`city_id`    AS `CI_ID`,
			`ci`.`city`       AS `Stadt`,
			co.country    AS `Land`,
			co.country_id AS `CO_ID`,
			ci.country_id AS `FK`
		FROM Country AS co, City AS ci
		WHERE ci.country_id = co.country_id) AS `stadt_land`
GROUP BY `FK`
ORDER BY `Anzahl Städte` DESC;

SELECT
	ci.city_id,
    ci.city
FROM City AS ci;
-- ===============================================
-- Select mit Order by, Where-Clauses and Group by
-- ===============================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?






-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header












-- 1.3) Sortiert die Resultat-Tabelle von 1.2 nach Nachname, Vorname


















-- 1.4) Liste alle Schauspieler-Nachnamen sortiert auf








-- 1.5) Liste alle Schauspieler-Nachnamen auf (jeder Nachname aber nur einmal)






-- 1.6) Von wie vielen Schauspieler hat oder hatte der Shop DVDs?















-- 1.7) Wieviele verschiedene Nachnamen gibt es bei den Schauspielern








-- 1.7.1 tbc) Gibt es Staedte die es in mehreren Laendern gibt und wie heissen diese Staedte?


-- If you need only the duplicates between the result sets of two SELECT statements in MySQL, you can use the INTERSECT operator. 
-- Unfortunately, MySQL doesn't support the INTERSECT operator directly, but you can achieve the same result using JOIN or EXISTS clauses. Here's an example:










-- 1.8) Liste alle Schauspielern (Vorname und Nachname) auf, welche Kirsten zum Vornamen heissen? Sortiere diese
--      nach Nachnamen absteigend (Z..A) und nach Vorname aufsteigend (A..Z)











-- 1.8.1) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICHT Kirsten zum Vornamen heissen oder die Id 10 haben? Sortiere diese
--      nach Nachnamen absteigend (Z..A) und nach Vorname aufsteigend (A..Z)












-- 1.9) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICK zum Vornamen heissen 
--        oder ein SS im Vornamen haben 
--        oder deren Vorname genau 4 Buchstaben lang ist.
--      Sortiert nach first_name und last_name


























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











-- 1.13) Erstellen Sie eine Liste mit allen Laendern und der Anzahl Staedte, sortiert nach Anzahl Staedte 
--       (Das Land mit den meisten Staedten zu oberst)





















-- 1.13.0) Erstellen Sie eine Liste aller Kunden_id mit deren Umsaetzen 
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





















