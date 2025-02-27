-- File:  TI24BLf_Rothlin_Walter.sql
-- Owner: Walter Rothlin
--
-- History:
-- 13-Feb-2025 Walter Rothlin	Initial Version

-- ---------------------------------------------------------------------------



SELECT
	`f`.`title`       AS `Titel`,
    `f`.`rating`      AS `Rating`,
    `f`.`description` AS `Beschreibung`
FROM `film` AS `f`
WHERE (`rating` = 'PG' OR `rating` = 'G') AND
      (`title` LIKE 'AC%');
      
SELECT count(`film_id`) AS `Anzahl Filme` FROM `film`;
SELECT count(*) AS `Anzahl Filme` FROM `film`;
SELECT 
	count(3) AS `Anzahl Filme`,
    5 * 6    AS `Produkt`
FROM `film` 
WHERE `title` LIKE 'AC%';