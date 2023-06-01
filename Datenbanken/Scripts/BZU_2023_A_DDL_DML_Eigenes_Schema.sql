-- ---------------------------------------------------------------------------------------------
-- Filename: BZU_2023_A_DDL_DML_Eigenes_Schema.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/BZU_2023_A_DDL_DML_Eigenes_Schema.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein eigenes Schema
--
-- History:
-- 21-Apr-2023   Walter Rothlin      Initial Version, Reveresed Enginiering
-- 11-May-2023   Walter Rothlin      Connect to Excel, add more Names and extend view
-- 25-May-2023   Walter Rothlin      Create view

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BZU_2023_A
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `BZU_2023_A`;
CREATE SCHEMA IF NOT EXISTS `BZU_2023_A` DEFAULT CHARACTER SET utf8 ;
USE `BZU_2023_A` ;

-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `id`   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`  VARCHAR(10) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
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
INSERT INTO `Orte` (`ID`, `PLZ`, `Name`) 
VALUES (1, 8855, 'Wangen'),
       (2, 8855, 'Nuolen'),
       (3, 8854, 'Siebnen'),
       (4, 8854, 'Galgenen'),
       (5, 8853, 'Lachen');
       
-- DELETE FROM `Orte`;
-- TRUNCATE `Orte`;
-- DELETE FROM `Orte` WHERE id = 1;
-- DELETE FROM `Orte` WHERE id = 5;

INSERT INTO `Adressen` (`ID`, `Gender`, `Name`, `Vorname`, `Strasse`, `Hausnummer`, `Orte_id`) 
VALUES (1, 'Herr', 'Rothlin', 'Walter', 'Peterliwiese', '33', 1),
	   (2, 'Herr', 'Rothlin', 'Tobias', 'Peterliwiese', '33', 1),
	   (3, 'Frau', 'Collet', 'Claudia', 'Blumenweg', '8', 5);
       
-- Functions
-- ---------
SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS getAnrede;
DELIMITER //
CREATE FUNCTION getAnrede(p_sex CHAR(20), p_lastname CHAR(100) ) RETURNS CHAR(150)
BEGIN
   IF (p_sex = 'Herr') THEN 
		RETURN  CONCAT('Sehr geehrter Herr ', p_lastname);
   ELSE
        RETURN  CONCAT('Sehr geehrte Frau ', p_lastname);
   END IF;
END//
DELIMITER ;

-- Views
-- -----
DROP VIEW IF EXISTS `Adress_Daten`; 
CREATE VIEW `Adress_Daten` AS
	SELECT
	   `a`.`id`                      AS `ID`,
	   `a`.`Gender`                  AS `Gender`,
	   `a`.`Name`                    AS `Lastname`,
	   `a`.`Vorname`                 AS `Firstname`,
	   CONCAT(
            `a`.`Strasse`,
            ' ',
            `a`.`Hausnummer`
            )                              AS `Strasse`,                           
	   `o`.`PLZ`                           AS `PLZ`,
	   `o`.`Name`                          AS `Ort`,
		getAnrede(`a`.`Gender`,`a`.`Name`) AS `Anrede`
	   FROM `Adressen`    AS `a`
	   INNER JOIN `Orte` AS `o` ON `a`.`orte_id` = `o`.`id`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
