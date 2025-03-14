-- -----------------------------------------
-- Autor: Walter Rothlin
-- Description: Kreiert ein Prüfungs-Schema 
--
-- https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/LN_Scripts/pruefung_1_schema.sql
--
-- History:
-- 13-Mar-2025   Walter Rothlin      Initial Version
-- -----------------------------------------
SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- =========================================
-- == Schema Prüfung_1 kreieren           ==
-- =========================================

DROP SCHEMA IF EXISTS `Pruefung_1`;
CREATE SCHEMA IF NOT EXISTS `Pruefung_1`  DEFAULT CHARACTER SET utf8mb4;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `Pruefung_1`;


-- =========================================
-- == Create Tables                       ==
-- =========================================

-- -----------------------------------------
-- Table `Properties`
-- -----------------------------------------
DROP TABLE IF EXISTS `Properties`;
CREATE TABLE IF NOT EXISTS `Properties` (
  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name`          VARCHAR(25) NOT NULL,
  `Value`         VARCHAR(25) NULL,
  `last_update`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
  
  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------
-- Table `Land`
-- -----------------------------------------
DROP TABLE IF EXISTS `Land`;
CREATE TABLE IF NOT EXISTS `Land` (
  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name`          VARCHAR(45) NOT NULL,
  `Code`          VARCHAR(5) NULL,
  `Landesvorwahl` VARCHAR(4) NULL,
  `last_update`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
  -- PK-Constraints
  PRIMARY KEY (`ID`));
  
-- -----------------------------------------
-- Table `Orte`
-- -----------------------------------------
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`         VARCHAR(10) NOT NULL,
  `Name`        VARCHAR(45) NULL,
  `Kanton`      VARCHAR(10) NULL,
  `Land_ID`     INT UNSIGNED NULL DEFAULT 1,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`  INT UNSIGNED NULL,
  
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


-- -----------------------------------------
-- Table `Adressen`
-- -----------------------------------------
DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `ID`                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Strasse`              VARCHAR(45)   NULL,
  `Hausnummer`           VARCHAR(15)   NULL,
  `Postfachnummer`       VARCHAR(5)    NULL,
  `Adresszusatz`         VARCHAR(20)   NULL,
  `Wohnung`              VARCHAR(10)   NULL,
  `Kataster_Nr`          VARCHAR(10)   NULL,
  `lon`                  VARCHAR(30)   NULL,
  `lat`                  VARCHAR(30)   NULL,
  `Politisch_Wangen`     INT UNSIGNED  NULL DEFAULT 0,
  `Orte_ID`              INT UNSIGNED  NULL,
  `last_update`          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL DEFAULT 533,

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

-- UPDATE `Adressen` SET `changed_by` = NULL;
-- ALTER TABLE `Adressen`  CHANGE COLUMN `changed_by` `changed_by` INT UNSIGNED NULL ;
-- UPDATE `Adressen` SET `changed_by` = 1245;

-- -----------------------------------------
-- Table `Personen` 
-- -----------------------------------------
DROP TABLE IF EXISTS `Personen`;
CREATE TABLE IF NOT EXISTS `Personen` (
  `ID`                       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ImmoTop_ID`               INT UNSIGNED NULL,
  `Source`                   ENUM('Initial_1', 'Loader_1', 'BuergerDB','ImmoTop','Manuel') DEFAULT NULL,
  `History`                  VARCHAR(500) NULL,
  `Bemerkungen`              VARCHAR(500) NULL,

  `Sex`                      VARCHAR(5) NULL,      -- Herr | Frau
  `Firma`                    VARCHAR(45) NULL,
  `Vorname`                  VARCHAR(45) NULL,
  `Vorname_2`                VARCHAR(45) NULL,
  `Ledig_Name`               VARCHAR(45) NULL,
  `Partner_Name`             VARCHAR(45) NULL,
  `Partner_Name_Angenommen`  BOOLEAN DEFAULT FALSE,
  `AHV_Nr`                   VARCHAR(45) NULL,
  `SAK`                      FLOAT NULL DEFAULT NULL,
  `Password`                 VARCHAR(70) NULL,
  `Betriebs_Nr`              VARCHAR(45) NULL,
  `Beruf`                    VARCHAR(45) NULL,

  `Zivilstand`  ENUM('Unbestimmt', 'Leer', 'Ledig','Verheiratet','Getrennt',
                      'Geschieden','Verwitwet','Wiederverheiratet','Gestorben',
                      'Bevormundet','Partnerschaft') 
                      DEFAULT NULL,

  `Kategorien`  SET('Bürger', 'Nutzungsberechtigt',  'Verwaltungsberechtigt', 'Hat_16a', 'Hat_35a',
                    'Firma', 'Auftragnehmer',
                    'Bewirtschafter', 'Pächter', 'Landwirt_EFZ', 'DZ betrechtigt', 
                    'Wohnungsmieter', 'Bootsplatzmieter', 'Wärmebezüger',  
                    'Betriebsgemeinschaft', 'Generationengemeinschaft') 
                    DEFAULT NULL,
  `Portrait_Link`                                VARCHAR(100) NULL,
  `FG_Color`                                     VARCHAR(10) NULL,
  `BG_Color`                                     VARCHAR(10) NULL,
  
  -- Datumsangaben
  `Geburtstag`                                    DATE NULL,
  `Todestag`                                      DATE NULL,
  `Nach_Wangen_Gezogen`                           DATE NULL,
  `Von_Wangen_Weggezogen`                         DATE NULL,
  `Baulandgesuch_Eingereicht_Am`                  DATE NULL,
  `Bauland_Gekauft_Am`                            DATE NULL,
  
  `Bauland_Abgelehnt_1`                           VARCHAR(20) NULL,
  `Bauland_Abgelehnt_2`                           VARCHAR(20) NULL,
  
  `Baulandgesuch_Details`                         VARCHAR(500) NULL,
  `Angemeldet_Am`                                 DATE NULL,
  `Aufnahme_Gebühr_bezahlt_Am`                    DATE NULL,
  `Bezahlte_Aufnahme_Gebühr`                      FLOAT UNSIGNED NULL,
  `Aufgenommen_Am`                                DATE NULL,
  `Sich_Für_Bürgertag_Angemeldet_Am`              DATE NULL,
  `Sich_Für_Bürgertag_Abgemeldet_Am`              DATE NULL,
  `Neubürgertag_gemacht_Am`                       DATE NULL,
  `Ausbezahlter_Bürgertaglohn`                    FLOAT UNSIGNED NULL,
  `Funktion_Uebernommen_Am`                       DATE NULL,
  `Funktion`                                      VARCHAR(45) NULL,
  `Funktion_Abgegeben_Am`                         DATE NULL,
  `Chronik_Bezogen_Am`                            DATE NULL,
  `Newsletter_Abonniert_Am`                       DATE NULL,
  
   -- FK: Verwandschaft
  `Partner_ID` 		                   INT UNSIGNED NULL,
  `Vater_ID`         		           INT UNSIGNED NULL,
  `Mutter_ID`				           INT UNSIGNED NULL,
  
  -- FK: Adressen
  `Privat_Adressen_ID`                 INT UNSIGNED NULL,
  `Geschaefts_Adressen_ID`             INT UNSIGNED NULL,
  
  `last_update`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`     INT UNSIGNED NULL DEFAULT 533,

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
    ON UPDATE NO ACTION);
    
-- -----------------------------------------
-- Table `Priviliges`
-- -----------------------------------------
DROP TABLE IF EXISTS `Priviliges`;
CREATE TABLE IF NOT EXISTS `Priviliges` (
  `ID`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Application`  VARCHAR(45)  NOT NULL,
  `Privilege`    VARCHAR(45)  NOT NULL,
  `last_update`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,

  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------
-- Table `Personen_has_Priviliges`
-- -----------------------------------------
DROP TABLE IF EXISTS `Personen_has_Priviliges`;
CREATE TABLE IF NOT EXISTS `Personen_has_Priviliges` (
  `Personen_ID`       INT UNSIGNED NOT NULL,
  `Privilige_ID`      INT UNSIGNED NOT NULL,
  `last_update`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
      
  -- PK-Constraints
  -- PRIMARY KEY (`ID`),
  PRIMARY KEY (`Personen_ID`, `Privilige_ID`),
  
  -- Indizes
  INDEX `fk_Personen_has_Priviliges_1_idx` (`Personen_ID` ASC)   VISIBLE,
  INDEX `fk_Personen_has_Priviliges_2_idx` (`Privilige_ID` ASC)  VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Personen_has_Priviliges_Personen1`
    FOREIGN KEY (`Personen_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personen_has_Priviliges_Adressen1`
    FOREIGN KEY (`Privilige_ID`)
    REFERENCES `Priviliges` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------
-- Table `EMail_Adressen`
-- -----------------------------------------
DROP TABLE IF EXISTS `EMail_Adressen`;
CREATE TABLE IF NOT EXISTS `EMail_Adressen` (
  `ID`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `eMail`        VARCHAR(45)  NOT NULL,
  `Type`         ENUM('Privat', 'Geschaeft', 'Sonstige', 'Fehlermeldung')  NULL,
  `Prio`         TINYINT      NOT NULL DEFAULT 0, 
  `last_update`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL DEFAULT 533,

  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------
-- Table `Personen_has_EMail_Adressen`
-- -----------------------------------------
DROP TABLE IF EXISTS `Personen_has_EMail_Adressen`;
CREATE TABLE IF NOT EXISTS `Personen_has_EMail_Adressen` (
  `Personen_ID`       INT UNSIGNED NOT NULL,
  `EMail_Adressen_ID` INT UNSIGNED NOT NULL,
  `last_update`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL DEFAULT 533,
      
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


-- -----------------------------------------
-- Table `Telefonnummern`
-- -----------------------------------------
DROP TABLE IF EXISTS `Telefonnummern` ;
CREATE TABLE IF NOT EXISTS `Telefonnummern` (
  `ID`           INT UNSIGNED                                 NOT NULL AUTO_INCREMENT,
  `Laendercode`  VARCHAR(4)                                   NOT NULL DEFAULT '0041',
  `Vorwahl`      VARCHAR(5)                                   NULL,
  `Nummer`       VARCHAR(13)                                  NULL,
  `Type`         ENUM('Privat', 'Geschaeft', 'Sonstige')      NULL,
  `Endgeraet`    ENUM('Festnetz', 'Mobile', 'FAX')            NULL,
  `Prio`         TINYINT                                      NOT NULL DEFAULT 0, 
  `last_update`  TIMESTAMP                                    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
      
  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------
-- Table `Personen_has_Telefonnummern`
-- -----------------------------------------
DROP TABLE IF EXISTS `Personen_has_Telefonnummern`;
CREATE TABLE IF NOT EXISTS `Personen_has_Telefonnummern` (
  `Personen_ID`       INT UNSIGNED NOT NULL,
  `Telefonnummern_ID` INT UNSIGNED NOT NULL,
  `last_update`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
      
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


-- -----------------------------------------
-- Table `IBAN`
-- -----------------------------------------
DROP TABLE IF EXISTS `IBAN` ;
CREATE TABLE IF NOT EXISTS `IBAN` (
  `ID`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nummer`       VARCHAR(26) NOT NULL,
  `Bezeichnung`  VARCHAR(45) NULL,
  `Bankname`     VARCHAR(45) NOT NULL DEFAULT '',
  `Bankort`      VARCHAR(45) NOT NULL DEFAULT '',
  `Lautend_auf`  VARCHAR(45) NOT NULL DEFAULT '',
  `Personen_ID`  INT UNSIGNED NOT NULL,
  `Prio`         TINYINT      NOT NULL DEFAULT 0, 
  `last_update`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
       
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


-- -----------------------------------------
-- Table `Kommissionen_Gruppen`
-- -----------------------------------------
DROP TABLE IF EXISTS `Kommissionen_Gruppen` ;
CREATE TABLE IF NOT EXISTS `Kommissionen_Gruppen` (
  `ID`                           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Bezeichnung`                  VARCHAR(45) NULL,
  `Abkürzung`                    VARCHAR(5) NULL,
  `Vorsitzender_ID`              INT UNSIGNED NOT NULL,
  `Ins_Leben_gerufen_am`         DATE NULL,
  `Aktiv_Ab`                     DATE NULL,
  `last_update`                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
       
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_Vorsitzender_ID_idx` (`Vorsitzender_ID` ASC) VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Vorsitzender_ID`
     FOREIGN KEY (`Vorsitzender_ID`)
     REFERENCES `personen` (`ID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION);


-- -----------------------------------------
-- Table `Gehört_zu_Kommissionen`
-- -----------------------------------------
DROP TABLE IF EXISTS `Gehört_zu_Kommissionen`;
CREATE TABLE IF NOT EXISTS `Gehört_zu_Kommissionen` (
  `ID`                INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Personen_ID`       INT UNSIGNED NOT NULL,
  `Kommissionen_ID`   INT UNSIGNED NOT NULL,
  `Funktion`          VARCHAR(45) NULL,
  `Aktiv_Ab`          DATE NULL,
  `Aktiv_Bis`         DATE NULL,
  `last_update`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   `changed_by`    INT UNSIGNED NULL DEFAULT 533,
      
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  -- PRIMARY KEY (`Personen_ID`, `Kommissionen_ID`),
  
  -- Indizes
  INDEX `fk_Gehört_zu_Kommissionen_1_idx` (`Kommissionen_ID` ASC) VISIBLE,
  INDEX `fk_Gehört_zu_Kommissionen_2_idx` (`Personen_ID` ASC)       VISIBLE,
  
  -- FK-Constraints
  CONSTRAINT `fk_Gehört_zu_Kommissionen_1`
    FOREIGN KEY (`Personen_ID`)
    REFERENCES `Personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Gehört_zu_Kommissionen_2`
    FOREIGN KEY (`Kommissionen_ID`)
    REFERENCES `Kommissionen_Gruppen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------
-- Table `Polygon_Flaechen`
-- -----------------------------------------
DROP TABLE IF EXISTS `Polygon_Flaechen`;
CREATE TABLE IF NOT EXISTS `Polygon_Flaechen` (
  `AV_Parzellen_Nr`      VARCHAR(40) NOT NULL,
  `Polygone`             VARCHAR(2000) NULL,
  `Schwerpunkt_x`        VARCHAR(20)  NULL,
  `Schwerpunkt_y`        VARCHAR(20)  NULL,
  `Flaeche_In_Aren`      FLOAT UNSIGNED NULL,
  `Farbe_Fläche`         VARCHAR(10) NULL DEFAULT '6600ff00', 
  `Farbe_Linie`          VARCHAR(10) NULL DEFAULT 'ff0000ff', 
    -- PK-Constraints
  PRIMARY KEY (`AV_Parzellen_Nr`));
  
-- INSERT INTO `Polygon_Flaechen` (`AV_Parzellen_Nr`)
--     SELECT DISTINCT 
--         `AV_Parzellen_Nr`
--     FROM `landteile`;
-- -----------------------------------------
-- Table `Landteil`
-- -----------------------------------------
DROP TABLE IF EXISTS `Landteile`;
CREATE TABLE IF NOT EXISTS `Landteile` (
  `ID`                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `AV_Parzellen_Nr`      VARCHAR(40) NOT NULL,
  `GENO_Parzellen_Nr`    VARCHAR(40) NOT NULL,
  `Flur_Bezeichnung`     VARCHAR(20) NULL,
  `Gemeindegebiet_ID`    INT UNSIGNED NULL,
  
  `Flaeche_In_Aren`      FLOAT UNSIGNED NULL,
  `Bemerkungen`          VARCHAR(255)   NULL,
  `Pachtzins_Pro_Are`    FLOAT UNSIGNED NULL,
  `Fix_Pachtzins`        FLOAT UNSIGNED NULL,
  `Vertragsart`          ENUM('Pachtvertrag','Fixpacht','Gebrauchsleihe','Gekündigt','Bürger_ist_Verpächter') DEFAULT NULL,
  
  `Buergerlandteil`      ENUM('16a','35a','Geno') DEFAULT NULL,
  `Qualitaet`            ENUM('Futter','Streu','Verbuscht','Wald') DEFAULT NULL,
  
  `Pachtbeginn_Am`      DATE NULL,
  `Rueckgabe_Am`        DATE NULL,
  `Vertragsende_Am`     DATE NULL,
  `Pachtende_Am`        DATE NULL,

  `Paechter_ID`                  INT UNSIGNED NULL,
  `Verpaechter_ID`               INT UNSIGNED NULL,
  `Vorheriger_Paechter_ID`       INT UNSIGNED NULL,
  `Vorheriger_Verpaechter_ID`    INT UNSIGNED NULL,

  `last_update`          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
        
  -- PK-Constraints
  PRIMARY KEY (`ID`),
  
  -- Indizes
  INDEX `fk_Landteil_Paechter_Adresse_idx`        (`Paechter_ID`               ASC)    VISIBLE,
  INDEX `fk_Landteil_Verpaechter_Adresse_idx`     (`Verpaechter_ID`            ASC)    VISIBLE,
  INDEX `fk_Landteil_Pre_Paechter_Adresse_idx`    (`Vorheriger_Paechter_ID`    ASC)    VISIBLE,
  INDEX `fk_Landteil_Pre_Verpaechter_Adresse_idx` (`Vorheriger_Verpaechter_ID` ASC)    VISIBLE,
  INDEX `fk_Landteil_Gemeindegebiet_idx`          (`Gemeindegebiet_ID`         ASC)    VISIBLE,
  UNIQUE INDEX `GENO_Parzellen_Nr_UNIQUE`         (`GENO_Parzellen_Nr` ASC)            VISIBLE,
  
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

   
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
