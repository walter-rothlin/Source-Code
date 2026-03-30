-- ---------------------------------------------------------------------------------------------
-- Filename: 01_DDL_DML_Eigenes_Schema.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/01_DDL_DML_Eigenes_Schema.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein Adressen_DB
--
-- History:
-- 29-Mar-2026   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- DDL: Schema Adressen_DB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Adressen_DB`;
CREATE SCHEMA IF NOT EXISTS `Adressen_DB` DEFAULT CHARACTER SET utf8 ;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `Adressen_DB` ;

-- -----------------------------------------------------
-- DDL: Tabellen kreieren (normalisiert)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `ID`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`       VARCHAR(10) NOT NULL,
  `Name`      VARCHAR(45) NOT NULL,
  `Land_code` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`ID`));

DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Strasse`     VARCHAR(45)  NOT NULL,
  `Hausnummer`  VARCHAR(5)   NULL,
  `Orte_ID`     INT UNSIGNED NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_adressen_orte_idx` (`Orte_ID` ASC) VISIBLE,
  CONSTRAINT `fk_adressen_orte`
    FOREIGN KEY (`Orte_ID`)
    REFERENCES `Orte` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
DROP TABLE IF EXISTS `Personen`;
CREATE TABLE IF NOT EXISTS `Personen` (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Gender`      VARCHAR(15)  NOT NULL,
  `Name`        VARCHAR(45)  NOT NULL,
  `Vorname`     VARCHAR(45)  NULL,
  `Adress_ID`   INT UNSIGNED NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_personen_adressen_idx` (`Adress_ID` ASC) VISIBLE,
  CONSTRAINT `fk_personen_adressen`
    FOREIGN KEY (`Adress_ID`)
    REFERENCES `Adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- DML: Tabellen mit Testdaten füllen
-- -----------------------------------------------------
INSERT INTO `Orte` (`ID`, `PLZ`, `Name`,  `Land_code`) 
VALUES (1, 8855,  'Wangen',   'CH'),
       (2, 8855,  'Nuolen',   'CH'),
       (3, 8854,  'Siebnen',  'CH'),
       (4, 8854,  'Galgenen', 'CH'),
       (5, 8853,  'Lachen',   'CH'),
       (6, 75000, 'Paris',    'F');


INSERT INTO `Adressen` (`ID`, `Strasse`, `Hausnummer`, `Orte_ID`) 
VALUES (1, 'Peterliwiese', '33', 1),
	   (2, 'Blumenweg',     '8', 5),
	   (3, 'Rue du ferre', '88', 6); 
       
       
INSERT INTO `Personen` (`ID`, `Gender`, `Name`, `Vorname`, `Adress_ID`) 
VALUES (1, 'Herr', 'Rothlin', 'Walter',  1),
	   (2, 'Herr', 'Rothlin', 'Tobias',  1),
	   (3, 'Frau', 'Collet',  'Claudia', 2),
	   (4, 'Frau', 'Dupont',  'Claudia', 3);
       

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- Aufgaben:
-- -----------------------------------------------------

-- 1) Kreieren Sie eine View mit dem Namen Adressen_Orte_Liste wie folgt:
/*
ID | Strasse      | Hausnummer | Strasse_Nr      | Ort_ID | PLZ   | Orts_Name | Land_Code | PLZ_Ort      
---+--------------+------------+-----------------+--------+-------+-----------+-----------+--------------
1  | Peterliwiese | 33         | Peterliwiese 33 | 1      | 8855  | Wangen    | CH        | 8855 Wangen  
2  | Blumenweg    | 8          | Blumenweg 8     | 5      | 8853  | Lachen    | CH        | 8853 Lachen  
3  | Rue du ferre | 88         | Rue du ferre 88 | 6      | 75000 | Paris     | F         | F-75000 Paris
*/





-- 2) Kreieren Sie eine View mit dem Namen Personen_Liste wie folgt
/*
ID | Gender | Name    | Firstname | Adress_ID | Strasse      | Hausnummer | Strasse_Nr      | Ort_ID | PLZ   | Orts_Name | Land_Code | PLZ_Ort       | Anrede                    
---+--------+---------+-----------+-----------+--------------+------------+-----------------+--------+-------+-----------+-----------+---------------+---------------------------
1  | Herr   | Rothlin | Walter    | 1         | Peterliwiese | 33         | Peterliwiese 33 | 1      | 8855  | Wangen    | CH        | 8855 Wangen   | Sehr geehrter Herr Rothlin
2  | Herr   | Rothlin | Tobias    | 1         | Peterliwiese | 33         | Peterliwiese 33 | 1      | 8855  | Wangen    | CH        | 8855 Wangen   | Sehr geehrter Herr Rothlin
3  | Frau   | Collet  | Claudia   | 2         | Blumenweg    | 8          | Blumenweg 8     | 5      | 8853  | Lachen    | CH        | 8853 Lachen   | Sehr geehrte Frau Collet  
4  | Frau   | Dupont  | Claudia   | 3         | Rue du ferre | 88         | Rue du ferre 88 | 6      | 75000 | Paris     | F         | F-75000 Paris | Sehr geehrte Frau Dupont  
*/

