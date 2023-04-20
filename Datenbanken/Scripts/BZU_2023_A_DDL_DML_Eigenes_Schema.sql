-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BZU_2023_A
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BZU_2023_A
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BZU_2023_A` DEFAULT CHARACTER SET utf8 ;
USE `BZU_2023_A` ;

-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Orte` (
  `id`   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`  VARCHAR(10) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Adressen` (
  `id`      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name`    VARCHAR(45) NOT NULL,
  `Vorname` VARCHAR(45) NULL,
  `Strasse` VARCHAR(45) NOT NULL,
  `Orte_id` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_adressen_Orte_idx` (`Orte_id` ASC) VISIBLE,
  CONSTRAINT `fk_adressen_Orte`
    FOREIGN KEY (`Orte_id`)
    REFERENCES `Orte` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
