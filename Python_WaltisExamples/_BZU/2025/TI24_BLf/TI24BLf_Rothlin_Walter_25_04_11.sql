-- File:  TI24BLf_Rothlin_Walter.sql
-- Owner: Walter Rothlin
--
-- History:
-- 13-Feb-2025 Walter Rothlin	Initial Version
-- 06-Mar-2025 Walter Rothlin	Date/Time examples
-- 13-Mar-2025 Walter Rothlin	Group By
-- 03-Apr-2025 Walter Rothlin	Joins
-- 11-Apr-2025 Walter Rothlin	Outer Joins
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


-- ---------------------------------------------------------------------------
-- Group-By
-- ---------------------------------------------------------------------------
SELECT
	`Staedte`.`Land`           AS `Land`,
    count(`Staedte`.`PK`)      AS `Anzahl Staedte`
FROM (
	SELECT
		`ci`.`city_id`     AS `ID`,
		`ci`.`city`        AS `Stadt`,
		`co`.`country`     AS `Land`,
		`co`.`country_id`  AS `PK`,
		`ci`.`country_id`  AS `FK`
	FROM `country` AS `co`, `city` AS `ci`
	WHERE `ci`.`country_id` = `co`.`country_id`
) AS `Staedte`
GROUP BY `Staedte`.`PK`
ORDER BY `Anzahl Staedte` DESC;


SELECT
	`ci`.`city_id`,
    `ci`.`city`,
    `ci`.`country_id`,
    `co`.`country_id`,
    `co`.`country`    
FROM `city` AS `ci`, `country` AS `co`;


SELECT * FROM `country`;

SELECT
    count(`country_id`)
FROM `city`
GROUP BY country_id;

-- ---------------------------------------------------------------------------
-- Zusammengesetzte Attribute / Views
-- ---------------------------------------------------------------------------
DROP VIEW IF EXISTS actor_names; 
CREATE VIEW actor_names AS
	SELECT
		actor_id                            AS ID,
		first_name                          AS Vorname,
		last_name                           AS Nachname,
		CONCAT(UPPER(LEFT(first_name, 1)), 
			   LOWER(SUBSTRING(first_name, 2))) AS Prop_Vorname,
		CONCAT(UPPER(LEFT(last_name, 1)), 
			   LOWER(SUBSTRING(last_name, 2))) AS Prop_Nachname,
		CONCAT(
			CONCAT(UPPER(LEFT(first_name, 1)), 
				   LOWER(SUBSTRING(first_name, 2))),' ',
			CONCAT(UPPER(LEFT(last_name, 1)), 
				   LOWER(SUBSTRING(last_name, 2)))
		)    AS `Full-Name`,
		LEFT(first_name,1)                  AS Initial,
		CONCAT(
			LEFT(first_name,1),
			'.',
			CONCAT(
				UPPER(LEFT(last_name, 1)), 
				LOWER(SUBSTRING(last_name, 2)))
		)                   AS `Initial.Name`           
	FROM
		actor;
        
-- ---------------------------------------------------------------------------
-- Joins / Views
-- ---------------------------------------------------------------------------

DROP VIEW IF EXISTS city_country; 
CREATE VIEW city_country AS
	SELECT
		ci.city_id    AS ID,
		ci.city       AS Stadt,
		-- ci.country_id AS FK,
		-- co.country_id AS PK,
		co.country    AS Land
	FROM city AS ci
	INNER JOIN country AS co ON ci.country_id = co.country_id;
    
    
DROP VIEW IF EXISTS address_city_country; 
CREATE VIEW address_city_country AS    
	SELECT
		a.address_id,
		a.address,
		-- a.city_id        AS FK_City,
		-- ci.city_id       AS PK_City,
		ci.city          AS Stadt,
		-- ci.country_id	 AS FK_Country,
		-- co.country_id	 AS PK_Country,
		co.country       AS Land,
		a.address2,
		a.district,
		a.postal_code,
		a.phone,
		a.location
	FROM address AS a
	INNER JOIN city    AS ci ON a.city_id     = ci.city_id
	INNER JOIN country AS co ON ci.country_id = co.country_id;
    
    SELECT
		`f`.`film_id`               AS `ID`,
        `f`.`title`                 AS `Titel`,
        `f`.`description`           AS `Beschreibung`,
        `f`.`language_id`           AS `FK Ton Spur`,
        `ton_spur`.`name`           AS `Ton Sprache`,
        `f`.`original_language_id`  AS `FK Original Sprache`,
        `org_lang`.`name`           AS `Original Sprache`
    FROM `film` AS `f`
    INNER JOIN      `language` AS `ton_spur` ON `f`.`language_id`          = `ton_spur`.`language_id`
    LEFT OUTER JOIN `language` AS `org_lang` ON `f`.`original_language_id` = `org_lang`.`language_id`;