-- ---------------------------------------------------------------------------------------------
-- Create_Formigration.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein neues Schema mit nicht normalisierten adressen
--
-- History:
-- 15-May-2020   Walter Rothlin      Initial Version

-- ---------------------------------------------------------------------------------------------

-- Neues Schema kreieren
DROP SCHEMA IF EXISTS `BZU`;
CREATE SCHEMA IF NOT EXISTS `BZU` DEFAULT CHARACTER SET utf8;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `BZU`;

-- Adressen-Tabelle kreieren
DROP TABLE IF EXISTS `adressen`;
CREATE TABLE IF NOT EXISTS `adressen` (
  `vorname`    VARCHAR(45) NOT NULL,
  `nachname`   VARCHAR(45) NOT NULL,
  `strasse`    VARCHAR(45) NULL,
  `plz`        INT(4)      NOT NULL,
  `ort`        VARCHAR(45) NOT NULL,
  `adress_id`  INT(10)     UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`adress_id`));
  
-- Adressen einfüllen
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) 
       VALUES 
           ('Walter'  ,  'Rothlin' ,  'Peterliwiese 33'  ,  8855, 'Wangen' ),
           ('Claudia' ,  'Collet'  ,  'Peterliwiese 33'  ,  8855, 'Wangen' ),
           ('Michaela',  'Stöhr'   ,  'Züricherstr. 42c' ,  8854, 'Siebnen'),
           ('Josef'   ,  'Friedlos',  'Ochsenbodenweg 7a',  8855, 'Nuolen' );


-- -----------------------------------------------------------------------------------------------
-- 1.Normalisierung: zusammengesetzte Felder trennen
-- -----------------------------------------------------------------------------------------------

-- Tabelle anpassen
ALTER TABLE `adressen` 
    ADD COLUMN `hausnummer` VARCHAR(10) NULL AFTER `strasse`;
    
-- Datensätze mutieren (Nicht hardcodiert, sondern via Python-Script
-- UPDATE `adressen` SET `strasse`='Peterliwiese',   `hausnummer`='33'  WHERE `adress_id`=1;


-- -----------------------------------------------------------------------------------------------
-- Weiter normalisieren (Orte in neue Tabelle auslagern)
-- -----------------------------------------------------------------------------------------------

-- Neue Tabelle kreieren
DROP TABLE IF EXISTS `orte`;
CREATE TABLE IF NOT EXISTS `orte` (
  `ort_id` INT(10)     UNSIGNED NOT NULL AUTO_INCREMENT,
  `plz`    INT(4)      NOT NULL,
  `name`   VARCHAR(45) NOT NULL, -- CHARACTER SET 'big5' NOT NULL,
  PRIMARY KEY (`ort_id`));

-- Foreign key in Haupttabelle einführen
ALTER TABLE `adressen` 
    ADD COLUMN `orte_fk` INT(10) UNSIGNED NULL;   -- NOT NULL produces a contraint violation; Change it after migration to NOT NULL

-- Add FK do be indexed NOT REQUIRED
ALTER TABLE `adressen` 
  ADD INDEX `fk_adressen_orte_idx` (`orte_fk` ASC);

-- add FK constraint
ALTER TABLE `adressen` 
  ADD CONSTRAINT `fk_adressen_orte`
     FOREIGN KEY (`orte_fk`) REFERENCES `orte` (`ort_id`)
     ON DELETE RESTRICT   -- ON DELETE NO ACTION
     ON UPDATE CASCADE;   -- ON UPDATE NO ACTION

-- Orte auslagern
-- --------------

-- Orte einfüllen, manually
-- INSERT INTO `orte` (`ort_id`, `plz`, `name`) VALUES (1, 8854, 'Siebnen');

-- FK-Setzen
-- UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Siebnen' AND plz = 8854) WHERE `ort`='Siebnen' AND plz=8854;


-- Ueberprüft ob Migration richtig war
-- Redundante Felder (Attributte löschen)
