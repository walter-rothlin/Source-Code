-- ---------------------------------------------------------------------------------------------
-- AufgabenLoesungen_1__DDL_DML.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein neues Schema und eine Adressen-Tabelle. Daten-Sätze werden erfasst.
--              Danach wird normalisiert und eine View erstellt
--
-- History:
-- 11-Jun-2021   Walter Rothlin      Initial Version
-- 18-Jun-2021   Walter Rothlin      Normalisierung
-- ---------------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS `bzu 2021`;
CREATE SCHEMA IF NOT EXISTS `bzu 2021`;

SELECT SLEEP(1);
USE `bzu 2021`;

DROP TABLE IF EXISTS adressen;
CREATE TABLE IF NOT EXISTS adressen (
  adress_id   INT(10)     UNSIGNED NOT NULL AUTO_INCREMENT,
  vorname     VARCHAR(45) NOT NULL,
  nachname    VARCHAR(45) NOT NULL,
  strasse     VARCHAR(45) NULL,
  plz         INT(4)      NOT NULL,
  ort         VARCHAR(45) NULL,
  PRIMARY KEY (adress_id));

INSERT INTO adressen (adress_id, vorname, nachname, strasse, plz, ort) VALUES (1, 'Walter'  , 'Rothlin' , 'Peterliwiese 33'  , 8855, 'Wangen');
INSERT INTO adressen (vorname, nachname, strasse, plz, ort) VALUES ('Claudia' , 'Collet'  , 'Peterliwiese 33'  , 8855, 'Wangen');
INSERT INTO adressen (vorname, nachname, strasse, plz, ort) VALUES ('Michaela', 'Stöhr'   , 'Züricherstr. 42c' , 8854, 'Siebnen');
INSERT INTO adressen (vorname, nachname, strasse, plz, ort) VALUES ('Josef'   , 'Friedlos', 'Ochsenbodenweg 7a', 8855, 'Nuolen');

SELECT
	adress_id,
    vorname,
    nachname,
    strasse,
    plz,
    ort
FROM
	adressen;
    
-- -----------------------------------------------------------------------------------------------
-- 1.Normalisierung: zusammengesetzte Felder trennen
-- -----------------------------------------------------------------------------------------------
ALTER TABLE adressen
	ADD COLUMN hausnummer VARCHAR(10) NULL AFTER strasse;
    
-- Datensätze mutieren
UPDATE `adressen` SET `strasse`='Peterliwiese',   `hausnummer`='33'  WHERE `adress_id`=1;
UPDATE `adressen` SET `strasse`='Peterliwiese',   `hausnummer`='33'  WHERE `adress_id`=2;
UPDATE `adressen` SET `strasse`='Züricherstr.',   `hausnummer`='42c' WHERE `adress_id`=3;
UPDATE `adressen` SET `strasse`='Ochsenbodenweg', `hausnummer`='7a'  WHERE `adress_id`=4;
    
SELECT
	adress_id,
    vorname,
    nachname,
    strasse,
    hausnummer,
    plz,
    ort
FROM
	adressen;

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


-- Check, welche Orte in die neue Tabelle migriert werden müssen
SELECT DISTINCT
     `adressen`.`plz`,
     `adressen`.`ort`
FROM 
     `adressen`
ORDER BY `plz`, `ort`; 

INSERT INTO `orte` (`ort_id`, `plz`, `name`) VALUES (1, 8854, 'Siebnen');
INSERT INTO `orte` (`ort_id`, `plz`, `name`) VALUES (2, 8855, 'Nuolen');
INSERT INTO `orte` (`ort_id`, `plz`, `name`) VALUES (3, 8855, 'Wangen');

DELETE FROM `orte`;      -- alles wieder löschen, weil es sollte wie folgt gemacht werden
INSERT INTO `orte` (`plz`, `name`) VALUES (8854, 'Siebnen');

TRUNCATE TABLE `orte`;   -- SEQUENZES will be reset as well. Is a DDL command
INSERT INTO `orte` (`plz`, `name`) VALUES (8854, 'Siebnen');

-- oder combined INSERT and SELECT
INSERT INTO `orte` (`plz`, `name`)
   SELECT DISTINCT
     `adressen`.`plz`,
     `adressen`.`ort`
   FROM 
     `adressen`
   ORDER BY `plz`, `ort`;
   
-- Foreign key in Haupttabelle einführen
ALTER TABLE `adressen` 
    ADD COLUMN `orte_fk` INT(10) UNSIGNED NULL;   -- NOT NULL produces a contraint violation; Change it after migration to NOT NULL

-- add FK constraint
ALTER TABLE `adressen` 
  ADD CONSTRAINT `fk_adressen_orte`
     FOREIGN KEY (`orte_fk`) REFERENCES `orte` (`ort_id`)
     ON DELETE RESTRICT   -- ON DELETE NO ACTION
     ON UPDATE CASCADE;   -- ON UPDATE NO ACTION
     

-- Datensätze mutieren
UPDATE `adressen` SET `orte_fk`=3 WHERE `adress_id`=1;
UPDATE `adressen` SET `orte_fk`=3 WHERE `adress_id`=2;
UPDATE `adressen` SET `orte_fk`=1 WHERE `adress_id`=3;
UPDATE `adressen` SET `orte_fk`=2 WHERE `adress_id`=4;

-- oder noch besser so...
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Siebnen' AND plz = 8854) WHERE `ort`='Siebnen' AND plz=8854;
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Nuolen'  AND plz = 8855) WHERE `ort`='Nuolen'  AND plz=8855;
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Wangen'  AND plz = 8855) WHERE `ort`='Wangen'  AND plz=8855;
