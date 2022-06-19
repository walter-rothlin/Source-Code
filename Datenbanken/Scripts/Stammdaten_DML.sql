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
INSERT INTO `orte` (`id`, `PLZ`, `Name`) 
       VALUES (1, '8855', 'Wangen'),
              (2, '8854', 'Siebnen'),
              (3, '8854', 'Galgenen'),
              (4, '8853', 'Lachen'),
              (5, '8858', 'Innerthal');

     
DELETE FROM `adressen`;
INSERT INTO `adressen` (`id`, `Strasse`, `Hausnummer`, `Orte_id`) 
       VALUES (1, 'Peterliwiese', '33' ,  1),
              (2, 'Etzelstrasse',  '7' ,  1),
              (3, 'Kapellstr.'  ,  '5' ,  2),
              (4, 'Leuholz'     , '12' ,  1),
              (5, 'Aberen'      , ''   ,  5),
              (6, 'Wangen-Nuolen', '',  1);
              
DELETE FROM `personen`;
INSERT INTO `personen` (`id`, `Sex`, `Firma`, `Vorname`, `Nachname`, `Privat_Adressen_id`) 
       VALUES (1, 'Herr', '', 'Walter' , 'Rothlin-Collet' , 1),
			  (2, 'Frau', '', 'Claudia', 'Rothlin Rothlin', 1),
			  (3, 'Herr', '', 'Tobias' , 'Rothlin'        , 1),
			  (4, 'Herr', '', 'Lukas'  , 'Rothlin'        , 1),
			  (5, 'Herr', '', 'Walter' , 'Rothlin-Meier'  , 2),
			  (6, 'Herr', '', 'Remo'   , 'Collet'         , 3),
			  (7, ''    , 'Genossame Wangen'  , '', ''    , 4),
			  (8, ''    , 'Flurgenossenschaft', '', ''    , 5),
			  (9, ''    , 'Feuerwehrverein'   , '', ''    , 6);

DELETE FROM `iban`;
INSERT INTO `iban` (`id`, `Nummer`, `Bezeichnung`, `Bankname`, `Bankort`, `Personen_id`) 
        VALUES (1, 'CH9580808006989422343', 'Haushalt'        , 'Raiffeisen'   , 'Lachen', 1),
			   (2, 'CH8704835041184041000', 'Lohnkonto UH'    , 'Credit-Suisse', 'Zürich', 1),
               (3, 'CH3904835056306331000', 'Lohnkonto Lachen', 'Credit-Suisse', 'Lachen', 1),
               (4, 'CH6709000000303904208', 'Post Lohn Tobias', 'Post Finanze ', 'Bern'  , 3),
               (5, 'CH1509000000922735753', 'Post Spar Tobias', 'Post Finanze' , 'Bern'  , 3),
               (6, 'CH2709000000319272638', 'Post Lohn Lukas' , 'Post Finanze' , 'Bern'  , 4),
               (7, 'CH6809000000924135382', 'Post Spar Lukas' , 'Post Finanze' , 'Bern'  , 4),
               (8, 'CH9800777001683190170', 'Liegenschaft Remo', 'SZKB' , 'Siebnen'  , 6),
               (9, 'CH2800777001683190072', 'Privat Remo'      , 'SZKB' , 'Siebnen'  , 6),
               (10, 'CH4100777005824911455', 'Fw Oktoberfest'  , 'SZKB' , 'Siebnen'  , 9),
               (11, 'CH9000777003292211667', 'FG Abern'        , 'SZKB' , 'Siebnen'  , 8);