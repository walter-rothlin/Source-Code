-- START title
-- ================================
-- Aufgaben-Sammlung (AufgabenLoesungen_1_SELECT.sql)
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
    sakila.act.first_name AS Vorname,
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
ORDER BY 
    last_name,
    first_name;  -- 121

-- 1.8) liste alle Schauspielern (Vorname und Nachname) auf, welche Kirsten zum Vornamen heissen? Sortiere diese
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

-- 1.14) ... und nun noch die Namen und Vornamen der Kunden
SELECT 
   payment.customer_id    As Kunden_ID,
   customer.first_name    AS Vorname,
   customer.last_name     AS Name,
   sum(payment.amount)    AS Umsatz
FROM 
   payment
LEFT JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY
   payment.customer_id
Order BY
   Umsatz DESC;
    
-- 1.12) Noch nicht loesen!!!!
--       In der staff table hat es ein Attribute picture vom Type BLOB. Googeln Sie, was das fuer ein Type ist und 
--       laden Sie ein Bild fuer eine Record (staff_id = 1) in dieses Feld




-- END select


-- START functions
-- Select mit Functions-Aufruf
-- ===========================

-- 2.1) liste alle Schauspielern (Vorname, Nachname und LAST_UPDATE im format [yyyy-mon-dd]) auf, sowie den entsprechenden Wochentag aber 
--      nur die, welche an einem bestimmten Datum geaendert wurden
--      https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html
SELECT 
    first_name AS Vorname,
    last_name AS Nachname,
    DATE_FORMAT(last_update, '%Y-%M-%d') AS LastUpdate,
    DAYNAME(last_update) AS Weekday
FROM
    actor
WHERE 
    date(last_update) = STR_TO_DATE('February 15, 2006','%M %d,%Y');

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
    rating, 
    special_features 
FROM 
    film
WHERE
    rating = 'PG' AND    -- e.g. Parental Guidance (Amerikanische Alterbeschränkung)
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
    JSON_OBJECT("Vorname", first_name, "Nachname",last_name) AS JASON
FROM
    actor;
    
-- 2.6) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme? 
--       Uebersetze den Name ED zu Edi und KARL zu Kari!
--       https://dev.mysql.com/doc/refman/5.7/en/case.html
SELECT 
    CASE 
      WHEN first_name = "ED"   THEN "Edi"
      WHEN first_name = "KARL" THEN "Kari"
      ELSE first_name
    END AS Vorname,
    last_name AS Nachname
FROM
    actor;
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

-- END metaData


-- START joins
-- Joins
-- =====
-- Erstellen Sie eine Orte Länderliste  (Kreuzprodukt)
SELECT
	city.city as Stadt,
    country.country as Land
FROM
	city, country;

-- Erstellen Sie eine Orte Länderliste (Kreuzprodukt)
SELECT
	S.city as Stadt,
    L.country as Land
FROM
	city as S, country as L;
 
-- Erstellen Sie eine Orte Länderliste (mit where close)
SELECT
	S.city as Stadt,
    L.country as Land
FROM
	city as S, country as L
WHERE
	S.country_id = L.country_id;

-- Erstellen Sie eine Orte Länderliste (mit inner join)
SELECT
	S.city as Stadt,
    L.country as Land
FROM
	city as S
INNER JOIN country as L on S.country_id = L.country_id;    

-- Erstellen Sie eine Orte Länderliste (mit left join)
SELECT
	S.city as Stadt,
    L.country as Land
FROM
	city as S
LEFT JOIN country as L on S.country_id = L.country_id;

-- Erstellen Sie eine Orte Länderliste (mit right join)
SELECT
	S.city as Stadt,
    L.country as Land
FROM
	country as L
RIGHT JOIN city as S on S.country_id = L.country_id; 

SELECT
     f.film_id      AS Id,
     f.title        AS Title,
     lang.name      AS Sprache,
     orgLang.name   AS Originalsprache
FROM
     film AS f
LEFT JOIN language AS lang    ON f.language_id          = lang.language_id
LEFT JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

--  4.0) Machen Sie folgende Aenderungen in skaila (Am einfachsten mit der Workbench):
--        a) fügen Sie eine weitere Sprache 'Schweizerdeutsch' in die Tabelle language 
--             INSERT INTO language (name) VALUES ('Schweizerdeutsch');
SELECT * FROM language;
INSERT INTO language (name) VALUES ('Schweizerdeutsch');
INSERT INTO language (name) VALUES ('Suiss Italien');
INSERT INTO language (name) VALUES ('Schweizerdeutsch'),('Suiss Italien');


--        b) setzen Sie für die beiden Filme mit der film_id 1 und 2 die original_language_id auf 1 resp 2
--             UPDATE film SET original_language_id=1 WHERE film_id=1;
--             UPDATE film SET original_language_id=6 WHERE film_id=2;
UPDATE film SET original_language_id=1 WHERE film_id=1;
UPDATE film SET original_language_id=1 WHERE film_id=2;

--        c) um diese Aenderungen am Schluss wieder Rueckgaengig zu machen verwenden Sie:
--              DELETE FROM language WHERE name='Schweizerdeutsch';
--              UPDATE film SET original_language_id=null WHERE film_id IN (1,2);


-- MySQL Workbench unter Edit > Preferences > SQL Queries das Feld “Safe Updates”
DELETE FROM language WHERE name='Schweizerdeutsch';

UPDATE film SET original_language_id=null WHERE film_id IN (1,2);



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

--  4.2)  Wie viele Einträge gibt es in der film  und in der language Tabelle?
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
WHERE f.original_language_id is not NULL;  -- 2 rows



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





-- 4.3.1) Listen sie Alle Städte auf und in wievielen Landern diese vorkommen absteigend sortiert nach den anzahl Laendern
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

-- 4.4.1) Erstellen Sie eine Liste mit allen ausgeliehenen DVDs und listen Sie die Vor-, Nachnamen
--        und Telefonnummern der Ausleiher auf sowie den Titel der DVD, welche am 27.5.2005 
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

-- START subQueries

-- SUB_QUERIES
-- ===========
-- 5.1) Nehmen Sie eine funktionierende Abfrage z.B. 4.2.5. Verwenden Sie diese Query als "Derived Table (Subqueries in the FROM clause) und 
--      und selektieren sie eine Spalte (z.B. original_language) aber nur von den Data-Tubles, welche nicht NULL sind.
SELECT SUBQ_1.Originalsprache AS ORGLANG FROM (
	SELECT 
		f.title       AS Title, 
		lang.name     AS Sprache,
		orgLang.name  AS Originalsprache
	FROM
		film AS f
	LEFT OUTER JOIN language AS lang    ON f.language_id          = lang.language_id
	LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id) as SUBQ_1
WHERE SUBQ_1.Originalsprache IS NOT NULL;

-- 5.2) Listen sie alle Filme-Titles auf, welche als Orginal-Sprache "GERMAN" oder "ENGLISH" haben.
--      Verwenden Sie dazu eine Subquery als Scalar-Operand für einen Vergleich
SELECT
	title                AS  FilmTitle,
    original_language_id AS  Sprache
FROM
    film
WHERE
	original_language_id in (
		SELECT
			language_id AS Id
		FROM
			language
		WHERE
			name = "GERMAN"   OR
            name = "ENGLISH"
    );


-- END subQueries

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


-- START ownFunctions
-- FUNCTIONS
-- ---------
-- Schreiben sie eine eigene Function. Diese Function nimmt ein String-Parameter entgegen und gibt einen 
-- String in der Form Hello : inString zurueck. 
-- Nach der Implementation testen sie die Function aus.
DROP FUNCTION IF EXISTS HelloFct;
Delimiter //
CREATE FUNCTION HelloFct(p_input_string CHAR(20)) RETURNS CHAR(50)
  BEGIN
    RETURN  concat('Hallo: ', p_input_string);
  END
//
select HelloFct('Walti') as HALLO;

-- END ownFunctions


-- START procedures
-- STORED PROCEDURES
-- -----------------
-- Schreiben sie eine Stored-Procedure bei welcher 2 Parameter uebergeben werden koennen. 
-- Der erste Parameter ist ein Land und der zweite ob case-sensitve oder nicht gesucht werden soll.
DROP PROCEDURE IF EXISTS test_searchCountry;

Delimiter // 
CREATE PROCEDURE test_searchCountry(IN searchQuery VARCHAR(20), IN caseSesitive BOOLEAN)
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

call test_searchCountry('GermanY', false);
call test_searchCountry('GermanY', true);


DROP PROCEDURE IF EXISTS insertOrt;
Delimiter // 
CREATE PROCEDURE `insertOrt`(IN ort_id smallint(5), IN plz smallint(4), In bezeichnung varchar(45))
BEGIN
	SELECT concat('insertOrt(', ort_id , ',' , plz, ',' , bezeichnung);
END//

call hwz_test_1.insertOrt(100,8853,'Lachen');

-- END procedures
