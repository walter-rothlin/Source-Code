-- For BWI-A20 Database
--
-- 15.3.22	First day

SELECT
	f.description AS Beschreibung,
	f.title       AS Titel,
    a.first_name
FROM
	film  AS f,
    actor AS a
WHERE a.first_name = 'PENELOPE';  -- String Literal

SELECT
	ci.city       AS Stadt,
    ci.country_id AS `id Land`,   -- Namensbegrenzung
    co.country    AS Land,
    co.last_update
FROM city AS ci
INNER JOIN country AS co ON ci.country_id = co.country_id;

SELECT
    country_id,
    country
FROM
	country
WHERE country_id = 87;

SELECT
	count(country_id) AS Anzahl
FROM Country;

SELECT COUNT(*) FROM Country;
SELECT COUNT(3) FROM Country;

SELECT 
	COUNT(DISTINCT first_name)
FROM
	actor
ORDER BY
	first_name DESC;
