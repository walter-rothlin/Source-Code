
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
  `adress_id`  INT(10)     UNSIGNED NOT NULL AUTO_INCREMENT,
  `vorname`    VARCHAR(45) NOT NULL,
  `nachname`   VARCHAR(45) NOT NULL,
  `strasse`    VARCHAR(45) NULL,
  `plz`        INT(4)      NOT NULL,
  `ort`        VARCHAR(45) NOT NULL,
  PRIMARY KEY (`adress_id`));
  
-- Adressen einfüllen
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Walter',   'Rothlin',  'Peterliwiese 33',   8855, 'Wangen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Claudia',  'Collet',   'Peterliwiese 33',   8855, 'Wangen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Michaela', 'Stöhr',    'Züricherstr. 42c',  8854, 'Siebnen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Josef',    'Friedlos', 'Ochsenbodenweg 7a', 8855, 'Nuolen');

select * from adressen;

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
     ON UPDATE CASCADE;   -- ON UPDATE RECURSIVE CHANGE

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


-- -----------------------------------------------------------------------------------------------
-- Create view for business (external) read access
-- -----------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS adress_liste;
CREATE VIEW adress_liste AS
	SELECT
		`adressen`.`vorname`    AS `Vorname`,
		`adressen`.`nachname`   AS `Nachname`,
		`adressen`.`strasse`    AS `Strasse`,
		`adressen`.`hausnummer` AS `Haus Nummer`,
		`orte`.`plz`            AS `PLZ`,
		`orte`.`name`           AS `Ort`
	FROM `adressen`
	INNER JOIN `orte` ON `adressen`.`orte_fk` = `orte`.`ort_id`;
    
-- -----------------------------------------------------------------------------------------------
-- Add Function
-- -----------------------------------------------------------------------------------------------
-- Create function formatPLZ()  e.g. 8855     --> CH-8855
-- ===========================
DROP FUNCTION IF EXISTS formatPLZ;
Delimiter //
CREATE FUNCTION formatPLZ(p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  concat('CH-', p_input_plz);
END
//
DELIMITER ;

SELECT
    plz              AS PLZ,
	formatPLZ(plz)   AS PLZ_Formatted,
    name             AS Ortsbezeichnung
FROM
    orte
    
DROP VIEW IF EXISTS adress_liste;
CREATE VIEW adress_liste AS
	SELECT
        `adressen`.`adress_id`  AS `Id`,
		`adressen`.`vorname`    AS `Vorname`,
		`adressen`.`nachname`   AS `Nachname`,
		`adressen`.`strasse`    AS `Strasse`,
		`adressen`.`hausnummer` AS `Haus Nummer`,
		`orte`.`plz`            AS `PLZ`,
        formatPLZ(`orte`.`plz`) AS `PLZ_Formatted`,
		`orte`.`name`           AS `Ort`
	FROM `adressen`
	INNER JOIN `orte` ON `adressen`.`orte_fk` = `orte`.`ort_id`;
    
-- -----------------------------------------------------------------------------------------------
-- Daten aendern
-- -----------------------------------------------------------------------------------------------

-- Update von Daten
-- ================
-- Claudia ist an die Etzelstrasse 7 gezogen
UPDATE adress_liste
    SET
         Strasse='Etzelstrasse',
        `Haus Nummer`= '7'
    WHERE
        Nachname = 'Collet' AND
        Vorname = 'Claudia';

UPDATE adressen 
    SET 
        strasse='Etzelstrasse', 
        hausnummer = '7'
    WHERE 
        nachname = 'Collet' AND 
        vorname = 'Claudia';
        
-- Claudia ist von Wangen weggezogen und wohnt nun in Nuolen am Ochsenbodenweg 8a
-- FEHLER!!!! Keine Aenderungen über JOINS
-- UPDATE adress_liste
--    SET
--        Strasse='Ochsenbodenweg',
--        `Haus Nummer`= '8a',
--        PLZ = 8855,
--        Ort = 'Nuolen'
--    WHERE
--        Nachname = 'Collet' AND
--        Vorname = 'Claudia';

UPDATE adressen 
   SET 
       strasse    = 'Ochsenbodenweg',
       hausnummer = '8a',
       orte_fk    = (SELECT 
                         ort_id 
                     FROM orte 
                     WHERE name='Nuolen')  
    WHERE 
       nachname = 'Collet' AND 
       vorname  = 'Claudia';
       
-- -----------------------------------------------------------------------------------------------
-- Create stored procedures for business (external) write access
-- -----------------------------------------------------------------------------------------------
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
call getOrtId(8855, 'Nuolen', @id);
select @id;
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

set @id = 5;
call updateAdresse(@id, 'Ruijter', 'Doron', 'Schulhausstrasse', '1a', 8400, 'Winterthur');

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

