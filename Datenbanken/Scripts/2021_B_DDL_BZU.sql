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
-- ---------------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS `bzu 2021`;
CREATE SCHEMA IF NOT EXISTS `bzu 2021`;

SELECT SLEEP(1);
USE `bzu 2021`;

DROP TABLE IF EXISTS adressen;
CREATE TABLE IF NOT EXISTS adressen (
  adress_id  INT(10)     UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (adress_id),
  vorname    VARCHAR(45) NOT NULL,
  nachname   VARCHAR(45) NOT NULL,
  strasse    VARCHAR(45) NULL,
  plz        INT(4)      NOT NULL,
  ort        VARCHAR(45) NOT NULL);
  
-- Adressen einfüllen
INSERT INTO adressen (vorname, nachname, strasse, plz, ort) VALUES ('Walter'  , 'Rothlin' , 'Peterliwiese 33'  , 8855, 'Wangen');
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

