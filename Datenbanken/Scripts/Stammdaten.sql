-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Stammdaten
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Stammdaten` DEFAULT CHARACTER SET utf8 ;
USE `Stammdaten` ;

-- -----------------------------------------------------
-- Table `Land`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Land (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Code` VARCHAR(5) NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Orte (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ` VARCHAR(10) NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Land_id` INT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Orte_Land1_idx` (`Land_id` ASC) VISIBLE,
  CONSTRAINT `fk_Orte_Land1`
    FOREIGN KEY (`Land_id`)
    REFERENCES `mydb`.`Land` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Adressen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Strasse` VARCHAR(45) NULL,
  `Hausnummer` VARCHAR(5) NULL,
  `Adresszusatz` VARCHAR(20) NULL,
  `Orte_id` INT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Adressen_Orte_idx` (`Orte_id` ASC) VISIBLE,
  CONSTRAINT `fk_Adressen_Orte`
    FOREIGN KEY (`Orte_id`)
    REFERENCES `mydb`.`Orte` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Personen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Personen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Vorname` VARCHAR(45) NOT NULL,
  `Nachname` VARCHAR(45) NOT NULL,
  `Privat_Adressen_id` INT NULL,
  `Geschaefts_Adressen_id` INT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Personen_Adressen1_idx` (`Privat_Adressen_id` ASC) VISIBLE,
  INDEX `fk_Personen_Adressen2_idx` (`Geschaefts_Adressen_id` ASC) VISIBLE,
  CONSTRAINT `fk_Personen_Adressen1`
    FOREIGN KEY (`Privat_Adressen_id`)
    REFERENCES `mydb`.`Adressen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_Adressen2`
    FOREIGN KEY (`Geschaefts_Adressen_id`)
    REFERENCES `mydb`.`Adressen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `EMail_Adressen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS EMail_Adressen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `eMail` VARCHAR(45) NOT NULL,
  `Type` VARCHAR(45) NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Personen_has_EMail_Adressen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Personen_has_EMail_Adressen (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Personen_id` INT NOT NULL,
  `EMail_Adressen_id` INT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Personen_has_EMail_Adressen_EMail_Adressen1_idx` (`EMail_Adressen_id` ASC) VISIBLE,
  INDEX `fk_Personen_has_EMail_Adressen_Personen1_idx` (`Personen_id` ASC) VISIBLE,
  CONSTRAINT `fk_Personen_has_EMail_Adressen_Personen1`
    FOREIGN KEY (`Personen_id`)
    REFERENCES `mydb`.`Personen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_has_EMail_Adressen_EMail_Adressen1`
    FOREIGN KEY (`EMail_Adressen_id`)
    REFERENCES `mydb`.`EMail_Adressen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Telefonnummern`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Telefonnummern (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Laendercode` INT(4) NULL,
  `Vorwahl` INT NULL,
  `Nummer` INT NULL,
  `Type` ENUM('Privat', 'Geschaeft') NULL,
  `Endgeraet` ENUM('Festnetz', 'Mobile', 'FAX') NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `Personen_has_Telefonnummern`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Personen_has_Telefonnummern (
  `Personen_id` INT NOT NULL,
  `Telefonnummern_id` INT NOT NULL,
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `fk_Personen_has_Telefonnummern_Telefonnummern1_idx` (`Telefonnummern_id` ASC) VISIBLE,
  INDEX `fk_Personen_has_Telefonnummern_Personen1_idx` (`Personen_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Personen_has_Telefonnummern_Personen1`
    FOREIGN KEY (`Personen_id`)
    REFERENCES `mydb`.`Personen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_has_Telefonnummern_Telefonnummern1`
    FOREIGN KEY (`Telefonnummern_id`)
    REFERENCES `mydb`.`Telefonnummern` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
