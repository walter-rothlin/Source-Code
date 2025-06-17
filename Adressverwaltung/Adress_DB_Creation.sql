-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Creating new schema for Adress_Manager
--
-- History:
-- 16-Jun-2025   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `Adressen_DB`;
CREATE SCHEMA `Adressen_DB`;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `Adressen_DB`;


DROP TABLE IF EXISTS `Adressen`;
CREATE TABLE IF NOT EXISTS `Adressen` (
  `ID`       INT         NOT NULL AUTO_INCREMENT,
  `Vorname`  VARCHAR(45) NOT NULL,
  `Nachname` VARCHAR(45) NOT NULL,
  `Strasse`  VARCHAR(45) NULL,
  `PLZ`      VARCHAR(20) NOT NULL,
  `Ort`      VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`));

-- Testdatensätze einfügen
-- -----------------------------------------------------
INSERT INTO `Adressen` (`ID`, `Vorname`, `Nachname`, `Strasse`, `PLZ`, `Ort`) VALUES 
(1, 'Walter', 'Rothlin', 'Peterliwiese 33', '8855', 'Wangen'),
(2, 'Max', 'Meier', 'Etzelstr. 7', '8855', 'Wangen'),
(3, 'Claudia', 'Müller', 'Hauptstr. 179a', '8853', 'Lachen'),
(4, 'Maria', 'Bächtiger', 'Etzelstr. 7', '8853', 'Lachen'),
(5, 'Fritz', 'Künzli', 'Rigiweg 55c', '8855', 'Nuolen');

