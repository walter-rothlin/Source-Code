-- START title

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
-- ---------------------------------------------------------------------------------------------

-- END title


-- START erd
-- Fragen zum ERD
-- -    Listen Sie alle Attribut-Typen auf die Sie finden. Gibt es ihnen unbekannte?
-- -    Machen Sie eine Liste der Symbole, Farben vor den Attribute Namen und deren Bedeutung.
-- -    Suchen Sie folgende Beziehungen:
--     o    1 : 1..n
--     o    1 : 0..n
--     o    m : n
-- -    Was bedeuten die zwei Relationen (Beziehungen) zwischen language und film?
-- -    Wieso steht die Tabelle film_text in keiner Beziehung zu einer anderen Tabelle?

-- -    Mit der Work-Bench koennen Sie aus einer DB ein ERD durch Reverse Engineering erzeugen. Machen Sie das mit Database --> Reverse Engineering...
-- END erd


-- START select
-- Select mit Order by, Where-Clauses and Group by
-- ===============================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT 
    first_name,
    last_name
FROM
    actor;

-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header
SELECT 
    `sakila`.`act`.`first_name` AS `Vorname`,
    last_name  AS Nachname
FROM
    sakila.actor AS act;

-- 1.3) Sortiert die Resultat-Tabelle von 1.2 nach Nachname, Vorname
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

-- 1.4) Liste alle Schauspieler-Nachnamen sortiert auf
SELECT 
    last_name AS Nachname
FROM
    actor
ORDER BY
    Nachname;


-- 1.5) Liste alle Schauspieler-Nachnamen auf (jeder Nachname aber nur einmal)
SELECT DISTINCT
    last_name AS Nachname
FROM
    actor
ORDER BY Nachname;

-- 1.6) Von wie vielen Schauspieler hat oder hatte es eine DVD?
SELECT 
    COUNT(last_name)
FROM
    actor;    -- 200

SELECT 
    COUNT(*)
FROM
    actor;    -- 200
    
SELECT 
    COUNT(3)      -- COUNT(last_name)
FROM
    actor;    -- 200

-- 1.7) Wieviele verschiedene Nachnamen gibt es bei den Schauspielern
SELECT 
    COUNT(DISTINCT last_name)
FROM
    actor
ORDER BY 
    last_name,
    first_name;  -- 121

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

-- 1.8.1) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICHT Kirsten zum Vornamen heissen oder die Id 10 haben? Sortiere diese
--      nach Nachnamen absteigend (Z..A) und nach Vorname aufsteigend (A..Z)
SELECT 
    `first_name`  AS `Vorname`, 
    `last_name`   AS `Nachname`
FROM
    `actor`
WHERE
    `first_name` != 'Kirsten' OR
     `actor_id` = 10
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
    
SELECT 
	`act`.`first_name` AS `Vorname`,
	`act`.`last_name`  AS `Nachname`
FROM `sakila`.`actor`  AS `act`
WHERE `act`.`first_name` LIKE BINARY 'NICK'            OR   -- Nick (case-insensitive)
	  `act`.`first_name` LIKE BINARY '%SS%' OR   -- % 0 .. n Zeichen     binary Chase-Sensitive
	  `act`.`first_name` LIKE '___'              -- _ genau ein Zeichen
ORDER BY
    `Nachname` DESC,  -- hier koennen ALIAS verwendet werden
    `act`.`first_name`; 
    
-- 1.10) Liste alle Schauspielern (Vorname und Nachname) auf, 
--       bei welchen der Nachname mit BER beginnt oder deren Vorname 
--       mit NA endet
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html
SELECT 
    `ac`.`first_name` AS `FName`,
    `ac`.`last_name`  AS `LName`
FROM `actor` AS `ac`
WHERE    
    `ac`.`last_name`  REGEXP '^BER'  OR
    `ac`.`first_name` REGEXP 'NA$';
	-- `ac`.`last_name`  LIKE 'BER%'  OR
    -- `ac`.`first_name` LIKE '%NA';
    
-- 1.11) Liste film_id, title, rating, special_features von der Tabelle film 
--       auf. Was ist der Type der Attribute rating und special_features?
SELECT 
    `film_id`,
    `title`,
    `rating`,            -- Enumeration
    `special_features`   -- Set / Menge
FROM
    `film`;
    
SELECT 
    `film_id`,
    `title`,
    `rating`,            -- Enumeration
    `special_features`   -- Set / Menge
FROM
    `film`
WHERE `rating` = 'PG';

SELECT 
    `film_id`,
    `title`,
    `rating`,            -- Enumeration
    `special_features`   -- Set / Menge
FROM
    `film`
WHERE FIND_IN_SET('Commentaries', `special_features`) > 0 OR FIND_IN_SET('Trailers', `special_features`) > 0;

-- 1.11.1) Liste film_id, title, rating, special_features von der Tabelle film 
--       auf. Filtern Sie wo rating PG und special_features Trailers sind?
SELECT
    film_id, 
    title, 
    rating,          -- enum
    special_features -- set
FROM 
    film
WHERE
    rating = 'PG' AND    -- e.g. Parental Guidance (Amerikanische Alterbeschränkung)
    find_in_set('Trailers', special_features);


-- 1.12) Erstellen Sie eine Liste der bezahlten Betraege (FROM payment), 
--       sortiert nach Betraege
SELECT 
   `P`.`customer_id`  AS `Customer_ID`,
   `P`.`amount`       AS `Betrag`
FROM 
   `payment` AS `P`
ORDER BY
   `Customer_ID`,
   `Betrag`         DESC;

-- 1.12.1) Erstellen Sie eine Liste (mit Vor- und Nachnamen) der bezahlten 
--         Betraege (FROM payment), sortiert nach Betraege   
SELECT
   `C`.`first_name`   AS `Vorname`,
   `C`.`last_name`    AS `Nachname`,
   `P`.`customer_id`  AS `FK`,
   `P`.`amount`       AS `Betrag`
FROM 
   `payment` AS `P`
INNER JOIN `customer` AS `C` ON `P`.`customer_id` = `C`.`customer_id`
ORDER BY
   `Betrag`    DESC;

-- 1.13) Erstellen Sie eine Liste aller Kunden_id mit deren Umsaetzen 
--       und Anzahl Rechnungen (FROM payment), sortiert nach customer_id und Betraege   
SELECT 
   `P`.`customer_id`    AS `Customer_ID`,
   sum(`P`.`amount`)    AS `Betrag`,
   count(`P`.`amount`)  AS `Anzahl Kaeufe`
FROM `payment` AS `P`
GROUP BY `P`.`customer_id`
ORDER BY `Betrag`;

-- 1.13.1) Erstellen Sie eine Liste aller Kunden_id, Vor- und Nachnamen 
-- mit deren Umsaetzen und Anzahl Rechnungen (FROM payment), 
-- sortiert nach Umsaetzen (hoechster zu oberst).
-- Wer sind unsere 'besten' (umsatzstaerksten) Kunden
SELECT
   `C`.`first_name`     AS `Vorname`,
   `C`.`last_name`      AS `Nachname`,
   -- `P`.`customer_id` AS `Customer_ID`,
   sum(`P`.`amount`)    AS `Umsatz`,
   count(`P`.`amount`)  AS `Anzahl Kaeufe`,
   avg(`P`.`amount`)    AS `Durchschnitt`
FROM `payment` AS `P`
INNER JOIN `customer` AS `C` ON `P`.`customer_id` = `C`.`customer_id`
GROUP BY `P`.`customer_id`
ORDER BY `Umsatz`  DESC;
   
-- 1.13.2) Erstellen Sie eine Liste Kunden_id, Vor- und Nachnamen mit 
--         deren Umsaetzen (FROM payment), ordnen Sie die Liste nach den 
--         Umsaetzen (Bester Kunde zuoberst)
--         Nur von den Kunden mit ID < 5
SELECT
   `C`.`first_name`     AS `Vorname`,
   `C`.`last_name`      AS `Nachname`,
   -- `P`.`customer_id` AS `Customer_ID`,
   sum(`P`.`amount`)    AS `Umsatz`,
   count(`P`.`amount`)  AS `Anzahl Kaeufe`,
   avg(`P`.`amount`)    AS `Durchschnitt`
FROM `payment` AS `P`
INNER JOIN `customer` AS `C` ON `P`.`customer_id` = `C`.`customer_id`
WHERE `P`.`customer_id` < 5
GROUP BY `P`.`customer_id`
ORDER BY `Umsatz`  DESC;
   
-- 1.13.3) Erstellen Sie eine Liste mit Kunden_id mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit einem Umsatz > 170
SELECT 
    `UmsatzListe`.`Kunden_ID` AS `Kunde`,
    `UmsatzListe`.`Umsatz`    AS `Sales`
FROM (
    SELECT 
       `P`.`customer_id` AS `Kunden_ID`,
       sum(`P`.`amount`) AS `Umsatz`
    FROM `payment` AS `P`
    GROUP BY `P`.`customer_id`
    ORDER BY `Umsatz`    DESC) AS `UmsatzListe`
WHERE
    `UmsatzListe`.`Umsatz` > 170;

-- 1.13.4) Erstellen Sie eine Liste Kunden_id, Vor- und Nachnamen mit 
--         deren Umsaetzen (FROM payment), ordnen Sie die Liste nach den 
--         Umsaetzen (Bester Kunde zuoberst)
--         Nur von den Kunden mit einem Umsatz > 170
SELECT 
    `UmsatzListe`.`Vorname`   AS `Firstname`,
    `UmsatzListe`.`Nachname`  AS `Lastname`,
    `UmsatzListe`.`Kunden_ID` AS `Kunde`,
    `UmsatzListe`.`Umsatz`    AS `Sales`
FROM (
    SELECT
       `C`.`first_name`      AS `Vorname`,
       `C`.`last_name`       AS `Nachname`,
       `P`.`customer_id`     AS `Kunden_ID`,
       sum(`P`.`amount`)     AS `Umsatz`
    FROM `payment` AS `P`
    LEFT OUTER JOIN `customer` AS `C` on `C`.`customer_id` = `P`.`customer_id`
    GROUP BY `P`.`customer_id`
    ORDER BY `Umsatz`    DESC) AS `UmsatzListe`
WHERE
    `UmsatzListe`.`Umsatz` > 170;
    

-- 1.14.1) Erstellen Sie eine Listen mit allen Staedten und die dazugehoerenden Laender.
SELECT
	`CI`.`city`    AS `Stadt`,
    `CO`.`country` AS `Land`
FROM  `city` as `CI`
INNER JOIN `country` AS `CO` ON `CI`.`country_id` = `CO`.`country_id`;

SELECT
	A.city AS Stadt,
    B.country AS Land
FROM city as A
INNER JOIN country AS B ON A.country_id = B.country_id;

SELECT
	A.city AS Stadt,
    B.country AS Land
FROM
	city as A
LEFT OUTER JOIN country AS B ON A.country_id = B.country_id;


-- END select

-- START date_functions
-- Date_Format() Str_To_Date()
-- ===========================
-- https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html
--
-- %a     Abbreviated weekday name (Sun..Sat)
-- %b     Abbreviated month name (Jan..Dec)
-- %c     Month, numeric (0..12)
-- %D     Day of the month with English suffix (0th, 1st, 2nd, 3rd, …)
-- %d     Day of the month, numeric (00..31)
-- %e     Day of the month, numeric (0..31)
-- %f     Microseconds (000000..999999)
-- %H     Hour (00..23)
-- %h     Hour (01..12)
-- %I     Hour (01..12)
-- %i     Minutes, numeric (00..59)
-- %j     Day of year (001..366)
-- %k     Hour (0..23)
-- %l     Hour (1..12)
-- %M     Month name (January..December)
-- %m     Month, numeric (00..12)
-- %p     AM or PM
-- %r     Time, 12-hour (hh:mm:ss followed by AM or PM)
-- %S     Seconds (00..59)
-- %s     Seconds (00..59)
-- %T     Time, 24-hour (hh:mm:ss)
-- %U     Week (00..53), where Sunday is the first day of the week; WEEK() mode 0
-- %u     Week (00..53), where Monday is the first day of the week; WEEK() mode 1
-- %V     Week (01..53), where Sunday is the first day of the week; WEEK() mode 2; used with %X
-- %v     Week (01..53), where Monday is the first day of the week; WEEK() mode 3; used with %x
-- %W     Weekday name (Sunday..Saturday)
-- %w     Day of the week (0=Sunday..6=Saturday)
-- %X     Year for the week where Sunday is the first day of the week, numeric, four digits; used with %V
-- %x     Year for the week, where Monday is the first day of the week, numeric, four digits; used with %v
-- %Y     Year, numeric, four digits
-- %y     Year, numeric (two digits)
-- %%     A literal % character
--

-- 2.1.1.0 Testen und analysieren Sie folgende Statements:

-- SELECT STR_TO_DATE('01,5,2013','%d,%m,%Y');
--  SELECT
--	language_id AS ID,
--    `name` AS Sprache,
--    last_update AS Last_Update,
--    DATE_FORMAT(last_update,'%d.%m.%Y %T') AS `Changed on`,
--	DATE_FORMAT(last_update,'%M') AS `Changed in Month`,
--    DATE_FORMAT(STR_TO_DATE('17.03.2023','%d.%m.%Y'),'%d.%m.%Y %T') AS `17.3.2023`,
--    DATE_FORMAT(NOW() ,'%d.%m.%Y %T') AS today,
--    DATE_FORMAT(last_update,'%d.%m.%Y') AS last_Update_Day
-- FROM language
-- -- WHERE DATE_FORMAT(last_update,'%d.%m.%Y') = DATE_FORMAT(STR_TO_DATE('17.03.2023','%d.%m.%Y'),'%d.%m.%Y')
-- WHERE DATE_FORMAT(last_update,'%d.%m.%Y') = DATE_FORMAT(NOW(),'%d.%m.%Y')
-- ORDER BY last_update DESC;


-- 2.1.1) liste alle Mitarbeiter (staff) mit (Vorname, Nachname und LAST_UPDATE im format [yyyy-mon-dd hh:mm:ss]) auf, 
--        sowie den entsprechenden Wochentag,
--        wann die Daten-Saetze geaendert wurden. Sortiere nach Aenderungs-Datum.
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d %T') AS LastUpdate,  -- e.g. 2006-February-15 04:34:33
    DAYNAME(last_update) AS Weekday
FROM
    staff
ORDER BY last_update;

-- andere Variante    
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d %d:%m:%Y') AS LastUpdate,  -- e.g. 2006-February-15 15:02:2006
    DAYNAME(last_update) AS Weekday
FROM
    staff
ORDER BY last_update;


-- 2.1.2) Suchen Sie in actor nach Eintraegen, welche am 15.2.2006 geaendert wurden. 
--        Verwenden Sie STR_TO_DATE in where clause (Effizienter als mit DATE_FORMAT!)
--        last_update e.g. 2006-02-15 03:57:16 --> 2006-February-15 and Wednesday
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d') AS LastUpdate,
    DAYNAME(last_update) AS Weekday
FROM
    staff
WHERE 
    date(last_update) = STR_TO_DATE('February 15, 2006','%M %d,%Y');


-- 2.1.2.1) last_update e.g. 2006-02-15 03:57:16 --> 3 AM Uhr 57
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%l %p Uhr %i') FROM staff;

-- 2.1.2.2) last_update e.g. 2006-02-15 03:57:16 --> 3 Uhr 57
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%k Uhr %i') FROM staff;

-- 2.1.2.3) last_update e.g. 2006-02-15 03:57:16 --> Treffpunkt: Wednesday 03:57 am See
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, 'Treffpunkt: %W %h:%m am See') FROM staff;

-- 2.1.2.4) last_update e.g. 2006-02-15 03:57:16 --> 20060215035716
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%Y%m%d%h%i%s') FROM staff;

-- 2.1.2.5) last_update e.g. 2006-02-15 03:57:16 --> 20060215--035716
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%Y%m%d--%h%i%s') FROM staff;

-- 2.1.2.6) last_update e.g. 2006-02-15 03:57:16 --> 03:57:16 AM
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%r') FROM staff;
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%h:%i:%s %p') FROM staff;

-- 2.1.2.7) last_update e.g. 2006-02-15 03:57:16 --> 03-57 AM
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%h-%i %p') FROM staff;


-- 2.1.3) Machen Sie einen neue Eintraege in der staff Tabelle mit ihren Angaben.
-- ------------------------------------------------------------------------------
--        Erstellen Sie weiter ein SQL fuer einen Update und Delete dieses Tabelle / Eintrages
--        und testen Sie ihre Loesungen



-- 2.1.3.1) SELECT staff_id, first_name, last_name,DATE_FORMAT(last_update) im Date-Format e.g.: Wed, 15.Feb 2006 03-57-16
--          Sortiere nach Aenderungs-Datum.
SELECT
    staff_id,
    first_name,
    last_name,
    DATE_FORMAT(last_update, '%a, %d.%b %Y %H-%i-%s')  -- Wed, 15.Feb 2006 03-57-16
FROM staff
ORDER BY last_update;


-- 2.1.3.2) SELECT staff_id, first_name, last_name,DATE_FORMAT(last_update) im Date-Format e.g.: 2006-February-15
--          Filtere nach einem bestimmten Aenderungs-Datum. Sortiere nach Aenderungs-Datum.
--          Verwenden Sie DATE_FORMAT in where clause (Nicht so effizient! Wieso?)
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d') AS LastUpdate,  -- e.g. 2006-February-15
    DAYNAME(last_update) AS Weekday
FROM
    staff
WHERE 
    DATE_FORMAT(last_update, '%Y-%M-%d') = '2006-February-15'
ORDER BY last_update;


-- 2.1.3.3) SELECT staff_id, first_name, last_name,DATE_FORMAT(last_update) im Date-Format e.g.: Wed, 15.Feb 2006 03-57-16
--          Filtere nach einem bestimmten Aenderungs-Datum. Sortiere nach Aenderungs-Datum.
--          Verwenden Sie STR_TO_DATE() in where clause (Effizienter! Wieso?)
SELECT
    staff_id,
    first_name,
    last_name,
    DATE_FORMAT(last_update, '%a, %d.%b %Y %H-%i-%s')  -- e.g. Fri, 18.Mar 2022 00-00-00
FROM staff
WHERE last_update >= STR_TO_DATE('18.03.2022','%d.%m.%Y') AND
      last_update <  STR_TO_DATE('19.03.2022','%d.%m.%Y')
ORDER BY last_update;


-- 2.1.3.4) Suchen Sie alle Eintraege in der Tabelle staff, welche am 17. Maerz 22 geaendert wurden
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%d.%M %Y %H:%i:%s') FROM staff
WHERE DATE_FORMAT(last_update, '%d.%m.%Y') = '17.03.2022' ORDER BY last_update;


-- 2.1.3.5) Fuegen sie zwei neuen Daten-Saetze hinzug und definieren Sie den PK 200, 201
--          und ueberpruefe mit den SELECTS das Resultat (checken sie last_update)
INSERT INTO 
       staff
       (staff_id, first_name, last_name, address_id, email           , username     , store_id, active) VALUES 
       (200     ,'Felix'    , 'Meier'  , 4         , 'Felix@meier.ch', 'felix.meier', 2       , 1),
       (201     ,'Felix 1'  , 'Meier'  , 4         , 'Felix@meier.ch', 'felix.meier', 2       , 1);


-- 2.1.3.6) Fuegen sie zwei neuen Daten-Saetze hinzug und definieren Sie den PK 50, 51 und setze das last_update Datum auf
--          '18.03.2022 00:00:00' und '18.03.2022 00:00:01'
--          und ueberpruefe mit den SELECTS das Resultat  (checken sie last_update)
INSERT INTO 
       staff
       (staff_id, first_name, last_name, address_id, email           , username     , store_id, active, last_update) VALUES 
       (50      ,'Franz'    , 'Meier'  , 4         , 'Franz@meier.ch', 'felix.meier', 2       , 1     , STR_TO_DATE('18.03.2022 00:00:00','%d.%m.%Y %T')),
       (51      ,'Micke'    , 'Meier'  , 4         , 'Micke@meier.ch', 'micke.meier', 2       , 1     , STR_TO_DATE('18.03.2022 00:00:01','%d.%m.%Y %T'));


-- 2.1.3.7) Updaten Sie den Datensatz mit PK 201 mit folgenden Werten:
--           first_name = 'Hans',
--           email      = 'Hans@meier.ch',
--           username   = 'hans.meier',
--           Setze das last_update nicht explizit
--          Ueberpruefe mit den SELECTS das Resultat
UPDATE staff SET 
     first_name='Hans',
     email='Hans@meier.ch',
     username='hans.meier',
     last_update = STR_TO_DATE('19.03.2022 12:30:01', '%d.%m.%Y %T')
WHERE staff_id=201;

-- 2.1.3.8) Loeschen Sie die Datensaetze mit PK 200, 201, 50, 51 aus der staff Tabelle.
DELETE FROM staff WHERE staff_id in (50, 51, 200, 201);


-- 2.1.4) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%d.%M %Y %H:%i:%s') AS LUpdate FROM staff;


-- 2.1.5) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%d.%M %Y %H:%i:%s') FROM staff;


-- 2.1.6) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'
--        Welche nach dem 17.3.2022 00:00:00 geaendert wurden
--        Verwende den > Operator
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%d.%M %Y %H:%i:%s') FROM staff
WHERE last_update  > STR_TO_DATE('17.03.2022', '%d.%m.%Y') ORDER BY last_update;


-- 2.1.7) Listen Sie alle Eintraege in der Tabelle staff auf. last_update e.g. 15.02.2006 15Uhr 57'
--        Welche nach dem 17.3.2022 00:00:00 geaendert wurden
--        Verwende den = Operator und analysiere, wieso dies nicht funktioniert!
SELECT staff_id, email, last_update, DATE_FORMAT(last_update, '%d.%M %Y %H:%i:%s') FROM staff
WHERE last_update  = STR_TO_DATE('17.03.2022', '%d.%m.%Y') ORDER BY last_update;  -- Gleichheit funktioniert nicht!

-- 2.1.8) Suchen Sie alle Eintraege in der Tabelle staff, welche nach 10 Uhr am 17. Maerz 22 geaendert wurden
SELECT email, last_update, DATE_FORMAT(last_update, '%d.%M %Y %H:%i:%s') FROM staff
WHERE last_update > STR_TO_DATE('17.03.2022 10','%d.%m.%Y %H');

-- 2.1.9) NOW(), CURTIME()
SELECT DATE_FORMAT(NOW()    , '%d.%M %Y %H:%i:%s'),
       DATE_FORMAT(CURTIME(), '%H:%i:%s')
FROM staff;

-- 2.1.9) ADDDATE(), DATE_ADD(), ADDTIME(), PERIODE_ADD
SELECT DATE_FORMAT(NOW()               ,'%d.%M %Y %H:%i:%s'),
       DATE_FORMAT(ADDDATE(NOW(),  60) ,'%d.%M %Y %H:%i:%s'),  -- 60 Tage spaeter
       DATE_FORMAT(ADDDATE(NOW(), -10) ,'%d.%M %Y %H:%i:%s'),  -- 10 Tage frueher
       DATE_ADD(NOW(),INTERVAL 1 DAY)     AS `+1 DAY`,
       DATE_ADD(NOW(),INTERVAL 1 MONTH)   AS `+1 MONTH`,
       DATE_ADD(NOW(),INTERVAL 1 YEAR)    AS `+1 YEAR`,
       DATE_ADD(NOW(),INTERVAL 1 HOUR)    AS `+1 HOUR`,
       DATE_ADD(NOW(),INTERVAL 1 MINUTE)  AS `+1 MINUTE`,
       DATE_ADD(NOW(),INTERVAL 1 SECOND)  AS `+1 SECOND`
FROM staff;

-- 2.1.10) DATEDIFF(), DATE_SUB(), SUBTIME(), PERIOD_DIFF, TIMEDIFF()
SELECT DATEDIFF(NOW(),ADDDATE(NOW(),  60)),
       DATEDIFF(NOW(),ADDDATE(NOW(), -10)),
       DATE_SUB(NOW(),INTERVAL 1 MONTH)   AS `-1 MONTH`;

-- 2.1.10.1) Wie alt (in Tagen) sind Sie heute?       
SELECT DATEDIFF(NOW(),STR_TO_DATE('05.08.1960', '%d.%m.%Y'));

-- 2.1.10.2) An welchem Datum sind/waren Sie 10000 Tage alt?       
SELECT ADDDATE(STR_TO_DATE('05.08.1960', '%d.%m.%Y'), 10000);

-- 2.1.10.3) An welchem Datum sind/waren Sie 25000 Tage alt?       
SELECT ADDDATE(STR_TO_DATE('05.08.1960', '%d.%m.%Y'), 25000);

-- 2.1.10.4) In wievielen Tagen sind Sie 25000 Tage alt?
SELECT DATEDIFF(ADDDATE(STR_TO_DATE('05.08.1960', '%d.%m.%Y'), 25000),NOW());

-- 2.1.11) GET_FORMAT()
SELECT 
	GET_FORMAT(DATE,'USA'),
    GET_FORMAT(DATE,'EUR'),
    GET_FORMAT(DATE,'ISO'),
    GET_FORMAT(DATE,'INTERNAL'),
    GET_FORMAT(TIME,'USA'),
    GET_FORMAT(DATETIME,'EUR');

SELECT staff_id, email, 
       last_update, 
       DATE_FORMAT(last_update, GET_FORMAT(DATETIME, 'EUR')) AS `DATETIME EUR`, 
       DATE_FORMAT(last_update, GET_FORMAT(DATE,     'USA')) AS `DATE     USA`
FROM staff;

-- 2.1.12) LAST_DAY()
SELECT 
	LAST_DAY('2004-02-05')                            AS `Last date of month`, -- --> '2004-02-29'
    WEEK(STR_TO_DATE('2004-02-05',' %Y-%m-%d'))       AS `Week Nr`,            -- --> '5'
    WEEKOFYEAR(STR_TO_DATE('2004-02-05',' %Y-%m-%d')) AS `Kalenderwoche`;       -- --> '6' 

-- 2.1.13) Vor wievielen Tagen wurden die Eintraege geaendert? 
--         Sortiert das kuerzlich geaenderte zu erst!       
SELECT 
   last_name,
   first_name,
   last_update,
   DATEDIFF(NOW(),last_update) AS `Days back changed`
FROM staff
ORDER BY last_update DESC;
   
   
-- END date_functions


-- START functions
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
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d') AS LastUpdate
FROM
    actor
WHERE
    -- -- Positiv formulierte Bedingung
    -- (first_name LIKE 'A%A_') OR
    -- (last_name IN ('Allen' , 'Bailey'));
    
    -- -- Negativ formulierte Bedingung
    NOT ((first_name NOT LIKE 'A%A_') AND
         (last_name NOT IN ('Allen' , 'Bailey')));


-- 2.3) Listen Sie nur die Rows auf, welche im rating eine PG haben und in den special_features Trailes enthalten.
SELECT
    film_id, 
    title, 
    rating,          -- enum
    special_features -- set
FROM 
    film
WHERE
    rating LIKE '%PG%' AND    -- e.g. Parental Guidance (Amerikanische Alterbeschraenkung)
    find_in_set('Trailers', special_features);

-- 2.4) Erstellen Sie eine Liste mit allen Namen und Vorname von staff, welche nur den Anfangsbuchstaben des Vornamen mit einem . getrennt vom vollstaendigen Nachnamen auflistet.
--      https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT 
    CONCAT(LEFT(first_name, 1), '. ', last_name) AS staff
FROM
    staff;
    
-- 2.5) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme? Liste diese in einer JSON Struktur auf!
--       https://dev.mysql.com/doc/refman/5.7/en/json-creation-functions.html#function_json-array
SELECT 
    JSON_OBJECT("Vorname", first_name, "Nachname",last_name) AS JSON
FROM
    actor;
    
-- 2.6) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme? 
--       Uebersetze den Name ED zu Edi und KARL zu Kari!
--       https://dev.mysql.com/doc/refman/5.7/en/case.html
SELECT 
    CASE 
      WHEN first_name = 'ED'   THEN 'Edi'
      WHEN first_name = 'KARL' THEN 'Kari'
      ELSE first_name
    END AS Vorname,
    last_name AS Nachname
FROM
    actor;


-- 2.7) Erstellen Sie eine Liste aller Filme mit den Originalsprachen (nur FK). Anstelle von NULL soll "Not defined" stehen
SELECT
    f.title AS Titel,
    CASE
       WHEN f.original_language_id IS NULL THEN 'Not Defined'
       ELSE f.original_language_id
    END AS `Original Sprache`
FROM
    film AS f;


-- END functions


-- START metaData
-- Meta-Daten abfragen
-- ===================

-- 3.0a) Welche Tabellen hat es in sakila?
SHOW FULL TABLES;
SHOW TABLES;

-- 3.0b) Welche Tabellen hat es in sakila, welche mit a beginnen?
SHOW TABLES WHERE Tables_in_sakila like 'a%';

-- 3.0c) Welche Attributte hat die Tabelle language?
DESCRIBE language;

-- 3.0d) Welche Attributte hat die Tabelle film, welche language enthalten?
DESCRIBE film;   -- WHERE Field like '%language%'; funktioniert nicht!!!!!

-- 3.1) Was finden Sie fuer Informationen in der Tabelle INFORMATION_SCHEMA.TABLES
--      https://dev.mysql.com/doc/mysql-infoschema-excerpt/8.0/en/information-schema.html
SELECT * FROM INFORMATION_SCHEMA.TABLES;
    
-- 3.1a) Liste alle Tabellen und Type, welche im Namen film enthalten, in der DB (im Schema) sakila auf und zeige deren Type an.
SELECT 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    TABLE_NAME LIKE '%film%' AND
    TABLE_SCHEMA = 'sakila'
ORDER BY 
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE;
    
SELECT 
    TABLE_NAME, 
    TABLE_TYPE 
FROM 
    INFORMATION_SCHEMA.TABLES 
WHERE 
    TABLE_SCHEMA = 'sakila';

-- 3.2) liste alle Attribute (mit Type) aller Tabellen in der DB (im Schema) sakila auf.
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = 'sakila'
ORDER BY TABLE_SCHEMA , TABLE_NAME , COLUMN_NAME;


-- 3.3 Liste alle Attribute der Tabelle film aus
DESC film; 


-- 3.4 Liste alle Attribute der Tabelle INFORMATION_SCHEMA.COLUMNS aus
DESCRIBE INFORMATION_SCHEMA.COLUMNS;

-- END metaData


-- START joins
-- Joins
-- =====
-- 3.9.1) Erstellen Sie eine Orte Laenderliste  (Kreuzprodukt)
SELECT
	city.city as Stadt,
    country.country as Land
FROM
    city, country;

-- 3.9.2) Erstellen Sie eine Orte Laenderliste (Kreuzprodukt)
SELECT
    S.city as Stadt,
    L.country as Land
FROM
    city as S, country as L;
 
-- 3.9.3) Erstellen Sie eine Orte Laenderliste (mit where close)
SELECT
    S.city as Stadt,
    L.country as Land
FROM
    city as S, country as L
WHERE
    S.country_id = L.country_id;

-- 3.9.4) Erstellen Sie eine Orte Laenderliste (mit inner join)
SELECT
    S.city as Stadt,
    L.country as Land
FROM
    city as S
INNER JOIN country as L on S.country_id = L.country_id;    

-- 3.9.5) Erstellen Sie eine Orte Laenderliste (mit left join)
SELECT
    S.city as Stadt,
    L.country as Land
FROM
    city as S
LEFT JOIN country as L on S.country_id = L.country_id;

-- 3.9.6) Erstellen Sie eine Orte Laenderliste (mit right join)
SELECT
    S.city as Stadt,
    L.country as Land
FROM
    country as L
RIGHT JOIN city as S on S.country_id = L.country_id; 

-- 3.9.7) Erstellen Sie eine Adress-, Orte und Laenderliste
SELECT
    address.address,
    city.city,
    country.country
FROM
    address
INNER JOIN city    ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;

-- 3.9.8.1) Erstellen Sie eine Filmtitle Liste mit den jeweiligen Sprachen
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache
FROM
     film AS f
INNER JOIN language AS lang    ON f.language_id          = lang.language_id;

-- 3.9.8.2) Erstellen Sie eine Filmtitle Liste mit den Originalsprache
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     orgLang.name   AS Originalsprache
FROM
     film AS f
LEFT  JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

-- 3.9.8.3) Erstellen Sie eine Filmtitle Liste mit den Originalsprache als Right Join
SELECT
     film_id      AS Id,
     title        AS Title,
     name         AS Originalsprache
FROM
     language
RIGHT JOIN film ON original_language_id = language.language_id;

-- 3.9.8.4) Erstellen Sie eine Filmtitle Liste mit den Originalsprache als Right Join
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     l.name         AS Originalsprache
FROM
     language AS l
RIGHT JOIN film AS f ON f.original_language_id = l.language_id;

-- 3.9.8.5) Erstellen Sie eine Filmtitle Liste mit den Sprachen und der Originalsprache
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache,
     orgLang.name   AS Originalsprache
FROM
     film AS f
INNER JOIN language AS lang    ON f.language_id          = lang.language_id
LEFT  JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

-- 3.9.9) Erstellen Sie eine Listen aller Kunden_id mit deren Umsaetzen (wie Aufgabe 1.13), nun aber neben der Kunden_ID noch die Namen und Vornamen der Kunden
SELECT 
   payment.customer_id    As Kunden_ID,
   customer.first_name    AS Vorname,
   customer.last_name     AS Name,
   sum(payment.amount)    AS Umsatz
FROM 
   payment
    -- LEFT JOIN customer ON payment.customer_id = customer.customer_id
   INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY
   payment.customer_id
Order BY
   Umsatz DESC;

-- 3.9.10) Erstellen Sie eine Liste mit allen Filmtitle und den beteiligten Acotrs
SELECT
   f.title              AS Film_Title,
   GROUP_CONCAT(CONCAT(`a`.`first_name`,
                       _utf8mb4 ' ',
					   `a`.`last_name`)
            SEPARATOR ', ') AS `Actors`
   
FROM film_actor  AS FA
INNER JOIN film  AS f ON FA.film_id  = f.film_id
INNER JOIN actor AS a ON FA.actor_id = a.actor_id
GROUP BY FA.film_id;
    

--  4.0) Erstellen Sie eine Abfrage von film (mit inner joins) mit  title, original_language und language
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache,
     orgLang.name   AS Originalsprache
FROM
     film AS f
INNER JOIN language AS lang    ON f.language_id          = lang.language_id
INNER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;


--  4.1) Inner-Join: Wieviele Rows hat es in der Tabelle country und city?
SELECT 
    COUNT(*)
FROM
    city;     -- 600 rows
    
SELECT 
    COUNT(*)
FROM
    country;  -- 109 rows

--  4.1.1) Listen sie alle Kombinationen von Cities mit den Laendern auf --> kartesisches Produkt!
SELECT 
    Stadt.city AS Stadt,
    Land.country AS Land
FROM
    city    AS Stadt,
    country AS Land;     -- 600 * 109 = 65400

--  4.1.2) Erstellen Sie eine Liste mit allen Staedten und den zugehoerigen Laendern --> impliziter Inner-Join / Self Join
SELECT 
    Stadt.city   AS Stadt, 
    Land.country AS Land
FROM
    city    AS Stadt,
    country AS Land
WHERE
    Stadt.country_id = Land.country_id;   -- 600 rows

--  4.1.3) Erstellen Sie eine Liste mit allen Staedten und den zugehoerigen Laendern --> expliziter Inner-Join
SELECT 
    Stadt.city   AS Stadt, 
    Land.country AS Land
FROM
    city    AS Stadt
INNER JOIN country AS Land on Stadt.country_id = Land.country_id;

--  4.2)  Wie viele Eintraege gibt es in der film  und in der language Tabelle?
SELECT 
    COUNT(*)
FROM
    film;           -- 1000 rows
    
SELECT 
    COUNT(*)
FROM
    language;       -- 7 rows

--  4.2.1) Bei welchen filmen ist die original_id nicht NULL?
SELECT 
    COUNT(*)
FROM
    film
WHERE original_language_id IS NOT NULL;  -- 2 rows

--  4.2.2) Erstellen Sie eine Liste aller Filmetitles mit dessen original_language mit einem inner join
SELECT 
    film.title     AS Title, 
    language.name  AS Originalsprache
FROM
    film
INNER JOIN language on film.original_language_id = language.language_id;   -- 2 rows

--  4.2.3) Erstellen Sie eine Liste aller Filmetitles mit dessen original_language mit einem left-outer join
SELECT 
    film.title     AS Title, 
    language.name  AS Originalsprache
FROM
    film
LEFT OUTER JOIN language ON film.original_language_id = language.language_id;  -- 1000 rows

--  4.2.4)  Erstellen sie gleiche List mit einem right join.
SELECT
    f.title AS Title, 
    l.name  AS Originalsprache
FROM
   language AS l
RIGHT JOIN film AS f ON l.language_id = f.original_language_id;    -- 1000 rows


--  4.2.5) Erstellen Sie eine Liste mit allen Filmetitles mit dessen language und original_language mit einem left-outer join
SELECT 
    f.title       AS Title, 
    lang.name     AS Sprache,
    orgLang.name  AS Originalsprache
FROM
    film AS f
LEFT OUTER JOIN language AS lang    ON f.language_id          = lang.language_id
LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;  -- 1000 rows

--  4.2.6) Listen Sie von der vorherigen Liste nur den Filmtitel und die Orginal-Sprache auf von den Filmen die eine 
--         Original-Sprache gesetzt haben. 
SELECT 
    f.title       AS Title, 
    orgLang.name  AS Originalsprache
FROM
    film AS f
LEFT OUTER JOIN language AS lang    ON f.language_id          = lang.language_id
LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id
WHERE f.original_language_id IS NOT NULL;  -- 2 rows



-- 4.2.7) Erstellen Sie eine Liste aller Film-Titels und allen Sprachen.
--        Tipp: full Outer Join gibt es in MySQL nicht! Verwenden Sie eine UNION und 2 LEFT Joins
SELECT
   film.title,
   language.name 
FROM
   film 
LEFT JOIN language ON language.language_id = film.original_language_id
UNION
SELECT
   film.title,
   language.name 
FROM
   language 
LEFT JOIN film ON language.language_id = film.original_language_id;   -- 1005 rows


-- 4.3.1) Listen sie Alle Staedte auf und in wievielen Landern diese vorkommen absteigend sortiert nach den anzahl Laendern
SELECT
   city.city       AS Stadt,
   count(country.country) As Count
FROM
   city
LEFT JOIN country ON city.country_id = country.country_id
Group BY city.city
ORDER BY
   Count DESC;



-- 4.3.2) Eine Liste Alle Staedte, welche in mehr als einem Land vorkommen zusammen mit dem Land aufgelistet 
SELECT
   city.city,
   country.country 
FROM
   city
LEFT JOIN country ON city.country_id = country.country_id
WHERE city.city IN (SELECT city.city FROM city GROUP BY city.city having count(*) > 1)
ORDER BY
   city.city, 
   country.country;  -- 2 rows

-- 4.4.1) Erstellen Sie eine Liste mit allen ausgeliehenen DVDs, welche am 27.5.2005 
--        zurueckgegeben worden sind.
SELECT 
   *
FROM
   rental
WHERE
   return_date IS NOT NULL AND 
   DATE_FORMAT(return_date, '%Y%m%d') = '20050527' 
ORDER BY 
   return_date; -- (49 rows)
   
   
SELECT 
   *
FROM
   rental
WHERE
   return_date IS NOT NULL AND 
   return_date = STR_TO_DATE('20050527', '%Y%m%d')
ORDER BY 
   return_date; -- (49 rows)

  -- Schneller! Nur einmal ein fct-Call in Where-Clause!
SELECT 
    first_name,  
    last_name, 
    DATE_FORMAT(last_update, '%d.%M %Y') AS LastUpdate 
FROM staff 
WHERE date(last_update) = STR_TO_DATE('May 17, 2021','%M %d,%Y');


-- 4.4.2) Erstellen Sie eine Liste mit allen ausgeliehenen DVDs und listen Sie die Vor-, Nachnamen
--        und Telefonnummern der Ausleiher auf sowie den Titel der DVD, welche am 27.5.2005 
--        zurueckgegeben worden sind.
--        https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT 
   CONCAT(LEFT(customer.first_name, 1),'. ', customer.last_name) AS Renter,
   film.title                                                    AS Film
FROM
   rental
LEFT JOIN customer  ON rental.customer_id     = customer.customer_id
LEFT JOIN inventory ON rental.inventory_id    = inventory.inventory_id
LEFT JOIN film      ON inventory.inventory_id = film.film_id
WHERE
    return_date IS NOT NULL AND 
    DATE_FORMAT(return_date, '%Y%m%d') = '20050527'
ORDER BY 
    return_date; -- (49 rows)

-- 4.4.3) Erstellen Sie eine Mahnungsliste, wie folgt:
--        Enthaelt alle Vornamen und Nachnamen und Telefonnummer der Kunden, welche eine DVD am 2005-05-27 zurueckgeben haben
--        https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT 
    CONCAT(LEFT(customer.first_name, 1),'. ',customer.last_name) AS Renter,
    address.phone                                                AS Phone,
    film.title                                                   AS Film
FROM
    rental
INNER JOIN customer  ON rental.customer_id     = customer.customer_id
INNER JOIN address   ON customer.address_id    = address.address_id
INNER JOIN inventory ON rental.inventory_id    = inventory.inventory_id
INNER JOIN film      ON inventory.inventory_id = film.film_id
WHERE
    return_date IS NOT NULL AND 
    DATE_FORMAT(return_date, '%Y%m%d') = '20050527'
ORDER BY
    return_date; -- (12 rows)
-- END joins


-- START views
-- VIEWS
-- =====
-- V1.0.0 Kreieren sie eine View mit alle City_id, Staedte und deren Laender sortiert nach Staedtenamen.
DROP VIEW IF EXISTS x_city_country;
CREATE VIEW x_city_country AS
     SELECT 
        city.city_id    AS ID, 
        city.city       AS Stadt, 
        country.country AS Land
     FROM city
	 INNER JOIN country ON city.country_id=country.country_id
     ORDER BY city.city ASC;

-- SELECT * from x_city_country;

-- V1.0.1 Kreieren sie eine View mit alle Adress_id, Staedte und deren Laender sortiert nach Staedtenamen.
--        Verwenden Sie die city_country view
DROP VIEW IF EXISTS x_adress_city_country;
CREATE VIEW x_adress_city_country AS
     SELECT 
        a.address_id  AS ID,
        a.address     AS Address,
        a.district    AS District,
        a.postal_code AS Postal_Code,
        cc.Stadt      AS Stadt, 
        cc.Land       AS Land
     FROM address AS a
	 INNER JOIN x_city_country AS cc ON a.address_id=cc.id
     ORDER BY cc.Stadt ASC;
     
-- SELECT * from x_adress_city_country;


-- V1.0.2 Erstellen Sie eine Personal-Liste sortiert nach Shop.



-- V1.0.3 Erstellen Sie eine Shop-Liste der Adresse und dem Manager des Shops.


-- V1.0.4 Erstellen Sie eine Liste mit allen Film Title, Sprache, Original_Sprache, rating, Specialfeatures


-- V1.0.5 Erstellen Sie eine Hitliste mit den Besten Kunden (Nach Umsatz sortiert und Anzahl Ausleihungen)


-- V1.0.6 Analysieren und bauen Sie die View actor_info nach (Actorsdetails with all film titles the took part in)

-- V1.0.7 Analysieren und bauen Sie die View film_list nach (Filmedetails mit allen actors involved)

-- V1.0.8 Erstellen Sie eine Liste mit allen Film_IDS, und allen beteiligten Actors

-- END views

-- START CRUD
-- Insert - Update - Delete
-- ========================
--  CRUD 0)  Welche Laender sind erfasst?
SELECT * FROM country;

--  CRUD 1)  Fuegen Sie das Land "Andorra ein
INSERT INTO country (country) VALUES ('Andorra');

--  CRUD 1a)  Wie lautet der PK von 'Andorra'?
SELECT country_id from country where country = 'Andorra';

--  CRUD 2)  Fuegen Sie die beiden Staedte "Soldeuu" und "Erts" ein. Beide gehoeren zum Land "Andorra".
INSERT INTO city (city,country_id) VALUES 
    ('Soldeuu', 111), 
    ('Erts', 111);

--  CRUD 2a)  Wie lauten die PKs aller Orte in Andora (Mit Otrsnamen, City_id, Country_Id)?    
SELECT
    city_id     AS Id,
    city        AS Stadt,
    country_id  AS CountryId
FROM
    city
WHERE country_id = 111;

SELECT
    city_id     AS Id,
    city        AS Stadt,
    country_id  AS CountryId
FROM
    city
WHERE country_id = (SELECT country_id from country where country = 'Andorra');

--  CRUD 2b)  Erstellen sie eine Liste mit den Orten und dem Landesnamen von Andorra (inner Join)
SELECT
    ci.city_id          AS Id,
    ci.city             AS Stadt,
    co.country_id       AS CountryId,
    co.country          AS Land
FROM
    city AS ci
INNER JOIN country AS co ON ci.country_id = co.country_id
WHERE ci.country_id = (SELECT country_id 
					   FROM country 
                       WHERE country = 'Andorra'); 

SELECT
    ci.city_id          AS Id,
    ci.city             AS Stadt,
    co.country_id       AS CountryId,
    co.country          AS Land
FROM
    city AS ci
INNER JOIN country AS co ON ci.country_id = co.country_id
WHERE ci.country = 'Andorra'; 

--  CRUD 2c)  Koorigieren Sie den Namen von 'Soldeuu' auf 'Soldeu'
--            Moegliche Fehlermeldung: "Safe Updates". Forbid UPDATEs and DELETEs with no key in WHERE clause
--            --> Workbench: Edit -> Preferences -> SQL Editor (Uncheck box at the end of the screen)
UPDATE city SET city='Soldeu' WHERE city='Soldeuu';


--  CRUD 3)  Loeschen Sie das Land "Andorra". Lesen Sie die Fehlermeldung? Wieso geht das nicht?
DELETE FROM country WHERE country = 'Andorra';

--  CRUD 3a)  Loeschen Sie nun zuerst alle Staedte von "Andorra".
DELETE FROM city
WHERE country_id = (SELECT country_id FROM country WHERE country = 'Andorra');

--  CRUD 3b)  Nun koennen Sie das Land "Andorra" loeschen.
DELETE FROM country WHERE country = 'Andorra';

--  CRUD 3c)  Kontrollieren Sie, ob Sie die Staedte und das Land wirklich geloescht haben.
SELECT country_id from country where country = 'Andorra';    

SELECT
    ci.city_id          AS Id,
    ci.city             AS Stadt,
    ci.country_id       AS CountryId
FROM
    city AS ci
WHERE country_id = (SELECT country_id 
                    FROM country 
                    WHERE country = 'Andorra');

--  CRUD 4)  Setzen Sie die Originalsprache von den Filmen 'ACADEMY DINOSAUR', 'ACE GOLDFINGER' auf 'Mandarin' 
UPDATE
   film 
SET original_language_id=(
            SELECT
                language_id
            FROM
                language
            WHERE
                name = 'Mandarin'
) 
WHERE title in ('ACADEMY DINOSAUR', 'ACE GOLDFINGER');

-- END CRUD


-- START uebung_1
-- Uebung 1: Update, Insert und Delete (C RUD)
-- ===========================================

-- C: Fuegen Sie drei neue Sprachen in die language Tabelle ein.
-- R: Listen Sie alle Filme mit language und original_language
-- U: Danach setzen Sie bei zwei Filmen die original_language auf eine dieser Sprachen.
-- R: Listen Sie alle Filme mit language und original_language
-- D: Loeschen Sie die alle neuen Sprachen und setzen Sie die original_language der beiden Filme wieder auf NULL.

--  U1.0) Setzen Sie bei allen Filmen die Original_Language_ID auf NULL
UPDATE film SET original_language_id = NULL;

--  U1.1) Erstellen Sie eine Abfrage von film (mit inner joins) mit  title, original_language und language. 
--        Wieso gibt es keine Resultate?
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache,
     orgLang.name   AS Originalsprache
FROM
     film AS f
INNER JOIN language AS lang    ON f.language_id          = lang.language_id
INNER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

--  U1.1a) Welche Filme haben eine original_language_id gesetzt?
SELECT original_language_id FROM film WHERE original_language_id IS NOT NULL;

--  U1.1b) Erstellen Sie ein SELECT, so dass alle Filme im Resultset erscheinen?
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache,
     orgLang.name   AS Originalsprache
FROM
     film AS f
INNER      JOIN language AS lang    ON f.language_id          = lang.language_id
LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

--  U1.2)  Fuegen Sie drei weitere Sprache 'Schweizerdeutsch', 'Suiss Italian' und 'Dutch' in die Tabelle language 
SELECT * FROM language;
INSERT INTO language (name) VALUES ('Schweizerdeutsch');
INSERT INTO language (name) VALUES ('Suiss Italian');
INSERT INTO language (name) VALUES ('Dutch');
INSERT INTO language (name) VALUES 
    ('Schweizerdeutsch'), 
    ('Suiss Italian'), 
    ('Dutch');

--  U1.2a)  Was fuer IDs haben diese neuen Sprachen bekommen?
SELECT * FROM language;

--  U1.3)   Setzen Sie fuer die beiden Filme mit der film_id 1 und 2 die original_language_id auf 1 resp 2
UPDATE film SET original_language_id=1 WHERE film_id=1;  -- English
UPDATE film SET original_language_id=2 WHERE film_id=2;  -- Italian

--  U1.4)   Setzen Sie fuer den Filme mit dem Titel AFRICAN EGG die original_language_id auf 'Schweizerdeutsch'
SELECT language_id FROM language WHERE name = 'Schweizerdeutsch';
SELECT film_id, title, original_language_id, last_update FROM film WHERE title='AFRICAN EGG';

UPDATE film SET original_language_id=7 WHERE film_id=5;
UPDATE film SET original_language_id=7 WHERE title='AFRICAN EGG';

SELECT film_id, title, original_language_id FROM film WHERE film_id=5;

UPDATE film SET original_language_id=NULL WHERE film_id=5;


UPDATE film SET original_language_id=(
                       SELECT language_id 
                       FROM language 
                       WHERE name='Schweizerdeutsch') 
WHERE title='AFRICAN EGG';

--  U1.5) Erstellen Sie eine Abfrage von film (mit den richtigen joins) mit  title, original_language und language
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache,
     orgLang.name   AS Originalsprache
FROM
     film AS f
INNER JOIN      language AS lang    ON f.language_id          = lang.language_id
LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

--  U1.6) Erstellen Sie eine View FILM_SPRACHEN mit dem Join von oben
DROP VIEW IF EXISTS FILM_SPRACHEN; 
CREATE VIEW FILM_SPRACHEN AS
	SELECT
		 f.film_id      AS Id,
		 f.title        AS Title,
		 lang.name      AS Sprache,
		 orgLang.name   AS Originalsprache
	FROM
		 film AS f
	INNER JOIN      language AS lang    ON f.language_id          = lang.language_id
	LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

SELECT * FROM film_sprachen;

-- U1.6.1) Geben Sie die Anzahl der Filme aus, welche als language.name "English" haben.
SELECT 
    COUNT(film.title) AS Anzahl 
FROM film 
INNER JOIN language ON film.language_id = language.language_id 
WHERE language.name = "English" 
GROUP BY film.language_id;


--  U1.7)   Loeschen Sie diese 3 neu zugefuegten Sprachen wieder! Wieso geht das nicht?
DELETE FROM language WHERE name in ('Schweizerdeutsch', 'Suiss Italian', 'Dutch');


--  U1.8)   Setzen Sie zuerst bei alle Filmen, welche einer dieser zugefuegten Sprachen als Original-Sprache gesetzt haben, diese wieder auf NULL 
UPDATE film SET original_language_id=NULL 
WHERE original_language_id in (
             SELECT language_id 
             FROM language 
             WHERE name IN ('Schweizerdeutsch', 'Suiss Italian', 'Dutch')
             );


-- END uebung_1



-- START pruefung
-- Pruefungsfragen
-- ===============

-- 1.0.0) Sie muessen eine Liste mit Vornamen, Nachnamen und Last_Update (Format: 25.May 2021) fuer alle
--        Datensaetze in staff, welche am 17.5.2021 geaendert wurden, erzeugen.
SELECT 
    first_name,  
    last_name, 
    DATE_FORMAT(last_update, '%d.%M %Y') AS LastUpdate 
FROM staff 
WHERE DATE_FORMAT(last_update, '%Y-%M-%d') = "2021-May-17";


SELECT 
    first_name,  
    last_name, 
    DATE_FORMAT(last_update, '%d.%M %Y') AS LastUpdate 
FROM staff 
WHERE date(last_update) = STR_TO_DATE('May 17, 2021','%M %d,%Y');

SELECT 
    first_name,  
    last_name, 
    DATE_FORMAT(last_update, '%d.%M %Y') AS LastUpdate 
FROM staff 
WHERE date(last_update) = STR_TO_DATE('May 17, 2021','%b %d,%Y');


-- falsch
SELECT 
    first_name,  
    last_name, 
    STR_TO_DATE(last_update, '%M %d,%Y') AS LastUpdate 
FROM staff 
WHERE date(last_update) = STR_TO_DATE('May 17, 2021','%M %d,%Y');

SELECT 
    first_name,  
    last_name, 
    DATE_FORMAT(last_update, '%d.%M %Y') AS LastUpdate 
FROM staff 
WHERE date(last_update) = STR_TO_DATE('May 17, 2021','%M %d,%y');

SELECT 
    first_name,  
    last_name, 
    DATE_FORMAT(last_update, '%d.%M %Y') AS LastUpdate 
FROM staff 
WHERE date(last_update) = STR_TO_DATE('May 17, 2021','%M %d %Y');


-- 1.0.1) Sie muessen eine XXXXX


-- END pruefung


-- START ownFunctions
-- FUNCTIONS
-- =========
-- PL/SQL: https://de.wikipedia.org/wiki/PL/SQL#Zahlenvariablen
--         https://www.tutorialspoint.com/plsql/index.htm
--         https://www.oracletutorial.com/plsql-tutorial/

-- Schreiben sie eine eigene Functionen gemaess folgenden Spezification

-- Bei folgendem Fehler:
--    Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)

-- noch folgendes ausfuehren
--    SET GLOBAL log_bin_trust_function_creators = 1;


--  -------------------------------------------------------------
--  Fct 1.0) Gibt 'Hallo!!' zurueck.
--           SELECT sayHelloSimple();-- --> Hallo!!
DROP FUNCTION IF EXISTS sayHelloSimple;
Delimiter //
CREATE FUNCTION sayHelloSimple() RETURNS CHAR(50)
BEGIN
  RETURN  'Hoi!!';
END//

-- Test-Cases
-- SELECT sayHelloSimple();
-- SELECT 'Hello???';

--  -------------------------------------------------------------
--  Fct 2.0) Nimmt eine Zeichenkette und haengt Hallo: vorne an.
--           SELECT sayHello('Walti');-- --> Hallo: Walti
DROP FUNCTION IF EXISTS sayHello;
Delimiter $$$
CREATE FUNCTION sayHello(p_input_string CHAR(20)) RETURNS CHAR(50)
BEGIN
  RETURN  CONCAT('Hallo: ', p_input_string);
END$$$

-- Test-Cases
-- SELECT sayHello('Walti');-- --> Hallo: Walti

--  -------------------------------------------------------------
--  Fct 2.1)  Nimmt eine PLZ und haengt CH- vorne an.
--            SELECT formatPLZ(8855);     -- --> CH-8855
DROP FUNCTION IF EXISTS formatPLZ;
Delimiter //
CREATE FUNCTION formatPLZ(p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  concat('CH-', p_input_plz);
END
//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZ(8854) AS PLZ_Formated;     -- --> CH-8855

--  -------------------------------------------------------------
--  Fct 2.2)  Nimmt einen Laendercode und eine PLZ und haengt diese mit 
--            einem - zusammen.
--            SELECT formatPLZ('D', 8855);     -- --> D-8855
DROP FUNCTION IF EXISTS formatPLZinternational;
Delimiter //
CREATE FUNCTION formatPLZinternational(p_countryCode CHAR(50), p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  concat(p_countryCode, '-', p_input_plz);
END
//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZinternational('CH', 8854) AS PLZ_Formated;     -- --> CH-8854
-- SELECT formatPLZinternational('D', 10115) AS PLZ_Formated;     -- --> D-10115

--  -------------------------------------------------------------
--  Fct 3.0) Nimmt eine Zeichenkette und macht den 1.Buchstaben Uppercase und die restlichen Lowercase
--           SELECT firstUpper("herr");  -- --> Herr
--           SELECT firstUpper("HERR");  -- --> Herr
--           SELECT firstUpper("Herr");  -- --> Herr
--           SELECT firstUpper("hERR");  -- --> Herr
DROP FUNCTION IF EXISTS firstUpper;
Delimiter //
CREATE FUNCTION firstUpper(p_str CHAR(100)) RETURNS CHAR(100)
BEGIN
   RETURN  CONCAT(UPPER(LEFT(p_str, 1)), LOWER(RIGHT(p_str,LENGTH(p_str)-1)));
END
//
DELIMITER ;

-- Test-Cases
-- SELECT firstUpper("herr");  -- --> Herr
-- SELECT firstUpper("HERR");  -- --> Herr
-- SELECT firstUpper("Herr");  -- --> Herr
-- SELECT firstUpper("hERR");  -- --> Herr

--  -------------------------------------------------------------
--  Fct 10.0) Gibt den aelteren Timestamp zurueck
DROP FUNCTION IF EXISTS getOlder;
DELIMITER //
CREATE FUNCTION  getOlder(timeStamp_1 datetime, timeStamp_2 datetime) RETURNS datetime
BEGIN
   IF timeStamp_1 < timeStamp_2 THEN
         RETURN  timeStamp_1;
   ELSE
         RETURN  timeStamp_2;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getOlder(STR_TO_DATE('20050527-194523', '%Y%m%d-%H%i%s'), STR_TO_DATE('20050527-194524', '%Y%m%d-%H%i%s')) AS latest_change;

-- --------------------------------------------------------------------------------
--  Fct 10.1) Gibt den juengeren Timestamp zurueck
DROP FUNCTION IF EXISTS getYounger;
DELIMITER //
CREATE FUNCTION  getYounger(timeStamp_1 datetime, timeStamp_2 datetime) RETURNS datetime
BEGIN
   IF timeStamp_1 > timeStamp_2 THEN
         RETURN  timeStamp_1;
   ELSE
         RETURN  timeStamp_2;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getYounger(STR_TO_DATE('20050527-194523', '%Y%m%d-%H%i%s'), STR_TO_DATE('20050527-194524', '%Y%m%d-%H%i%s')) AS latest_change;

-- --------------------------------------------------------------------------------
--  Fct 10.3) Gibt die internationale PLZ zurueck
DROP FUNCTION IF EXISTS formatPLZinternational;
DELIMITER //
CREATE FUNCTION formatPLZinternational(p_countryCode CHAR(50), p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  concat(p_countryCode, '-', p_input_plz);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZinternational('CH', 8854) AS PLZ_Formated;     -- --> CH-8854
-- SELECT formatPLZinternational('D', 10115) AS PLZ_Formated;     -- --> D-10115
--  -------------------------------------------------------------
--  Fct 10.3.1) Gibt die internationale PLZ mit dem Ort zurueck
DROP FUNCTION IF EXISTS formatPLZinternational_ort;
DELIMITER //
CREATE FUNCTION formatPLZinternational_ort(p_countryCode CHAR(50), p_input_plz SMALLINT, p_ort CHAR(50)) RETURNS CHAR(50)
BEGIN
   RETURN  concat(p_countryCode, '-', p_input_plz, ' ', p_ort);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZinternational_ort('CH', 8854, 'Siebnen') AS PLZ_Ort;     -- --> CH-8854 Siebnen
-- SELECT formatPLZinternational_ort('D', 10115, 'Berlin') AS PLZ_Ort;     -- --> D-10115 Berlin
--  -------------------------------------------------------------
--  Fct 10.3.2) Gibt die PLZ mit dem Ort zurueck
DROP FUNCTION IF EXISTS formatPLZ_ort;
DELIMITER //
CREATE FUNCTION formatPLZ_ort(p_input_plz SMALLINT, p_ort CHAR(50)) RETURNS CHAR(50)
BEGIN
   RETURN  concat(p_input_plz, ' ', p_ort);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZ_ort(8854, 'Siebnen') AS PLZ_Ort;     -- --> 8854 Siebnen
-- SELECT formatPLZ_ort(10115, 'Berlin') AS PLZ_Ort;     -- --> 10115 Berlin
--  -------------------------------------------------------------
--  Fct 10.4) Gibt p_str zurueck mit erstem Buchstaben als Grossbuchstabe
DROP FUNCTION IF EXISTS firstUpper;
DELIMITER //
CREATE FUNCTION firstUpper(p_str VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
   RETURN  CONCAT(UPPER(LEFT(p_str, 1)), LOWER(RIGHT(p_str,CHAR_LENGTH(p_str)-1)));
END//
DELIMITER ;

-- Test-Cases
-- SHOW CHARACTER SET;
-- SELECT firstUpper("herr");    -- --> Herr
-- SELECT firstUpper("HERR");    -- --> Herr
-- SELECT firstUpper("Herr");    -- --> Herr
-- SELECT firstUpper("hERR");    -- --> Herr
-- SELECT firstUpper("züger");   -- --> Zzaüger
-- SELECT firstUpper("zueger");  -- --> Zzaüger


-- --------------------------------------------------------------------------------
--  Fct 10.5) Gibt ersten Buchstaben von p_name als Grossbuchstabe zurueck gefolgt von p_tail
DROP FUNCTION IF EXISTS getInitial;
DELIMITER //
CREATE FUNCTION getInitial(p_name CHAR(100), p_tail CHAR(5)) RETURNS CHAR(10)
BEGIN
   RETURN  CONCAT(UPPER(LEFT(p_name, 1)), p_tail);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getInitial("Walter",".");  -- --> W.
-- SELECT getInitial("walti", ".");  -- --> W.
-- SELECT getInitial("Max", ",");    -- --> M,
-- SELECT getInitial("max", ",");    -- --> M,

-- --------------------------------------------------------------------------------
--  Fct 10.6) Gibt p_firstname gefolgt von, falls existiert, einem Space und ersten 
--            Buchstaben von p_firstname2 als Grossbuchstabe zurueck 
DROP FUNCTION IF EXISTS getName_With_Initial;
DELIMITER //
CREATE FUNCTION getName_With_Initial(p_firstname CHAR(100), p_firstname2 CHAR(100)) RETURNS CHAR(45)
BEGIN
   IF (p_firstname2 = '' OR p_firstname2 is NULL) THEN
	   RETURN  p_firstname;
   ELSE
       RETURN  CONCAT(p_firstname, ' ', getInitial(p_firstname2, '.'));
   END IF;
END//
DELIMITER ;

-- Test-Case
-- SELECT getName_With_Initial('Walter', 'Max');  -- --> Walter M.
-- SELECT getName_With_Initial('Walti', '');      -- --> Walti
-- SELECT getName_With_Initial('Walti', NULL);    -- --> Walti

-- --------------------------------------------------------------------------------
--  Fct 10.7) Gibt Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getAnrede;
DELIMITER //
CREATE FUNCTION getAnrede(p_sex CHAR(20), p_firstname CHAR(45), p_vorname_short BOOLEAN, p_lastname CHAR(100) ) RETURNS CHAR(150)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  '';
   ELSE
		IF (p_vorname_short) THEN
			RETURN  CONCAT(p_sex, ' ', LEFT(p_firstname, 1), '.', p_lastname);
		ELSE
            RETURN  CONCAT(p_sex, ' ', p_firstname, ' ', p_lastname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Case
-- SELECT getAnrede("Herr", "Walter", TRUE, "Rothlin");         -- --> Herr W.Rothlin
-- SELECT getAnrede("Frau", "Claudia", TRUE, "Collet Rothlin"); -- --> Frau C.Collet Rothlin

-- --------------------------------------------------------------------------------
--  Fct 10.8) Gibt Brief-Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getBrief_Anrede;
DELIMITER //
CREATE FUNCTION getBrief_Anrede(p_sex CHAR(20), p_lastname CHAR(100) ) RETURNS CHAR(100)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  'Sehr geehrte Damen, Sehr geehrte Herren,';
   ELSE
		IF (p_sex = 'Herr') THEN 
			RETURN  CONCAT('Sehr geehrter ',firstUpper(p_sex), ' ', p_lastname);
		ELSE
            RETURN  CONCAT('Sehr geehrte ',firstUpper(p_sex), ' ', p_lastname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Case
-- SELECT getBrief_Anrede("Herr", "Walter", "Rothlin"); -- --> Sehr geehrter Herr Rothlin
-- SELECT getBrief_Anrede("Frau", "Claudia", "Collet"); -- --> Sehr geehrte Frau Collet

-- --------------------------------------------------------------------------------
--  Fct 10.9) Gibt perDu Brief-Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getBrief_Anrede_PerDu;
DELIMITER //
CREATE FUNCTION getBrief_Anrede_PerDu(p_sex CHAR(20), p_firstname CHAR(100) ) RETURNS CHAR(100)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  '';
   ELSE
		IF (p_sex = 'Herr') THEN 
			RETURN  CONCAT('Lieber ', p_firstname);
		ELSE
            RETURN  CONCAT('Liebe ', p_firstname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Case
-- SELECT getBrief_Anrede("Herr", "Walter", "Rothlin"); -- --> Sehr geehrter Herr Rothlin
-- SELECT getBrief_Anrede("Frau", "Claudia", "Collet"); -- --> Sehr geehrte Frau Collet
 
--  ------------------------------------------------------------- 
--  Fct 10.10) Gibt Familienname zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getFamilieName;
DELIMITER //
CREATE FUNCTION getFamilieName(p_sex CHAR(5) , p_name_angenommen BOOLEAN , p_ledig_name CHAR(45) , p_partner_name CHAR(45)) RETURNS CHAR(100)
BEGIN
	IF (p_sex = 'Herr' or p_sex = 'Frau') THEN
		IF (p_partner_name = '') THEN
			RETURN  p_ledig_name;
		ELSE
            IF (p_sex = 'Herr') THEN
				IF (p_name_angenommen = True) THEN
					RETURN CONCAT(p_partner_name,' ', p_ledig_name);
				ELSE
					RETURN CONCAT(p_ledig_name,'-', p_partner_name);
                END IF;
			ELSE
                IF (p_name_angenommen = True) THEN
					RETURN CONCAT(p_partner_name,'-', p_ledig_name);
				ELSE
					RETURN CONCAT(p_ledig_name,' ', p_partner_name);
                END IF;
            END IF;
        END IF;
	ELSE 
		RETURN  "";
    END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getFamilieName('Herr', FALSE, 'Rothlin', '');        -- --> Rothlin
-- SELECT getFamilieName('Frau', FALSE, 'Collet', '');         -- --> Collet
-- SELECT getFamilieName('Herr', TRUE,  'Rothlin', '');        -- --> Rothlin
-- SELECT getFamilieName('Frau', TRUE,  'Collet', '');         -- --> Collet

-- SELECT getFamilieName('Herr', FALSE, 'Rothlin', 'Collet');  -- --> Rothlin-Collet
-- SELECT getFamilieName('Frau', FALSE, 'Collet', 'Rothlin');  -- --> Collet Rothlin
-- SELECT getFamilieName('Herr', TRUE,  'Rothlin', 'Collet');  -- --> Collet Rothlin
-- SELECT getFamilieName('Frau', TRUE,  'Collet', 'Rothlin');  -- --> Rothlin-Collet

--  ------------------------------------------------------------- 
--  Fct 10.11) Gibt LastName zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getLastName;
DELIMITER //
CREATE FUNCTION getLastName(p_sex CHAR(5) , p_name_angenommen BOOLEAN , p_ledig_name CHAR(45) , p_partner_name CHAR(45)) RETURNS CHAR(50)
BEGIN
	IF (p_sex = 'Herr' or p_sex = 'Frau') THEN
		IF (p_partner_name = '' OR p_partner_name is NULL) THEN
			RETURN  firstUpper(p_ledig_name);
		ELSE
            IF (p_sex = 'Herr') THEN
				IF (p_name_angenommen = True) THEN
					RETURN p_partner_name;
				ELSE
					RETURN p_ledig_name;
                END IF;
			ELSE
                IF (p_name_angenommen = True) THEN
					RETURN p_partner_name;
				ELSE
					RETURN p_ledig_name;
                END IF;
            END IF;
        END IF;
	ELSE 
		RETURN  '';
    END IF;
END//
DELIMITER ;

-- Test-Cases

-- --------------------------------------------------------------------------------
--  Fct 10.12) Gibt Strasse mit Nr resp Postfach zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getStrassenAdresse;
DELIMITER //
CREATE FUNCTION getStrassenAdresse(p_strasse VARCHAR(45), p_hausnummer VARCHAR(15), p_postfach VARCHAR(5)) RETURNS CHAR(100)
BEGIN
    IF (p_postfach = "") THEN
		RETURN CONCAT(p_strasse, ' ', p_hausnummer);
	ELSE
    	RETURN CONCAT(p_strasse, ' ', p_hausnummer, ' / Postfach:', p_postfach);
    END IF;
    
    IF (strasse = '') THEN
         IF (postfach = '' OR postfach = NULL) THEN
			RETURN '';
		 ELSE
            RETURN CONCAT('Postfach ', postfach);
         END IF;
    ELSE
       IF (hausnummer = '') THEN
          IF (postfach = '') THEN
               RETURN CONCAT('', strasse);
		  ELSE
               RETURN CONCAT(strasse, ' / Postfach:', postfach);
		  END IF;
	   ELSE
		  IF (postfach = '') THEN
		       RETURN CONCAT(strasse, ' ', hausnummer);
		  ELSE
               RETURN CONCAT(strasse, ' ', hausnummer, ' / Postfach:', postfach);
		  END IF;
       END IF;
    END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getStrassenAdresse('Peterliwiese', '33a', '');      -- --> Peterliwiese 33
-- SELECT getStrassenAdresse('Peterliwiese', '33a', '243' );  -- --> Peterliwiese 33 / Postfach:243

-- END ownFunctions


-- START variablen
-- Variablen
-- =========
SET @dolphin:='BZUäöü';
SELECT LENGTH(@dolphin), CHAR_LENGTH(@dolphin);
SELECT 'HAlloäöü';
SELECT @dolphin;

-- DECLARE @MyCounter INT;
-- SET @MyCounter = 0;

-- WHILE (@MyCounter < 26)
-- BEGIN;

--        (@MyCounter,
--         CHAR( ( @MyCounter + ASCII('a') ) )
--        );

--    SET @MyCounter = @MyCounter + 1;
-- END;

-- END variablen

-- START procedures
-- STORED PROCEDURES
-- =================
-- https://federico-razzoli.com/mysql-stored-procedures-all-ways-to-produce-an-output

-- STO_01) Schreiben sie eine Stored-Procedure bei welcher 2 Parameter uebergeben werden koennen. 
--         Der erste Parameter ist ein Land und der Zweite ob case-sensitve oder nicht gesucht werden soll.
    DROP PROCEDURE IF EXISTS isCountryExits;

    Delimiter // 
    CREATE PROCEDURE isCountryExits(IN searchQuery VARCHAR(20), IN caseSesitive BOOLEAN)
    BEGIN
       IF caseSesitive THEN
           SELECT
              country  AS Land
           FROM
              country 
           WHERE 
              country LIKE BINARY searchQuery;
        ELSE
           SELECT
              country  AS Land
            FROM 
               country 
            WHERE
               country LIKE searchQuery;
        END IF;
    END//
    DELIMITER ;
    CALL isCountryExits('GermanY', false);
    CALL isCountryExits('GermanY', true);


-- STO_02) Schreiben sie eine Stored-Procedure, bei welcher eine Landesbezeichnung uebergeben werden kann. 
--         Existiert dieses Land noch nicht in der country Tabelle, wird es dort eingefuegt.
--         Der PK dieses Landes wird als Parameter zurueck gegeben
    DROP PROCEDURE IF EXISTS getCountryId;
    DELIMITER $$
    CREATE PROCEDURE getCountryId(IN landesNamen VARCHAR(50), OUT land_id SMALLINT(5))
    BEGIN
        IF((SELECT COUNT(*) FROM country WHERE country = landesNamen) = 0) THEN
            INSERT INTO country(`country`) VALUES (landesNamen);
        END IF;
        SELECT country_id FROM country WHERE country = landesNamen INTO land_id;
    END$$
    DELIMITER ;

    CALL isCountryExits('Lichtenstein', false);
    CALL getCountryId('Lichtenstein', @country_pk);
    SELECT @country_pk;
    
    SELECT * FROM country WHERE country = 'Lichtenstein';


-- STO_03) Schreiben sie eine Stored-Procedure bei welcher 2 Parameter uebergeben werden koennen. 
--         Der erste Parameter ist eine Stadt und der zweite ein Land. 
--         Die Procedure checked als erstes ob das Land bereits in country existiert
--              wenn Nein: Insert neues Land
--         Danach wird der PK des neuen Landes geholt
--         Checken ob Die Stadt in diesem Land bereits besteht
--              wenn Ja: nichts weiter machen
--              wenn Nein: Stadt in city einfuegen mit dem PK des Landes
    DROP PROCEDURE IF EXISTS getCityId;
    DELIMITER $$
    CREATE PROCEDURE getCityId(IN ortsNamen varchar(45), IN landesName varchar(45), OUT city_id SMALLINT(5))
    BEGIN
        CALL getCountryId(landesName, @land_id);
        IF((SELECT COUNT(*) FROM city WHERE country_id = @land_id AND city = ortsNamen) = 0) THEN
            INSERT INTO city (city, country_id) VALUES (ortsNamen, @land_id);
        END IF;
        SELECT city_id FROM city WHERE city = ortsNamen AND country_id = @land_id INTO city_id;
    END$$
    DELIMITER ;

    SELECT city_id FROM city WHERE city = 'Rom' AND country_id =119;

    CALL getCityId('Roma', 'Italien', @city_pk);
    SELECT @city_pk;

    CALL getCityId('Schaan', 'Lichtenstein', @city_pk);
    SELECT @city_pk;


-- STO_04) Schreiben sie eine Stored-Procedure, welche eine city mittels ID loescht.
    -- Noch testen!!! 
    DROP PROCEDURE IF EXISTS deleteCityById;
    DELIMITER $$
    CREATE PROCEDURE deleteCityById(IN id SMALLINT(5), OUT countOfDelete SMALLINT(5))
    BEGIN
        SELECT COUNT(*) FROM city WHERE city_id = id INTO countOfDelete;
        IF((SELECT COUNT(*) FROM city WHERE city_id = id) != 0) THEN
            DELETE FROM city WHERE city_id=id;
        END IF;
    END$$
    DELIMITER ;

    CALL deleteCityById(601, @countOfDel);
    SELECT @countOfDel;


-- STO_05) Schreiben sie eine Stored-Procedure, welche eine city mittels name loescht.
    -- Noch testen!!!
    DROP PROCEDURE IF EXISTS deleteCityByName;
    DELIMITER $$
    CREATE PROCEDURE deleteCityByName(IN ortsNamen varchar(45), OUT countOfDelete SMALLINT(5))
    BEGIN
        SELECT COUNT(*) FROM city WHERE city = ortsNamen INTO countOfDelete;
        IF((SELECT COUNT(*) FROM city WHERE city = ortsNamen) != 0) THEN
            DELETE FROM city WHERE city = ortsNamen;
        END IF;
    END$$
    DELIMITER ;

    CALL deleteCityByName('Vaduz', @countOfDel);
    SELECT @countOfDel;






-- nur fuer BZU Schema!!!!!!
DROP PROCEDURE IF EXISTS insertOrt;
Delimiter // 
CREATE PROCEDURE `insertOrt`(IN ort_id smallint(5), IN plz smallint(4), In bezeichnung varchar(45))
BEGIN
    SELECT concat('insertOrt(', ort_id , ',' , plz, ',' , bezeichnung);
END//

-- call insertOrt(100,8853,'Lachen');

-- END procedures


-- START subQueries
-- SUB_QUERIES
-- ===========
-- 5.1) Nehmen Sie eine funktionierende Abfrage. Verwenden Sie diese Query als "Derived Table (Subqueries in the FROM clause) und 
--      und selektieren sie eine Spalte (z.B. original_language) aber nur von den Data-Tubles, welche nicht NULL sind.
SELECT 
    SUBQ_1.Originalsprache AS ORGLANG 
FROM (
    SELECT 
        f.title       AS Title, 
        lang.name     AS Sprache,
        orgLang.name  AS Originalsprache
    FROM
        film AS f
    INNER      JOIN language AS lang    ON f.language_id          = lang.language_id
    LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id) AS SUBQ_1
WHERE SUBQ_1.Originalsprache IS NOT NULL;

-- 5.2 (siehe 1.14.1) Erstellen Sie eine Liste Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit einem Umsatz > 170
SELECT 
    UmsatzListe.Vorname   AS Firstname,
    UmsatzListe.Nachname  AS Lastname,
    UmsatzListe.Kunden_ID AS Kunde,
    UmsatzListe.Umsatz    AS Sales
FROM (
    SELECT
       C.first_name  AS Vorname,
       C.last_name   AS Nachname,
       P.customer_id AS Kunden_ID,
       sum(P.amount) AS Umsatz
    FROM 
       payment AS P
    LEFT JOIN customer AS C ON C.customer_id = P.customer_id
    GROUP BY
       P.customer_id
    ORDER BY
       P.customer_id,
       P.amount    DESC) AS UmsatzListe
WHERE
    UmsatzListe.Umsatz > 170;

-- 5.3) Listen sie alle Filme-Titles auf, welche als Sprache "GERMAN" oder "ENGLISH" haben.
--      Verwenden Sie dazu eine Subquery als Scalar-Operand fuer einen Vergleich
SELECT
    title                AS  FilmTitle,
    original_language_id AS  Sprache
FROM
    film
WHERE
    original_language_id IN (
        SELECT
            language_id AS Id
        FROM
            language
        WHERE
            name = "GERMAN"   OR
            name = "ENGLISH"
    );


-- END subQueries