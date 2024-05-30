-- ---------------------------------------------------------------------------------------------
-- BZU_2024_B_DDL_DML_Eigenesschema.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Mit der Klasse erarbeitetes Script
--
-- History:
-- 30-May-2024   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


DROP SCHEMA IF EXISTS `bzu_b`;
CREATE SCHEMA IF NOT EXISTS  `bzu_b` ;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `bzu_b`;

-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `Ort_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`       VARCHAR(10) NULL,
  `Ort`       VARCHAR(45) NULL,
  PRIMARY KEY (`Ort_id`));

INSERT INTO `Orte` (`Ort_id`, `PLZ`, `Ort`) VALUES 
     (1,  '8855', 'Wangen'),
     (2,  '8854', 'Siebnen'),
     (3,  '8854', 'Galgenen'),
     (4,  '8855', 'Nuolen'),
     (5,  '8853', 'Lachen');

-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `Adress_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Vorname`   VARCHAR(45) NOT NULL,
  `Nachname`  VARCHAR(45) NOT NULL,
  `Strasse`   VARCHAR(45) NULL,
  `HausNr`    VARCHAR(5)  NULL,
  -- `PLZ`       VARCHAR(10) NULL,
  -- `Ort`       VARCHAR(45) NULL,
  `Ort_id`    INT UNSIGNED NULL,
  PRIMARY KEY (`Adress_id`),
  INDEX `fk_Ort_id_idx` (`Ort_id` ASC) VISIBLE,
  CONSTRAINT `fk_adressen_orte`
    FOREIGN KEY (`Ort_id`)
    REFERENCES `Orte` (`Ort_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  );


INSERT INTO `Adressen` (`Adress_id`, `Vorname`, `Nachname`, `Strasse`, `HausNr`, `Ort_id`) VALUES 
     (1, 'Walter',  'Rothlin', 'Peterliwiese',    '33',  1),
     (2, 'Claudia', 'Rothlin', 'Peterliwiese',    '33',  1),
     (3, 'Max',     'Meier',   'Nördlingerhof',   '1d',  3),
     (4, 'Walter',  'Rothlin', 'Etzelstr.',       ' 7',  1),
     (5, 'Walter',  'Krieg',    'St. Gallerstr.', '24c', 5);
     
     
DROP VIEW IF EXISTS `Adressen_V`;
CREATE VIEW `Adressen_V` AS    
	SELECT
		`Adr`.`Adress_id` AS `Adress_id`, 
		`Adr`.`Vorname`   AS `Vorname`, 
		`Adr`.`Nachname`  AS `Nachname`, 
		CONCAT(`Adr`.`Strasse`,' ',`Adr`.`HausNr`)    AS `Strasse`, 
		-- `Adr`.`HausNr`    AS `HausNr`, 
		-- `Adr`.`PLZ`, 
		-- `Adr`.`Ort`, 
		-- `Adr`.`Ort_id`,
		`O`.`PLZ`         AS `PLZ`,
		`O`.`Ort`         AS `Ort`
	FROM `Adressen` AS `Adr`
	LEFT OUTER JOIN `Orte` AS `O` ON `Adr`.`Ort_id` =  `O`.`Ort_id`;
     
     
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



