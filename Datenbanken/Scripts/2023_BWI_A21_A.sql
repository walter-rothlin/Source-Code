-- ---------------------------------------------------------------------------------------------
-- Filename: 2023_BWI_A21_A.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/2023_BWI_A21_A.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert Shema, Functions, Views and Procedures for BWI_A21
--
-- History:
-- 23-May-2023   Walter Rothlin      Initial Version (Forward engineered)
-- ---------------------------------------------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BWI_A21
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `BWI_A21`;
CREATE SCHEMA IF NOT EXISTS `BWI_A21` DEFAULT CHARACTER SET utf8 ;
USE `BWI_A21` ;

-- -----------------------------------------------------
-- Table `Cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cities` (
  `ID`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`       VARCHAR(10)  NOT NULL,
  `City_Name` VARCHAR(45)  NOT NULL,
  PRIMARY KEY (`ID`));

-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `ID`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Sex`        VARCHAR(10)  NULL,
  `Firstname`  VARCHAR(45)  NOT NULL,
  `Lastname`   VARCHAR(45)  NOT NULL,
  `Adress`     VARCHAR(45)  NULL,
  `Nr`         VARCHAR(10)  NULL,
  `Cities_ID`  INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_adressen_Cities_idx` (`Cities_ID` ASC) VISIBLE,
  CONSTRAINT `fk_adressen_Cities`
    FOREIGN KEY (`Cities_ID`)
    REFERENCES `Cities` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- DML CRUD (Insert)
INSERT INTO `Cities` (`ID`, `PLZ`, `City_Name`) 
VALUES (1, '8855', 'Wangen'),
       (2, '8854', 'Siebnen'),
       (3, '8008', 'Uster'),
       (4, '8000', 'Zürich'),
       (5, '3000', 'Bern');

INSERT INTO `adressen` (`Sex`, `Firstname`, `Lastname`, `Adress`, `Nr`, `Cities_ID`) 
VALUES ('Herr', 'Walter', 'Rothlin', 'Peterliwiese', '33', 1),
       ('Herr','Heiri', 'Meier', 'Etzelstr.', '7', 2),
       ('Herr','Felix', 'Muster', 'Gartenstr.', '61a', 3),
       ('Herr','Nico', 'Schmid', 'Europaallee','', 4),
       ('Herr','Gavin', 'Rotach', '','', 5),
       ('Frau','Claudia', 'Collet', 'Petzerliwiese','33', 1);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

DROP FUNCTION IF EXISTS getBrief_Anrede;
DELIMITER //
CREATE FUNCTION getBrief_Anrede(p_sex CHAR(20), p_lastname CHAR(100) ) RETURNS CHAR(100)
BEGIN
	IF (p_sex = 'Herr') THEN 
		RETURN  CONCAT('Sehr geehrter Herr ', p_lastname);
	ELSE
		RETURN  CONCAT('Sehr geehrte Frau ', p_lastname);
	END IF;
END//
DELIMITER ;

DROP VIEW IF EXISTS Adress__Liste; 
CREATE VIEW Adress__Liste AS
	SELECT 
	   a.ID                        AS ID,
       a.Sex                       AS Sex,
	   a.Firstname                 AS Vorname,
	   a.Lastname                  AS Nachname,
	   CONCAT(a.Adress,' ',a.Nr)   AS Strasse,
	   -- a.Cities_ID                 AS City_ID,
	   c.PLZ                       AS PLZ,
	   c.City_Name                 AS Ort,
       getBrief_Anrede(a.sex, a.Lastname) AS Anrede
	FROM adressen AS a
	INNER JOIN Cities AS c ON a.Cities_ID = c.ID;
