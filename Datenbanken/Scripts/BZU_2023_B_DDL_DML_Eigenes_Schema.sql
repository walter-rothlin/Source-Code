-- ---------------------------------------------------------------------------------------------
-- Filename: BZU_2023_B_DDL_DML_Eigenes_Schema.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/BZU_2023_B_DDL_DML_Eigenes_Schema.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein eigenes Schema
--
-- History:
-- 22-Apr-2023   Walter Rothlin      Initial Version, Reveresed Enginiering
-- 25-May-2023   Walter Rothlin      Create view

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BZU_2023_B
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS  `BZU_2023_B`;
CREATE SCHEMA IF NOT EXISTS `BZU_2023_B` DEFAULT CHARACTER SET utf8 ;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `BZU_2023_B` ;


-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `id`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`      VARCHAR(10) NOT NULL,
  `Ortsname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Personen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Personen`;
CREATE TABLE IF NOT EXISTS `Personen` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Vorname`    VARCHAR(45) NULL,
  `Nachname`   VARCHAR(45) NOT NULL,
  `Strasse`    VARCHAR(45) NULL,
  `Hausnummer` VARCHAR(10) NULL,
  `Orte_id`    INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Adressen_Orte_idx` (`Orte_id` ASC) VISIBLE,
  CONSTRAINT `fk_Adressen_Orte`
    FOREIGN KEY (`Orte_id`)
    REFERENCES `Orte` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Views
-- =====
DROP VIEW IF EXISTS `Adressen`;
CREATE VIEW `Adressen` AS
	SELECT
		 pers.id           AS id,
		 pers.Vorname      AS Vorname,
		 pers.Nachname     AS Nachname,
		 CONCAT(pers.Strasse,' ', pers.Hausnummer)     AS Strasse,
		 -- pers.Hausnummer   AS Hausnummer,
		 -- adr.Orte_id      AS Orte_ID,
		 ort.plz          AS PLZ,
		 ort.Ortsname     AS Ortsname
	FROM Personen AS pers
	INNER JOIN Orte AS ort ON pers.Orte_id = ort.id;

-- DML 2023-Apr-21
-- ===============
INSERT INTO `Orte` (`ID`, `PLZ`, `Ortsname`) VALUES 
   (1,'8855', 'Wangen'),
   (2,'8854', 'Siebnen');
   
INSERT INTO `Orte`  (`PLZ`, `Ortsname`) VALUES 
   ('8855', 'Nuolen'),
   ('8853', 'Lachen');
           
           
INSERT INTO `Personen` (`ID`, `Vorname`, `Nachname`, `Strasse`, `Hausnummer`, `Orte_id`) VALUES 
   ('1', 'Walter', 'Rothlin', 'Peterliwiese',  '33', '1'),
   ('2', 'Tobias', 'Rothlin', 'Peterliwiese',  '33', '1'),
   ('3', 'Max',    'Meier',   'Nördlingerhof', '1d', '2');

