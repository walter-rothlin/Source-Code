
-- Script last changed at 2017_05_03 12:25


SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema hwz_test_1
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `hwz_test_1` ;

CREATE SCHEMA IF NOT EXISTS `hwz_test_1` DEFAULT CHARACTER SET utf8 ;
USE `hwz_test_1` ;

-- -----------------------------------------------------
-- Table `hwz_test_1`.`orte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hwz_test_1`.`orte` ;

CREATE TABLE IF NOT EXISTS `hwz_test_1`.`orte` (
  `ort_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `plz` SMALLINT(4) NOT NULL,
  `bezeichnung` VARCHAR(45) CHARACTER SET 'big5' NOT NULL,
  PRIMARY KEY (`ort_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hwz_test_1`.`adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hwz_test_1`.`adressen` ;

CREATE TABLE IF NOT EXISTS `hwz_test_1`.`adressen` (
  `adress_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `vorname` VARCHAR(45) NOT NULL,
  `strasse` VARCHAR(45) NOT NULL,
  `orte_ort_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`adress_id`),
  INDEX `fk_adressen_orte_idx` (`orte_ort_id` ASC),
  CONSTRAINT `fk_adressen_orte`
    FOREIGN KEY (`orte_ort_id`)
    REFERENCES `hwz_test_1`.`orte` (`ort_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- Adding Data
INSERT INTO `hwz_test_1`.`orte` (`ort_id`, `plz`, `bezeichnung`) VALUES ('1', '8855', 'Wangen');
INSERT INTO `hwz_test_1`.`orte` (`ort_id`, `plz`, `bezeichnung`) VALUES ('2', '8855', 'Nuolen');
INSERT INTO `hwz_test_1`.`orte` (`ort_id`, `plz`, `bezeichnung`) VALUES ('3', '8854', 'Siebnen');

INSERT INTO `hwz_test_1`.`adressen` (`adress_id`, `name`, `vorname`, `strasse`, `orte_ort_id`) VALUES ('1', 'Rothlin', 'Walter', 'Peterliwiese 33', '1');
INSERT INTO `hwz_test_1`.`adressen` (`adress_id`, `name`, `vorname`, `strasse`, `orte_ort_id`) VALUES ('2', 'Friedlos', 'Josef', 'Ochsenboden 1a', '2');
INSERT INTO `hwz_test_1`.`adressen` (`adress_id`, `name`, `vorname`, `strasse`, `orte_ort_id`) VALUES ('3', 'Meier', 'Muster', 'Musterweg 6', '3');
INSERT INTO `hwz_test_1`.`adressen` (`adress_id`, `name`, `vorname`, `strasse`, `orte_ort_id`) VALUES ('4', 'Collet', 'Claudia', 'Peterliwiese 33', '1');

-- Creating view
drop view if exists adressliste;
create view adressliste as 
SELECT
	adressen.adress_id AS ID,
    adressen.name      AS Familienname,
    adressen.vorname   AS Vorname,
    adressen.strasse   AS Strasse,
    orte.plz           AS Postleitzahl,
    orte.bezeichnung   AS Ortschaft
FROM
    adressen,
    orte
WHERE
    adressen.orte_ort_id = orte.ort_id
Order by adressen.name, adressen.vorname;
    
-- Abfragen
SELECT Familienname, Ortschaft FROM adressliste;

select adressliste.Familienname, adressen.vorname from adressliste,adressen where adressen.name = adressliste.Familienname;
