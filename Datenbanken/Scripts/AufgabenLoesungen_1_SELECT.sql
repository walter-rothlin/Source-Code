-- START title

-- ---------------------------------------------------------------------------------------------
-- AufgabenLoesungen_1_SELECT.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Aufgaben und Loesungen zu DML
--
-- History:
-- 15-May-2020   Walter Rothlin      Initial Version
-- 02-Feb-2021   Walter Rothlin	     Adapded for BWI-A19
-- 09-Jun-2021   Walter Rothlin      Explained "Safe Updates"
-- 18-Jun-2021   Walter Rothlin      Added more functions
-- 18-Feb-2022   Walter Rothlin      Minor changes
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
-- Select mit Order by und Where-Clause
-- ====================================
-- 1.1) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme?
SELECT 
    first_name,
    last_name
FROM
    actor;

-- 1.2) Beschrifte die Resultat-Tabelle von 1.1 mit Vorname und Nachname als Spalten-Header
SELECT 
    sakila.act.first_name AS Vorname,
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

-- 1.6) Von wie viele Schauspieler hat es im DVD im Store?
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
--      nach Nachnamen absteigend und nach Vorname aufsteigend
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    first_name = 'Kirsten'
ORDER BY
    last_name DESC,
    first_name;


-- 1.9) Liste alle Schauspielern (Vorname und Nachname) auf, welche NICK zum Vornamen heissen oder ein SS im Vornamen haben oder deren Vorname genau 4 Buchstaben lang ist.
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

    
-- 1.10) Liste alle Schauspielern (Vorname und Nachname) auf, bei welchen der Nachname mit BER beginnt oder deren Vorname mit NA endet
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html
SELECT 
    first_name AS FName,
    last_name  AS LName
FROM
    actor
WHERE    
    last_name  REGEXP BINARY "^BER"  OR
    first_name REGEXP BINARY "NA$";
    
-- 1.11) Liste film_id, title, rating, special_features von der Tabelle film auf.
--       Was ist der Type der Attribute rating und special_features?
SELECT 
    film_id,
    title,
    rating,            -- Enumeration
    special_features   -- Set / Menge
FROM
    film;

-- 1.12) Erstellen Sie eine Listen der bezahlten Betraege (FROM payment), sortiert nach customer_id und Betraege
SELECT 
   customer_id,
   amount
FROM 
   payment
ORDER BY
   customer_id,
   amount    DESC;

-- 1.12.1) Erstellen Sie eine Listen (mit Vor- und Nachnamen) der bezahlten Betraege (FROM payment), sortiert nach customer_id und Betraege   
SELECT
   C.first_name,
   C.last_name,
   P.customer_id,
   P.amount
FROM 
   payment AS P
LEFT JOIN customer AS C ON C.customer_id = P.customer_id
ORDER BY
   P.customer_id,
   P.amount    DESC;

-- 1.13) Erstellen Sie eine Listen aller Kunden_id mit deren Umsaetzen (FROM payment), sortiert nach customer_id und Betraege   
SELECT 
   P.customer_id,
   sum(P.amount)
FROM 
   payment AS P
GROUP BY
   P.customer_id
ORDER BY
   P.customer_id,
   P.amount    DESC;

-- 1.13.1) Erstellen Sie eine Listen aller Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment), sortiert nach customer_id und Betraege   
SELECT
   C.first_name,
   C.last_name,
   P.customer_id,
   sum(P.amount)
FROM 
   payment AS P
LEFT JOIN customer AS C ON C.customer_id = P.customer_id
GROUP BY
   P.customer_id
ORDER BY
   P.customer_id,
   P.amount    DESC;
   
-- 1.14) Erstellen Sie eine Listen Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit ID < 5
SELECT
   C.first_name,
   C.last_name,
   P.customer_id    AS Kunden_ID,
   sum(P.amount)    AS Umsatz
FROM 
   payment as P
LEFT JOIN customer as C on C.customer_id = P.customer_id
WHERE P.customer_id < 5
GROUP BY
   P.customer_id
Order BY
   Umsatz DESC;
   
-- 1.14) Erstellen Sie eine Listen Kunden_id mit deren Umsaetzen (FROM payment),
--       ordnen Sie die Liste nach den Umsaetzen (Bester Kunde zuoberst)
--       Nur von den Kunden mit einem Umsatz > 170
SELECT 
    UmsatzListe.Kunden_ID AS Kunde,
    UmsatzListe.Umsatz    AS Sales
FROM (
    SELECT 
       P.customer_id AS Kunden_ID,
       sum(P.amount) AS Umsatz
    FROM 
       payment AS P
    GROUP BY
       P.customer_id
    ORDER BY
       P.customer_id,
       P.amount    DESC) AS UmsatzListe
WHERE
    UmsatzListe.Umsatz > 170;

-- 1.14.1) Erstellen Sie eine Listen Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment),
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
    LEFT JOIN customer as C on C.customer_id = P.customer_id
    GROUP BY
       P.customer_id
    ORDER BY
       P.customer_id,
       P.amount    DESC) AS UmsatzListe
WHERE
    UmsatzListe.Umsatz > 170;
    


-- 1.14) Noch nicht loesen!!!!
--       In der staff table hat es ein Attribute picture vom Type BLOB. Googeln Sie, was das fuer ein Type ist und 
--       laden Sie ein Bild fuer eine Record (staff_id = 1) in dieses Feld




-- END select


-- START functions
-- Select mit Functions-Aufruf
-- ===========================
-- https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
-- https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html
-- https://dev.mysql.com/doc/refman/5.7/en/regexp.html
-- https://dev.mysql.com/doc/refman/5.7/en/retrieving-data.html
-- https://dev.mysql.com/doc/refman/5.7/en/json-creation-functions.html#function_json-array
-- https://dev.mysql.com/doc/refman/5.7/en/case.html
-- https://dev.mysql.com/doc/refman/5.7/en/pattern-matching.html
-- https://www.w3schools.com/sql/sql_join.asp


-- 2.1) liste alle Schauspielern (Vorname, Nachname und LAST_UPDATE im format [yyyy-mon-dd]) auf, sowie den entsprechenden Wochentag aber 
--      nur die, welche an einem bestimmten Datum geaendert wurden
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

-- 2.1.1) mit STR_TO_DATE in where clause (Effizienter! Wieso?)
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d') AS LastUpdate,
    DAYNAME(last_update) AS Weekday
FROM
    actor
WHERE 
    date(last_update) = STR_TO_DATE('February 15, 2006','%M %d,%Y');

-- 2.1.2) mit STR_TO_DATE in where clause (Effizienter! Wieso?)
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d') AS LastUpdate,
    DAYNAME(last_update) AS Weekday
FROM
    actor
WHERE 
    DATE_FORMAT(last_update, '%Y-%M-%d') = "2006-February-15";

-- 2.2) liste alle Schauspielern (Vorname, Nachname und LAST_UPDATE [yyyy-mon-dd]), bei welchen der Vorname mit A beginnt und der zweitletzte Buchstabe im Vornamen ebenfalls  ein A ist sowie der Nachname nicht ALLEN oder BAILEY ist.
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d') AS LastUpdate
FROM
    actor
WHERE
    (NOT (first_name LIKE 'A%A_')) AND
    (last_name NOT IN ('Allen' , 'Bailey'));


-- 2.3) Listen Sie nur die Rows auf, welche im rating eine PG haben und in den special_features Trailes enthalten.
SELECT
    film_id, 
    title, 
    rating,          -- enum
    special_features -- set
FROM 
    film
WHERE
    rating = 'PG' AND    -- e.g. Parental Guidance (Amerikanische Alterbeschraenkung)
    find_in_set('Trailers', special_features);

-- 2.4) Erstellen Sie eine Liste mit allen Namen und Vorname von staff, welche nur den Anfangsbuchstaben des Vornamen mit einem . getrennt vom vollstaendigen Nachnamen auflistet.
--      https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT 
    CONCAT(LEFT(first_name, 1), '. ', last_name) AS staff
FROM
    staff;
    
-- 2.5) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme? Liste diese in einer JASON Struktur auf!
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

-- 3.1) liste alle Tabellen, welche im Namen film enthalten, in der DB (im Schema) sakila auf und zeige deren Type an.
--      https://dev.mysql.com/doc/refman/5.7/en/tables-table.html
SELECT 
    table_schema, 
    table_name, 
    table_type
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    table_name LIKE '%film%'
ORDER BY 
    table_schema,
    table_name,
    table_type;

-- 3.2) liste alle Attribute (mit Type) aller Tabellen in der DB (im Schema) sakila auf.
--      https://dev.mysql.com/doc/refman/5.7/en/columns-table.html
SELECT 
    table_schema,
    TABLE_NAME,
    column_name,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    table_schema = 'sakila'
ORDER BY table_schema , Table_NAME , column_name;


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
-- Kreieren sie eine View mit alle Staedte und deren Laender.
DROP VIEW IF EXISTS test_city_country;

CREATE VIEW test_city_country AS
     SELECT 
        city.city       AS Stadt, 
        country.country AS Land
     FROM
        city
        INNER JOIN country ON city.country_id=country.country_id
     ORDER BY city.city ASC;

select Stadt, Land from test_city_country;

-- END views

-- START CRUD
-- Insert - Update - Delete
-- ========================
--  CRUD 0)  Welche Laender sind erfasst?
SELECT * FROM country;

--  CRUD 1)  Fuegen Sie das Land "Lichtenstein" ein
INSERT INTO country (country) VALUES ('Lichtenstein');

--  CRUD 1a)  Wie lautet der PK von 'Lichtenstein'?
SELECT country_id from country where country = 'Lichtenstein';


--  CRUD 2)  Fuegen Sie die beiden Staedte "Vaduz" und "Schan" ein. Beide gehoeren zum Land "Lichtenstein".
INSERT INTO city (city,country_id) VALUES 
    ('Vaduz', 111), 
    ('Schan', 111);

--  CRUD 2a)  Wie lauten die beiden PKs dieser beiden Orte?    
SELECT
    city_id,
    city,
    country_id
FROM
    city
WHERE country_id = 111;

SELECT
    city_id,
    city,
    country_id
FROM
    city
WHERE country_id = (SELECT country_id from country where country = 'Lichtenstein');

--  CRUD 2b)  Erstellen sie eine Liste mit den Orten und dem Landesnamen von Lichtenstein (inner Join)
SELECT
    city_id,
    city,
    country.country_id,
    country.country
FROM
    city
INNER JOIN country ON city.country_id = country.country_id
WHERE city.country_id = (SELECT country_id from country where country = 'Lichtenstein'); 

--  CRUD 2c)  Koorigieren Sie den Namen von 'Schan' auf 'Schaan'
--            Mögliche Fehlermeldung: "Safe Updates". Forbid UPDATEs and DELETEs with no key in WHERE clause
--            --> Workbench: Edit -> Preferences -> SQL Editor (Uncheck box at the end of the screen)
UPDATE city SET city='Schaan' WHERE city='Schan';


--  CRUD 3)  Loeschen Sie das Land "Lichtenstein". Lesen Sie die Fehlermeldung? Wieso geht das nicht?
DELETE FROM country WHERE country = 'Lichtenstein';

--  CRUD 3a)  Loeschen Sie nun zuerst alle Staedte von "Lichtenstein".
DELETE FROM city
WHERE country_id = (SELECT country_id FROM country WHERE country = 'Lichtenstein');

--  CRUD 3b)  Nun koennen Sie das Land "Lichtenstein" loeschen.
DELETE FROM country WHERE country = 'Lichtenstein';

--  CRUD 3c)  Kontrollieren Sie, ob Sie die Staedte und das Land wirklich geloescht haben.
SELECT country_id from country where country = 'Lichtenstein';    

SELECT
    city_id,
    city,
    country_id
FROM
    city
WHERE country_id = (SELECT country_id from country where country = 'Lichtenstein');

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
-- Uebung 1
-- ==============
--  Machen Sie folgende Aenderungen in skaila:
--  U1.1) Erstellen Sie eine Abfrage von film (mit inner joins) mit  title, original_language und language
SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache,
     orgLang.name   AS Originalsprache
FROM
     film AS f
INNER JOIN language AS lang    ON f.language_id          = lang.language_id
INNER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

--  U1.2)  Fuegen Sie drei weitere Sprache 'Schweizerdeutsch', 'Suiss Italian' und 'Dutch' in die Tabelle language 
SELECT * FROM language;
INSERT INTO language (name) VALUES ('Schweizerdeutsch');
INSERT INTO language (name) VALUES ('Suiss Italian');
INSERT INTO language (name) VALUES ('Dutch');
INSERT INTO language (name) VALUES 
    ('Schweizerdeutsch'), 
    ('Suiss Italian'), 
    ('Dutch');


--  U1.3)   Setzen Sie fuer die beiden Filme mit der film_id 1 und 2 die original_language_id auf 1 resp 2
UPDATE film SET original_language_id=1 WHERE film_id=1;  -- English
UPDATE film SET original_language_id=2 WHERE film_id=2;  -- Italian

--  U1.4)   Setzen Sie fuer den Filme mit der AFRICAN EGG die original_language_id auf 'Schweizerdeutsch'
SELECT language_id FROM language where name = 'Schweizerdeutsch';
SELECT film_id, title, original_language_id FROM film WHERE title='AFRICAN EGG';
UPDATE film SET original_language_id=7 WHERE film_id=5;
SELECT film_id, title, original_language_id FROM film WHERE film_id=5;

UPDATE film SET original_language_id=NULL WHERE film_id=5;

UPDATE film SET original_language_id=(SELECT language_id FROM language WHERE name='Schweizerdeutsch') WHERE title='AFRICAN EGG';

--  U1.5)   Loeschen Sie diese 3 neu zugefuegten Sprachen wieder! Wieso geht das nicht?
DELETE FROM language WHERE name in ('Schweizerdeutsch', 'Suiss Italian', 'Dutch');

--  U1.6)   Setzen Sie zuerst bei alle Filmen, welche einer dieser zugefuegten Sprachen als Original-Sprache gesetzt haben, diese wieder auf NULL 
UPDATE film SET original_language_id=NULL WHERE original_language_id in (SELECT language_id FROM language WHERE name IN ('Schweizerdeutsch', 'Suiss Italian', 'Dutch'));


-- END uebung_1



-- START pruefung

-- Pruefungsfragen
-- ==============

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
-- Schreiben sie eine eigene Function gemäss Spezification

-- Bei folgendem Fehler:
--    Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)

-- noch folgendes ausführen
--    SET GLOBAL log_bin_trust_function_creators = 1;

--  Fct 1.0)  Nimmt eine PLZ und hängt CH- vorne an.
--            SELECT formatPLZ(8855);     -- --> CH-8855

DROP FUNCTION IF EXISTS formatPLZ;
Delimiter //
CREATE FUNCTION formatPLZ(p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  concat('CH-', p_input_plz);
END
//
DELIMITER ;

SELECT formatPLZ(8855);     -- --> CH-8855


--  Fct 2.0) Nimmt eine Zeichenkette und hängt Hallo: vorne an.
--           SELECT sayHello('Walti');-- --> Hallo: Walti

DROP FUNCTION IF EXISTS sayHello;
-- DROP FUNCTION IF EXISTS HelloFct;
Delimiter //
CREATE FUNCTION sayHello(p_input_string CHAR(20)) RETURNS CHAR(50)
BEGIN
  RETURN  CONCAT('Hallo: ', p_input_string);
END//

SELECT sayHello('Walti');-- --> Hallo: Walti


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

SELECT firstUpper("herr");  -- --> Herr
SELECT firstUpper("HERR");  -- --> Herr
SELECT firstUpper("Herr");  -- --> Herr
SELECT firstUpper("hERR");  -- --> Herr


--  Fct 4.0) Nimmt eine Zeichenkette und hängt Hallo: vorne an.
--           SELECT getAnrede("Herr", "Walter", "Rothlin"); -- --> Herr W.Rothlin
--           SELECT getAnrede("herr", "walter", "rothlin"); -- --> Herr W.Rothlin
DROP FUNCTION IF EXISTS getAnrede;
Delimiter //
CREATE FUNCTION getAnrede(p_sex CHAR(20), p_firstname CHAR(20), p_lastname CHAR(20) ) RETURNS CHAR(50)
BEGIN
   RETURN  CONCAT(firstUpper(p_sex), ' ', UPPER(LEFT(p_firstname, 1)), '.', firstUpper(p_lastname));
END
//
DELIMITER ;

SELECT getAnrede("Herr", "Walter", "Rothlin"); -- --> Herr W.Rothlin
SELECT getAnrede("herr", "walter", "rothlin"); -- --> Herr W.Rothlin


-- END ownFunctions




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

    CALL isCountryExits('GermanY', false);
    CALL isCountryExits('GermanY', true);


-- STO_02) Schreiben sie eine Stored-Procedure, bei welcher eine Landesbezeichnung uebergeben werden kann. 
--         Existiert dieses Land noch nicht in der country Tabelle, wird es dort eingefuegt.
--         Der PK dieses Landes wird als Parameter zurueck gegeben
    DROP PROCEDURE IF EXISTS getCountryId;
    DELIMITER $$
    CREATE PROCEDURE getCountryId(IN landesNamen VARCHAR(50), out land_id SMALLINT(5))
    BEGIN
        IF((SELECT COUNT(*) FROM country WHERE country = landesNamen) = 0) THEN
            INSERT INTO country(`country`) VALUES (landesNamen);
        END IF;
        SELECT country_id FROM country WHERE country = landesNamen INTO land_id;
    END$$
    DELIMITER ;

    CALL getCountryId('Lichtenstein', @country_pk);
    SELECT @country_pk;


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

-- 5.2 (siehe 1.14.1) Erstellen Sie eine Listen Kunden_id, Vor- und Nachnamen mit deren Umsaetzen (FROM payment),
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