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

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BZU_2023_B
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS  `BZU_2023_B`;
CREATE SCHEMA IF NOT EXISTS `BZU_2023_B` DEFAULT CHARACTER SET utf8 ;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `bzu_2023_b` ;


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
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
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
CREATE VIEW Adressen_Liste AS
	SELECT
		 adr.id           AS id,
		 adr.Vorname      AS Vorname,
		 adr.Nachname     AS Nachname,
		 adr.Strasse      AS Strasse,
		 adr.Hausnummer   AS Hausnummer,
		 -- adr.Orte_id      AS Orte_ID,
		 ort.plz          AS PLZ,
		 ort.Ortsname     AS Ortsname
	FROM Adressen AS adr
	INNER JOIN Orte AS ort ON adr.Orte_id = ort.id;

-- DML 2023-Apr-21
-- ===============
INSERT INTO `orte` (`ID`, `PLZ`, `Ortsname`) VALUES 
   (1,'8855', 'Wangen'),
   (2,'8854', 'Siebnen');
           
           
INSERT INTO `adressen` (`id`, `Vorname`, `Nachname`, `Strasse`, `Hausnummer`, `Orte_id`) VALUES 
   ('1', 'Walter', 'Rothlin', 'Peterliwiese',  '33', '1'),
   ('2', 'Tobias', 'Rothlin', 'Peterliwiese',  '33', '1'),
   ('3', 'Max',    'Meier',   'Nördlingerhof', '1d', '2');

