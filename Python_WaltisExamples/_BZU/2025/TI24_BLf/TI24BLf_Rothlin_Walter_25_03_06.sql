-- File:  TI24BLf_Rothlin_Walter.sql
-- Owner: Walter Rothlin
--
-- History:
-- 13-Feb-2025 Walter Rothlin	Initial Version
-- 06-Mar-2025 Walter Rothlin	Date/Time examples
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- Select Statement with WHERE-Clause
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


-- ---------------------------------------------------------------------------
-- Date / Time Functions
-- ---------------------------------------------------------------------------
SELECT * FROM `language` ORDER BY `last_update`;

SELECT * FROM `language`
-- WHERE `last_update` > STR_TO_DATE('01.01.2010','%d.%m.%Y')
WHERE YEAR(`last_update`) > 2010
ORDER BY `last_update`;

SELECT
    DATE_FORMAT(NOW(), '%a, %d.%m.%Y  %H:%i') AS `NOW`,
    `language_id`,
    `name`,
    `last_update`,
    DATE_FORMAT(`last_update`, '%a, %d.%m.%Y  %H:%i') AS `Date_Formated`
FROM `language`
WHERE DATE_FORMAT(`last_update`, '%d.%m.%Y') = '06.03.2025'
ORDER BY `last_update` DESC;

INSERT INTO `language` (`name`) VALUES ('Deutsch');
UPDATE `language` 
	SET `last_update` = STR_TO_DATE('06.03.2025 12:02:01', '%d.%m.%Y %T')
WHERE (`language_id` = '11');