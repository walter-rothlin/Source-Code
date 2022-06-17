-- ---------------------------------------------------------------------------------------------
-- Filename: Stammdaten_DML.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Stammdaten_DML.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Füllt Stammdaten Schema mit Daten
--
-- History:
-- 17-Jun_2022   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

DELETE FROM `land`;
INSERT INTO `land` (`id`, `Name`, `Code`, `Landesvorwahl`) 
       VALUES (1, 'Schweiz' , 'CH', '0041'),
              (2, 'Albanien', 'AL', '0355');

DELETE FROM `orte`;
INSERT INTO `orte` (`id`, `PLZ`, `Name`, `Land_id`) 
       VALUES ('1', '8855', 'Wangen', '1'),
              ('2', '8854', 'Siebnen', '1'),
              ('3', '8854', 'Galgenen', '1'),
              ('4', '8853', 'Lachen', '1');
     
DELETE FROM `adressen`;
INSERT INTO `adressen` (`id`, `Strasse`, `Hausnummer`, `Orte_id`) 
       VALUES ('1', 'Peterliwiese', '33', '1'),
              ('2', 'Etzelstrasse', '7', '1');
              
DELETE FROM `personen`;
INSERT INTO `personen` (`id`, `Vorname`, `Nachname`, `Privat_Adressen_id`) 
       VALUES ('1', 'Walter', 'Rothlin-Collet', '1'),
			  ('2', 'Walter', 'Rothlin-Meier', '2');

