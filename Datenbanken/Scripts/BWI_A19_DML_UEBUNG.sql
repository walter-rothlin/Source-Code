
-- ---------------------------------------------------------------------------------------------
-- Script zum erstellen einer Adress-DB
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein neues Schema und eine Adressen-Tabelle. Daten-Sätze werden erfasst.
--              Danach wird normalisiert und die Daten migriert
--
-- History:
-- 08-Jun-2021   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

-- create new Schema
DROP SCHEMA IF EXISTS `hwz 2021`;
CREATE SCHEMA IF NOT EXISTS `hwz 2021` DEFAULT CHARACTER SET utf8;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait a sec, just to give a chance to set schema as default
USE `hwz 2021`;



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
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Walter',   'Rothlin',  'Peterliwiese 33',   8855, 'Wangen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Claudia',  'Collet',   'Peterliwiese 33',   8855, 'Wangen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Michaela', 'Stöhr',    'Züricherstr. 42c',  8854, 'Siebnen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Josef',    'Friedlos', 'Ochsenbodenweg 7a', 8855, 'Nuolen');

-- Check der Daten
SELECT
     `adress_id`,
     `vorname`,
     `nachname`,
     `strasse`,
     `plz`,
     `ort`
FROM 
     `adressen`;

-- -----------------------------------------------------------------------------------------------
-- 1.Normalisierung: zusammengesetzte Felder trennen
-- -----------------------------------------------------------------------------------------------

-- Tabelle anpassen
ALTER TABLE `adressen` 
    ADD COLUMN `hausnummer` VARCHAR(10) NULL AFTER `strasse`;

-- Datensätze mutieren
UPDATE `adressen` SET `strasse`='Peterliwiese',   `hausnummer`='33'  WHERE `adress_id`=1;
UPDATE `adressen` SET `strasse`='Peterliwiese',   `hausnummer`='33'  WHERE `adress_id`=2;
UPDATE `adressen` SET `strasse`='Züricherstr.',   `hausnummer`='42c' WHERE `adress_id`=3;
UPDATE `adressen` SET `strasse`='Ochsenbodenweg', `hausnummer`='7a'  WHERE `adress_id`=4;


-- Check der Daten
SELECT * FROM adressen;
SELECT
     `adress_id`,
     `vorname`,
     `nachname`,
     `strasse`,
     `hausnummer`,
     `plz`,
     `ort`
FROM `adressen`;

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
 
-- Orte einfüllen, manually
INSERT INTO `orte` (`ort_id`, `plz`, `name`) VALUES (1, 8854, 'Siebnen');
INSERT INTO `orte` (`ort_id`, `plz`, `name`) VALUES (2, 8855, 'Nuolen');
INSERT INTO `orte` (`ort_id`, `plz`, `name`) VALUES (3, 8855, 'Wangen');
DELETE FROM `orte`;      -- alles wieder löschen, weil es sollte wie folgt gemacht werden
TRUNCATE TABLE `orte`;   -- SEQUENZES will be reset as well. Is a DDL command

-- oder combined INSERT and SELECT
INSERT INTO `orte` (`plz`, `name`)
   SELECT DISTINCT
     `adressen`.`plz`,
     `adressen`.`ort`
   FROM 
     `adressen`
   ORDER BY `plz`, `ort`;

-- Check der Daten
SELECT * FROM `orte`;
SELECT * FROM `adressen`;

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

-- Datensätze mutieren
UPDATE `adressen` SET `orte_fk`=3 WHERE `adress_id`=1;
UPDATE `adressen` SET `orte_fk`=3 WHERE `adress_id`=2;
UPDATE `adressen` SET `orte_fk`=1 WHERE `adress_id`=3;
UPDATE `adressen` SET `orte_fk`=2 WHERE `adress_id`=4;

-- oder so...
UPDATE `adressen` SET `orte_fk`=1 WHERE `ort`='Siebnen' AND plz=8854;
UPDATE `adressen` SET `orte_fk`=2 WHERE `ort`='Nuolen'  AND plz=8855;
UPDATE `adressen` SET `orte_fk`=3 WHERE `ort`='Wangen'  AND plz=8855;

-- oder noch besser so...
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Siebnen' AND plz = 8854) WHERE `ort`='Siebnen' AND plz=8854;
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Nuolen'  AND plz = 8855) WHERE `ort`='Nuolen'  AND plz=8855;
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Wangen'  AND plz = 8855) WHERE `ort`='Wangen'  AND plz=8855;

-- oder noch besser mit einer procedure TBA


-- Ueberprüft ob Migration richtig war
SELECT
     `adressen`.`vorname`,
     `adressen`.`nachname`,
     `adressen`.`strasse`,
     `adressen`.`hausnummer`,
     `adressen`.`plz`,
     `adressen`.`ort`,
     `orte`.`plz`,
     `orte`.`name`
FROM `adressen`
JOIN `orte` ON `adressen`.`orte_fk` = `orte`.`ort_id`
WHERE `adressen`.`plz` <> `orte`.`plz` or 
      `adressen`.`ort` <> `orte`.`name`;

-- Redundante Felder (Attributte löschen)
ALTER TABLE `adressen` 
    DROP COLUMN `ort`,
    DROP COLUMN `plz`;

-- After migration set FK to NOT NULL
ALTER TABLE `adressen`
     CHANGE COLUMN `orte_fk` `orte_fk` INT(10) UNSIGNED NOT NULL;


-- Abfrage via Join
SELECT
    `adressen`.`vorname`    AS `Vorname`,
    `adressen`.`nachname`   AS `Nachname`,
    `adressen`.`strasse`    AS `Strasse`,
    `adressen`.`hausnummer` AS `Haus Nummer`,
    `orte`.`plz`            AS `PLZ`,
    `orte`.`name`           AS `Ort`
FROM `adressen`
JOIN `orte` ON `adressen`.`orte_fk` = `orte`.`ort_id`;
