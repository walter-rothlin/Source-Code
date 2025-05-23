-- Owner: Walter Rothlin
-- History:
-- 07-Feb-2025 Walter Rothlin	Initial Version
-- 14-Feb-2025 Walter Rothlin	String-Functions
-- 07-Mar-2025 Walter Rothlin   Date / Time Functions
-- 14-Mar-2025 Walter Rothlin	Group By
-- 04-Apr-2025 Walter Rothlin	Joins
-- 16-May-2025 Walter Rothlin	Eigenes Schema kreieren und normalisieren
-- 23-May-2025 Walter Rothlin   Migration: Aufteilen von Strasse_Hausnummer auf zwei Attributte
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
DROP SCHEMA IF EXISTS `bzu_ble`;
CREATE SCHEMA `bzu_ble`;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `bzu_ble`;

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
      `o`.`PLZ`             AS `PLZ`
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
