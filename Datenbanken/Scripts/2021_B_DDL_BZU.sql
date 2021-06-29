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


-- oder noch besser so...
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Siebnen' AND plz = 8854) WHERE `ort`='Siebnen' AND plz=8854;
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Nuolen'  AND plz = 8855) WHERE `ort`='Nuolen'  AND plz=8855;
UPDATE `adressen` SET `orte_fk`=(SELECT ort_id FROM orte WHERE name = 'Wangen'  AND plz = 8855) WHERE `ort`='Wangen'  AND plz=8855;

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

DROP VIEW IF EXISTS adress_liste;
CREATE VIEW adress_liste AS
    SELECT
         A.vorname           AS Vorname,
         sayHello(a.Vorname) AS Anrede,
         A.nachname          AS Nachname,
         A.strasse           AS Strasse,
         A.hausnummer        AS Hausnummer,
         O.plz               AS PLZ,
         O.name              AS Ort
    FROM adressen AS A
    INNER JOIN orte AS O ON A.orte_fk = O.ort_id;
    
SELECT * FROM adress_liste;


-- Functions
-- ---------
-- Bei folgendem Fehler:
--    Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)

-- noch folgendes ausführen
--    SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS sayHello;
Delimiter //
CREATE FUNCTION sayHello(p_input_string CHAR(20)) RETURNS CHAR(50)
BEGIN
  RETURN  CONCAT('Hallo: ', p_input_string);
END//

SELECT sayHello('Walti');
SELECT 
     sayHello(Vorname) AS Anrede,
     Vorname           AS Firstname,
     Nachname          AS Lastname
FROM adress_liste;

