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
-- 26-May-2023   Walter Rothlin      Create view and function
-- 02-Jun-2023   Walter Rothlin      Added Anrede (Rohdaten + Fct) 

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
  `Gender`     VARCHAR(10) NULL,
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


SET GLOBAL log_bin_trust_function_creators = 1;

-- Functions
-- =========
DROP FUNCTION IF EXISTS get_strasse_nr;
DELIMITER //
CREATE FUNCTION  get_strasse_nr(p_strasse VARCHAR(50), p_plz VARCHAR(10)) RETURNS VARCHAR(65)
BEGIN
  RETURN  CONCAT(p_strasse, ' ', p_plz);
END//
DELIMITER ;

DROP FUNCTION IF EXISTS get_anrede;
DELIMITER //
CREATE FUNCTION  get_anrede(p_gender VARCHAR(10), p_name VARCHAR(45)) RETURNS VARCHAR(65)
BEGIN
  IF (p_gender = 'Herr') THEN
	    RETURN  CONCAT('Sehr geehrter ', p_gender, ' ', p_name);
  ELSE
	    RETURN  CONCAT('Sehr geehrte ', p_gender, ' ', p_name);
  END IF;
END//
DELIMITER ;

-- Views
-- =====
DROP VIEW IF EXISTS `Adressen`;
CREATE VIEW `Adressen` AS
	SELECT
		 pers.id           AS id,
         pers.Gender       AS Gender,
		 pers.Vorname      AS Vorname,
		 pers.Nachname     AS Nachname,
		 get_strasse_nr(pers.Strasse, pers.Hausnummer)     AS Strasse,
		 -- pers.Hausnummer   AS Hausnummer,
		 -- adr.Orte_id      AS Orte_ID,
		 ort.plz          AS PLZ,
		 ort.Ortsname     AS Ortsname,
         -- IF (pers.Gender='Herr',
         --    CONCAT('Sehr geehrter Herr ',pers.Nachname ),
         --    CONCAT('Sehr geehrte Frau ',pers.Nachname ))    AS Anrede_old,
         get_anrede(pers.Gender, pers.Nachname) AS Anrede
	FROM Personen AS pers
	INNER JOIN Orte AS ort ON pers.Orte_id = ort.id;

-- DML 2023-Apr-21
-- ===============
INSERT INTO `Orte` (`ID`, `PLZ`, `Ortsname`) VALUES 
   (1,'8855', 'Wangen'),
   (2,'8854', 'Siebnen'),
   (3,'8855', 'Nuolen'),
   (4,'8853', 'Lachen');
           
           
INSERT INTO `Personen` (`ID`, `Gender`, `Vorname`, `Nachname`, `Strasse`, `Hausnummer`, `Orte_id`) VALUES 
   ('1', 'Herr', 'Walter', 'Rothlin', 'Peterliwiese',  '33', '1'),
   ('2', 'Herr', 'Tobias', 'Rothlin', 'Peterliwiese',  '33', '1'),
   ('3', 'Herr', 'Max',    'Meier',   'Nördlingerhof', '1d', '2'),
   ('4', 'Frau', 'Claudia', 'Collet', 'Peterliwiese',  '33', '1');