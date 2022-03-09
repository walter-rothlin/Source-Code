
-- ---------------------------------------------------------------------------------------------
-- Genossame-Schema.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein neues Schema für die Genossame
--
-- History:
-- 03-Mar-2022   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------



-- Save constraints
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Genossame` ;
CREATE SCHEMA IF NOT EXISTS `Genossame` DEFAULT CHARACTER SET utf8 ;
USE `Genossame` ;

-- -----------------------------------------------------
-- Create tables
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Land` ;
CREATE TABLE IF NOT EXISTS `Land` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Code` VARCHAR(5) NULL,
  PRIMARY KEY (`id`));


DROP TABLE IF EXISTS `Ort` ;
CREATE TABLE IF NOT EXISTS `Ort` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Plz` VARCHAR(5) NOT NULL,
  `Land_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Ort_Land_idx` (`Land_id` ASC),
  CONSTRAINT `fk_Ort_Land`
    FOREIGN KEY (`Land_id`)
    REFERENCES `Land` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


DROP TABLE IF EXISTS Adresse ;
CREATE TABLE IF NOT EXISTS Adresse (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Strasse` VARCHAR(45) NULL,
  `Hausnummer` VARCHAR(5) NULL,
  `Ort_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Adresse_Ort1_idx` (`Ort_id` ASC),
  CONSTRAINT `fk_Adresse_Ort1`
    FOREIGN KEY (`Ort_id`)
    REFERENCES `Ort` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


DROP TABLE IF EXISTS `Sex` ;
CREATE TABLE IF NOT EXISTS `Sex` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Status` ENUM('Mann', 'Frau') NOT NULL,
  PRIMARY KEY (`id`));


DROP TABLE IF EXISTS `Person`;
CREATE TABLE IF NOT EXISTS `Person` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Vorname` VARCHAR(45) NOT NULL,
  `Firma` VARCHAR(45) NULL,
  `Postanschrift_FK` INT NOT NULL,
  `Rechnungsadresse_FK` INT NULL,
  `Objektadresse_FK` INT NULL,
  `Sex_FK` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Person_Adresse1_idx` (`Postanschrift_FK` ASC),
  INDEX `fk_Person_Adresse2_idx` (`Rechnungsadresse_FK` ASC),
  INDEX `fk_Person_Adresse3_idx` (`Objektadresse_FK` ASC),
  INDEX `fk_Person_Sex1_idx`     (`Sex_FK` ASC),
  CONSTRAINT `fk_Person_Adresse1`
    FOREIGN KEY (`Postanschrift_FK`)
    REFERENCES `Adresse` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Person_Adresse2`
    FOREIGN KEY (`Rechnungsadresse_FK`)
    REFERENCES `Adresse` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Person_Adresse3`
    FOREIGN KEY (`Objektadresse_FK`)
    REFERENCES `Adresse` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Person_Sex1`
    FOREIGN KEY (`Sex_FK`)
    REFERENCES `Sex` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


DROP TABLE IF EXISTS `AdressType` ;
CREATE TABLE IF NOT EXISTS `AdressType` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(10) NOT NULL,
  `Beschreibung` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));


DROP TABLE IF EXISTS `Email` ;
CREATE TABLE IF NOT EXISTS `Email` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Adresse` VARCHAR(45) NOT NULL,
  `Person_id` INT NOT NULL,
  `Type_FK` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Email_Person1_idx`     (`Person_id` ASC),
  INDEX `fk_Email_AdressType1_idx` (`Type_FK`   ASC),
  CONSTRAINT `fk_Email_Person1`
    FOREIGN KEY (`Person_id`)
    REFERENCES `Person` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Email_AdressType1`
    FOREIGN KEY (`Type_FK`)
    REFERENCES `AdressType` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

DROP TABLE IF EXISTS `TelefonNr` ;
CREATE TABLE IF NOT EXISTS `TelefonNr` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Laendercode` VARCHAR(4) GENERATED ALWAYS AS (0041) VIRTUAL,
  `Vorwahl` VARCHAR(4) NULL DEFAULT '055',
  `Nummer` VARCHAR(10) NOT NULL,
  `Person_id` INT NOT NULL,
  `Type_FK` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_TelefonNr_Person1_idx`     (`Person_id` ASC),
  INDEX `fk_TelefonNr_AdressType1_idx` (`Type_FK`   ASC),
  CONSTRAINT `fk_TelefonNr_Person1`
    FOREIGN KEY (`Person_id`)
    REFERENCES `Person` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TelefonNr_AdressType1`
    FOREIGN KEY (`Type_FK`)
    REFERENCES `AdressType` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    

-- -----------------------------------------------------
-- Create functions
-- -----------------------------------------------------    
DROP FUNCTION IF EXISTS OrtBezeichnung;
Delimiter //
CREATE FUNCTION OrtBezeichnung(pCode VARCHAR(5), pPLZ VARCHAR(5), pOrt VARCHAR(45)) RETURNS CHAR(50)
BEGIN
    RETURN concat(pCode, '-', pPLZ, ' ', pOrt);
END
//

DROP FUNCTION IF EXISTS Anrede;
Delimiter //
CREATE FUNCTION Anrede(pSex VARCHAR(5), pName VARCHAR(45)) RETURNS CHAR(50)
BEGIN
    IF pSex = 'Mann' THEN
          RETURN concat('Sehr geehrter Herr ', pName);
	ELSE
          RETURN concat('Sehr geehrte Frau ', pName);
	END IF;
END
//

-- Restore constraints
-- SET SQL_MODE=@OLD_SQL_MODE;
-- SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
-- SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;