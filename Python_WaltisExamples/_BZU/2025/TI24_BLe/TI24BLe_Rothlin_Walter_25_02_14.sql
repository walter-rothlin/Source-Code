-- Owner: Walter Rothlin
-- History:
-- 07-Feb-2025 Walter Rothlin	Initial Version
-- 14-Feb-2025 Walter Rothlin	String-Functions
-- ---------------------------------------------------------------------------

-- ==============================
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


-- ===============================================
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



-- ===========================
-- Select mit Functions-Aufruf
-- ===========================
-- https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html
-- https://dev.mysql.com/doc/refman/5.7/en/retrieving-data.html
-- https://dev.mysql.com/doc/refman/5.7/en/json-creation-functions.html#function_json-array
-- https://dev.mysql.com/doc/refman/5.7/en/case.html
-- https://dev.mysql.com/doc/refman/5.7/en/pattern-matching.html
-- https://www.w3schools.com/sql/sql_join.asp


-- 2.2) liste alle Schauspielern (Vorname, Nachname und LAST_UPDATE [yyyy-mon-dd]), 
--      bei welchen der Vorname mit A beginnt und der zweitletzte Buchstabe im Vornamen ebenfalls  ein A ist
--      sowie der Nachname ALLEN oder BAILEY ist.
















-- 2.3) Listen Sie nur die Rows auf, welche im rating eine PG haben und in den special_features Trailes enthalten.











-- 2.4) Erstellen Sie eine Liste mit allen Namen und Vorname von staff, welche nur den Anfangsbuchstaben des Vornamen mit einem . getrennt vom vollstaendigen Nachnamen auflistet.
--      https://dev.mysql.com/doc/refman/5.7/en/string-functions.html





-- 2.5) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme? Liste diese in einer JSON Struktur auf!
--       https://dev.mysql.com/doc/refman/5.7/en/json-creation-functions.html#function_json-array





-- 2.6) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme? 
--       Uebersetze den Name ED zu Edi und KARL zu Kari!
--       https://dev.mysql.com/doc/refman/5.7/en/case.html











-- 2.7) Erstellen Sie eine Liste aller Filme mit den Originalsprachen (nur FK). Anstelle von NULL soll "Not defined" stehen




















