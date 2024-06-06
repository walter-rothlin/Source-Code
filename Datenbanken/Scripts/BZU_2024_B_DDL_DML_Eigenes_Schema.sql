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
  `ID`             INT UNSIGNED NOT NULL,
  `PLZ`            VARCHAR(10)  NOT NULL,
  `Ortsname`       VARCHAR(45)  NOT NULL,
  `last_update`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`     VARCHAR(45)  NOT NULL DEFAULT 'Unknown',
  PRIMARY KEY (`ID`));

INSERT INTO `Orte` (`ID`, `PLZ`, `Ortsname`) VALUES 
	(1, '8855',  'Wangen' ),
    (2, '8854',  'Galgenen'),
    (3, '8854',  'Siebnen'),
    (4, '8853',  'Lachen');

-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `ID`             INT UNSIGNED NOT NULL,
  `Strasse`        VARCHAR(45)  NULL,
  `Hausnummer`     VARCHAR(10)  NULL,
  `Ort_id`         INT UNSIGNED NOT NULL,
  `last_update`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`     VARCHAR(45)  NOT NULL DEFAULT 'Unknown',
  PRIMARY KEY (`ID`),
  INDEX `fk_Ort_id_idx` (`Ort_id` ASC) VISIBLE,
  CONSTRAINT `fk_Adressen_Orte`
    FOREIGN KEY (`Ort_id`)
    REFERENCES `Orte` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
  
INSERT INTO `Adressen` (`ID`, `Strasse`, `Hausnummer`, `Ort_id` ) VALUES 
	(1, 'Peterliwiese',    '33',  1 ),
    (2, 'Musterstr.',      '44',  2 ),
    (3, 'Nördlingerhof.',  '1d',  3 ),
    (4, 'Zürcherstr.',     '42c', 4 );

-- -----------------------------------------------------
-- Table `Personen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Personen`;
CREATE TABLE IF NOT EXISTS `Personen` (
  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Vorname`       VARCHAR(45)  NOT NULL,
  `Nachname`      VARCHAR(45)  NOT NULL,
  `Adresse_id`    INT UNSIGNED NULL,
  `last_update`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    VARCHAR(45)  NOT NULL DEFAULT 'Unknown',
  PRIMARY KEY (`ID`),
  INDEX `fk_Adresse_id_idx` (`Adresse_id` ASC) VISIBLE,
  CONSTRAINT `fk_Personen_Adressen`
    FOREIGN KEY (`Adresse_id`)
    REFERENCES `Adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    
INSERT INTO `Personen` (`ID`, `Vorname`, `Nachname`, `Adresse_id` ) VALUES 
	(1, 'Walter' , 'Rothlin', 1 ),
    (2, 'Claudia', 'Collet' , 1 ),
    (3, 'Hans'   , 'Muster' , 2 ),
    (4, 'Max'    , 'Meier'  , 3 ),
    (5, 'Fritz'  , 'Künzli' , 4 ),
    (6, 'Martin' , 'Landolt', NULL );
    
-- -----------------------------------------------------
-- View `Mailing_Liste`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `Mailing_Liste`;
CREATE VIEW `Mailing_Liste` AS    
SELECT
	`pers`.`ID`                AS `ID`, 
    `pers`.`Vorname`           AS `Vorname`, 
    `pers`.`Nachname`          AS `Nachname`,
    `pers`.`Adresse_id`        AS `Adresse_id`,
    
    `adr`.`Strasse`            AS `Strasse`,
	`adr`.`Hausnummer`         AS `Hausnummer`,
    CONCAT(`adr`.`Strasse`, 
           ' ', 
           `adr`.`Hausnummer`)  AS `Strasse_Nr`,
	
    `o`.`PLZ`                   AS `PLZ`, 
    `o`.`Ortsname`              AS `Ort`
FROM `Personen` AS `pers`
LEFT OUTER JOIN `Adressen` AS `adr` ON `pers`.`Adresse_id` = `adr`.`ID`
LEFT OUTER JOIN `Orte`     AS `o`   ON `adr`.`ID` = `o`.`ID`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;