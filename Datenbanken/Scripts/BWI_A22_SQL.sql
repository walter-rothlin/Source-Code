-- ---------------------------------------------------------------------------------------------
-- AufgabenLoesungen_1_SELECT.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/AufgabenLoesungen_1_SELECT.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Aufgaben und Loesungen zu DML
--
-- History:
-- 04-Apr-2024   Walter Rothlin      Select Lösungen
-- ---------------------------------------------------------------------------------------------



-- Select mit Order by, Where-Clauses and Group by
-- ===============================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT
	first_name  AS `Vor Name`,
	last_name	AS `Nach Name`
FROM actor;

SELECT COUNT(3) AS Count FROM actor;

SELECT 
     2*3      AS Betrag,
     'Hallo'  AS Anrede,
	 first_name
FROM actor;



-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header
SELECT
	`first_name` AS `Vorname`,
	`last_name`	 AS `Nachname`
FROM `actor`;











-- 1.3) Sortiert die Resultat-Tabelle von 1.2 nach Nachname, Vorname


















-- 1.4) Liste alle Schauspieler-Nachnamen sortiert auf








-- 1.5) Liste alle Schauspieler-Nachnamen auf (jeder Nachname aber nur einmal)






-- 1.6) Von wie vielen Schauspieler hat oder hatte der Shop DVDs?















-- 1.7) Wieviele verschiedene Nachnamen gibt es bei den Schauspielern








-- 1.7.1 tbc) Gibt es StÃ¤dte die es in mehreren LÃ¤ndern gibt und wie heissen diese StÃ¤dte?


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











-- 1.13) Erstellen Sie eine Liste mit allen LÃ¤ndern und der Anzahl StÃ¤dte, sortiert nach Anzahl StÃ¤dte 
--       (Das Land mit den meisten StÃ¤dten zu oberst)



















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






















