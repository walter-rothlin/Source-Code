-- 18.5.21 (2.Abend)
-- =================
select
	country as Land,
    country_id,
    country
from country
where country = 'Angola';

select
	city_id,
    city,
    country_id
from city
where country_id = 4;

select * from country;

-- Join
select
	city_id,
    city,
    country
from city
inner join country on city.country_id = country.country_id;

select
	city.city_id,
    city.city,
    country.country
from city,country
where city.country_id = country.country_id;

select
	title,
    language_id,
    original_language_id
from film;

select * from language;

select
	title,
    lang.name
from film
inner join language as lang on film.language_id = lang.language_id;

select
	title,
    name
from film
left outer join language on film.original_language_id = language.language_id;

select * from film where original_language_id is not null;

select
	title         as Filmtitel,
    lang.name     as Sprache,
    org_lang.name as OrgSprache
from film
inner join language as lang on film.language_id = lang.language_id
left outer join language as org_lang on film.original_language_id = org_lang.language_id;


-- 1.6.21 (3.Abend)
-- ================

-- 1.6) Von wie viele Schauspieler hat es im DVD im Store?
SELECT
	count(*) AS Anzahl
FROM
	actor;

SELECT
	count('A') AS Anzahl
FROM
	actor;

SELECT
	count(DISTINCT first_name) AS Anzahl
FROM
	actor;

SELECT DISTINCT
	first_name AS Anzahl
FROM
	actor;
    
-- 2.2) liste alle Schauspielern (Vorname, Nachname und LAST_UPDATE [yyyy-mon-dd]), bei welchen der Vorname mit A beginnt und der zweitletzte Buchstabe im Vornamen ebenfalls  ein A ist sowie der Nachname nicht ALLEN oder BAILEY ist.
SELECT
	first_name,
    last_name,
    DATE_FORMAT(last_update, '%Y-%b-%d') AS `Letzte Aenderung`
FROM
	actor
WHERE
	DATE_FORMAT(last_update, '%d-%m-%Y') = '15-02-2006';
    
-- 2.4) Erstellen Sie eine Liste mit allen Namen und Vorname von staff, welche nur den Anfangsbuchstaben des Vornamen mit einem . getrennt vom vollstaendigen Nachnamen auflistet.
--      https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT
	Concat(Left(first_name,1), '.', last_name) AS Name
FROM
	staff;
    
-- 2.5) Von welchen Schauspielern (Vorname und Nachname) hat der Store Filme? Liste diese in einer JASON Struktur auf!
--       https://dev.mysql.com/doc/refman/5.7/en/json-creation-functions.html#function_json-array
SELECT 
    JSON_OBJECT('Vorname', first_name, 'Nachname',last_name) AS JSON
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
	actor
ORDER BY first_name;

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

-- 5.1) Nehmen Sie eine funktionierende Abfrage. Verwenden Sie diese Query als "Derived Table (Subqueries in the FROM clause) und 
--      und selektieren sie eine Spalte (z.B. original_language) aber nur von den Data-Tubles, welche nicht NULL sind.
SELECT SUBQ_1.Originalsprache AS ORGLANG FROM (
	SELECT 
		f.title       AS Title, 
		lang.name     AS Sprache,
		orgLang.name  AS Originalsprache
	FROM
		film AS f
	INNER JOIN language AS lang    ON f.language_id          = lang.language_id
	LEFT OUTER JOIN language AS orgLang ON f.original_language_id = orgLang.language_id) as SUBQ_1
WHERE SUBQ_1.Originalsprache IS NOT NULL;



-- 5.3) Listen sie alle Filme-Titles auf, welche als Sprache "GERMAN" oder "ENGLISH" haben.
--      Verwenden Sie dazu eine Subquery als Scalar-Operand fuer einen Vergleich
SELECT
	F.title                AS  FilmTitle,
    L.name                 AS  Sprache,
    F.language_id          AS  SpracheId
FROM
    film AS F
LEFT JOIN language AS L on L.language_id = F.language_id
WHERE
    F.language_id in (
          SELECT
			language_id
		  FROM
            language
		  WHERE name = 'GERMAN' OR name = 'ENGLISH'
    );
    
-- CRUD Aufgabe (siehe Moodle)
SELECT * FROM language;
INSERT INTO language (name) VALUES ('Schweizerdeutsch'), ('Dutch');

SELECT * FROM language;
UPDATE film SET original_language_id=7 WHERE film_id=1;

SELECT
	f.title          AS Title,
    orgLang.name     AS Sprache
FROM
	film as f
LEFT JOIN language AS orgLang ON f.original_language_id = orgLang.language_id;

UPDATE film SET original_language_id= NULL WHERE film_id=1;
DELETE FROM language WHERE name='Schweizerdeutsch';
