-- START title
-- ================================
-- Aufgaben-Sammlung (AufgabenLoesungen_1_SELECT_2019_04_04.sql)
-- ================================
-- END title


-- START erd
-- Fragen zum ERD
-- -    Listen Sie alle Attribut-Typen auf die Sie finden. Gibt es ihnen unbekannte?
-- -    Machen Sie eine Liste der Symbole, Farben vor den Attribute Namen und deren Bedeutung.
-- -    Suchen Sie folgende Beziehungen:
--     o    1  :  1..n
--     o    1 : 0..n
--     o    m : n
-- -    Was bedeuten die zwei Relationen (Beziehungen) zwischen language und film?
-- -    Wieso steht die Tabelle film_text in keiner Beziehung zu einer anderen Tabelle?

-- -    Mit der Work-Bench koennen Sie aus einer DB ein ERD durch Reverse Engineering erzeugen. Machen Sie das mit Database --> Reverse Engineering...
-- END erd


-- START select
-- Select mit Order by und Where-Clause
-- ====================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT 
    first_name,
    last_name
FROM
    actor;

-- 1.2) Beschrifte die Resultat-Tabelle mit Vorname und Nachname als Spalten-Header
SELECT 
    first_name AS Vorname,
    last_name  AS Nachname
FROM
    sakila.actor AS act;

-- 1.3) sortiert nach Nachname, Vorname
SELECT 
    first_name AS Vorname, 
    last_name  AS Nachname
FROM
    actor
ORDER BY 
    last_name,
    first_name;

SELECT 
    first_name AS Vorname,
    last_name  AS Nachname
FROM
    actor
ORDER BY 
    Nachname,
    Vorname;

-- 1.4) liste alle Schauspieler-Nachnamen sortiert auf
SELECT 
    last_name AS Nachname
FROM
    actor
ORDER BY
    Nachname;


-- 1.5) liste alle Schauspieler-Nachnamen auf (jeder Nachname aber nur einmal)
SELECT DISTINCT
    last_name AS Nachname
FROM
    actor
ORDER BY Nachname;

-- 1.6) von wie viele Schauspieler hat es DVD im Store?
SELECT 
    COUNT(3)      -- COUNT(last_name)
FROM
    actor;    -- 200

-- 1.7) wieviele verschiedene Nachnamen gibt es bei den Schauspielern
SELECT 
    COUNT(DISTINCT last_name)
FROM
    actor
ORDER BY last_name , first_name;  -- 121

-- 1.8) liste alle Schauspielern (Vorname und Nachname) auf, welche Kirsten zum Vornamen heissen? Sortiere diese
--      nach Nachnamen und absteigend nach Vorname 
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    first_name = 'Kirsten'
ORDER BY
    last_name,
    first_name DESC;


-- 1.9) Alle die NICK zum Vornamen heissen oder ein SS im Vornamen haben oder deren Vorname genau 4 Buchstaben lang ist.
--      Sortiert nach first_name und last_name
SELECT 
    first_name AS FName,
    last_name  AS LName
FROM 
    actor
WHERE
    -- in where-clause können keine Alias verwendet werden     
    -- FName      = 'NICK'            OR
    first_name = 'NICK'           OR   -- Nick (case-insensitive)
    first_name like binary '%SS%' OR   -- % 0 .. n Zeichen     binary Chase-Sensitive
    first_name like '___'              -- _ genau ein Zeichen
ORDER BY
	FName,   -- hier koennen ALIAS verwendet werden
    LName;

    
-- 1.10) ... alle bei denen der Nachname mit BER beginnt oder deren Vorname mit NA endet
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html
SELECT 
    first_name AS FName,
    last_name  AS LName
FROM
    actor
WHERE    
    last_name  regexp binary "^BER"  OR
    first_name regexp binary "NA$";
    
-- 1.11) Liste film_id, title, rating, special_features von der Tabelle film auf.
--       Was ist der Type der Attribute rating und special_features?
SELECT 
    film_id,
    title,
    rating,
    special_features
FROM
    film;
    
-- 1.12) Erstellen Sie eine Listen aller Kunden_id mit deren Umsaetzen
SELECT 
   customer_id,
   sum(amount)
FROM 
   payment
GROUP BY
   customer_id;
   
-- 1.13) ... ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
SELECT 
   customer_id    AS Kunden_ID,
   sum(amount)    AS Umsatz
FROM 
   payment
GROUP BY
   customer_id
Order BY
   Umsatz DESC;
   