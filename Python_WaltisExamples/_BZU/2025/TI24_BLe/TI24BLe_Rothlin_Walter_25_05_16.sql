-- Owner: Walter Rothlin
-- History:
-- 07-Feb-2025 Walter Rothlin	Initial Version
-- 14-Feb-2025 Walter Rothlin	String-Functions
-- 07-Mar-2025 Walter Rothlin   Date / Time Functions
-- 14-Mar-2025 Walter Rothlin	Group By
-- 04-Apr-2025 Walter Rothlin	Joins
-- 16-May-2025 Walter Rothlin	Eigenes Schema kreieren und normalisieren
-- ---------------------------------------------------------------------------

-- ==============================
-- Beispiele mit String-Functions
-- ==============================
-- siehe https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT count(*) FROM staff;
SELECT count(staff_id) FROM staff;
SELECT count(3) AS `Anzahl Tuples` FROM `staff`;

SELECT
	`first_name` AS `Vorname`,
    CONCAT(UPPER(LEFT(`first_name`, 1)), '.')        AS `Initial`,
	`last_name`  AS `Nachname`,
    CONCAT(UPPER(LEFT(`first_name`, 1)), '.',`last_name`) AS `Initial_Nachname`
FROM `staff`
WHERE CONCAT(UPPER(LEFT(`first_name`, 1)), '.') = 'J.';










-- ==============================
-- Beispiele mit Date/Time
-- ==============================
SELECT * FROM `language`;

INSERT INTO `language` (`name`) VALUES ('Schweizerdeutsch');
UPDATE `language` SET `name` = 'Deutsch' WHERE (`language_id` = '6');
UPDATE `language` SET `last_update` = STR_TO_DATE('07.03.2023 08:54:00', '%d.%m.%Y %H:%i:%s') WHERE (`language_id` = '1');

SELECT
	`language_id`    AS `ID`,
    `name`           AS `Name der Sprache`,
    `last_update`    AS `Letzte Aenderung`,
    Date_Format(`last_update`, '%a, %d.%m.%Y %H:%i')  AS `Last Change CH`,
    Date_Format(now(), '%a, %d.%m.%Y %H:%i')  AS `Heute`
FROM `language`;


-- ==============================
-- Group-By
-- ==============================
SELECT  count(*) FROM `Country`;
SELECT  count(*) FROM `City`;

SELECT
	`cio`.`Land`     AS `Land`,
    COUNT(`FK City`) AS `Anzahl Staedte`
FROM (
	SELECT
		`co`.`country_id`  AS `PK Land`,
		`co`.`country`     AS `Land`,
		`ci`.`city`        AS `Stadt`,
		`ci`.`country_id`  AS `FK City`
	FROM `country` AS `co`, `city` AS `ci`
	WHERE `co`.`country_id` = `ci`.`country_id`
	ORDER BY `PK Land`) AS `cio`
    GROUP BY `FK City`
ORDER BY `Anzahl Staedte` DESC;

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


-- ===========================================================================
-- Eigenes Schema kreieren und normalisieren
-- ===========================================================================
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


DROP SCHEMA IF EXISTS `bzu_ble`;
CREATE SCHEMA `bzu_ble`;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `bzu_ble`;


-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `ID`       INT         NOT NULL AUTO_INCREMENT,
  `Vorname`  VARCHAR(45) NOT NULL,
  `Nachname` VARCHAR(45) NOT NULL,
  `Strasse`  VARCHAR(45) NULL,
  `PLZ`      VARCHAR(10) NOT NULL,
  `Ort`      VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`));

-- -----------------------------------------------------
-- Testdatensätze einfügen
-- -----------------------------------------------------
INSERT INTO `Adressen` (`ID`, `Vorname`, `Nachname`, `Strasse`, `PLZ`, `Ort`) VALUES 
('1', 'Walter', 'Rothlin', 'Peterliwiese 33', '8855', 'Wangen'),
('2', 'Claudia', 'Müller', 'Peterliwiese 33', '8855', 'Wangen'),
('3', 'Anna', 'Kunz', 'Bahnhofstr. 144c', '8854', 'Siebnen'),
('4', 'Max', 'Meier', 'Nördlingerhof 12a', '8854', 'Galgenen'),
('5', 'Anita', 'Bamert', 'Haupstr. 23', '8855', 'Nuolen');

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
    
ALTER TABLE `Adressen_RD` 
	ADD COLUMN `Hausnummer` VARCHAR(10) NULL AFTER `Strasse`;

SELECT * FROM `Adressen`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
