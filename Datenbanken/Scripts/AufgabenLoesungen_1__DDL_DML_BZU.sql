-- ---------------------------------------------------------------------------------------------
-- AufgabenLoesungen_1__DDL_DML.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein neues Schema und eine Adressen-Tabelle. Daten-Sätze werden erfasst.
--              Danach wird normalisiert und eine View erstellt
--
-- History:
-- 15-May-2020   Walter Rothlin      Initial Version
-- 04-Jun-2020   Walter Rothlin      Added Join, Function, View
-- 25-Jun-2020   Walter Rothlin      Added Stored-Procedures
-- ---------------------------------------------------------------------------------------------

-- Neues Schema kreieren
DROP SCHEMA IF EXISTS `bzu`;
CREATE SCHEMA `bzu`;

-- Als default Schema setzen
USE `bzu`;

-- Adressen-Tabelle kreieren
DROP TABLE IF EXISTS `adressen`;
CREATE TABLE `adressen` (
  `vorname`    VARCHAR(45) NOT NULL,
  `nachname`   VARCHAR(45) NOT NULL,
  `strasse`    VARCHAR(45) NULL,
  `plz`        INT(4)      NOT NULL,
  `ort`        VARCHAR(45) NOT NULL,
  `adress_id`  INT         NOT NULL AUTO_INCREMENT,
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
SELECT
     `adress_id`,
     `vorname`,
     `nachname`,
     `strasse`,
     `plz`,
     `ort`
     `hausnummer`,
     `plz`,
     `ort`
FROM `adressen`;

-- -----------------------------------------------------------------------------------------------
-- Weiter Normalisieren (Orte in neue Tabelle auslagern)
-- -----------------------------------------------------------------------------------------------

-- Neue Tabelle kreieren
DROP TABLE IF EXISTS `orte`;
CREATE TABLE `orte` (
  `ort_id` INT         NOT NULL AUTO_INCREMENT,
  `plz`    INT(4)      NOT NULL,
  `name`   VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ort_id`));

-- Check, welche Orte in die neue Tabelle migriert werden müssen
SELECT DISTINCT
     `adressen`.`plz`,
     `adressen`.`ort`
FROM 
     `adressen`
ORDER BY `plz`, `ort`; 
 
-- Orte einfüllen
-- -- INSERT INTO `orte` (`plz`, `name`) VALUES (8854, 'Siebnen');
-- -- INSERT INTO `orte` (`plz`, `name`) VALUES (8855, 'Nuolen');
-- -- INSERT INTO `orte` (`plz`, `name`) VALUES (8855, 'Wangen');


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
    ADD COLUMN `orte_fk` INT NULL;   -- NOT NULL produces a contraint violation; Change it after migration to NOT NULL

-- Add FK do be indexed NOT REQUIRED
ALTER TABLE `adressen` 
  ADD INDEX `fk_adressen_orte_idx` (`orte_fk` ASC);

-- add FK constraint
ALTER TABLE `adressen` 
  ADD CONSTRAINT `fk_adressen_orte`
     FOREIGN KEY (`orte_fk`) REFERENCES `orte` (`ort_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Datensätze mutieren
-- -- UPDATE `adressen` SET `orte_fk`=3 WHERE `adress_id`=1;
-- -- UPDATE `adressen` SET `orte_fk`=3 WHERE `adress_id`=2;
-- -- UPDATE `adressen` SET `orte_fk`=1 WHERE `adress_id`=3;
-- -- UPDATE `adressen` SET `orte_fk`=2 WHERE `adress_id`=4;

-- oder so...
UPDATE `adressen` SET `orte_fk`=1 WHERE `ort`='Siebnen' and plz=8854;
UPDATE `adressen` SET `orte_fk`=2 WHERE `ort`='Nuolen'  and plz=8855;
UPDATE `adressen` SET `orte_fk`=3 WHERE `ort`='Wangen'  and plz=8855;


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
     CHANGE COLUMN `orte_fk` `orte_fk` INT NOT NULL;

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

-- -----------------------------------------------------------------------------------------------
-- Add Function
-- -----------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS formatPLZ;
Delimiter //
CREATE FUNCTION formatPLZ(p_input_plz SMALLINT) RETURNS CHAR(10)
BEGIN
   RETURN  concat('CH-', p_input_plz);
END
//
DELIMITER ;

SELECT
     formatPLZ(`orte`.`plz`),
     `orte`.`name`
FROM `orte`;


-- -----------------------------------------------------------------------------------------------
-- Create view for business (external) read access
-- -----------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS `adress_liste`;
CREATE VIEW `adress_liste` AS
    SELECT
         `adressen`.`vorname`    AS `Vorname`,
         `adressen`.`nachname`   AS `Nachname`,
         `adressen`.`strasse`    AS `Strasse`,
         `adressen`.`hausnummer` AS `Hausnummer`,
         `orte`.`plz`            AS `PLZ`,
         `orte`.`name`           AS `Ort`,
         formatPLZ(`orte`.`plz`) AS `PLZ_Formated`
    FROM `adressen`
    JOIN `orte` ON `adressen`.`orte_fk` = `orte`.`ort_id`;
 

-- Abfrage via VIEW
SELECT * FROM `adress_liste`;


-- -----------------------------------------------------------------------------------------------
-- Create stored procedures for business (external) write access
-- -----------------------------------------------------------------------------------------------

-- getOrtId
DROP PROCEDURE IF EXISTS getOrtId;
DELIMITER $$
CREATE PROCEDURE getOrtId(IN plz SMALLINT(4), IN bezeichnung VARCHAR(45), OUT id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM orte WHERE orte.plz = plz AND orte.name = bezeichnung) = 0) THEN
        INSERT INTO orte (`plz`, `name`) VALUES (plz, bezeichnung);
    END IF;
    SELECT orte.ort_id FROM orte WHERE orte.plz = plz and orte.name = bezeichnung INTO id;
END$$
DELIMITER ;

-- Tests von getOrtId
-- bestehendes Ort
set @id = 0;
call getOrtId(8855, 'Wangen', @id);
select @id;

-- neues Ort
set @id = 0;
call getOrtId(8310, 'Grafstal', @id);
select @id;


-- createAdresse
DROP PROCEDURE IF EXISTS createAdresse;
DELIMITER $$
CREATE PROCEDURE createAdresse(IN nachname VARCHAR(45), IN vorname VARCHAR(45), IN strasse VARCHAR(45), IN hausnummer VARCHAR(10), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45), OUT generatedId SMALLINT(5))
BEGIN
    CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    INSERT INTO adressen (nachname, vorname, strasse, hausnummer, orte_fk) VALUES (nachname, vorname, strasse, hausnummer, @ort_id);
    SELECT LAST_INSERT_ID() INTO generatedId;
END$$
DELIMITER ;

-- Tests von createAdresse
set @id = 0;
call createAdresse('Ruijter', 'Doron', 'Im Gräbler', '12', 8310, 'Grafstal', @id);
select @id;

-- updateAdresse
DROP PROCEDURE IF EXISTS updateAdresse;
DELIMITER $$
CREATE PROCEDURE updateAdresse(IN id SMALLINT(5), IN nachname VARCHAR(45), IN vorname VARCHAR(45), IN strasse VARCHAR(45), IN hausnummer VARCHAR(10), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45))
BEGIN
    CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    UPDATE adressen SET nachname=nachname, vorname=vorname, strasse=strasse, hausnummer=hausnummer, orte_fk=@ort_id WHERE adress_id=id;
END$$
DELIMITER ;

-- Tests von updateAdresse
set @id = 6;
call updateAdresse(@id, 'Ruijter', 'Doron', 'Schulhausstrasse', '1a', 8400, 'Winterthur');
select @id;

deleteAdresse-- deleteAdresse
DROP PROCEDURE IF EXISTS deleteAdresse;
DELIMITER $$
CREATE PROCEDURE deleteAdresse(IN id SMALLINT(5))
BEGIN
    DELETE FROM adressen WHERE adress_id=id;
END$$
DELIMITER ;

-- Tests von deleteAdresse
set @id = 6;
call deleteAdresse(@id);
select @id;

-- deleteOrtIfUnused
DROP PROCEDURE IF EXISTS deleteOrtIfUnused;
DELIMITER $$
CREATE PROCEDURE deleteOrtIfUnused(IN id SMALLINT(5))
BEGIN
    IF ((SELECT COUNT(orte_fk) FROM adressen WHERE orte_fk=id) = 0) THEN
        DELETE FROM orte WHERE ort_id=id;
    END IF;
END$$
DELIMITER ;

-- Tests von deleteOrtIfUnused
set @id = 1;
call deleteOrtIfUnused(@id);

DROP PROCEDURE IF EXISTS deleteAdresseCascade;
-- Diese storeded procedure löscht auch Orte die nicht mehr von Adressen Referenziert werden
-- Kann auch über einen Konstraint ON DELETE CASCADE
DELIMITER $$
CREATE PROCEDURE deleteAdresseCascade(IN id SMALLINT(5))
BEGIN
    SET @ortID = (SELECT orte_fk FROM adressen WHERE adress_id = id);
    DELETE FROM adressen WHERE adress_id=id;
    CALL deleteOrtIfUnused(@ortID);
END$$
DELIMITER ;


-- -----------------------------------------------------------------------------------------------
-- Alles wieder löschen
-- -----------------------------------------------------------------------------------------------
DELETE FROM `adressen`;
DELETE FROM `orte`;

DROP VIEW  `adress_liste`;
DROP TABLE `adressen`;
DROP TABLE `orte`;

DROP Schema `bzu`;