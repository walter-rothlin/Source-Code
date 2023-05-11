-- ---------------------------------------------------------------------------------------------
-- Filename: Stammdaten_DDL.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Stammdaten_DDL.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein Stammdaten Schema
--
-- History:
-- 03-Jun-2022   Walter Rothlin      Initial Version
-- 10-Jun-2022   Walter Rothlin      Modified ERD and added Attributs
-- 17-Jun_2022   Walter Rothlin		 Added Waermebezueger and its relations
-- 15-Jul-2022   Walter Rothlin      Added Functions and extended views with functions fields
-- 14-Jan-2023   Walter Rothlin      Prepared for takeover from Buerger_DB
-- 21-Jan-2023   Walter Rothlin      Added landteil
-- 08-Feb-2023   Walter Rothlin      Added more attributes to Person, Landteil
-- 18-Feb-2023   Walter Rothlin      Fix Charset issue in firstUpper()
-- 26-Feb-2023   Walter Rothlin      Added IDs to orte....personen viewsstored-Procedure section
-- 18-Apr-2023   Walter Rothlin      Fixed DELIMITER in Fct
-- 25-Apr-2023   Walter Rothlin      Added history and Bemerkungen to view personen_daten
-- 08-May-2023   Walter Rothlin	     removed ID and Added combined PK to personen_has_email_adressen and personen_has_telefonnummern
-- ---------------------------------------------------------------------------------------------

-- To-Does
-- Split Strasse Hausnummer
-- TelefonNummer splitten
-- Format Telefonnummer
-- Format IBAN
-- View PERSONEN_DATEN mit Partner, Vater und Mutter erweitern
-- get_age() Aktuelles Alter berechnen, wenn Todestag dann Alter fixiert
-- If Todestag is not NULL then alle Telefonnummer und eMail Adressen löschen
-- Ueberprüfen ob jede Person nur 1 Telnr, IBAN und eMail addresse pro Prioritaet hat und die schön aufsteigend von 0 an sind
-- ---------------------------------------------------------------------------------------------
SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ===============================================================================================
-- == Schema Stammdaten kreieren                                                                ==
-- ===============================================================================================
DROP SCHEMA IF EXISTS genossame_wangen;
CREATE SCHEMA IF NOT EXISTS genossame_wangen  DEFAULT CHARACTER SET utf8 ;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE genossame_wangen;


-- ===============================================================================================
-- == Create Tables                                                                             ==
-- ===============================================================================================

-- -----------------------------------------------------
-- Table `Land`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Land;
CREATE TABLE IF NOT EXISTS Land (
  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name`          VARCHAR(45) NOT NULL,
  `Code`          VARCHAR(5) NULL,
  `Landesvorwahl` VARCHAR(4) NULL,
  `last_update`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- PK-Constraints
  PRIMARY KEY (`ID`));

-- -----------------------------------------------------
-- Table `Orte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Orte;
CREATE TABLE IF NOT EXISTS Orte (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`         VARCHAR(10) NOT NULL,
  `Name`        VARCHAR(45) NULL,
  `Land_ID`     INT UNSIGNED NULL DEFAULT 1,
  `Kanton`      VARCHAR(10) NULL,
  `Tel_Vorwahl` VARCHAR(3) NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_Orte_Land1_idx` (`Land_ID` ASC) VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Orte_Land1`
    FOREIGN KEY (`Land_ID`)
    REFERENCES `Land` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Adressen;
CREATE TABLE IF NOT EXISTS Adressen (
  `ID`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Strasse`        VARCHAR(45) NULL,
  `Hausnummer`     VARCHAR(15) NULL,
  `Postfachnummer` VARCHAR(5) NULL,
  `Adresszusatz`   VARCHAR(20) NULL,
  `Wohnung`        VARCHAR(10) NULL,
  `Orte_ID`        INT UNSIGNED NULL,
  `KatasterNr`     VARCHAR(10) NULL,
  `x_CH1903`       INT(7) UNSIGNED NULL,
  `y_CH1903`       INT(7) UNSIGNED NULL,
  `last_update`    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_Adressen_Orte_idx` (`Orte_ID` ASC) VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Adressen_Orte`
    FOREIGN KEY (`Orte_ID`)
    REFERENCES `Orte` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

    
    
-- -----------------------------------------------------
-- Table `Personen` 
-- -----------------------------------------------------
DROP TABLE IF EXISTS Personen;
CREATE TABLE IF NOT EXISTS Personen (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Source`      ENUM('Initial_1', 'Loader_1', 'BuergerDB','ImmoTop') DEFAULT NULL,
  `History`     VARCHAR(500) NULL,
  `Bemerkungen` VARCHAR(500) NULL,

  `Sex`                      VARCHAR(5) NULL,
  `Firma`                    VARCHAR(45) NULL,
  `Vorname`                  VARCHAR(45) NULL,
  `Vorname_2`                VARCHAR(45) NULL,
  `Ledig_Name`               VARCHAR(45) NULL,
  `Partner_Name`             VARCHAR(45) NULL,
  `Partner_Name_Angenommen`  BOOLEAN DEFAULT FALSE,
  `AHV_Nr`                   VARCHAR(45) NULL,
  `Betriebs_Nr`              VARCHAR(45) NULL,
  `Partner_ID` 		         INT NULL,
  `Vater_ID`         		 INT NULL,
  `Mutter_ID`				 INT NULL,
  `Zivilstand`  ENUM('Unbestimmt', 'Leer', 'Ledig','Verheiratet','Getrennt','Geschieden','Verwitwet','Wiederverheiratet','Gestorben','Bevormundet','Partnerschaft') DEFAULT NULL,
  `Kategorien`  SET('Firma','Bürger','Angestellter', 'Auftragnehmer','Genossenrat', 'LWK', 'Landteilbesitzer',
					'Pächter','Wohnungsmieter', 'Bootsplatzmieter', 'Landwirt', 'Waermebezüger', 'Nutzungsberechtigt', 
                    'Betriebsgemeinschaft', 'Generationengemeinschaft') DEFAULT NULL,
  
  -- Datumsangaben
  `Geburtstag`                   DATE NULL,
  `Todestag`                     DATE NULL,
  `Nach_Wangen_Gezogen`          DATE NULL,
  `Von_Wangen_Weggezogen`        DATE NULL,
  `Baulandgesuch_Eingereicht_Am` DATE NULL,
  `Bauland_Gekauft_Am`           DATE NULL,
  `Baulandgesuch_Details`        VARCHAR(500) NULL,
  `Angemeldet_Am`                DATE NULL,
  `Aufgenommen_Am`               DATE NULL,
  `Funktion_Uebernommen_Am`      DATE NULL,
  `Funktion_Abgegeben_Am`        DATE NULL,
  `Chronik_Bezogen_Am`           DATE NULL,
  
  -- von ACCESS-DB 1:1 uebernommen (Temporär)
  -- lintNutzenKey				   INT,
  -- bolNutzenberechtigung		   BOOL DEFAULT FALSE,
  -- bolBaulandgesuch   		   BOOL DEFAULT FALSE,
  -- bolMutationen_Aktuell         BOOL DEFAULT FALSE,
  -- bolMitarbeiter_Genossame      BOOL DEFAULT FALSE,
  -- bolWeggezogen                 BOOL DEFAULT FALSE,
  -- bolAktiv                      BOOL DEFAULT FALSE,
  -- bolLandwirt				   BOOL DEFAULT FALSE,
  -- bolGenossenbürger			   BOOL DEFAULT FALSE,
  -- bolBürgerauflage  			   BOOL DEFAULT FALSE,
  
  -- FK: Adressen
  `Privat_Adressen_ID`          INT UNSIGNED NULL,
  `Geschaefts_Adressen_ID`      INT UNSIGNED NULL,
  
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_Personen_Adressen1_idx` (`Privat_Adressen_ID` ASC)     VISIBLE,
  INDEX `fk_Personen_Adressen2_idx` (`Geschaefts_Adressen_ID` ASC) VISIBLE,
  INDEX `fk_Personen_Adressen3_idx` (`Vater_ID` ASC)               VISIBLE,
  INDEX `fk_Personen_Adressen4_idx` (`Mutter_ID` ASC)              VISIBLE,
  INDEX `fk_Personen_Adressen5_idx` (`Partner_ID` ASC)             VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Personen_Adressen1`
    FOREIGN KEY (`Privat_Adressen_ID`)
    REFERENCES `Adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_Adressen2`
    FOREIGN KEY (`Geschaefts_Adressen_ID`)
    REFERENCES `Adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  
  CONSTRAINT `fk_Personen_Adressen3`
    FOREIGN KEY (`Vater_ID`)
    REFERENCES `Person` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_Adressen4`
    FOREIGN KEY (`Mutter_ID`)
    REFERENCES `Person` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_Adressen5`
    FOREIGN KEY (`Partner_ID`)
    REFERENCES `Person` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `EMail_Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS EMail_Adressen;
CREATE TABLE IF NOT EXISTS EMail_Adressen (
  `ID`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `eMail`        VARCHAR(45)  NOT NULL,
  `Type`         ENUM('Privat', 'Geschaeft', 'Sonstige')  NULL,
  `Prio`         TINYINT      NOT NULL DEFAULT 0, 
  `last_update`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------------------
-- Table `Personen_has_EMail_Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS Personen_has_EMail_Adressen;
CREATE TABLE IF NOT EXISTS Personen_has_EMail_Adressen (
  -- `ID`                INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Personen_ID`       INT UNSIGNED NOT NULL,
  `EMail_Adressen_ID` INT UNSIGNED NOT NULL,
  `last_update`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      
  -- PK-Constraints
  -- PRIMARY KEY (`ID`),
  PRIMARY KEY (`Personen_ID`, `EMail_Adressen_ID`),
  
  -- Indizes
  INDEX `fk_Personen_has_EMail_Adressen_EMail_Adressen1_idx` (`EMail_Adressen_ID` ASC) VISIBLE,
  INDEX `fk_Personen_has_EMail_Adressen_Personen1_idx`       (`Personen_ID` ASC)       VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Personen_has_EMail_Adressen_Personen1`
    FOREIGN KEY (`Personen_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_has_EMail_Adressen_EMail_Adressen1`
    FOREIGN KEY (`EMail_Adressen_ID`)
    REFERENCES `EMail_Adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Telefonnummern`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telefonnummern` ;
CREATE TABLE IF NOT EXISTS `Telefonnummern` (
  `ID`           INT UNSIGNED                                 NOT NULL AUTO_INCREMENT,
  `Laendercode`  VARCHAR(4)                                   NOT NULL DEFAULT '0041',
  `Vorwahl`      VARCHAR(3)                                   NULL,
  `Nummer`       VARCHAR(11)                                  NULL,
  `Type`         ENUM('Privat', 'Geschaeft', 'Sonstige')      NULL,
  `Endgeraet`    ENUM('Festnetz', 'Mobile', 'FAX')            NULL,
  `Prio`         TINYINT                                      NOT NULL DEFAULT 0, 
  `last_update`  TIMESTAMP                                    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      
  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------------------
-- Table `Personen_has_Telefonnummern`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Personen_has_Telefonnummern`;
CREATE TABLE IF NOT EXISTS `Personen_has_Telefonnummern` (
  -- `ID`                INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Personen_ID`       INT UNSIGNED NOT NULL,
  `Telefonnummern_ID` INT UNSIGNED NOT NULL,
  `last_update`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      
  -- PK-Constraints
  -- PRIMARY KEY (`ID`),
  PRIMARY KEY (`Personen_ID`, `Telefonnummern_ID`),
  
  -- Indizes
  INDEX `fk_Personen_has_Telefonnummern_Telefonnummern1_idx` (`Telefonnummern_ID` ASC) VISIBLE,
  INDEX `fk_Personen_has_Telefonnummern_Personen1_idx`       (`Personen_ID` ASC)       VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Personen_has_Telefonnummern_Personen1`
    FOREIGN KEY (`Personen_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_has_Telefonnummern_Telefonnummern1`
    FOREIGN KEY (`Telefonnummern_ID`)
    REFERENCES `Telefonnummern` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `IBAN`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `IBAN` ;
CREATE TABLE IF NOT EXISTS `IBAN` (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nummer`      VARCHAR(26) NOT NULL,
  `Bezeichnung` VARCHAR(45) NULL,
  `Bankname`    VARCHAR(45) NOT NULL DEFAULT '',
  `Bankort`     VARCHAR(45) NOT NULL DEFAULT '',
  `Personen_ID` INT UNSIGNED NOT NULL,
  `Prio`        TINYINT      NOT NULL DEFAULT 0, 
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_iban_personen1_idx` (`personen_ID` ASC) VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_iban_personen1`
     FOREIGN KEY (`personen_ID`)
     REFERENCES `personen` (`ID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION);

-- ALTER TABLE `iban` 
-- ADD UNIQUE INDEX `Nummer_UNIQUE` (`Nummer` ASC) VISIBLE;
-- -----------------------------------------------------
-- Table `Waermebezueger`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Waermebezueger`;
CREATE TABLE IF NOT EXISTS `Waermebezueger` (
  `ID`                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `kW_Leistung`          INT UNSIGNED NULL,
  `ZaehlerNr`            VARCHAR(20) NULL,
  `Vertragsende`         DATE NULL,
  `Objekt_Adresse`       INT UNSIGNED NOT NULL,
  `Objekt_Owner`         INT UNSIGNED NOT NULL,
  `Rechnungs_Empfaenger` INT UNSIGNED NOT NULL,
  `Handwerker`           INT UNSIGNED NOT NULL,
  `last_update`          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_Waermebezueger_Adressen1_idx` (`Objekt_Adresse` ASC)       VISIBLE,
  INDEX `fk_Waermebezueger_Personen1_idx` (`Objekt_Owner` ASC)         VISIBLE,
  INDEX `fk_Waermebezueger_Personen2_idx` (`Rechnungs_Empfaenger` ASC) VISIBLE,
  INDEX `fk_Waermebezueger_Personen3_idx` (`Handwerker` ASC)           VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Waermebezueger_Adressen1`
    FOREIGN KEY (`Objekt_Adresse`)
    REFERENCES `Adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Waermebezueger_Personen1`
    FOREIGN KEY (`Objekt_Owner`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Waermebezueger_Personen2`
    FOREIGN KEY (`Rechnungs_Empfaenger`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Waermebezueger_Personen3`
    FOREIGN KEY (`Handwerker`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `Landteil`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Landteil`;
CREATE TABLE IF NOT EXISTS `Landteil` (
  `ID`                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `AV_Parzellen_Nr`      VARCHAR(20) NOT NULL,
  `GENO_Parzellen_Nr`    VARCHAR(20) NOT NULL,
  `Flur_Bezeichnung`     VARCHAR(20) NULL,
  `Gemeindegebiet_ID`    INT UNSIGNED NULL,
  
  `Flaeche_In_Aren`      FLOAT UNSIGNED NULL,
  `Pachtzins_Pro_Are`    FLOAT UNSIGNED NULL,
  `Fix_Pachtzins`        FLOAT UNSIGNED NULL,
  `Vertragsart`          ENUM('Pachtvertrag','Fixpacht','Gebrauchsleihe','Gekündigt','Bürger_ist_Verpächter') DEFAULT NULL,
  
  `Buergerlandteil`      ENUM('16a','35a','Geno') DEFAULT NULL,
  `Qualitaet`            ENUM('Futter','Streu','Verbuscht','Wald') DEFAULT NULL,
  `Polygone_Flaeche`     VARCHAR(300) NULL,
  
  `Pachtbeginn_Am`      DATE NULL,
  `Rueckgabe_Am`        DATE NULL,
  `Vertragsende_Am`     DATE NULL,
  `Pachtende_Am`        DATE NULL,

  `Paechter_ID`                  INT UNSIGNED NULL,
  `Verpaechter_ID`               INT UNSIGNED NOT NULL,
  `Vorheriger_Paechter_ID`       INT UNSIGNED NULL,
  `Vorheriger_Verpaechter_ID`    INT UNSIGNED NOT NULL,

  `last_update`          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_Landteil_Paechter_Adresse_idx`        (`Paechter_ID`               ASC)    VISIBLE,
  INDEX `fk_Landteil_Verpaechter_Adresse_idx`     (`Verpaechter_ID`            ASC)    VISIBLE,
  INDEX `fk_Landteil_Pre_Paechter_Adresse_idx`    (`Vorheriger_Paechter_ID`    ASC)    VISIBLE,
  INDEX `fk_Landteil_Pre_Verpaechter_Adresse_idx` (`Vorheriger_Verpaechter_ID` ASC)    VISIBLE,
  INDEX `fk_Landteil_Gemeindegebiet_idx`          (`Gemeindegebiet_ID`         ASC)    VISIBLE,

  -- FK-Constraints
  CONSTRAINT `fk_Paechter_ID`
    FOREIGN KEY (`Paechter_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Verpaechter_ID`
    FOREIGN KEY (`Verpaechter_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pre_Verpaechter_ID`
    FOREIGN KEY (`Vorheriger_Paechter_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pre_Paechter_ID`
    FOREIGN KEY (`Vorheriger_Verpaechter_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `Landteil_Gemeindegebiet`
    FOREIGN KEY (`Gemeindegebiet_ID`)
    REFERENCES `Orte` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- ===============================================================================================
-- == Create Funtions used in Joins                                                             ==
-- ===============================================================================================
SET GLOBAL log_bin_trust_function_creators = 1;

-- --------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS getRowCount;
DELIMITER //
CREATE FUNCTION getRowCount(tableName varchar(255))
RETURNS int
BEGIN
  DECLARE rowCount int;
  SET rowCount = (SELECT COUNT(*) FROM tableName);
  RETURN rowCount;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getRowCount('land') AS rc_land;

-- --------------------------------------------------------------------------------

--  Added a value to a SET
DROP FUNCTION IF EXISTS addSetValue;
DELIMITER //
CREATE FUNCTION  addSetValue(oldSetValue VARCHAR(500), valueToAdd VARCHAR(30)) RETURNS VARCHAR(500)
BEGIN
   IF oldSetValue IS NULL OR length(oldSetValue) = 0 THEN
         RETURN  valueToAdd;
   ELSE
         RETURN  CONCAT(oldSetValue, ',', valueToAdd);
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter') WHERE  id = 1112;

-- --------------------------------------------------------------------------------
--  Remove a value from a SET
DROP FUNCTION IF EXISTS removeSetValue;
DELIMITER //
CREATE FUNCTION  removeSetValue(oldSetValue VARCHAR(500), valueToRremove VARCHAR(30)) RETURNS VARCHAR(500)
BEGIN
   IF oldSetValue IS NULL OR length(oldSetValue) = 0 THEN
         RETURN  oldSetValue;
   ELSE
         RETURN  REPLACE(REPLACE(oldSetValue, valueToRremove, ''),',,', ',');
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- UPDATE `personen` SET Kategorien = removeSetValue(Kategorien, 'Pächter') WHERE  id = 1112;

-- --------------------------------------------------------------------------------
--  Fct 10.0) Gibt den aelteren Timestamp zurueck
DROP FUNCTION IF EXISTS getOlder;
DELIMITER //
CREATE FUNCTION  getOlder(timeStamp_1 datetime, timeStamp_2 datetime) RETURNS datetime
BEGIN
   IF timeStamp_1 < timeStamp_2 THEN
         RETURN  timeStamp_1;
   ELSE
         RETURN  timeStamp_2;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getOlder(STR_TO_DATE('20050527-194523', '%Y%m%d-%H%i%s'), STR_TO_DATE('20050527-194524', '%Y%m%d-%H%i%s')) AS latest_change;

-- --------------------------------------------------------------------------------
--  Fct 10.1) Gibt den juengeren Timestamp zurueck
DROP FUNCTION IF EXISTS getYounger;
DELIMITER //
CREATE FUNCTION  getYounger(timeStamp_1 datetime, timeStamp_2 datetime) RETURNS datetime
BEGIN
   IF timeStamp_1 > timeStamp_2 THEN
         RETURN  timeStamp_1;
   ELSE
         RETURN  timeStamp_2;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getYounger(STR_TO_DATE('20050527-194523', '%Y%m%d-%H%i%s'), STR_TO_DATE('20050527-194524', '%Y%m%d-%H%i%s')) AS latest_change;

-- --------------------------------------------------------------------------------
--  Fct 10.2) getAge() Aktuelles Alter berechnen, wenn Todestag dann Alter fixiert, sonst NOW() - Birthday (Nur Jahre)
DROP FUNCTION IF EXISTS getAge;
DELIMITER //
CREATE FUNCTION  getAge(birthday date, deathDate date) RETURNS int
BEGIN
	IF deathDate IS NULL THEN
		RETURN timestampdiff(YEAR,birthday, CURDATE());
    ELSE
       RETURN timestampdiff(YEAR,birthday, deathDate);
	END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getAge(STR_TO_DATE('1960-08-05', '%Y-%m-%d'), STR_TO_DATE('2023-04-28', '%Y-%m-%d')) AS Age;
-- SELECT getAge(STR_TO_DATE('1960-08-05', '%Y-%m-%d'), NULL) AS Age;

-- --------------------------------------------------------------------------------
--  Fct 10.3) Gibt die internationale PLZ zurueck
DROP FUNCTION IF EXISTS formatPLZinternational;
DELIMITER //
CREATE FUNCTION formatPLZinternational(p_countryCode CHAR(50), p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  CONCAT(p_countryCode, '-', p_input_plz);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZinternational('CH', 8854) AS PLZ_Formated;     -- --> CH-8854
-- SELECT formatPLZinternational('D', 10115) AS PLZ_Formated;     -- --> D-10115
--  -------------------------------------------------------------
--  Fct 10.3.1) Gibt die internationale PLZ mit dem Ort zurueck
DROP FUNCTION IF EXISTS formatPLZinternational_ort;
DELIMITER //
CREATE FUNCTION formatPLZinternational_ort(p_countryCode CHAR(50), p_input_plz SMALLINT, p_ort CHAR(50)) RETURNS CHAR(50)
BEGIN
   RETURN  CONCAT(p_countryCode, '-', p_input_plz, ' ', p_ort);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZinternational_ort('CH', 8854, 'Siebnen') AS PLZ_Ort;     -- --> CH-8854 Siebnen
-- SELECT formatPLZinternational_ort('D', 10115, 'Berlin') AS PLZ_Ort;     -- --> D-10115 Berlin
--  -------------------------------------------------------------
--  Fct 10.3.2) Gibt die PLZ mit dem Ort zurueck
DROP FUNCTION IF EXISTS formatPLZ_ort;
DELIMITER //
CREATE FUNCTION formatPLZ_ort(p_input_plz SMALLINT, p_ort CHAR(50)) RETURNS CHAR(50)
BEGIN
   RETURN  CONCAT(p_input_plz, ' ', p_ort);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZ_ort(8854, 'Siebnen') AS PLZ_Ort;     -- --> 8854 Siebnen
-- SELECT formatPLZ_ort(10115, 'Berlin') AS PLZ_Ort;     -- --> 10115 Berlin
--  -------------------------------------------------------------
--  Fct 10.4) Gibt p_str zurueck mit erstem Buchstaben als Grossbuchstabe
DROP FUNCTION IF EXISTS firstUpper;
DELIMITER //
CREATE FUNCTION firstUpper(p_str VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
   RETURN  CONCAT(UPPER(LEFT(p_str, 1)), LOWER(RIGHT(p_str,CHAR_LENGTH(p_str)-1)));
END//
DELIMITER ;

-- Test-Cases
-- SHOW CHARACTER SET;
-- SELECT firstUpper("herr");    -- --> Herr
-- SELECT firstUpper("HERR");    -- --> Herr
-- SELECT firstUpper("Herr");    -- --> Herr
-- SELECT firstUpper("hERR");    -- --> Herr
-- SELECT firstUpper("züger");   -- --> Zzaüger
-- SELECT firstUpper("zueger");  -- --> Zzaüger


-- --------------------------------------------------------------------------------
--  Fct 10.5) Gibt ersten Buchstaben von p_name als Grossbuchstabe zurueck gefolgt von p_tail
DROP FUNCTION IF EXISTS getInitial;
DELIMITER //
CREATE FUNCTION getInitial(p_name CHAR(100), p_tail CHAR(5)) RETURNS CHAR(10)
BEGIN
   RETURN  CONCAT(UPPER(LEFT(p_name, 1)), p_tail);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getInitial("Walter",".");  -- --> W.
-- SELECT getInitial("walti", ".");  -- --> W.
-- SELECT getInitial("Max", ",");    -- --> M,
-- SELECT getInitial("max", ",");    -- --> M,

-- --------------------------------------------------------------------------------
--  Fct 10.6) Gibt p_firstname gefolgt von, falls existiert, einem Space und ersten 
--            Buchstaben von p_firstname2 als Grossbuchstabe zurueck 
DROP FUNCTION IF EXISTS getName_With_Initial;
DELIMITER //
CREATE FUNCTION getName_With_Initial(p_firstname CHAR(100), p_firstname2 CHAR(100)) RETURNS CHAR(45)
BEGIN
   IF (p_firstname2 = '' OR p_firstname2 is NULL) THEN
	   RETURN  firstUpper(p_firstname);
   ELSE
       RETURN  CONCAT(firstUpper(p_firstname), ' ', getInitial(p_firstname2, '.'));
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getName_With_Initial('Walter', 'Max');  -- --> Walter M.
-- SELECT getName_With_Initial('Walti', '');      -- --> Walti
-- SELECT getName_With_Initial('Walti', NULL);    -- --> Walti

-- --------------------------------------------------------------------------------
--  Fct 10.7) Gibt Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getAnrede;
DELIMITER //
CREATE FUNCTION getAnrede(p_sex CHAR(20), p_firstname CHAR(45), p_vorname_short BOOLEAN, p_lastname CHAR(100) ) RETURNS CHAR(150)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  '';
   ELSE
		IF (p_vorname_short) THEN
			RETURN  CONCAT(p_sex, ' ', LEFT(p_firstname, 1), '.', p_lastname);
		ELSE
            RETURN  CONCAT(p_sex, ' ', p_firstname, ' ', p_lastname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getAnrede("Herr", "Walter", TRUE, "Rothlin");         -- --> Herr W.Rothlin
-- SELECT getAnrede("Frau", "Claudia", TRUE, "Collet Rothlin"); -- --> Frau C.Collet Rothlin

-- --------------------------------------------------------------------------------
--  Fct 10.8) Gibt Brief-Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getBrief_Anrede;
DELIMITER //
CREATE FUNCTION getBrief_Anrede(p_sex CHAR(20), p_lastname CHAR(100) ) RETURNS CHAR(100)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  'Sehr geehrte Damen, Sehr geehrte Herren,';
   ELSE
		IF (p_sex = 'Herr') THEN 
			RETURN  CONCAT('Sehr geehrter ',firstUpper(p_sex), ' ', p_lastname);
		ELSE
            RETURN  CONCAT('Sehr geehrte ',firstUpper(p_sex), ' ', p_lastname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getBrief_Anrede("Herr", "Walter", "Rothlin"); -- --> Sehr geehrter Herr Rothlin
-- SELECT getBrief_Anrede("Frau", "Claudia", "Collet"); -- --> Sehr geehrte Frau Collet

-- --------------------------------------------------------------------------------
--  Fct 10.9) Gibt perDu Brief-Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getBrief_Anrede_PerDu;
DELIMITER //
CREATE FUNCTION getBrief_Anrede_PerDu(p_sex CHAR(20), p_firstname CHAR(100) ) RETURNS CHAR(100)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  '';
   ELSE
		IF (p_sex = 'Herr') THEN 
			RETURN  CONCAT('Lieber ', p_firstname);
		ELSE
            RETURN  CONCAT('Liebe ', p_firstname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getBrief_Anrede("Herr", "Walter", "Rothlin"); -- --> Sehr geehrter Herr Rothlin
-- SELECT getBrief_Anrede("Frau", "Claudia", "Collet"); -- --> Sehr geehrte Frau Collet
 
--  ------------------------------------------------------------- 
--  Fct 10.10) Gibt Familienname zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getFamilieName;
DELIMITER //
CREATE FUNCTION getFamilieName(p_sex CHAR(5) , p_name_angenommen BOOLEAN , p_ledig_name CHAR(45) , p_partner_name CHAR(45)) RETURNS CHAR(100)
BEGIN
	IF (p_sex = 'Herr' or p_sex = 'Frau') THEN
		IF (p_partner_name = '') THEN
			RETURN  p_ledig_name;
		ELSE
            IF (p_sex = 'Herr') THEN
				IF (p_name_angenommen = True) THEN
					RETURN CONCAT(p_partner_name,' ', p_ledig_name);
				ELSE
					RETURN CONCAT(p_ledig_name,'-', p_partner_name);
                END IF;
			ELSE
                IF (p_name_angenommen = True) THEN
					RETURN CONCAT(p_partner_name,'-', p_ledig_name);
				ELSE
					RETURN CONCAT(p_ledig_name,' ', p_partner_name);
                END IF;
            END IF;
        END IF;
	ELSE 
		RETURN  CONCAT(p_ledig_name, ' ', p_partner_name);
    END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getFamilieName('Herr', FALSE, 'Rothlin', '');        -- --> Rothlin
-- SELECT getFamilieName('Frau', FALSE, 'Collet', '');         -- --> Collet
-- SELECT getFamilieName('Herr', TRUE,  'Rothlin', '');        -- --> Rothlin
-- SELECT getFamilieName('Frau', TRUE,  'Collet', '');         -- --> Collet

-- SELECT getFamilieName('Herr', FALSE, 'Rothlin', 'Collet');  -- --> Rothlin-Collet
-- SELECT getFamilieName('Frau', FALSE, 'Collet', 'Rothlin');  -- --> Collet Rothlin
-- SELECT getFamilieName('Herr', TRUE,  'Rothlin', 'Collet');  -- --> Collet Rothlin
-- SELECT getFamilieName('Frau', TRUE,  'Collet', 'Rothlin');  -- --> Rothlin-Collet

--  ------------------------------------------------------------- 
--  Fct 10.11) Gibt LastName zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getLastName;
DELIMITER //
CREATE FUNCTION getLastName(p_sex CHAR(5) , p_name_angenommen BOOLEAN , p_ledig_name CHAR(45) , p_partner_name CHAR(45)) RETURNS CHAR(50)
BEGIN
	IF (p_sex = 'Herr' or p_sex = 'Frau') THEN
		IF (p_partner_name = '' OR p_partner_name is NULL) THEN
			RETURN  firstUpper(p_ledig_name);
		ELSE
            IF (p_sex = 'Herr') THEN
				IF (p_name_angenommen = True) THEN
					RETURN p_partner_name;
				ELSE
					RETURN p_ledig_name;
                END IF;
			ELSE
                IF (p_name_angenommen = True) THEN
					RETURN p_partner_name;
				ELSE
					RETURN p_ledig_name;
                END IF;
            END IF;
        END IF;
	ELSE 
		RETURN  CONCAT(p_ledig_name, ' ', p_partner_name);
    END IF;
END//
DELIMITER ;

-- Test-Cases

-- --------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS calc_yearly_pachtfee;
DELIMITER //
CREATE FUNCTION calc_yearly_pachtfee(flaeche_in_aren FLOAT, preis_pro_are FLOAT) RETURNS FLOAT
BEGIN
   RETURN  flaeche_in_aren * preis_pro_are;
END//
DELIMITER ;

-- Test-Cases

-- --------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS getPrio_1_TelNr;
DELIMITER //
CREATE FUNCTION getPrio_1_TelNr(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT nummer FROM Telnr_Liste_Prio_0 WHERE Pers_ID = p_id AND prio=1 LIMIT 1);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getPrio_1_TelNr(4);  -- --> 0793315587

-- --------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS getPrio_0_TelNr;
DELIMITER //
CREATE FUNCTION getPrio_0_TelNr(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT nummer FROM Telnr_Liste_Prio_0 WHERE Pers_ID = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getPrio_0_TelNr(4);  -- --> 0793315587

-- --------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS getPrio_0_EMail;
DELIMITER //
CREATE FUNCTION getPrio_0_EMail(p_id INT) RETURNS CHAR(100)
BEGIN
    -- RETURN (SELECT eMail FROM email_adressen WHERE id = p_id AND prio=0 LIMIT 1);
    RETURN (SELECT eMail_Adresse FROM email_liste_prio_0 WHERE Pers_id = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getPrio_0_EMail(4);  -- --> abajschne@gmx.ch

-- --------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS getPrio_0_IBAN;
DELIMITER //
CREATE FUNCTION getPrio_0_IBAN(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT IBAN_Nummer FROM iban_liste_prio_0 WHERE Pers_id = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getPrio_0_IBAN(16);  -- --> abajschne@gmx.ch

-- --------------------------------------------------------------------------------
--  Fct 10.12) Gibt Strasse mit Nr resp Postfach zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getStrassenAdresse;
DELIMITER //
CREATE FUNCTION getStrassenAdresse(p_strasse VARCHAR(45), p_hausnummer VARCHAR(15), p_postfach VARCHAR(5)) RETURNS CHAR(100)
BEGIN
    IF (p_postfach = "") THEN
		RETURN CONCAT(p_strasse, ' ', p_hausnummer);
	ELSE
    	RETURN CONCAT(p_strasse, ' ', p_hausnummer, ' / Postfach:', p_postfach);
    END IF;
    
    IF (strasse = '') THEN
         IF (postfach = '' OR postfach = NULL) THEN
			RETURN '';
		 ELSE
            RETURN CONCAT('Postfach ', postfach);
         END IF;
    ELSE
       IF (hausnummer = '') THEN
          IF (postfach = '') THEN
               RETURN CONCAT('', strasse);
		  ELSE
               RETURN CONCAT(strasse, ' / Postfach:', postfach);
		  END IF;
	   ELSE
		  IF (postfach = '') THEN
		       RETURN CONCAT(strasse, ' ', hausnummer);
		  ELSE
               RETURN CONCAT(strasse, ' ', hausnummer, ' / Postfach:', postfach);
		  END IF;
       END IF;
    END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getStrassenAdresse('Peterliwiese', '33a', '');  -- --> Peterliwiese 33
-- SELECT getStrassenAdresse('Peterliwiese', '33a', '243' );  -- --> Peterliwiese 33 / Postfach:243

-- ===============================================================================================
-- == Create Views                                                                              ==
-- ===============================================================================================

DROP VIEW IF EXISTS Personen_Daten_Row_Counts; 
CREATE VIEW Personen_Daten_Row_Counts AS
	SELECT 
		(select COUNT(*) FROM land) rc_land,
		(select COUNT(*) FROM orte) rc_orte,
		(select COUNT(*) FROM adressen) rc_adressen,
		(select COUNT(*) FROM personen) rc_personen,
		(select COUNT(*) FROM iban) rc_iban,
		(select COUNT(*) FROM email_adressen) rc_email_adressen,
		(select COUNT(*) FROM personen_has_email_adressen) rc_personen_has_email_adressen,
		(select COUNT(*) FROM telefonnummern) rc_telefonnummern,
		(select COUNT(*) FROM personen_has_telefonnummern) rc_personen_has_telefonnummern;
    
    
DROP VIEW IF EXISTS Länder; 
CREATE VIEW Länder AS
	SELECT
        l.ID                                     AS ID,
		l.Name                                   AS Land,
        l.Code                                   AS Code,
		l.Landesvorwahl                          AS Landesvorwahl,
        l.last_update                            AS last_update
	FROM Land AS l;

-- SELECT * FROM Länder;

-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS Ort_Land; 
CREATE VIEW Ort_Land AS
	SELECT
        o.ID                                     AS ID,
		o.PLZ                                    AS PLZ,
        formatPLZinternational(l.Code, o.PLZ)    AS PLZ_International,
		l.Code                                   AS Code,
		o.Name                                   AS Ort,
        l.ID                                     AS Land_ID,
		l.Name                                   AS Land,
		l.Landesvorwahl                          AS Landesvorwahl,
        getYounger(l.last_update, o.last_update) AS last_update,
        o.last_update                            AS o_last_update,
        l.last_update                            AS l_last_update
	FROM orte AS o
	LEFT OUTER JOIN Land AS l ON o.Land_ID = l.ID;

-- SELECT * FROM Ort_Land;
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS Adress_Daten; 
CREATE VIEW Adress_Daten AS
	SELECT
		a.ID                                      AS ID,
		a.Strasse                                 AS Strasse,
		a.Hausnummer                              AS Hausnummer,
        a.postfachnummer                          AS Postfachnummer,
        ol.ID                                     AS Ort_ID,
		ol.PLZ	                                  AS PLZ,
        ol.Code                                   AS Land_Code,
        ol.PLZ_International	                  AS PLZ_International,
		ol.Ort	                                  AS Ort,
        ol.Land_ID                                AS Land_ID,
		ol.Land	                                  AS Land,
		getYounger(a.last_update, ol.last_update) AS last_update,
        a.last_update                             AS a_last_update,
        ol.last_update                            AS o_last_update
	FROM Adressen AS a
	LEFT OUTER JOIN ORT_LAND AS ol ON ol.ID = a.Orte_ID;

-- SELECT * FROM Adress_Daten;

-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS Telnr_Liste; 
CREATE VIEW Telnr_Liste AS
	SELECT
        pers.ID                                     AS Pers_ID,
        pers.Sex                                    AS Sex,
        pers.Partner_Name_Angenommen                AS Name_Angenommen_P,
        pers.Ledig_Name                             AS Ledig_Name_P, 
		pers.Partner_Name                           AS Partner_Name_P,
		getFamilieName(pers.Sex, 
                  pers.Partner_Name_Angenommen, 
                  pers.Ledig_Name, 
                  pers.Partner_Name)                AS Familien_Name,          -- Rothlin-Collet
		getName_With_Initial(pers.Vorname, 
                             pers.Vorname_2)        AS Vorname_Initial,
		tel.ID                                      AS Tel_ID,
        tel.laendercode                             AS Laendercode,
        tel.vorwahl									AS Vorwahl,
        tel.Nummer                                  AS Nummer,
        tel.Type                                    AS Type,
        tel.endgeraet                               AS Endgeraet,
        tel.prio                                    AS Prio,
        getYounger(pt.last_update, tel.last_update) AS last_update
	FROM personen_has_telefonnummern AS pt
	LEFT OUTER JOIN Telefonnummern AS tel  ON pt.telefonnummern_ID = tel.ID
    LEFT OUTER JOIN Personen       AS pers ON pt.personen_ID       = pers.ID
    WHERE pers.Todestag IS NULL;

-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS EMail_Liste; 
CREATE VIEW EMail_Liste AS
	SELECT
		pers.ID                                     AS Pers_ID,
		pers.Sex                                    AS Sex,
		pers.Partner_Name_Angenommen                AS Name_Angenommen_P,
		pers.Ledig_Name                             AS Ledig_Name_P, 
		pers.Partner_Name                           AS Partner_Name_P,
		getFamilieName(pers.Sex, 
				  pers.Partner_Name_Angenommen, 
				  pers.Ledig_Name, 
				  pers.Partner_Name)                AS Familien_Name,          -- Rothlin-Collet
		getName_With_Initial(pers.Vorname, 
							 pers.Vorname_2)        AS Vorname_Initial,
		email.ID                                    AS Email_ID,
		email.eMail                                 AS eMail_adresse,
		email.Type                                  AS Type,
		email.prio                                  AS Prio,
		getYounger(pt.last_update, email.last_update) AS last_update
	FROM personen_has_email_adressen AS pt
	LEFT OUTER JOIN email_adressen AS email  ON pt.EMail_Adressen_ID   = email.ID
	LEFT OUTER JOIN Personen       AS pers   ON pt.personen_ID         = pers.ID
	WHERE pers.Todestag IS NULL;
    
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS IBAN_Liste; 
CREATE VIEW IBAN_Liste AS
	SELECT
		pers.ID                                      AS Pers_ID,
		pers.Sex                                     AS Sex,
		pers.Partner_Name_Angenommen                 AS Name_Angenommen_P,
		pers.Ledig_Name                              AS Ledig_Name_P, 
		pers.Partner_Name                            AS Partner_Name_P,
		getFamilieName(pers.Sex, 
				  pers.Partner_Name_Angenommen, 
				  pers.Ledig_Name, 
				  pers.Partner_Name)                 AS Familien_Name,          -- Rothlin-Collet
		getName_With_Initial(pers.Vorname, 
							 pers.Vorname_2)         AS Vorname_Initial,
		iban.ID                                      AS IBAN_ID,
		iban.Nummer                                  AS IBAN_Nummer,
		iban.Bezeichnung                             AS Bezeichnung,
		iban.Bankname                                AS Bankname,
		iban.Bankort                                 AS Bankort,
		iban.prio                                    AS Prio,
		getYounger(pers.last_update, iban.last_update) AS last_update
	FROM IBAN AS iban
	LEFT OUTER JOIN Personen AS pers   ON iban.personen_ID  = pers.ID
	WHERE pers.Todestag IS NULL;
    
-- --------------------------------------------------------------------------------    
DROP VIEW IF EXISTS Personen_Daten; 
CREATE VIEW Personen_Daten AS
	SELECT
		  P.ID                                         AS ID,
          P.Zivilstand                                 AS Zivilstand,
          P.Kategorien                                 AS Kategorien,
		  -- FIND_IN_SET('Bürger', `Kategorien`) AS Is_Bürger,
			CASE 
			  WHEN FIND_IN_SET('Bürger', P.Kategorien) > 0   THEN 'Ja'
			  WHEN FIND_IN_SET('Bürger', P.Kategorien ) = 0   THEN ''
			  -- ELSE Kategorien
			END AS Ist_Bürger,
			CASE 
			  WHEN FIND_IN_SET('Pächter', P.Kategorien) >  0   THEN 'Ja'
			  WHEN FIND_IN_SET('Pächter', P.Kategorien) =  0   THEN ''
			  -- ELSE Kategorien
			END AS Ist_Pächter,
			CASE 
			  WHEN FIND_IN_SET('Landwirt', P.Kategorien) >  0  THEN 'Ja'
			  WHEN FIND_IN_SET('Landwirt', P.Kategorien) =  0   THEN ''
			  -- ELSE Kategorien
			END AS Ist_Direktzahlungsberechtigt,
          -- IF(P.Geburtstag is NULL, "NoGeburi", "GeburiFound") AS NoYesGeburi,
          -- IF(P.Geburtstag is NULL, "NoGeburi", DATE_FORMAT(P.Geburtstag,'%Y%m%d')) AS NoWithGeburi,
          CONCAT(P.Vorname,';',
                 P.Ledig_Name,';',
                 P.Partner_Name,';',
                 getStrassenAdresse(pAdr.Strasse, 
                             pAdr.Hausnummer, 
							 pAdr.Postfachnummer),';',
                 pAdr.Ort,';',
                 -- IF(P.Geburtstag is NULL, "NoGeburi", DATE_FORMAT(P.Geburtstag,'%Y%m%d')),';',
                 IF(P.Betriebs_Nr is NULL, "NoBetriebsNr", P.Betriebs_Nr),';',
                 IF(P.Geburtstag is NULL, "NoGeburi", DATE_FORMAT(P.Geburtstag,'%Y%m%d')))   AS Such_Begriff,     -- YYYYMMDD
		  P.History                                    AS History,
          P.Bemerkungen                                AS Bemerkungen,
		  P.Sex                                        AS Geschlecht,       -- Herr | Frau
		  P.Firma                                      AS Firma,
		  P.Vorname                                    AS Vorname,
          P.Vorname_2                                  AS Vorname_2,
		  P.Ledig_Name                                 AS Ledig_Name,
          P.Partner_Name                               AS Partner_Name,
		  P.Partner_Name_Angenommen                    AS Partner_Name_Angenommen,
          P.Partner_ID                                 AS Partner_ID,
          P.Mutter_ID                                  AS Mutter_ID,
          P.Vater_ID                                   AS Vater_ID,
		  getLastName(P.Sex, 
                      P.Partner_Name_Angenommen, 
                      P.Ledig_Name, 
                      P.Partner_Name)                  AS LastName,         -- Rothlin
		  getName_With_Initial(P.Vorname, 
                               P.Vorname_2)            AS Vorname_Initial,  -- Walter M.
          getFamilieName(P.Sex, 
                      P.Partner_Name_Angenommen, 
                      P.Ledig_Name, 
                      P.Partner_Name)                 AS Familien_Name,     -- Rothlin-Collet
          
          getAnrede(P.Sex, 
					P.Vorname,
                    TRUE,
                    getLastName(P.Sex, 
                                P.Partner_Name_Angenommen, 
                                P.Ledig_Name, 
                                P.Partner_Name))       AS Anrede_Short_Short,		 -- Herr W.Rothlin
		  getAnrede(P.Sex, 
					P.Vorname,
                    FALSE,
				    getLastName(P.Sex, 
                                P.Partner_Name_Angenommen, 
                                P.Ledig_Name, 
                                P.Partner_Name))       AS Anrede_Long_Short,		 -- Herr Walter Rothlin
		  getAnrede(P.Sex, 
                    P.Vorname,
                    TRUE,
                    getFamilieName(P.Sex, 
                                   P.Partner_Name_Angenommen, 
                                   P.Ledig_Name, 
                                   P.Partner_Name))    AS Anrede_Short_Long,		-- Herr W.Rothlin-Collet
		  getAnrede(P.Sex, 
                    P.Vorname,
                    FALSE,
                    getFamilieName(P.Sex, 
                                   P.Partner_Name_Angenommen, 
                                   P.Ledig_Name, 
                                   P.Partner_Name))    AS Anrede_Long_Long,		  -- Herr Walter Rothlin-Collet
          
          
          getBrief_Anrede(P.Sex,
						  getLastName(P.Sex, 
									  P.Partner_Name_Angenommen, 
                                      P.Ledig_Name, 
                                      P.Partner_Name))       AS Brief_Anrede,           -- Sehr geehrter Herr Rothlin | Sehr geehrte Frau Collet | Sehr geehrte Damen, Sehr geehrte Herren
		  getBrief_Anrede(P.Sex,
		                  getFamilieName(P.Sex, 
                                         P.Partner_Name_Angenommen, 
                                         P.Ledig_Name, 
                                         P.Partner_Name))    AS Brief_Anrede_Long,     -- Sehr geehrter Herr Rothlin-Collet | Sehr geehrte Frau Collet Rothlin | Sehr geehrte Damen, Sehr geehrte Herren    
          
          getBrief_Anrede_PerDu(P.Sex,
		                        P.Vorname)                   AS Brief_Anrede_PerDu,     -- Lieber Walter | Liebe Claudia 
                                         
                                         
          P.AHV_Nr                                     AS AHV_Nr,
		  P.Betriebs_Nr                                AS Betriebs_Nr,

          getPrio_0_IBAN(P.ID)                         AS IBAN,
          getPrio_0_EMail(P.ID)                        AS eMail,
          getPrio_0_TelNr(P.ID)                        AS Tel_Nr,
          DATE_FORMAT(P.Geburtstag,'%d.%m.%Y')                                 AS Geburtstag,
		  DATE_FORMAT(P.Todestag ,'%d.%m.%Y')                                  AS Todestag,
          getAge(P.Geburtstag, P.Todestag)                                     AS Age,
          DATE_FORMAT(P.Nach_Wangen_Gezogen,'%d.%m.%Y')                        AS Nach_Wangen_Gezogen,
          DATE_FORMAT(P.Von_Wangen_Weggezogen,'%d.%m.%Y')                      AS Von_Wangen_Weggezogen,
          DATE_FORMAT(P.Baulandgesuch_Eingereicht_Am,'%d.%m.%Y')               AS Baulandgesuch_Eingereicht_Am,
          DATE_FORMAT(P.Bauland_Gekauft_Am,'%d.%m.%Y')                         AS Bauland_Gekauft_Am,
          DATE_FORMAT(P.Angemeldet_Am,'%d.%m.%Y')                              AS Angemeldet_Am,
          DATE_FORMAT(P.Aufgenommen_Am,'%d.%m.%Y')                             AS Aufgenommen_Am,
          DATE_FORMAT(P.Funktion_Uebernommen_Am,'%d.%m.%Y')                    AS Funktion_Uebernommen_Am,
          DATE_FORMAT(P.Funktion_Abgegeben_Am,'%d.%m.%Y')                      AS Funktion_Abgegeben_Am,
          DATE_FORMAT(P.Chronik_Bezogen_Am,'%d.%m.%Y')                         AS Chronik_Bezogen_Am,
          pAdr.ID                                      AS Private_Adressen_ID,
		  pAdr.Strasse                                 AS Private_Strasse,
		  pAdr.Hausnummer                              AS Private_Hausnummer,
          pAdr.Postfachnummer                          AS Private_Postfachnummer,
          getStrassenAdresse(pAdr.Strasse, 
                             pAdr.Hausnummer, 
							 pAdr.Postfachnummer)      AS Private_Strassen_Adresse,
		  pAdr.Ort_ID                                  AS Private_Ort_ID,
		  pAdr.PLZ                                     AS Private_PLZ,
          pAdr.Land_Code                               AS Private_Land_Code,
          pAdr.PLZ_International                       AS Private_PLZ_International,
		  pAdr.Ort                                     AS Private_Ort,
          formatPLZ_ort(pAdr.PLZ, 
                        pAdr.Ort)                      AS Private_PLZ_Ort,
          pAdr.Land_ID                                 AS Private_Land_ID,
		  pAdr.Land                                    AS Private_Land,
          
          gAdr.ID                                      AS Geschaeft_Adressen_ID,
		  gAdr.Strasse                                 AS Geschaeft_Strasse,
		  gAdr.Hausnummer                              AS Geschaeft_Hausnummer,
          gAdr.Postfachnummer                          AS Geschaeft_Postfachnummer,
          getStrassenAdresse(gAdr.Strasse, 
                             gAdr.Hausnummer, 
                             gAdr.Postfachnummer)      AS Geschaeft_Strassen_Adresse,
		  gAdr.Ort_ID                                  AS Geschaeft_Ort_ID,
		  gAdr.PLZ                                     AS Geschaeft_PLZ,
          gAdr.Land_Code                               AS Geschaeft_Land_Code,
          gAdr.PLZ_International                       AS Geschaeft_PLZ_International,    -- CH-8855
		  gAdr.Ort                                     AS Geschaeft_Ort,
		  formatPLZ_ort(gAdr.PLZ, 
                        gAdr.Ort)                      AS Geschaeft_PLZ_Ort,
		  gAdr.Land_ID                                 AS Geschaeft_Land_ID,
		  gAdr.Land                                    AS Geschaeft_Land,
          getYounger(P.last_update, pAdr.last_update)  AS last_update
	FROM Personen AS P
    LEFT OUTER JOIN Adress_Daten AS pAdr ON  P.Privat_Adressen_ID         = pAdr.ID
	LEFT OUTER JOIN Adress_Daten AS gAdr ON  P.Geschaefts_Adressen_ID     = gAdr.ID
    ORDER BY Familien_Name, Vorname_Initial;

-- SELECT * FROM Personen_Daten;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Personen_Daten_Lebend; 
CREATE VIEW Personen_Daten_Lebend AS
    SELECT
	*
    FROM Personen_Daten
    WHERE Todestag IS NULL
    ORDER BY Geschlecht, Familien_Name, Vorname;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Bürger_Lebend; 
CREATE VIEW Bürger_Lebend AS
    SELECT
		ID,
		Zivilstand,
        Geschlecht,
		-- Anrede_Long_Long          AS Anrede,
        Vorname_Initial           AS Vorname,
        Familien_Name             AS Name,
		Private_Strassen_Adresse  AS Strasse,
        Private_PLZ_Ort           AS PLZ_Ort,
        Geburtstag,
        Age,
        eMail,
        Tel_Nr,
        IBAN,
		History,
		Bemerkungen
    FROM Personen_Daten_Lebend
    WHERE Todestag IS NULL AND FIND_IN_SET('Bürger', Kategorien) >  0
    ORDER BY Familien_Name, Vorname;
-- -----------------------------------------------------    
DROP VIEW IF EXISTS Personen_Daten_Gestorben; 
CREATE VIEW Personen_Daten_Gestorben AS
    SELECT 
		ID,
        Vorname_Initial                                        AS Vorname,
        Familien_Name                                          AS Familienname,
        CONCAT(Private_Strassen_Adresse,' ; ',Private_PLZ_ORT) AS `Letzte Adresse`,
        Geburtstag,
        Todestag,
        Age
    FROM Personen_Daten 
    WHERE Todestag IS NOT NULL
    ORDER BY STR_TO_DATE(Todestag,'%d.%m.%Y');

-- -----------------------------------------------------
DROP VIEW IF EXISTS Bewirtschafter; 
CREATE VIEW Bewirtschafter AS
	SELECT
		ID,
		Kategorien,
		Ist_Bürger,
		Ist_Pächter,
		Ist_Direktzahlungsberechtigt,
		Betriebs_Nr,
        Age,
		Geburtstag,
		Geschlecht,
		Vorname_Initial          AS Vorname,
		Familien_Name            AS `Name`,
		Private_Strassen_Adresse AS Strasse,
		Private_PLZ_Ort          AS Ort,
		eMail,
		Tel_Nr,
		IBAN,
        Bemerkungen
	FROM Personen_Daten_Lebend
	WHERE Ist_Pächter = 'Ja' OR
		  Ist_Direktzahlungsberechtigt = 'Ja' OR
          Betriebs_Nr IS NOT NULL
	ORDER BY `Name`, `Vorname`;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Pächter; 
CREATE VIEW Pächter AS
	SELECT
		ID,
		Ist_Bürger,
		Ist_Direktzahlungsberechtigt,
        Geschlecht   AS Sex,
        Vorname,
		`Name`       AS Familien_Name,
		Strasse      AS Adresse,
		Ort,
        Geburtstag,
        Tel_Nr,
        eMail,
		Betriebs_Nr,
        Age,
        Bemerkungen
	FROM Bewirtschafter
	WHERE Ist_Pächter = 'Ja'
	ORDER BY ID;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Telnr_Liste_Sorted; 
CREATE VIEW Telnr_Liste_Sorted AS
	SELECT         
         T.Pers_ID           AS Pers_ID,
         T.Sex               AS Sex,
		 T.Familien_Name      AS Familien_Name,          -- Rothlin-Collet
		 T.Vorname_Initial   AS Vorname_Initial,
         P.Private_Strassen_Adresse   AS Strasse,
         P.Private_PLZ_International  AS PLZ,
         P.Private_Ort                AS Ort,
		 T.Tel_ID                     AS Tel_ID,
         T.Laendercode                AS Laendercode,
         T.Vorwahl                    AS Vorwahl,
         T.Nummer                     AS Nummer,
         T.Type                       AS Type,
         T.Endgeraet                  AS Endgeraet,
         T.Prio                       AS Prio,
         T.last_update                AS last_update
	FROM Telnr_Liste AS T
    LEFT OUTER JOIN Personen_Daten AS P ON  P.ID  = T.Pers_ID
    ORDER BY Familien_Name;

-- -----------------------------------------------------
DROP VIEW IF EXISTS EMail_Liste_Sorted; 
CREATE VIEW EMail_Liste_Sorted AS
	SELECT         
         E.Pers_ID           AS Pers_ID,
         E.Sex               AS Sex,
		 E.Familien_Name      AS Familien_Name,          -- Rothlin-Collet
		 E.Vorname_Initial   AS Vorname_Initial,
         P.Private_Strassen_Adresse   AS Strasse,
         P.Private_PLZ_International  AS PLZ,
         P.Private_Ort                AS Ort,
		 E.Email_ID                   AS Email_ID,
         E.eMail_adresse              AS Email_Adresse,
         E.Type                       AS Type,
         E.Prio                       AS Prio,
         E.last_update                AS last_update
	FROM EMail_Liste AS E
    LEFT OUTER JOIN Personen_Daten AS P ON  P.ID  = E.Pers_ID
    ORDER BY Familien_Name;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS IBAN_Liste_Sorted;
CREATE VIEW IBAN_Liste_Sorted AS
	SELECT         
         ib.Pers_ID            AS Pers_ID,
         ib.Sex                AS Sex,
		 ib.Familien_Name      AS Familien_Name,          -- Rothlin-Collet
		 ib.Vorname_Initial    AS Vorname_Initial,
         P.Private_Strassen_Adresse    AS Strasse,
         P.Private_PLZ_International   AS PLZ,
         P.Private_Ort                 AS Ort,
		 ib.IBAN_ID                    AS Email_ID,
         ib.IBAN_Nummer                AS IBAN_Nummer,
         ib.Bezeichnung                AS Bezeichnung,
		 ib.Bankname                   AS Bankname,
		 ib.Bankort                    AS Bankort,
         ib.Prio                       AS Prio,
         ib.last_update                AS last_update
	FROM IBAN_Liste AS ib
    LEFT OUTER JOIN Personen_Daten AS P ON  P.ID  = ib.Pers_ID
    ORDER BY Familien_Name;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Telnr_Liste_Prio_0; 
CREATE VIEW Telnr_Liste_Prio_0 AS
	SELECT * FROM Telnr_Liste_Sorted WHERE Prio=0;

-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS EMail_Liste_Prio_0; 
CREATE VIEW EMail_Liste_Prio_0 AS
	SELECT * FROM  EMail_Liste_Sorted WHERE Prio = 0;
       
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS IBAN_Liste_Prio_0; 
CREATE VIEW IBAN_Liste_Prio_0 AS
	SELECT * FROM  IBAN_Liste_Sorted WHERE Prio = 0;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Personen_Daten_Tel_Email; 
CREATE VIEW Personen_Daten_Tel_Email AS
	SELECT
		  ID,
		  Geschlecht,               -- Herr | Frau
		  Firma,
		  Vorname,
          Vorname_2,
          Vorname_Initial,          -- Walter M.
          Ledig_Name,
          Partner_Name,
		  Partner_Name_Angenommen,
		  LastName,                 -- Rothlin
          Familien_Name,            -- Rothlin-Collet
		  Anrede_Short_Short,		-- Herr W.Rothlin
		  Anrede_Long_Short,		-- Herr Walter Rothlin
		  Anrede_Short_Long,		-- Herr W.Rothlin-Collet
		  Anrede_Long_Long,		    -- Herr Walter Rothlin-Collet
          Brief_Anrede,             -- Sehr geehrter Herr Rothlin | Sehr geehrte Frau Collet | Sehr geehrte Damen, Sehr geehrte Herren
		  Brief_Anrede_Long,        -- Sehr geehrter Herr Rothlin-Collet | Sehr geehrte Frau Collet Rothlin | Sehr geehrte Damen, Sehr geehrte Herren    
          Brief_Anrede_PerDu,       -- Lieber Walter | Liebe Claudia 
          AHV_Nr,
		  Betriebs_Nr,
          Zivilstand,
		  Kategorien,
          IBAN,
          eMail,
          Tel_Nr,
          Geburtstag,
          Todestag,
          Nach_Wangen_Gezogen,
          Von_Wangen_Weggezogen,
          Baulandgesuch_Eingereicht_Am,
          Bauland_Gekauft_Am,
          Angemeldet_Am,
          Aufgenommen_Am,
          Funktion_Uebernommen_Am,
          Funktion_Abgegeben_Am,
          Chronik_Bezogen_Am,
		  Private_Strasse,
		  Private_Hausnummer,
          Private_Postfachnummer,
          Private_Strassen_Adresse,
		  Private_PLZ,
          Private_PLZ_International,
		  Private_Ort,
		  Private_Land,
		  Geschaeft_Strasse,
		  Geschaeft_Hausnummer,
          Geschaeft_Postfachnummer,
          Geschaeft_Strassen_Adresse,
		  Geschaeft_PLZ,
          Geschaeft_PLZ_International,    -- CH-8855
		  Geschaeft_Ort,
		  Geschaeft_Land,
          last_update
	FROM Personen_Daten AS P;
    -- ORDER BY LastName, Vorname;

-- SELECT * FROM Personen_Daten;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Pachtlandzuteilung; 
CREATE VIEW Pachtlandzuteilung AS
	SELECT
		  L.ID                                       AS ID,
          L.AV_Parzellen_Nr                          AS AV_Parzelle,
          L.GENO_Parzellen_Nr                        AS GENO_Parzelle,
          L.Flur_Bezeichnung                         AS FLur_Bezeichnung,
          L.Flaeche_In_Aren                          AS Flaeche,
          L.Pachtzins_Pro_Are                        AS Pachtzins_pro_Are,
          calc_yearly_pachtfee(L.Flaeche_In_Aren,
                               L.Pachtzins_Pro_Are)  AS Pachtzins_pro_Jahr,
	      L.Fix_Pachtzins                            AS FixPachtPreis,
          L.Vertragsart                              AS Vertragsart,
          L.Buergerlandteil                          AS Buergerteil,
          L.Polygone_Flaeche                         AS Polygone,
          
          L.Pachtbeginn_Am                           AS Pachtbeginn,
          L.Rueckgabe_Am                             AS Rueckgabe,
          L.Vertragsende_Am                          AS Vertragsende,
          L.Pachtende_Am                             AS Pachtende,
          
          L.Vorheriger_Paechter_ID                   AS Vorheriger_Paechter_ID,
          L.Paechter_ID                              AS Paechter_ID,
          Paechter_Adr.Betriebs_Nr                   AS Pachter_Betriebs_Nr,
          Paechter_Adr.Firma                         AS Pachter_Firma,
          Paechter_Adr.Familien_Name                  AS Paechter_Name,
          Paechter_Adr.Vorname                       AS Paechter_Vorname,
          Paechter_Adr.Private_Strasse               AS Paechter_Strasse,
          Paechter_Adr.Private_Hausnummer            AS Paechter_Hausnummer,
          Paechter_Adr.Private_PLZ                   AS Paechter_PLZ,
          Paechter_Adr.Private_Ort                   AS Paechter_Ort,

          L.Vorheriger_Verpaechter_ID                AS Vorheriger_Verpaechter_ID,
          L.Verpaechter_ID                           AS Verpaechter_ID,
		  Verpaechter_Adr.Firma                      AS Verpaechter_Firma,
          Verpaechter_Adr.Familien_Name              AS Verpaechter_Name,
          Verpaechter_Adr.Vorname                    AS Verpaechter_Vorname,
          Verpaechter_Adr.Private_Strasse            AS Verpaechter_Strasse,
          Verpaechter_Adr.Private_Hausnummer         AS Verpaechter_Hausnummer,
          Verpaechter_Adr.Private_PLZ                AS Verpaechter_PLZ,
          Verpaechter_Adr.Private_Ort                AS Verpaechter_Ort
	FROM Landteil AS L
    LEFT OUTER JOIN Personen_Daten AS Paechter_Adr    ON  L.Paechter_ID     = Paechter_Adr.ID
	LEFT OUTER JOIN Personen_Daten AS Verpaechter_Adr ON  L.Verpaechter_ID  = Verpaechter_Adr.ID;

-- ===============================================================================================
-- == Create stored procedures for business (external) write access                             ==
-- ===============================================================================================
-- ------------------------------------------------------
-- EMail Adressen
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getEmailAdrId;
DELIMITER $$
CREATE PROCEDURE getEmailAdrId(IN email_addr VARCHAR(45), IN email_type ENUM('Privat', 'Geschaeft', 'Sonstige'), IN Prio TINYINT, OUT email_id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM email_adressen WHERE eMail=email_addr AND Type=email_type) = 0) THEN
        INSERT INTO email_adressen (`eMail`,`Type`,`Prio`) VALUES (email_addr, email_type, Prio);
        COMMIT;
    END IF;
    SELECT id FROM email_adressen WHERE eMail=email_addr AND Type=email_type INTO email_id;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call getEmailAdrId('walter@rothlin.com', 'Sonstige', 0,  @id);
-- select @id;

-- set @id = 0;
-- call getTelefonnummerId('0041', '', '0793689492', 'Privat','Mobile',1, @id);
-- select @id;


-- ------------------------------------------------------
-- Telefonnummer
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getTelefonnummerId;
DELIMITER $$
CREATE PROCEDURE getTelefonnummerId(IN Laendercode VARCHAR(4), IN Vorwahl VARCHAR(3), IN Nummer VARCHAR(11), IN TEL_Type ENUM('Privat', 'Geschaeft'), IN Endgeraet ENUM('Festnetz', 'Mobile', 'FAX'), IN Prio TINYINT, OUT tel_id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM Telefonnummern WHERE Telefonnummern.Laendercode=Laendercode AND Telefonnummern.Vorwahl=Vorwahl AND Telefonnummern.Nummer=Nummer) = 0) THEN
        INSERT INTO Telefonnummern (`Laendercode`,`Vorwahl`,`Nummer`,`Type`,`Endgeraet`,`Prio`) VALUES (Laendercode, Vorwahl, Nummer, TEL_Type, Endgeraet, Prio);
        COMMIT;
    END IF;
    SELECT id FROM Telefonnummern WHERE Telefonnummern.Laendercode=Laendercode AND Telefonnummern.Vorwahl=Vorwahl AND Telefonnummern.Nummer=Nummer INTO tel_id;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call getTelefonnummerId('0041', '', '0554601440', 'Privat','Festnetz',0, @id);
-- select @id;

-- set @id = 0;
-- call getTelefonnummerId('0041', '', '0793689492', 'Privat','Mobile',1, @id);
-- select @id;


-- ------------------------------------------------------
-- Land
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getLandId;
DELIMITER $$
CREATE PROCEDURE getLandId(IN landname VARCHAR(45), IN land_code VARCHAR(5), IN landesvorwahl VARCHAR(4), OUT id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM land WHERE land.name = landname) = 0) THEN
        INSERT INTO land (`name`, `code`, `landesvorwahl`) VALUES (landname, land_code, landesvorwahl);
        COMMIT;
    END IF;
    SELECT land.id FROM land WHERE land.name = landname or land.code = land_code or land.landesvorwahl = landesvorwahl INTO id;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call getLandId('Schweiz', 'CH', '0041', @id);
-- select @id;


-- ------------------------------------------------------
-- Ort
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getOrtId;
DELIMITER $$
CREATE PROCEDURE getOrtId(IN plz SMALLINT(4), IN ortsname VARCHAR(45), IN kanton VARCHAR(10), IN tel_vorwahl VARCHAR(3), OUT id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM orte WHERE orte.plz = plz AND orte.name = ortsname) = 0) THEN
        INSERT INTO orte (`plz`, `name`, `kanton`, `tel_vorwahl`) VALUES (plz, ortsname, kanton, tel_vorwahl);
        COMMIT;
    END IF;
    SELECT orte.id FROM orte WHERE orte.plz = plz and orte.name = ortsname INTO id;
END$$
DELIMITER ;

-- Tests
-- bestehendes Ort
-- set @id = 0;
-- call getOrtId(8855, 'Wangen', NULL, NULL, @id);
-- select @id;

-- call getOrtId(8854, 'Siebnen', NULL, NULL, @id);
-- select @id;

-- call getOrtId(8854, 'Galgenen', NULL, NULL, @id);
-- select @id;

-- call getOrtId(8853, 'Lachen', NULL, NULL, @id);
-- select @id;


-- try to reenter duplicate plz, Ort
-- call getOrtId(8854, 'Galgenen', NULL, NULL, @id);
-- select @id;
-- call getOrtId(8853, 'Lachen', NULL, NULL, @id);
-- select @id;

-- deleteOrtIfUnused
DROP PROCEDURE IF EXISTS deleteOrtIfUnused;
DELIMITER $$
CREATE PROCEDURE deleteOrtIfUnused(IN id SMALLINT(5))
BEGIN
    IF ((SELECT COUNT(orte_id) FROM adressen WHERE id=id) = 0) THEN
        DELETE FROM orte WHERE id=id;
        COMMIT;
    END IF;
END$$
DELIMITER ;

-- Tests
-- set @id = 1;
-- call deleteOrtIfUnused(@id);


-- ------------------------------------------------------
-- Adresse
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getAdressId;
DELIMITER $$
CREATE PROCEDURE getAdressId(IN strasse VARCHAR(45), 
							 IN hausnummer VARCHAR(15), 
                             IN plz SMALLINT(4), 
                             IN ortsname VARCHAR(45), 
                             OUT adress_id SMALLINT(5))
BEGIN
    CALL getOrtId(plz, ortsname, NULL, NULL, @ort_id);
    IF ((SELECT count(*) FROM adressen WHERE adressen.strasse    = strasse AND 
											 adressen.hausnummer = hausnummer AND 
                                             adressen.Orte_id    = @ort_id) = 0) THEN
        INSERT adressen (`strasse`, `hausnummer`, `orte_id`) VALUES (strasse, hausnummer, @ort_id);
        COMMIT;
    END IF;
    SELECT id FROM adressen WHERE adressen.strasse = strasse and 
                                  adressen.hausnummer = hausnummer and 
                                  adressen.orte_id = @ort_id INTO adress_id;
END$$
DELIMITER ;

-- Tests von AdressenId
-- bestehende Adresse
-- set @id = 0;
-- call getAdressId('Peterliwiese', '33', '8855', 'Wangen', @id);
-- select @id;

-- createAdresse
DROP PROCEDURE IF EXISTS createAdresse;
DELIMITER $$
CREATE PROCEDURE createAdresse(IN strasse VARCHAR(45), 
                               IN hausnummer VARCHAR(15), 
                               IN plz SMALLINT(4), 
                               IN ortsname VARCHAR(45), 
                               OUT generatedId SMALLINT(5))
BEGIN
    CALL getOrtId(plz, ortsname, @ort_id);
    INSERT INTO adressen (strasse, hausnummer, orte_id) VALUES (strasse, hausnummer, @ort_id);
    COMMIT;
    SELECT LAST_INSERT_ID() INTO generatedId;
END$$
DELIMITER ;

-- set @id = 0;
-- call createAdresse('Im Gräbler', '12', 8310, 'Grafstal', @id);
-- select @id;

-- updateAdresse
DROP PROCEDURE IF EXISTS updateAdresse;
DELIMITER $$
CREATE PROCEDURE updateAdresse(IN id SMALLINT(5), IN strasse VARCHAR(45), IN hausnummer VARCHAR(15), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45))
BEGIN
    CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    UPDATE adressen SET strasse=strasse, hausnummer=hausnummer, orte_id=@ort_id WHERE id=id;
    COMMIT;
END$$
DELIMITER ;

-- Tests
-- set @id = 6;
-- call updateAdresse(@id, 'Schulhausstrasse', '1a', 8400, 'Winterthur');
-- select @id;

-- deleteAdresse
DROP PROCEDURE IF EXISTS deleteAdresse;
DELIMITER $$
CREATE PROCEDURE deleteAdresse(IN id SMALLINT(5))
BEGIN
    DELETE FROM adressen WHERE id=id;
END$$
DELIMITER ;

-- Tests
-- set @id = 6;
-- call deleteAdresse(@id);
-- select @id;

DROP PROCEDURE IF EXISTS deleteAdresseCascade;
-- Diese storeded procedure löscht auch Orte die nicht mehr von Adressen Referenziert werden
-- Kann auch über einen Konstraint ON DELETE CASCADE
DELIMITER $$
CREATE PROCEDURE deleteAdresseCascade(IN id SMALLINT(5))
BEGIN
    SET @ortID = (SELECT orte_fk FROM adressen WHERE id = id);
    DELETE FROM adressen WHERE id=id;
    COMMIT;
    CALL deleteOrtIfUnused(@ortID);
END$$
DELIMITER ;


-- ------------------------------------------------------
-- Personen
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getPersonenId;
DELIMITER $$
CREATE PROCEDURE getPersonenId(IN source ENUM('Initial_1', 'Loader_1', 'BuergerDB', 'ImmoTop'),
							   IN sex VARCHAR(45),
                               IN firma VARCHAR(45),
							   IN vorname VARCHAR(45),
                               IN ledig_name VARCHAR(45),
                               IN partner_name VARCHAR(45),
                               IN partner_name_angenommen BOOLEAN,
							   IN strasse VARCHAR(45), 
							   IN hausnummer VARCHAR(15), 
							   IN plz SMALLINT(4), 
							   IN ortsname VARCHAR(45), 
                               OUT personen_id SMALLINT(5))
BEGIN
    CALL getAdressId(strasse, hausnummer, plz, ortsname, @adressen_id);
    IF ((SELECT count(*) 
         FROM personen 
         WHERE personen.sex = sex AND
               personen.firma = firma AND 
               personen.vorname = vorname AND 
               personen.ledig_name = ledig_name AND 
               personen.partner_name = partner_name AND 
               personen.partner_name_angenommen = partner_name_angenommen AND 
               personen.privat_adressen_id = @adressen_id) = 0) THEN
        INSERT personen (`source`, `sex`, `firma`, `vorname`, `ledig_name`, `partner_name`,`partner_name_angenommen`, `privat_adressen_id`) VALUES (source, sex, firma, vorname, ledig_name, partner_name, partner_name_angenommen, @adressen_id);
        COMMIT;
    END IF;
    SELECT id FROM personen WHERE personen.sex = sex AND
                                  personen.firma = firma AND 
								  personen.vorname = vorname AND 
                                  personen.ledig_name = ledig_name AND
                                  personen.partner_name = partner_name AND
                                  personen.partner_name_angenommen = partner_name_angenommen AND 
                                  personen.privat_adressen_id = @adressen_id INTO personen_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS getPersonenId_New;
DELIMITER $$
CREATE PROCEDURE getPersonenId_New(IN source ENUM('Initial_1', 'Loader_1', 'BuergerDB', 'ImmoTop'),
							       IN personen_id_old SMALLINT(5),
                                   IN sex VARCHAR(45),
                                   IN firma VARCHAR(45),
							       IN vorname VARCHAR(45),
                                   IN ledig_name VARCHAR(45),
                                   IN partner_name VARCHAR(45),
                                   IN partner_name_angenommen BOOLEAN,
							       IN strasse VARCHAR(45), 
							       IN hausnummer VARCHAR(15), 
							       IN plz SMALLINT(4), 
							       IN ortsname VARCHAR(45), 
                                   OUT personen_id SMALLINT(5))
BEGIN
    CALL getAdressId(strasse, hausnummer, plz, ortsname, @adressen_id);
    IF ((SELECT count(*) 
         FROM personen 
         WHERE personen.id = personen_id_old) = 0) THEN
        INSERT personen (`source`, `ID`, `sex`, `firma`, `vorname`, `ledig_name`, `partner_name`,`partner_name_angenommen`, `privat_adressen_id`) VALUES (source, personen_id_old, sex, firma, vorname, ledig_name, partner_name, partner_name_angenommen, @adressen_id);
        COMMIT;
    END IF;
    SELECT id FROM personen WHERE personen.sex = sex AND
                                  personen.firma = firma AND 
								  personen.vorname = vorname AND 
                                  personen.ledig_name = ledig_name AND
                                  personen.partner_name = partner_name AND
                                  personen.partner_name_angenommen = partner_name_angenommen AND 
                                  personen.privat_adressen_id = @adressen_id INTO personen_id;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call getPersonenId_New('BuergerDB', 9999, 'Herr', 'M_Firma', 'M_Vorname','M_LedigName', 'M_PartnerName', 1, 'M_Strasse', '33_M', '8855', 'M_Wangen', @id);
-- select @id;
-- call getPersonenId('Walter','Rothlin',NULL,NULL,'Peterliwiese', '33', '8855', 'Wangen', @id);
-- select @id;

DROP PROCEDURE IF EXISTS createPerson;
DELIMITER $$
CREATE PROCEDURE createPerson(IN vorname VARCHAR(45),
							  IN ledig_name VARCHAR(45),
                              IN partner_name VARCHAR(45),
                              IN firma VARCHAR(45),
							  IN strasse VARCHAR(45), 
							  IN hausnummer VARCHAR(15), 
							  IN plz SMALLINT(4), 
							  IN ortsname VARCHAR(45),
							  OUT generatedId SMALLINT(5))
BEGIN
    CALL getAdressId(strasse, hausnummer, plz, ortsname, @adressen_id);
    INSERT personen (`vorname`, `ledig_name`, `partner_name`, `firma`,  `privat_adressen_id`) VALUES (vorname, ledig_name, partner_name, firma, @adressen_id);
    COMMIT;
    SELECT LAST_INSERT_ID() INTO generatedId;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call createPerson('Walter','Rothlin','BZU','Im Gräbler', '12', 8310, 'Grafstal', @id);
-- select @id;



   
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- ------------------------------------------------------
-- Zwingende Data updates
-- ------------------------------------------------------
UPDATE Personen SET Zivilstand = 'Gestorben' WHERE Todestag is not NULL;



-- ------------------------------------------------------
-- Hilfreiche Abfragen
-- ------------------------------------------------------
-- SELECT ID,Vorname_Initial, Familien_Name, Private_Strassen_Adresse, Kategorien FROM personen_daten Where Such_Begriff LIKE Binary '%Züger%' ORDER BY Vorname_Initial;

 -- SELECT ID,Vorname_Initial, Familien_Name, Private_Strassen_Adresse, Kategorien FROM personen_daten Where ID in (11,23,42) ORDER BY Familien_Name, Vorname_Initial;
 
SELECT * FROM Personen_Daten WHERE ID = 11;

 /*
 SELECT Vorname_Initial,
       getFamilieName(P.Sex, 
                      P.Partner_Name_Angenommen, 
                      P.Ledig_Name, 
                      P.Partner_Name) AS Familien_Name,
       P.Sex, 
       P.Partner_Name_Angenommen, 
	   P.Ledig_Name, 
       P.Partner_Name
FROM personen AS P 
WHERE ID in (11,23,42,889) 
ORDER BY Familien_Name;
*/



SELECT
    ID                                                 AS ID,
    Anrede_Long_Long                                   AS Anrede,
    Private_Strassen_Adresse                           AS Strasse,
    CONCAT(Private_PLZ_International,' ',Private_Ort)  AS PLZ_Ort,
    
    DATE_FORMAT(Geburtstag, '%d.%m.%Y') AS Geburtstag,

    Zivilstand    AS Zivilstand,
    Kategorien    AS Kategorien,
    Such_Begriff  AS Such_Begriff
FROM Personen_Daten 
WHERE 
        ID is NOT NULL
        -- AND ID in (11,23,42,488,487,889)
        -- AND (FIND_IN_SET('Landwirt', `Kategorien`) > 0 OR FIND_IN_SET('Bürger', `Kategorien`) > 0)
        AND (Such_Begriff LIKE BINARY '%Kä' AND Such_Begriff LIKE BINARY '%holz%')
ORDER BY Familien_Name, Vorname;

        SELECT
            ID AS ID,
             Anrede_Long_Long                                   AS Anrede,
             Private_Strassen_Adresse                           AS Strasse,
             CONCAT(Private_PLZ_International,' ',Private_Ort)  AS PLZ_Ort
        FROM Personen_Daten 
        WHERE Such_Begriff LIKE BINARY '%Vogel%' AND 
              Such_Begriff LIKE BINARY '%%' AND 
              Such_Begriff LIKE BINARY '%%'
        ORDER BY Familien_Name, Vorname;
    
