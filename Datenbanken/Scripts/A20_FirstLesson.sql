SELECT
	f.description AS Beschreibung,
	f.title       AS Titel,
    a.first_name
FROM
	film  AS f,
    actor AS a
WHERE a.first_name = 'PENELOPE';

SELECT
	ci.city       AS Stadt,
    ci.country_id AS `id Land`,
    co.country    AS Land
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
