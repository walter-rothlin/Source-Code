-- Neues Schema kreieren
CREATE SCHEMA `bzu`;

-- als default Schema setzen
USE `bzu`;

-- Adressen-Tabelle kreieren
CREATE TABLE `adressen` (
  `vorname` VARCHAR(45) NOT NULL,
  `nachname` VARCHAR(45) NOT NULL,
  `strasse` VARCHAR(45) NULL,
  `plz` INT(4) NOT NULL,
  `ort` VARCHAR(45) NOT NULL,
  `adress_id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`adress_id`));
  
-- Adressen einfüllen
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Walter', 'Rothlin', 'Peterliwiese 33', '8855', 'Wangen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Claudia', 'Collet', 'Peterliwiese 33', '8855', 'Wangen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Michaela', 'Stöhr', 'Züricherstr. 42c', '8854', 'Siebnen');
INSERT INTO `adressen` (`vorname`, `nachname`, `strasse`, `plz`, `ort`) VALUES ('Josef', 'Friedlos', 'Ochsenbodenweg 7a', '8855', 'Nuolen');


-- check der Daten
select
	 adressen.adress_id,
	 adressen.vorname,
     adressen.nachname,
     adressen.strasse,
     adressen.plz,
     adressen.ort
from adressen;


-- 1.Normalisierung: zusammengesetzte Felder trennen
-- Tabelle anpassen
ALTER TABLE `adressen` 
    ADD COLUMN `hausnummer` VARCHAR(10) NULL AFTER `adress_id`;

-- Datensätze mutieren
UPDATE `adressen` SET `strasse`='Peterliwiese', `hausnummer`='33' WHERE `adress_id`='1';
UPDATE `adressen` SET `strasse`='Peterliwiese', `hausnummer`='33' WHERE `adress_id`='2';
UPDATE `adressen` SET `strasse`='Züricherstr.', `hausnummer`='42c' WHERE `adress_id`='3';
UPDATE `adressen` SET `strasse`='Ochsenbodenweg', `hausnummer`='7a' WHERE `adress_id`='4';


-- check der Daten
select
     adressen.adress_id,
     adressen.vorname,
     adressen.nachname,
     adressen.strasse,
     adressen.hausnummer,
     adressen.plz,
     adressen.ort
from adressen;


-- weiter Normalisieren (Orte in neue Tabelle auslagern)
-- -----------------------------------------------------

-- neue Tabelle kreieren
CREATE TABLE `orte` (
  `ort_id` INT NOT NULL AUTO_INCREMENT,
  `plz` INT(4) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ort_id`));
 
-- Orte einfüllen
INSERT INTO `orte` (`plz`, `name`) VALUES ('8855', 'Wangen');
INSERT INTO `orte` (`plz`, `name`) VALUES ('8855', 'Nuolen');
INSERT INTO `orte` (`plz`, `name`) VALUES ('8854', 'Siebnen');

-- check der Daten
select * from orte;


-- foreign key in Haupttabelle einführen
ALTER TABLE `adressen` 
    ADD COLUMN `orte_fk` INT NOT NULL;

-- Datensätze mutieren
UPDATE `adressen` SET `orte_fk`='1' WHERE `adress_id`='1';
UPDATE `adressen` SET `orte_fk`='1' WHERE `adress_id`='2';
UPDATE `adressen` SET `orte_fk`='3' WHERE `adress_id`='3';
UPDATE `adressen` SET `orte_fk`='2' WHERE `adress_id`='4';

-- check der Daten
select
     adressen.adress_id,
     adressen.vorname,
     adressen.nachname,
     adressen.strasse,
     adressen.hausnummer,
     adressen.plz,
     adressen.ort,
     adressen.orte_fk
from adressen;

-- redundante Felder (Attributte löschen)
ALTER TABLE `adressen` 
    DROP COLUMN `ort`,
    DROP COLUMN `plz`;

-- check der Daten
select
     adressen.adress_id,
     adressen.vorname,
     adressen.nachname,
     adressen.strasse,
     adressen.hausnummer,
     adressen.orte_fk
from adressen;

-- check der Daten
select
     adressen.vorname,
     adressen.nachname,
     adressen.strasse,
     adressen.hausnummer,
     orte.plz,
     orte.name
from adressen
join orte on adressen.orte_fk = orte.ort_id;


-- alles wieder löschen
-- --------------------
DELETE FROM `adressen`;
DELETE FROM `orte`;

DROP TABLE `adressen`;
DROP TABLE `orte`;

DROP Schema `bzu`;
