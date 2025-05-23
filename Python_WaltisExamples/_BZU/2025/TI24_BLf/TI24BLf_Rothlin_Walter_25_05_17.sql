-- File:  TI24BLf_Rothlin_Walter.sql
-- Owner: Walter Rothlin
--
-- History:
-- 13-Feb-2025 Walter Rothlin	Initial Version
-- 06-Mar-2025 Walter Rothlin	Date/Time examples
-- 13-Mar-2025 Walter Rothlin	Group By
-- 03-Apr-2025 Walter Rothlin	Joins
-- 11-Apr-2025 Walter Rothlin	Outer Joins
-- 17-Apr-2025 Walter Rothlin	Own Functions
-- 15-May-2025 Walter Rothlin	Eigenes Schema kreieren und normalisieren
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

DROP VIEW IF EXISTS schauspieler_liste; 
CREATE VIEW schauspieler_liste AS   
	SELECT
		st.customer_id,
        st.first_name,
        st.last_name,
		a.address,
		ci.city          AS Stadt,
		co.country       AS Land
	FROM customer AS st
    INNER JOIN address    AS a  ON a.address_id    = st.address_id
	INNER JOIN city       AS ci ON a.city_id       = ci.city_id
	INNER JOIN country    AS co ON ci.country_id   = co.country_id;
    
DROP VIEW IF EXISTS `film_sprachen`; 
CREATE VIEW `film_sprachen` AS    
    SELECT
		`f`.`film_id`                 AS `ID`,
        `f`.`title`                   AS `Titel`,
        `f`.`description`             AS `Beschreibung`,
        -- `f`.`language_id`             AS `FK Ton Spur`,
        `ton_spur`.`name`             AS `Ton Sprache`,
        -- `f`.`original_language_id`    AS `FK Original Sprache`,
        IF (`org_lang`.`name` IS NULL,
            '--',
            `org_lang`.`name`)        AS `Original Sprache`
    FROM `film` AS `f`
    INNER JOIN      `language` AS `ton_spur` ON `f`.`language_id`          = `ton_spur`.`language_id`
    LEFT OUTER JOIN `language` AS `org_lang` ON `f`.`original_language_id` = `org_lang`.`language_id`;
    
    
-- ---------------------------------------------------------------------------
-- Own Functions
-- ---------------------------------------------------------------------------
SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS format_ort_land;
DELIMITER //
CREATE FUNCTION format_ort_land(p_ort VARCHAR(50), p_land VARCHAR(50)) RETURNS VARCHAR(150)
BEGIN
   RETURN  CONCAT(p_ort, ' (', p_land, ')');
END//
DELIMITER ;

select format_ort_land('Wangen', 'Schweiz') AS `Stadt_Land`;


-- ===========================================================================
-- Eigenes Schema kreieren und normalisieren
-- ===========================================================================
DROP SCHEMA IF EXISTS `bzu_blf`;
CREATE SCHEMA `bzu_blf`;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `bzu_blf`;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `ID`       INT         NOT NULL AUTO_INCREMENT,
  `Vorname`  VARCHAR(45) NOT NULL,
  `Nachname` VARCHAR(45) NOT NULL,
  `Strasse`  VARCHAR(45) NULL,
  `PLZ`      VARCHAR(20) NOT NULL,
  `Ort`      VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`));

-- -----------------------------------------------------
-- Testdatensätze einfügen
-- -----------------------------------------------------
INSERT INTO `Adressen` (`ID`, `Vorname`, `Nachname`, `Strasse`, `PLZ`, `Ort`) VALUES 
(1, 'Walter', 'Rothlin', 'Peterliwiese 33', '8855', 'Wangen'),
(2, 'Max', 'Meier', 'Etzelstr. 7', '8855', 'Wangen'),
(3, 'Claudia', 'Müller', 'Hauptstr. 179a', '8853', 'Lachen'),
(4, 'Maria', 'Bächtiger', 'Etzelstr. 7', '8853', 'Lachen'),
(5, 'Fritz', 'Künzli', 'Rigiweg 55c', '8855', 'Nuolen');

ALTER TABLE `Adressen` RENAME TO `Adressen_RD`;

DROP VIEW IF EXISTS `Adressen` ; 
CREATE VIEW `Adressen`  AS  
	SELECT
      `ID`       AS `ID`,
	  `Vorname`  AS `Vorname`,
      `Nachname` AS `Nachname`,
      `Strasse`  AS `Strasse`,
	  `PLZ`      AS `PLZ`,
	  `Ort`      AS `Ort`
    FROM `Adressen_RD`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
