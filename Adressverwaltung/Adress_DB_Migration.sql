-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Migrating schema for Adress_Manager
--
-- History:
-- 16-Jun-2025   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------

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
