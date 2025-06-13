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
-- 22-May-2025 Walter Rothlin   Migration: Aufteilen von Strasse_Hausnummer auf zwei Attributte
-- 12-Jun-2025 Walter Rothlin   Added Search_Fields
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


-- Table `Adressen` create
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

-- Testdatensätze einfügen
-- -----------------------------------------------------
INSERT INTO `Adressen` (`ID`, `Vorname`, `Nachname`, `Strasse`, `PLZ`, `Ort`) VALUES 
(1, 'Walter', 'Rothlin', 'Peterliwiese 33', '8855', 'Wangen'),
(2, 'Max', 'Meier', 'Etzelstr. 7', '8855', 'Wangen'),
(3, 'Claudia', 'Müller', 'Hauptstr. 179a', '8853', 'Lachen'),
(4, 'Maria', 'Bächtiger', 'Etzelstr. 7', '8853', 'Lachen'),
(5, 'Fritz', 'Künzli', 'Rigiweg 55c', '8855', 'Nuolen');

-- ---------------------------------------------------
-- Entkoppeln von interner Sicht und Applikationssicht
-- ---------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 1.Schritt Normalisierung: Strasse aufteilen in Strasse und Hausnummer
-- ---------------------------------------------------------------------

-- Metadaten / Struktur anpassen
ALTER TABLE `Adressen_RD` 
	ADD COLUMN `Hausnummer` VARCHAR(10) NULL AFTER `Strasse`;

ALTER TABLE `Adressen_RD` 
	ADD COLUMN `Strassenname` VARCHAR(45) NULL AFTER `Strasse`;

-- Daten Migration        
UPDATE `Adressen_RD`
SET `Hausnummer` = TRIM(SUBSTRING_INDEX(`Strasse`, ' ', -1));

UPDATE `Adressen_RD`
SET `Strassenname` = TRIM(SUBSTRING_INDEX(`Strasse`, ' ', 1));

-- Uebrprüfen der Datenmigration
DROP VIEW IF EXISTS `Normalisierung_1` ; 
CREATE VIEW `Normalisierung_1`  AS  
	SELECT
      `ID`            AS `ID`,
	  `Vorname`       AS `Vorname`,
      `Nachname`      AS `Nachname`,
      `Strasse`	      AS `OLD_Strasse`,
      CONCAT(
		`Strassenname`,
		' ',
		`Hausnummer`) AS `Strasse`,
	  `PLZ`           AS `PLZ`,
	  `Ort`           AS `Ort`
    FROM `Adressen_RD`
    WHERE `Strasse` <> CONCAT(`Strassenname`, ' ', `Hausnummer`);

SELECT
  CAST(
    CASE
      WHEN COUNT(*) = 0 THEN 'Normalisation 1.Schritt ist ok'
      ELSE CONCAT(
        'ERROR: Normalisation 1.Schritt ist nicht erfolgreich!', CHAR(13, 10),
        'Check view Normalisierung_1'
      )
    END AS CHAR
  ) AS status
FROM `Normalisierung_1`;

DROP VIEW IF EXISTS `Adressen` ; 
CREATE VIEW `Adressen`  AS  
	SELECT
      `ID`            AS `ID`,
	  `Vorname`       AS `Vorname`,
      `Nachname`      AS `Nachname`,
      CONCAT(
		`Strassenname`,
		' ',
		`Hausnummer`) AS `Strasse`,
	  `PLZ`           AS `PLZ`,
	  `Ort`           AS `Ort`
    FROM `Adressen_RD`;


-- Aufräumen / Cleanup
ALTER TABLE `Adressen_RD`
	DROP COLUMN `Strasse`;

DROP VIEW IF EXISTS `Normalisierung_1`;

 
-- ------------------------------------------------------------    
-- 2.Schritt Normalisierung: Orte in separate Tabelle auslagern
-- ------------------------------------------------------------

-- Metadaten / Struktur anpassen
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `ID`       INT         NOT NULL AUTO_INCREMENT,
  `PLZ`      VARCHAR(20) NOT NULL,
  `Ortname`  VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`));
  
ALTER TABLE `Adressen_RD`
	ADD COLUMN `FK_Orte` INT NOT NULL;

ALTER TABLE `Adressen_RD`
	ADD CONSTRAINT `fk_addr_orte`
	FOREIGN KEY (`FK_Orte`)
	REFERENCES `Orte`(`ID`);
    
-- Daten Migration    
INSERT INTO `Orte` (`PLZ`, `Ortname`)
	SELECT DISTINCT `PLZ`, `Ort`
	FROM `Adressen_RD`;
    
UPDATE `Adressen_RD` `adr`
	JOIN `Orte` `o` ON `adr`.`PLZ` = `o`.`PLZ` AND `adr`.`Ort` = `o`.`Ortname`
	SET `adr`.`FK_Orte` = `o`.`ID`;

-- Uebrprüfen der Datenmigration
DROP VIEW IF EXISTS `Normalisierung_2`; 
CREATE VIEW `Normalisierung_2`  AS  
	SELECT
      `adr`.`ID`            AS `ID`,
	  `adr`.`Vorname`       AS `Vorname`,
      `adr`.`Nachname`      AS `Nachname`,
      CONCAT(
		`adr`.`Strassenname`,
		' ',
		`adr`.`Hausnummer`) AS `Strasse`,
	  `adr`.`PLZ`           AS `OLD_PLZ`,
	  `adr`.`Ort`           AS `OLD_Ort`,
      `adr`.`FK_Orte`       AS `FK_Orte`,
      `o`.`ID`              AS `PK_Ort`,
      `o`.`Ortname`         AS `Ort`,
      `o`.`PLZ`             AS `PLZ`
    FROM `Adressen_RD` AS `adr`
    INNER JOIN `Orte` AS `o` ON `o`.`ID` = `adr`.`FK_Orte`
    WHERE `adr`.`PLZ` <> `o`.`PLZ` OR `adr`.`Ort` <> `o`.`Ortname`;


SELECT
  CAST(
    CASE
      WHEN COUNT(*) = 0 THEN 'Normalisation 2.Schritt ist ok'
      ELSE CONCAT(
        'ERROR: Normalisation 2.Schritt ist nicht erfolgreich!', CHAR(13, 10),
        'Check view Normalisierung_2'
      )
    END AS CHAR
  ) AS status
FROM `Normalisierung_2`;


DROP VIEW IF EXISTS `Adressen` ; 
CREATE VIEW `Adressen`  AS
	SELECT
      `adr`.`ID`            AS `ID`,
	  `adr`.`Vorname`       AS `Vorname`,
      `adr`.`Nachname`      AS `Nachname`,
      CONCAT(
		`adr`.`Strassenname`,
		' ',
		`adr`.`Hausnummer`) AS `Strasse`,
      `o`.`Ortname`         AS `Ort`,
      `o`.`PLZ`             AS `PLZ`,
      CONCAT(`adr`.`Vorname`,';',
             `adr`.`Nachname`,';',
             `adr`.`Strassenname`,';',
             `o`.`Ortname`,';',
             `o`.`PLZ`)              AS `Search_Field`
    FROM `Adressen_RD` AS `adr`
    INNER JOIN `Orte` AS `o` ON `o`.`ID` = `adr`.`FK_Orte`;

-- Aufräumen / Cleanup
ALTER TABLE `Adressen_RD`
	DROP COLUMN `Ort`;

ALTER TABLE `Adressen_RD`
	DROP COLUMN `PLZ`;
    
DROP VIEW IF EXISTS `Normalisierung_2`; 



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
