-- -----------------------------------------
-- Filename: 2024_BWI_A22.sql
-- Source  : 
-- -----------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert alle Rohdaten-Tabellen für HWZ
--              !!!!!! LOESCHT ALLE DATEN !!!!!!!
--
-- History:
-- 07-May-2024   Walter Rothlin      Inital version

-- -----------------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';



-- =========================================
-- == Schema HWZ kreieren                 ==
-- =========================================
DROP SCHEMA IF EXISTS `hwz`;
CREATE SCHEMA IF NOT EXISTS  `hwz` ;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `hwz`;

-- =========================================
-- == Rohdaten-Tabellen kreieren          ==
-- =========================================
-- -----------------------------------------------------
-- Table `hwz`.`Orte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Orte` (
  `ID` INT NOT NULL,
  `PLZ` VARCHAR(10) NOT NULL,
  `Ortsname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`));

CREATE TABLE `adressen` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Vorname` VARCHAR(45) NOT NULL,
  `Nachname` VARCHAR(45) NOT NULL,
  `Strasse` VARCHAR(45) NULL,
  
  `Orte_ID` INT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_adressen_Orte_idx` (`Orte_ID` ASC) VISIBLE,
  
  CONSTRAINT `fk_adressen_Orte`
    FOREIGN KEY (`Orte_ID`)
    REFERENCES `Orte` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    
);



-- =========================================
-- == Testdate einfügen                   ==
-- =========================================
INSERT INTO `orte` (`ID`, `PLZ`, `Ortsname`) VALUES 
	(1, '8855', 'Wangen'),
	(2, '8007', 'Musterort'),
	(3, '8854', 'Galgenen'),
	(4, '8007', 'Zürich');


INSERT INTO `adressen` (`Vorname`, `Nachname`, `Strasse`, `Orte_ID`, `ID`) VALUES 
	('Walter' , 'Rothlin', 'Peterliwiese 33'  , 1,  1),
    ('Claudia', 'Collet' , 'Peterliwiese 33'  , 1,  2),
    ('Hans'   , 'Muster' , 'Musterstr. 44'    , 2,  3),
    ('Max'    , 'Meier'  , 'Nördlingerhof. 1d', 3,  4),
    ('Fritz'  , 'Künzli' , 'Zürcherstr. 42c'  , 4,  5);
    
    
-- ======================================================================
-- == 1.Schritt der Normalisierung: Attributte enthalten nur eine Info ==
-- ======================================================================

-- DDL
ALTER TABLE `adressen` 
ADD COLUMN `Hausnummer` VARCHAR(10) NULL AFTER `Strasse`;

-- DML
UPDATE `adressen` SET `Strasse` = 'Peterliwiese',   `Hausnummer` = '33'  WHERE `ID` IN (1,2);
UPDATE `adressen` SET `Strasse` = 'Musterstr.',     `Hausnummer` = '44'  WHERE `ID` = 3;
UPDATE `adressen` SET `Strasse` = 'Nördlingerhof.', `Hausnummer` = '1d'  WHERE `ID` IN (4);
UPDATE `adressen` SET `Strasse` = 'Zürcherstr.',    `Hausnummer` = '42c' WHERE `ID` IN (5);



-- ===============================================
-- == Ursprüngliche Benutzersicht herstellen    ==
-- ===============================================
DROP VIEW IF EXISTS Adresse_View; 
CREATE VIEW Adresse_View AS
	SELECT
		`adr`.`ID`           AS `ID`,
		`adr`.`Vorname`      AS `Vorname`,
		`adr`.`Nachname`     AS `Nachname`,
		`adr`.`Strasse`      AS `Strasse`,
		`adr`.`Hausnummer`   AS `Hausnummer`,
		-- `adr`.`Orte_ID`      AS `adr_Orte_ID`,
		-- `adr`.`PLZ`          AS `adr_PLZ`,
		-- `adr`.`Ort`          AS `adr_Ort`,
		-- `o`.`ID`             AS `o_ID`,
		`o`.`PLZ`            AS `PLZ`,
		`o`.`Ortsname`       AS `Ort`
	FROM `adressen` AS `adr`
	LEFT OUTER JOIN `Orte` AS `o` ON `adr`.`Orte_ID` = `o`.`ID`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


