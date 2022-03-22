-- For BWI-A20 Database
--
-- 22.3.22	3rd day

-- Liste aller Orte mit den zugehoerenden Laendern
DROP VIEW CityListe;
CREATE VIEW CityListe AS
	SELECT
        ci.city_id  AS CityId,
		ci.city     AS `Ort`,
		co.country  AS Land
	FROM city AS ci
	JOIN country AS co ON co.country_id = ci.country_id;


SELECT 
	CityId,
    Ort,
    Land
FROM CityListe
WHERE Ort like 'K%';


-- Liste aller Film-Titel, Sprache
CREATE VIEW filmSprachen AS
	SELECT
		f.title  AS Titel,
		l.name   AS Sprache,
		ol.name  AS `Original Sprache`
	FROM film AS f
	INNER JOIN      language AS l  ON f.language_id          = l.language_id
	LEFT OUTER JOIN language AS ol ON f.original_language_id  = ol.language_id;

SELECT * FROM  filmSprachen;



-- Wieviele Filme haben eine Originalsprache gesetzt
SELECT count(original_language_id) FROM film WHERE original_language_id is NOT NULL;


SELECT 
	last_update,
	DATE_FORMAT(last_update,'%Y-%m-%d %H:%i:%s') 
FROM country;