-- -----------------------------------------
-- Filename: GenoWangen_Create_Table_DDL.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/GenoWangen_Create_Table_DDL.sql
-- -----------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert alle Rohdaten-Tabellen for Genossame Wangen
--              !!!!!! LOESCHT ALLE DATEN !!!!!!!
--
-- History:
-- 13-May_2023   Walter Rothlin      Splitted file in DDL Tables / Fct, Views, Proc
-- 08-Jun-2023   Walter Rothlin		 Added fields for Neubürger
-- 05-Jul-2023   Walter Rothlin      Removed Waermebezueger and replaced by Wärmeanschlüsse
-- 07-Jul-2023   Walter Rothlin      Detail definition Wärmebezüger mit Remo und Adrian
-- 11-Jul-2023   Walter Rothlin      Added 'Fehlermeldung' zu email
-- 12-Jul-2023   Walter Rothlin      Added  `Projekt_Nr` Eigentümer_2_ID to Wärmeanschlüsse
-- 29-Aug-2023   Walter Rothlin      Added  'Verwaltungsberechtigt' zu Kategorien
-- 05_Oct-2023   Walter Rothlin      Added  SAK (Standard Arbeitskraft)
-- 07-Oct_2023   Walter Rothlin		 Added   `Sich_Für_Bürgertag_definitiv_abgemeldet_Am` to Personen
-- 16-Oct-2023   Walter Rothlin      Added Bemerkungen zu landteilen
-- 07-Nov-2023   Walter Rothlin      Added Entschädigungs_Modelle und Durchleitungsrechte
-- 27-Nov-2023   Walter Rothlin      Added Password to Person and Add Privilege-Table
-- -----------------------------------------

-- -----------------------------------------
SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- =========================================
-- == Schema Stammdaten kreieren          ==
-- =========================================
DROP SCHEMA IF EXISTS genossame_wangen;
CREATE SCHEMA IF NOT EXISTS genossame_wangen  DEFAULT CHARACTER SET utf8 ;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE genossame_wangen;


-- =========================================
-- == Create Tables                       ==
-- =========================================

-- -----------------------------------------
-- Table `Properties`
-- -----------------------------------------
DROP TABLE IF EXISTS Properties;
CREATE TABLE IF NOT EXISTS Properties (
  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name`          VARCHAR(25) NOT NULL,
  `Value`         VARCHAR(25) NULL,
  `last_update`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- PK-Constraints
  PRIMARY KEY (`ID`));
  
INSERT INTO `properties` (`Name`, `Value`) VALUES 
       ('Grundnutzen', '1650.00'),
       ('Nutzen_16a_Teil', '130.00'),
       ('Nutzen_35a_Teil', '220.00');
 
-- -----------------------------------------
-- Table `Land`
-- -----------------------------------------
DROP TABLE IF EXISTS Land;
CREATE TABLE IF NOT EXISTS Land (
  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name`          VARCHAR(45) NOT NULL,
  `Code`          VARCHAR(5) NULL,
  `Landesvorwahl` VARCHAR(4) NULL,
  `last_update`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- PK-Constraints
  PRIMARY KEY (`ID`));

-- -----------------------------------------
-- Table `Orte`
-- -----------------------------------------
DROP TABLE IF EXISTS Orte;
CREATE TABLE IF NOT EXISTS Orte (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`         VARCHAR(10) NOT NULL,
  `Name`        VARCHAR(45) NULL,
  `Kanton`      VARCHAR(10) NULL,
  `Land_ID`     INT UNSIGNED NULL DEFAULT 1,
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


-- -----------------------------------------
-- Table `Adressen`
-- -----------------------------------------
DROP TABLE IF EXISTS Adressen;
CREATE TABLE IF NOT EXISTS Adressen (
  `ID`                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Strasse`              VARCHAR(45)   NULL,
  `Hausnummer`           VARCHAR(15)   NULL,
  `Postfachnummer`       VARCHAR(5)    NULL,
  `Adresszusatz`         VARCHAR(20)   NULL,
  `Wohnung`              VARCHAR(10)   NULL,
  `Kataster_Nr`          VARCHAR(10)   NULL,
  `x_CH1903`             VARCHAR(10)   NULL,
  `y_CH1903`             VARCHAR(10)   NULL,
  `Politisch_Wangen`     INT UNSIGNED  NULL DEFAULT 0,
  `Orte_ID`              INT UNSIGNED  NULL,
  `last_update`          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      
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

    
    
-- -----------------------------------------
-- Table `Personen` 
-- -----------------------------------------
DROP TABLE IF EXISTS Personen;
CREATE TABLE IF NOT EXISTS Personen (
  `ID`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Source`      ENUM('Initial_1', 'Loader_1', 'BuergerDB','ImmoTop','Manuel') DEFAULT NULL,
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
  `SAK`                      FLOAT NULL DEFAULT NULL,
  `Password`                 VARCHAR(20) NULL,
  `Betriebs_Nr`              VARCHAR(45) NULL,

  `Zivilstand`  ENUM('Unbestimmt', 'Leer', 'Ledig','Verheiratet','Getrennt',
                      'Geschieden','Verwitwet','Wiederverheiratet','Gestorben',
                      'Bevormundet','Partnerschaft') 
                      DEFAULT NULL,

  `Kategorien`  SET('Bürger', 'Nutzungsberechtigt',  'Verwaltungsberechtigt', 'Hat_16a', 'Hat_35a',
                    'Firma', 'Angestellter', 'Auftragnehmer', 'Genossenrat', 'GPK',
                    'LWK', 'Forst_Komm', 'Grauer Panter', 'Bewirtschafter', 
                    'Pächter', 'Landwirt_EFZ', 'DZ betrechtigt', 
                    'Wohnungsmieter', 'Bootsplatzmieter', 'Waermebezüger',  
                    'Betriebsgemeinschaft', 'Generationengemeinschaft') 
                    DEFAULT NULL,
  
  -- Datumsangaben
  `Geburtstag`                                    DATE NULL,
  `Todestag`                                      DATE NULL,
  `Nach_Wangen_Gezogen`                           DATE NULL,
  `Von_Wangen_Weggezogen`                         DATE NULL,
  `Baulandgesuch_Eingereicht_Am`                  DATE NULL,
  `Bauland_Gekauft_Am`                            DATE NULL,
  `Baulandgesuch_Details`                         VARCHAR(500) NULL,
  `Angemeldet_Am`                                 DATE NULL,
  `Bezahlte_Aufnahme_Gebühr`                      FLOAT UNSIGNED NULL,
  `Aufgenommen_Am`                                DATE NULL,
  `Sich_Für_Bürgertag_Angemeldet_Am`              DATE NULL,
  `Sich_Für_Bürgertag_definitiv_abgemeldet_Am`    DATE NULL,
  `Neubürgertag_gemacht_Am`                       DATE NULL,
  `Ausbezahlter_Bürgertaglohn`                    FLOAT UNSIGNED NULL,
  `Funktion_Uebernommen_Am`                       DATE NULL,
  `Funktion`                                      VARCHAR(45) NULL,
  `Funktion_Abgegeben_Am`                         DATE NULL,
  `Chronik_Bezogen_Am`                            DATE NULL,
  `Newsletter_Abonniert_Am`                       DATE NULL,
  
   -- FK: Verwandschaft
  `Partner_ID` 		                   INT NULL,
  `Vater_ID`         		           INT NULL,
  `Mutter_ID`				           INT NULL,
  
  -- FK: Adressen
  `Privat_Adressen_ID`                 INT UNSIGNED NULL,
  `Geschaefts_Adressen_ID`             INT UNSIGNED NULL,
  
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


-- -----------------------------------------
-- Table `Priviliges`
-- -----------------------------------------
DROP TABLE IF EXISTS Priviliges;
CREATE TABLE IF NOT EXISTS Priviliges (
  `ID`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Application`  VARCHAR(45)  NOT NULL,
  `Privilege`    VARCHAR(45)  NOT NULL,
  `last_update`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- PK-Constraints
  PRIMARY KEY (`ID`));
  
-- -----------------------------------------
-- Table `Personen_has_Priviliges`
-- -----------------------------------------
DROP TABLE IF EXISTS Personen_has_Priviliges;
CREATE TABLE IF NOT EXISTS Personen_has_Priviliges (
  -- `ID`                INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Personen_ID`       INT UNSIGNED NOT NULL,
  `Privilige_ID`      INT UNSIGNED NOT NULL,
  `last_update`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      
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
DROP TABLE IF EXISTS EMail_Adressen;
CREATE TABLE IF NOT EXISTS EMail_Adressen (
  `ID`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `eMail`        VARCHAR(45)  NOT NULL,
  `Type`         ENUM('Privat', 'Geschaeft', 'Sonstige', 'Fehlermeldung')  NULL,
  `Prio`         TINYINT      NOT NULL DEFAULT 0, 
  `last_update`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- PK-Constraints
  PRIMARY KEY (`ID`));

-- -----------------------------------------
-- Table `Personen_has_EMail_Adressen`
-- -----------------------------------------
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
      
  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------
-- Table `Personen_has_Telefonnummern`
-- -----------------------------------------
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

-- -----------------------------------------
-- Table `IBAN`
-- -----------------------------------------
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


-- -----------------------------------------
-- Table `Entschädigungs_Modelle`
-- -----------------------------------------
DROP TABLE IF EXISTS `Entschädigungs_Modelle`;
CREATE TABLE IF NOT EXISTS `Entschädigungs_Modelle` (
  `ID`                               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Betrag`                           FLOAT UNSIGNED NULL,
  `Form_Betragszahlung`              ENUM('Einmalig Auszahlung', 
                                          'Reduktion bei Vertragsabschluss') DEFAULT NULL,
  `Zeitpunk_der_Zahlung`             ENUM('Zukünftig', 
                                          'Abgeschlossen') DEFAULT NULL,
  `Details`                          VARCHAR(100) NULL DEFAULT NULL,
  `Bezahlt_Am`                       DATE NULL,
  `Ablauf_Datum`                     DATE NULL,
  
  `last_update`                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`));
  

-- -----------------------------------------
-- Table `Durchleitungsrechte`
-- -----------------------------------------
DROP TABLE IF EXISTS `Durchleitungsrechte`;
CREATE TABLE IF NOT EXISTS `Durchleitungsrechte` (
  `ID`                               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Parzellen_Nummer`                 VARCHAR(45) NULL,  -- Wohnung, Kataster_Nr, x,y sind in Adressen
  `Korrenspondenz`                   VARCHAR(500) NULL,
  `Vertrags_Name`                    VARCHAR(30)  NULL,
  

  `Vertrag_unterzeichnet_Am`         DATE NULL,
  `Notariel_beglaubigt_Am`           DATE NULL,
  `Gültig_bis_Am`                    DATE NULL,
  
  `Standort_Adresse_ID`              INT UNSIGNED NULL,
  `Haupt_Vertragspartner_ID`         INT UNSIGNED NULL,  -- m:n Beziehung
  `Anzahl_Vertrags_Partner`          INT UNSIGNED NULL   DEFAULT 1,
  `Entschädigungs_ID`				 INT UNSIGNED NULL,
  
  `last_update`                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  INDEX `fk_Durchleitungsrechte_Standort_Adresse_idx`          (`Standort_Adresse_ID`        ASC) VISIBLE,
  INDEX `fk_Durchleitungsrechte_Haupt_Vertragspartner_idx`     (`Haupt_Vertragspartner_ID`   ASC) VISIBLE,
  INDEX `fk_Durchleitungsrechte_Entschädigungs_idx`            (`Entschädigungs_ID`          ASC) VISIBLE,
  CONSTRAINT `fk_Durchleitungsrechte_Standort_Adresse`
    FOREIGN KEY (`Standort_Adresse_ID`)
    REFERENCES `adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Durchleitungsrechte_Haupt_Vertragspartner`
    FOREIGN KEY (`Haupt_Vertragspartner_ID`)
    REFERENCES `personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Durchleitungsrechte_Entschaedigung`
    FOREIGN KEY (`Entschädigungs_ID`)
    REFERENCES `Entschädigungs_Modelle` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );


-- -----------------------------------------
-- Table `Wärmeanschlüsse`
-- -----------------------------------------
DROP TABLE IF EXISTS `Wärmeanschlüsse`;
CREATE TABLE IF NOT EXISTS `Wärmeanschlüsse` (
  `ID`                               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Parzellen_Nummer`                 VARCHAR(45) NULL,  -- Wohnung, Kataster_Nr, x,y sind in Adressen
  `Korrenspondenz`                   VARCHAR(500) NULL,
  `Projekt_Nr`                       VARCHAR(10) NULL,
  `Vertrags_Name`                    VARCHAR(30)  NULL,
  `Gebietsbezeichnung`               VARCHAR(45) NULL,
  `Anschluss_Type`                   ENUM('Vollanschluss', 
                                          'Teilanschluss_Grundstück', 
                                          'Teilanschluss_Gebäude') DEFAULT NULL,
  `Anschluss_Gebühr`                 FLOAT UNSIGNED NULL,
  `Vertrag_unterzeichnet_Am`                   DATE NULL,
  `Teilanschluss_Vereinbarung_Endet_Am`        DATE NULL,
  `Verrechnet_Am`                              DATE NULL,
  `Bezahlt_Am`                                 DATE NULL,
  
  `kW_Leistung`                      INT UNSIGNED NULL,
  `Stations_Type`                    ENUM('AmStat T0', 
                                          'AmStat T1', 
                                          'AmStat T2', 
                                          'AmStat T3', 
                                          'AmStat T3+', 
                                          'AmStat Spez') DEFAULT NULL,
  `Fabrikations_Nr`                  VARCHAR(20) NULL,   -- 1424-202213065
  `Steuerungs_Type`                  ENUM('Saia', 'TA') DEFAULT NULL,
  `Zähler_Nr`                        VARCHAR(8) NULL,   -- W123 
  `Baujahr_Station`                  DATE NULL,
  
  `Inbetrieb_genommen_Am`            DATE NULL,
  `Letzte_Kontrolle_Am`              DATE NULL,
  `Sieb_Primär_gereinigt_Am`         DATE NULL,
  `Sieb_Sekundär_gereinigt_Am`       DATE NULL,
  `SBS_Baterrien_gewechselt_Am`      DATE NULL,
  
  `Parameter`                              VARCHAR(500) NULL,
  -- `Durchleitungsvertrag_unterzeichnet_Am` DATE NULL,
  -- `Durchleitungsvertrag_endet_Am`         DATE NULL,
  -- `Bezahlte_Durchleitungs_Gebühr`         FLOAT UNSIGNED NULL,   -- NULL kein DL-Recht     0..xxx DL-Recht gegeben
  `Bemerkungen`                           VARCHAR(500) NULL,
  
  `Standort_Adresse_ID`              INT UNSIGNED NULL,
  `Eigentümer_ID`                    INT UNSIGNED NULL,
  `Eigentümer_2_ID`                  INT UNSIGNED NULL,
  `Kontakt_ID`                       INT UNSIGNED NULL,
  `Rechnungs_Adresse_ID`             INT UNSIGNED NULL,
  `Heizungs_Installateur_ID`         INT UNSIGNED NULL,
  `Elektro_Installateur_ID`          INT UNSIGNED NULL,

  `last_update`                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `Fabrikations_Nr_UNIQUE`     (`Fabrikations_Nr`          ASC) VISIBLE,
  INDEX `fk_Wärmeanschlüsse_adressen1_idx`  (`Standort_Adresse_ID`      ASC) VISIBLE,
  INDEX `fk_Wärmeanschlüsse_personen1_idx`  (`Eigentümer_ID`            ASC) VISIBLE,
  INDEX `fk_Wärmeanschlüsse_personen1a_idx` (`Eigentümer_2_ID`            ASC) VISIBLE,
  INDEX `fk_Wärmeanschlüsse_personen2_idx`  (`Kontakt_ID`               ASC) VISIBLE,
  INDEX `fk_Wärmeanschlüsse_personen3_idx`  (`Heizungs_Installateur_ID` ASC) VISIBLE,
  INDEX `fk_Wärmeanschlüsse_personen4_idx`  (`Elektro_Installateur_ID`  ASC) VISIBLE,
  INDEX `fk_Wärmeanschlüsse_personen5_idx`  (`Rechnungs_Adresse_ID`     ASC) VISIBLE,
  CONSTRAINT `fk_Wärmeanschlüsse_adressen1`
    FOREIGN KEY (`Standort_Adresse_ID`)
    REFERENCES `adressen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wärmeanschlüsse_personen1`
    FOREIGN KEY (`Eigentümer_ID`)
    REFERENCES `personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wärmeanschlüsse_personen1a`
    FOREIGN KEY (`Eigentümer_2_ID`)
    REFERENCES `personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wärmeanschlüsse_personen2`
    FOREIGN KEY (`Kontakt_ID`)
    REFERENCES `personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wärmeanschlüsse_personen3`
    FOREIGN KEY (`Heizungs_Installateur_ID`)
    REFERENCES `personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wärmeanschlüsse_personen5`
    FOREIGN KEY (`Rechnungs_Adresse_ID`)
    REFERENCES `personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wärmeanschlüsse_personen4`
    FOREIGN KEY (`Elektro_Installateur_ID`)
    REFERENCES `personen` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- INSERT INTO `wärmeanschlüsse` (`ID`, `Projekt_Nr`, `Gebietsbezeichnung`, `Anschluss_Type`, `kW_Leistung`, `Standort_Adresse_ID`, `Eigentümer_ID`, `Kontakt_ID`, `Rechnungs_Adresse_ID`, `Heizungs_Installateur_ID`, `Elektro_Installateur_ID`) VALUES ('1', '16886', 'Knobelhof', 'Vollanschluss', '10', '132', '223', '223', '223', '523', '644');


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
  `Polygone_Flaeche`     VARCHAR(300) NULL,
  `x_CH1903`             VARCHAR(10)  NULL,
  `y_CH1903`             VARCHAR(10)  NULL,
  
  `Pachtbeginn_Am`      DATE NULL,
  `Rueckgabe_Am`        DATE NULL,
  `Vertragsende_Am`     DATE NULL,
  `Pachtende_Am`        DATE NULL,

  `Paechter_ID`                  INT UNSIGNED NULL,
  `Verpaechter_ID`               INT UNSIGNED NULL,
  `Vorheriger_Paechter_ID`       INT UNSIGNED NULL,
  `Vorheriger_Verpaechter_ID`    INT UNSIGNED NULL,

  `last_update`          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        
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