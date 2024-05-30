-- ---------------------------------------------------------------------------------------------
-- BZU_2024_A_DDL_DML_Eigenesschema.sql
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


DROP SCHEMA IF EXISTS `bzu_a`;
CREATE SCHEMA IF NOT EXISTS  `bzu_a` ;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `bzu_a`;

-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `Ort_id`   INT UNSIGNED NOT NULL,
  `PLZ`      VARCHAR(10) NOT NULL,
  `Ortsname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Ort_ID`));
  

DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `Adress_id`  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Vorname`    VARCHAR(45) NOT NULL,
  `Nachname`   VARCHAR(45) NOT NULL,
  `Strasse`    VARCHAR(45) NULL,
  `Hausnummer` VARCHAR(10) NULL,
  `PLZ`        VARCHAR(10) NOT NULL,
  `Ort`        VARCHAR(45) NOT NULL,
  `Ort_id`     INT UNSIGNED NULL,
  PRIMARY KEY (`Adress_id`),
  INDEX `fk_Ort_id_idx` (`Ort_id` ASC) VISIBLE,
  CONSTRAINT `fk_adressen_Orte`
    FOREIGN KEY (`Ort_id`)
    REFERENCES `Orte` (`Ort_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- Adding Test-Data
INSERT INTO `Orte` (`Ort_id`, `PLZ`, `Ortsname`) VALUES 
	(1, '8855',  'Wangen' ),
    (2, '8854',  'Galgenen'),
    (3, '8854',  'Siebnen'),
    (4, '8853',  'Lachen');
    
    
INSERT INTO `Adressen` (`Adress_id`, `Vorname`, `Nachname`, `Strasse`, `Hausnummer`, `PLZ`, `Ort`, `Ort_id` ) VALUES 
	(1, 'Walter' , 'Rothlin', 'Peterliwiese',    '33',  '8855',  'Wangen',     1 ),
    (2, 'Claudia', 'Collet' , 'Peterliwiese',    '33',  '8855',  'Wangen',     1 ),
    (3, 'Hans'   , 'Muster' , 'Musterstr.',      '44',  '8854',  'Galgenen',   2 ),
    (4, 'Max'    , 'Meier'  , 'Nördlingerhof.',  '1d',  '8854',  'Siebnen',    3 ),
    (5, 'Fritz'  , 'Künzli' , 'Zürcherstr.',     '42c', '8853',  'Lachen',     4 );

SELECT
	`adr`.`Adress_id`, 
    `adr`.`Vorname`, 
    `adr`.`Nachname`, 
    `adr`.`Strasse`, 
    `adr`.`Hausnummer`, 
    `adr`.`PLZ`, 
    `adr`.`Ort`, 
    `adr`.`Ort_id`,
    `o`.`PLZ`, 
    `o`.`Ortsname`
FROM `adressen` AS `adr`
LEFT OUTER JOIN `Orte` AS `o` ON `adr`.`Ort_id` = `o`.`Ort_id`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;