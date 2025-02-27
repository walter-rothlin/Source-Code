-- Owner: Walter Rothlin
-- History:
-- 07-Feb-2025 Walter Rothlin	Initial Version
-- 14-Feb-2025 Walter Rothlin	String-Functions
-- ---------------------------------------------------------------------------

-- Beispiele mit String-Functions
-- ==============================
-- siehe https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT count(*) FROM staff;
SELECT count(staff_id) FROM staff;
SELECT count(3) AS `Anzahl Tuples` FROM `staff`;

SELECT
	`first_name` AS `Vorname`,
    CONCAT(UPPER(LEFT(`first_name`, 1)), '.')        AS `Initial`,
	`last_name`  AS `Nachname`,
    CONCAT(UPPER(LEFT(`first_name`, 1)), '.',`last_name`) AS `Initial_Nachname`
FROM `staff`
WHERE CONCAT(UPPER(LEFT(`first_name`, 1)), '.') = 'J.';


-- Select mit Order by, Where-Clauses and Group by
-- ===============================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT 
	`first_name` AS `Vorname`,
    `last_name`  AS `Nachname`
 FROM `Actor`;


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













