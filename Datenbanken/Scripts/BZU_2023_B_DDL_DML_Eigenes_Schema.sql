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
-- 09-Jun_2023   Walter Rothlin      Ländercode und CH-8855 Wangen hinzufügen

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
  `id`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`       VARCHAR(10) NOT NULL,
  `Name`      VARCHAR(45) NOT NULL,
  `Land_code` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`id`));

-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Gender`      VARCHAR(15)  NOT NULL,
  `Name`        VARCHAR(45)  NOT NULL,
  `Vorname`     VARCHAR(45)  NULL,
  `Strasse`     VARCHAR(45)  NOT NULL,
  `Hausnummer`  VARCHAR(5)   NULL,
  `Orte_id`     INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_adressen_Orte_idx` (`Orte_id` ASC) VISIBLE,
  CONSTRAINT `fk_adressen_Orte`
    FOREIGN KEY (`Orte_id`)
    REFERENCES `Orte` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- DML für Test-Daten erfassen
-- ---------------------------
INSERT INTO `Orte` (`ID`, `PLZ`, `Name`,  `Land_code`) 
VALUES (1, 8855, 'Wangen', 'CH'),
       (2, 8855, 'Nuolen', 'CH'),
       (3, 8854, 'Siebnen', 'CH'),
       (4, 8854, 'Galgenen', 'CH'),
       (5, 8853, 'Lachen', 'CH'),
       (6, 75000, 'Paris', 'F');
       
-- DELETE FROM `Orte`;
-- TRUNCATE `Orte`;
-- DELETE FROM `Orte` WHERE id = 1;
-- DELETE FROM `Orte` WHERE id = 5;

INSERT INTO `Adressen` (`ID`, `Gender`, `Name`, `Vorname`, `Strasse`, `Hausnummer`, `Orte_id`) 
VALUES (1, 'Herr', 'Rothlin', 'Walter', 'Peterliwiese', '33', 1),
	   (2, 'Herr', 'Rothlin', 'Tobias', 'Peterliwiese', '33', 1),
	   (3, 'Frau', 'Collet', 'Claudia', 'Blumenweg', '8', 5),
	   (4, 'Frau', 'Dupont', 'Claudia', 'Rue du ferre', '88', 6);
       
-- Functions
-- ---------
SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS get_strasse_nr;
DELIMITER //
CREATE FUNCTION  get_strasse_nr(p_strasse VARCHAR(50), p_haus_nr VARCHAR(10)) RETURNS VARCHAR(65)
BEGIN
  RETURN  CONCAT(p_strasse, ' ', p_haus_nr);
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

DROP FUNCTION IF EXISTS get_international_plz;
DELIMITER //
CREATE FUNCTION  get_international_plz(p_landcode VARCHAR(3), p_plz VARCHAR(10)) RETURNS VARCHAR(65)
BEGIN
  IF (p_landcode = 'CH') THEN
	    RETURN  p_plz;
  ELSE
	    RETURN  CONCAT(p_landcode, '-', p_plz);
  END IF;
END//
DELIMITER ;

DROP FUNCTION IF EXISTS get_plz_ort;
DELIMITER //
CREATE FUNCTION  get_plz_ort(p_landcode VARCHAR(3), p_plz VARCHAR(10), p_ort VARCHAR(45)) RETURNS VARCHAR(65)
BEGIN
	RETURN  CONCAT(get_international_plz(p_landcode, p_plz), ' ', p_ort);
END//
DELIMITER ;

-- Views
-- -----
DROP VIEW IF EXISTS `Adress_Daten`; 
CREATE VIEW `Adress_Daten` AS
	SELECT
	   `a`.`id`                              AS `ID`,
	   `a`.`Gender`                          AS `Gender`,
	   `a`.`Name`                            AS `Lastname`,
	   `a`.`Vorname`                         AS `Firstname`,
	   get_strasse_nr(a.Strasse, 
                      a.Hausnummer)          AS Strasse,                         
	   `o`.`PLZ`                             AS `PLZ`,
	   `o`.`Name`                            AS `Ort`,
       get_international_plz(`o`.`Land_code`,
                             `o`.`PLZ`)      AS `Int_PLZ`,
	   get_plz_ort(`o`.`Land_code`,
				    `o`.`PLZ`,
				    `o`.`Name`)              AS `PLZ_Ort`,
       get_anrede(`a`.`Gender`,`a`.`Name`)   AS `Anrede`
	   FROM `Adressen`    AS `a`
	   INNER JOIN `Orte` AS `o` ON `a`.`orte_id` = `o`.`id`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
