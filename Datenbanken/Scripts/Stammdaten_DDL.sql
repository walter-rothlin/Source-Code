-- ---------------------------------------------------------------------------------------------
-- Filename: Stammdaten_DDL.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Stammdaten_DDL.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein Stammdaten Schema
--
-- History:
-- 03-Jun-2022   Walter Rothlin      Initial Version
-- 10-Jun-2022   Walter Rothlin      Modified ERD and added Attributs
-- 17-Jun_2022   Walter Rothlin		 Added Waermebezueger and its relations
-- ---------------------------------------------------------------------------------------------

-- MySQL Workbench Forward Engineering
SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Stammdaten kreieren
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS stammdaten;
CREATE SCHEMA IF NOT EXISTS stammdaten  DEFAULT CHARACTER SET utf8 ;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE stammdaten;

-- -----------------------------------------------------
-- Table `Land`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Land;
CREATE TABLE IF NOT EXISTS Land (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Code` VARCHAR(5) NULL,
  `Landesvorwahl` VARCHAR(4) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Orte;
CREATE TABLE IF NOT EXISTS Orte (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ` VARCHAR(10) NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Land_id` INT UNSIGNED NULL DEFAULT 1,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Orte_Land1_idx` (`Land_id` ASC) VISIBLE,
  CONSTRAINT `fk_Orte_Land1`
    FOREIGN KEY (`Land_id`)
    REFERENCES `Land` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Adressen;
CREATE TABLE IF NOT EXISTS Adressen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Strasse` VARCHAR(45) NULL,
  `Hausnummer` VARCHAR(5) NULL,
  `Adresszusatz` VARCHAR(20) NULL,
  `Wohnung` VARCHAR(10) NULL,
  `Orte_id` INT UNSIGNED NULL,
  `KatasterNr` VARCHAR(10) NULL,
  `x_CH1903` INT(7) UNSIGNED NULL,
  `y_CH1903` INT(7) UNSIGNED NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Adressen_Orte_idx` (`Orte_id` ASC) VISIBLE,
  CONSTRAINT `fk_Adressen_Orte`
    FOREIGN KEY (`Orte_id`)
    REFERENCES `Orte` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Personen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Personen;
CREATE TABLE IF NOT EXISTS Personen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Sex` VARCHAR(5) NULL,
  `Firma` VARCHAR(45) NULL,
  `Vorname` VARCHAR(45) NULL,
  `Nachname` VARCHAR(45) NULL,
  `Kategorien` SET('Firma','Buerger','Angestellter','Genossenrat','Bewirtschafter', 'Landteilbesitzer', 'Paechter', 'Wohnungsmieter', 'Bootsplatzmieter', 'Landwirt', 'Waermebezueger') DEFAULT NULL,
  `Geburtstag` DATE NULL,
  `Todestag` DATE NULL,
  `Aufnahmedatum` DATE NULL,
  `Privat_Adressen_id` INT UNSIGNED NULL,
  `Geschaefts_Adressen_id` INT UNSIGNED NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Personen_Adressen1_idx` (`Privat_Adressen_id` ASC) VISIBLE,
  INDEX `fk_Personen_Adressen2_idx` (`Geschaefts_Adressen_id` ASC) VISIBLE,
  CONSTRAINT `fk_Personen_Adressen1`
    FOREIGN KEY (`Privat_Adressen_id`)
    REFERENCES `Adressen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_Adressen2`
    FOREIGN KEY (`Geschaefts_Adressen_id`)
    REFERENCES `Adressen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `EMail_Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS EMail_Adressen;
CREATE TABLE IF NOT EXISTS EMail_Adressen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `eMail` VARCHAR(45) NOT NULL,
  `Type` VARCHAR(45) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Personen_has_EMail_Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Personen_has_EMail_Adressen;
CREATE TABLE IF NOT EXISTS Personen_has_EMail_Adressen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Personen_id` INT UNSIGNED NOT NULL,
  `EMail_Adressen_id` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Personen_has_EMail_Adressen_EMail_Adressen1_idx` (`EMail_Adressen_id` ASC) VISIBLE,
  INDEX `fk_Personen_has_EMail_Adressen_Personen1_idx` (`Personen_id` ASC) VISIBLE,
  CONSTRAINT `fk_Personen_has_EMail_Adressen_Personen1`
    FOREIGN KEY (`Personen_id`)
    REFERENCES `Personen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_has_EMail_Adressen_EMail_Adressen1`
    FOREIGN KEY (`EMail_Adressen_id`)
    REFERENCES `EMail_Adressen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Telefonnummern`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telefonnummern` ;
CREATE TABLE IF NOT EXISTS `Telefonnummern` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Laendercode` INT NULL,
  `Vorwahl` INT NULL,
  `Nummer` INT NULL,
  `Type` ENUM('Privat', 'Geschaeft') NULL,
  `Endgeraet` ENUM('Festnetz', 'Mobile', 'FAX') NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Personen_has_Telefonnummern`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Personen_has_Telefonnummern`;
CREATE TABLE IF NOT EXISTS `Personen_has_Telefonnummern` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Personen_id` INT UNSIGNED NOT NULL,
  `Telefonnummern_id` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `fk_Personen_has_Telefonnummern_Telefonnummern1_idx` (`Telefonnummern_id` ASC) VISIBLE,
  INDEX `fk_Personen_has_Telefonnummern_Personen1_idx` (`Personen_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Personen_has_Telefonnummern_Personen1`
    FOREIGN KEY (`Personen_id`)
    REFERENCES `Personen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_has_Telefonnummern_Telefonnummern1`
    FOREIGN KEY (`Telefonnummern_id`)
    REFERENCES `Telefonnummern` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
-- -----------------------------------------------------
-- Table `Waermebezueger`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Waermebezueger`;
CREATE TABLE IF NOT EXISTS `Waermebezueger` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `kW_Leistung` INT UNSIGNED NULL,
  `ZaehlerNr` VARCHAR(20) NULL,
  `Vertragsende` DATE NULL,
  `Objekt_Adresse` INT UNSIGNED NOT NULL,
  `Objekt_Owner` INT UNSIGNED NOT NULL,
  `Rechnungs_Empfaenger` INT UNSIGNED NOT NULL,
  `Handwerker` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Waermebezueger_Adressen1_idx` (`Objekt_Adresse` ASC) VISIBLE,
  INDEX `fk_Waermebezueger_Personen1_idx` (`Objekt_Owner` ASC) VISIBLE,
  INDEX `fk_Waermebezueger_Personen2_idx` (`Rechnungs_Empfaenger` ASC) VISIBLE,
  INDEX `fk_Waermebezueger_Personen3_idx` (`Handwerker` ASC) VISIBLE,
  CONSTRAINT `fk_Waermebezueger_Adressen1`
    FOREIGN KEY (`Objekt_Adresse`)
    REFERENCES `Adressen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Waermebezueger_Personen1`
    FOREIGN KEY (`Objekt_Owner`)
    REFERENCES `Personen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Waermebezueger_Personen2`
    FOREIGN KEY (`Rechnungs_Empfaenger`)
    REFERENCES `Personen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Waermebezueger_Personen3`
    FOREIGN KEY (`Handwerker`)
    REFERENCES `Personen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `IBAN`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `IBAN` ;
CREATE TABLE IF NOT EXISTS `IBAN` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nummer` VARCHAR(26) NOT NULL,
  `Bezeichnung` VARCHAR(45) NULL,
  `Bankname` VARCHAR(45) NOT NULL,
  `Bankort` VARCHAR(45) NOT NULL,
  `personen_id` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_iban_personen1_idx` (`personen_id` ASC) VISIBLE,
  CONSTRAINT `fk_iban_personen1`
     FOREIGN KEY (`personen_id`)
     REFERENCES `personen` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION);





SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
