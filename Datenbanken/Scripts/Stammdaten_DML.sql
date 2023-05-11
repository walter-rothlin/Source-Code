-- ---------------------------------------------------------------------------------------------
-- Filename: Stammdaten_DML.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Stammdaten_DML.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Füllt Stammdaten Schema mit Daten
--
-- History:
-- 17-Jun-2022   Walter Rothlin      Initial Version
-- 26-Apr-2023   Walter Rothlin      Mutationen Buerger DB
-- ---------------------------------------------------------------------------------------------

/*
            LOAD DATA INFILE 'C:/Users/Landwirtschaft/Desktop/Länder.csv'
            INTO TABLE Land 
            FIELDS TERMINATED BY '|' 
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n'
            IGNORE 1 ROWS;
INSERT IGNORE INTO products VALUES (null, 111, '8.8.8.8')

INSERT INTO products VALUES (null, 111, '8.8.8.8')
ON DUPLICATE KEY UPDATE products SET last_modified = NOW()

REPLACE INTO products VALUES (null, 111, '8.8.8.8')adressen
*/



UPDATE `personen` SET `AHV_Nr` = '756.2534.0047.47' WHERE (`ID` = 644);  -- Walter Rothlin 1960

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

UPDATE `personen` SET `Partner_ID` = NULL, `Vater_ID` = NULL, `Mutter_ID` = NULL;

UPDATE `personen` SET `Vater_ID` = 223                     WHERE `ID` = 644;   -- Walter Rothlin 1960
UPDATE `personen` SET `Vater_ID` = 223, `Partner_ID` = 812 WHERE `ID` = 151;   -- Rosi Friedlos 1959

UPDATE `personen` SET `Partner_ID` = 151 WHERE (`ID` = 812);                   -- Josef Friedlos 1958

UPDATE `personen` SET `Partner_ID` = 235 WHERE (`ID` = 227);                   -- Bruno Rothlin
UPDATE `personen` SET `Partner_ID` = 235 WHERE (`ID` = 235);                   -- Heidi Rothlin

-- Genossame Wangen
UPDATE `personen` SET 
		  `Firma` = 'Genossame Wangen', 
		  `Partner_Name_Angenommen` = 0,
          `Vorname`                 = '',
		  `Ledig_Name`              = 'Genossame',
		  `Partner_Name`            = 'Wangen',
		  `Privat_Adressen_ID`      = 273, 
		  `Geschaefts_Adressen_ID`  = 273
WHERE `ID` = 625;

UPDATE `adressen` SET `Strasse` = 'Leuholz 12', `Postfachnummer` = NULL WHERE `ID` = 273;
INSERT INTO `telefonnummern` (`ID`, `Laendercode`, `Vorwahl`, `Nummer`, `Type`, `Endgeraet`, `Prio`) VALUES (496, '0041', '', '0554405483', 'Geschaeft', 'Festnetz', '0');
INSERT INTO `email_adressen` (`ID`, `eMail`, `Type`, `Prio`) VALUES (314, 'verwaltung@genossame-wangen.ch', 'Geschaeft', '0');
INSERT INTO `personen_has_email_adressen` (`ID`, `Personen_ID`, `EMail_Adressen_ID`) VALUES (319, 625, 314);
INSERT INTO `personen_has_telefonnummern` (`ID`, `Personen_ID`, `Telefonnummern_ID`) VALUES (513, 625, 496);

-- Bewirtschafter
INSERT INTO `personen` (`ID`, `Source`, `Sex`, `Vorname`, `Ledig_Name`) VALUES 
        (1112, 'Initial_1', 'Herr', 'Pius', 'Diethelm'),
        (1113, 'Initial_1', 'Frau', 'Gabriela', 'Dobler'),
        (1114, 'Initial_1', 'Herr', 'Daniel', 'Elmer'),
        (1115, 'Initial_1', 'Herr', 'Werner', 'Kessler'),
        (1116, 'Initial_1', 'Herr', 'Alois', 'Mächler'),
        (1117, 'Initial_1', 'Herr', 'Stefan', 'Mächler'),
        (1118, 'Initial_1', 'Herr', 'Daniel', 'Schnellmann'),
        (1119, 'Initial_1', 'Herr', 'Andreas', 'Schnyder');
INSERT INTO `personen` (`ID`, `Source`, `Sex`, `Vorname`, `Ledig_Name`) VALUES (905, 'Initial_1', 'Herr', 'Albin', 'Marty');
INSERT INTO `personen` (`ID`, `Source`, `Sex`, `Vorname`, `Ledig_Name`) VALUES (908, 'Initial_1', 'Herr', 'Peter', 'Züger');
INSERT INTO `personen` (`ID`, `Source`, `Sex`, `Vorname`, `Ledig_Name`, `Partner_Name`) VALUES (906, 'Initial_1', 'Herr', 'Andreas', 'Schnyder','Mächler');
        
INSERT INTO `adressen` (`ID`, `Strasse`, `Orte_ID`) VALUES 
     (673, 'Bergwiese 7',      8),
     (674, 'Falkenstr. 8',     2),
     (675, 'Zürcherstr. 112',  1),
     (676, 'Zürcherstr. 82a',  3),
     (677, 'Bergstrasse 12',   9),
     (678, 'Zopfstr. 50a',     1),
     (679, 'Zopfstr. 59',      1),
     (680, 'Obere Bächweid 2', 9);
INSERT INTO `adressen` (`ID`, `Strasse`, `Orte_ID`) VALUES (681, 'Zügerdörfliweg 24', 2);
INSERT INTO `adressen` (`ID`, `Strasse`, `Orte_ID`) VALUES (682, 'Chällenstrasse 28', 10);
INSERT INTO `adressen` (`ID`, `Strasse`, `Orte_ID`) VALUES (683, 'Oberstöss 3', 9);

UPDATE `personen` SET `Betriebs_Nr` = '1346.1.9',   `Geburtstag` = '1965-11-03', `Privat_Adressen_ID` = 673 WHERE `ID` = 1112;
UPDATE `personen` SET `Betriebs_Nr` = '1349.1.57',  `Geburtstag` = '1974-05-01', `Privat_Adressen_ID` = 674, Ledig_Name = 'Galler' WHERE `ID` = 1113;
UPDATE `personen` SET `Betriebs_Nr` = '1349.1.65',  `Geburtstag` = '1974-11-27', `Privat_Adressen_ID` = 675 WHERE `ID` = 1114;
UPDATE `personen` SET `Betriebs_Nr` = '1342.1.70',  `Geburtstag` = '1957-02-12', `Privat_Adressen_ID` = 676, Ledig_Name = 'Hüppin', Bemerkungen='Corinne Egli(Tochter) + Thomas Egli (Mann)' WHERE `ID` = 1115;
UPDATE `personen` SET `Betriebs_Nr` = '1348.1.29',                               `Privat_Adressen_ID` = 677 WHERE `ID` = 1116;
UPDATE `personen` SET `Betriebs_Nr` = '1349.1.33',  `Geburtstag` = '1978-11-17', `Privat_Adressen_ID` = 678 WHERE `ID` = 1117;
UPDATE `personen` SET `Betriebs_Nr` = '1349.1.15',  `Geburtstag` = '2002-06-29', `Privat_Adressen_ID` = 679, Bemerkungen='Vormals Mathilde Schnellmann' WHERE `ID` = 1118;
UPDATE `personen` SET                                                            `Privat_Adressen_ID` = 680 WHERE `ID` = 1119;
UPDATE `personen` SET `Betriebs_Nr` = '1349.1.54',  `Geburtstag` = '1965-08-24', `Privat_Adressen_ID` = 681 WHERE `ID` = 905;
UPDATE `personen` SET `Betriebs_Nr` = '1348.1.24',                               `Privat_Adressen_ID` = 683 WHERE `ID` = 906;
UPDATE `personen` SET                                                            `Privat_Adressen_ID` = 682 WHERE `ID` = 908;
UPDATE `personen` SET                               `Geburtstag` = '1960-08-17'                             WHERE `ID` = 493;
UPDATE `personen` SET                               `Geburtstag` = '1986-06-12'                             WHERE `ID` = 495;
UPDATE `personen` SET                               `Geburtstag` = '1965-07-12'                             WHERE `ID` = 498;
UPDATE `personen` SET                               `Geburtstag` = '1959-05-12'                             WHERE `ID` = 627;
UPDATE `personen` SET                               `Geburtstag` = '1960-09-22'                             WHERE `ID` = 628;
UPDATE `personen` SET                               `Geburtstag` = '1977-01-14'                             WHERE `ID` = 637;
UPDATE `personen` SET                               `Geburtstag` = '1955-09-28'                             WHERE `ID` = 638;
UPDATE `personen` SET                               `Geburtstag` = '1981-02-13'                             WHERE `ID` = 740;



INSERT INTO `email_adressen` (`id`, `eMail`, `Type`, `prio`) 
       VALUES (315, 'piusdiethelm@bluewin.ch',        'Privat',   0),
              (316, 'ga.ga@bluewin.ch',               'Privat',   0),
              (317, 'fam-schnellmann@bluewin.ch',     'Privat',   0);
INSERT INTO `email_adressen` (`id`, `eMail`, `Type`, `prio`) 
       VALUES (318, 'chaellenbuur@bluewin.ch',        'Privat',   0);
       
INSERT INTO `Personen_has_EMail_Adressen` (`id`, `Personen_id`, `EMail_Adressen_id`) 
       VALUES (320, 1112, 315),
              (321, 1113, 316),
              (322, 1118, 317);
INSERT INTO `Personen_has_EMail_Adressen` (`id`, `Personen_id`, `EMail_Adressen_id`) 
       VALUES (323, 908, 318);

INSERT INTO `telefonnummern` (`ID`, `Laendercode`, `Nummer`, `Type`, `Endgeraet`, `Prio`) 
       VALUES ('497', '0041', '0554405816', 'Privat', 'Festnetz', '0'),
              ('498', '0041', '0554403763', 'Privat', 'Festnetz', '1'),
              ('499', '0041', '0554403908', 'Privat', 'Festnetz', '0'),
              ('500', '0041', '0554401971', 'Privat', 'Festnetz', '1'),
              ('501', '0041', '0554403560', 'Privat', 'Festnetz', '1'),
              ('502', '0041', '0554403246', 'Privat', 'Festnetz', '1'),
              ('503', '0041', '0797969484', 'Privat', 'Mobile', '0'),
              ('504', '0041', '0765366407', 'Privat', 'Mobile', '0'),
              ('505', '0041', '0797035951', 'Privat', 'Mobile', '0'),
              ('506', '0041', '0796393547', 'Privat', 'Mobile', '0');
INSERT INTO `telefonnummern` (`ID`, `Laendercode`, `Nummer`, `Type`, `Endgeraet`, `Prio`) 
       VALUES ('507', '0041', '0554403237', 'Privat', 'Festnetz', '0');
INSERT INTO `telefonnummern` (`ID`, `Laendercode`, `Nummer`, `Type`, `Endgeraet`, `Prio`) 
       VALUES ('508', '0041', '0794726215', 'Privat', 'Mobile', '0');
       
INSERT INTO `personen_has_telefonnummern` (`ID`, `Personen_ID`, `Telefonnummern_ID`)
      VALUES (514, 1112, 497),
             (515, 1113, 498),
             (516, 1114, 499),
             (517, 1115, 500),
             (518, 1117, 501),
             (519, 1118, 502),
             (520, 1113, 503),
             (521, 1115, 504),
             (522, 1117, 505),
             (523, 1118, 506);
  INSERT INTO `personen_has_telefonnummern` (`ID`, `Personen_ID`, `Telefonnummern_ID`)
      VALUES (524, 905, 507);
  INSERT INTO `personen_has_telefonnummern` (`ID`, `Personen_ID`, `Telefonnummern_ID`)
      VALUES (525, 908, 508);
      
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter')  WHERE  id = 905;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Landwirt')  WHERE  id = 905;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter')  WHERE  id = 906;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Landwirt')  WHERE  id = 906;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter')  WHERE  id = 908;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Landwirt')  WHERE  id = 908;

UPDATE `personen` SET `Kategorien` = 'Pächter' WHERE `ID` = '625';

UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.30'  WHERE  id = 64;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.58'  WHERE  id = 72;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = ''  WHERE  id = 73;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.48'  WHERE  id = 94;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.22'  WHERE  id = 100;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.14'  WHERE  id = 135;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.27'  WHERE  id = 202;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.18'  WHERE  id = 220;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.42'  WHERE  id = 265;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.3'  WHERE  id = 277;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.23'  WHERE  id = 287;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1341.1.20'  WHERE  id = 393;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.39'  WHERE  id = 493;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.28'  WHERE  id = 495;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.53'  WHERE  id = 498;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.44'  WHERE  id = 521;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.63'  WHERE  id = 522;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = 'Keine'  WHERE  id = 524;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.26'  WHERE  id = 572;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = 'Keine'  WHERE  id = 587;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.24;1349.1.13 (vom Felix)'  WHERE  id = 608;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = 'Keine'  WHERE  id = 609;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.20'  WHERE  id = 627;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1342.1.7'  WHERE  id = 628;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1347.1.41'  WHERE  id = 637;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1341.1.32'  WHERE  id = 638;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.46'  WHERE  id = 684;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.9'  WHERE  id = 693;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.45'  WHERE  id = 723;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.35'  WHERE  id = 740;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.37'  WHERE  id = 802;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.21'  WHERE  id = 832;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.54'  WHERE  id = 905;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1348.1.24'  WHERE  id = 906;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = 'Unbekannt'  WHERE  id = 908;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1347.1.44'  WHERE  id = 990;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.5'  WHERE  id = 1076;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1346.1.9'  WHERE  id = 1112;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.57'  WHERE  id = 1113;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.65'  WHERE  id = 1114;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1342.1.70'  WHERE  id = 1115;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1348.1.29'  WHERE  id = 1116;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.33'  WHERE  id = 1117;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = '1349.1.15'  WHERE  id = 1118;
UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = ''  WHERE  id = 1119;

Select ID, Bemerkungen FROM personen WHERE ID IN (277, 495, 637, 802, 905, 908);
UPDATE `personen` SET Bemerkungen = 'GG mit Sohn: Thomas'  WHERE  id = 277;
UPDATE `personen` SET Vorname = 'Josef', Bemerkungen = 'Vater: Fritz'  WHERE  id = 495;
UPDATE `personen` SET Bemerkungen = '055 445 15 63 (Vater?)'  WHERE  id = 637;
UPDATE `personen` SET Bemerkungen = 'Vertrag erneuern 01.01.26'  WHERE  id = 802;
UPDATE `personen` SET Bemerkungen = 'Bewirtschafter Schweinestall Hauhusengasse Wangen, Sohn: Roman Marty, Sonnenriedstr. 8, Wangen, 055 440 54 69 

P: 055 440 74 49 
G: 055 440 19 88
Büelstr. 3, 8854 Siebnen'  WHERE  id = 905;
UPDATE `personen` SET Bemerkungen = 'Bewirtschafter, bzw. inoffizieller Unterpächter, bewirtschaftet die Fläche von Albin Marty mehr oder weniger komplett eigenständig, hat aber keinen Pachtvertrag und erhält keine Dirketzahlungen'  WHERE  id = 908;

-- UPDATE `personen` SET Kategorien = removeSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = ''  WHERE  id = 1112;
-- UPDATE `personen` SET Kategorien = removeSetValue(Kategorien, 'Pächter'), `Betriebs_Nr` = ''  WHERE  id = 135;
             
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Cleanups
-- ========
UPDATE `personen` SET `Firma` = ''            WHERE (`Firma`            IS NULL OR `Firma` = ' ');
UPDATE `personen` SET `Partner_Name`     = '' WHERE (`Partner_Name`     IS NULL OR `Partner_Name` = ' ');
UPDATE `adressen` SET `Hausnummer`       = '' WHERE (`Hausnummer`       IS NULL OR `Hausnummer` = ' ');
UPDATE `adressen` SET `Postfachnummer`   = '' WHERE (`Postfachnummer`   IS NULL OR `Postfachnummer` = ' ');

-- Tests
-- =====
SELECT * FROM Bewirtschafter WHERE ID IN (1116, 1119, 493, 64);
SELECT * FROM personen_daten WHERE ID IN (1116, 1119, 493, 64);
SELECT * FROM Personen       WHERE ID IN (1116, 1119, 493, 64);

/*
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
              (5, '8858', 'Innerthal'),
              (6, '8610', 'Uster'),
              (7, '8855', 'Nuolen'),
              (8, '8862', 'Schübelbach'),
              (9, '8857', 'Vorderthal'),
              (10, '8852', 'Altendorf'),
              (11, '8856', 'Tuggen');

     
DELETE FROM `adressen`;
INSERT INTO `adressen` (`id`, `Strasse`, `Hausnummer`, `Orte_id`) 
       VALUES (1, 'Peterliwiese', '33' ,  1),
              (2, 'Etzelstrasse',  '7' ,  1),
              (3, 'Kapellstr.'  ,  '5' ,  2),
              (4, 'Leuholz'     , '12' ,  1),
              (5, 'Aberen'      , ''   ,  5),
              (6, 'Linthgasse'  , '30',  7),
              (7, 'Krämacherstr.', '15',  6),
              (8, 'Seestr.', 'xx',  1),
              (9, 'Galtbrunnen',  '8' ,  1);
              
DELETE FROM `personen`;
INSERT INTO `personen` (`id`, `Sex`,`Privat_Adressen_id`, `Geschaefts_Adressen_id`, `Firma`,`Vorname`,`Vorname_2`,`Ledig_Name`,`Partner_Name`,`Partner_Name_Angenommen`,`Zivilstand`,`AHV_Nr`,`Betriebs_Nr`,`Geburtstag`,`Kategorien`) 
       VALUES (1,'Herr',1,7,   NULL,'Walter','Max','Rothlin' ,'Collet' , True,  'Verheiratet', '756.2534.0047.47', NULL, '1960-8-5', 'Buerger,Genossenrat,Waermebezueger'),
              (2,'Frau',1,NULL,NULL,'Claudia',NULL,'Collet'  ,'Rothlin', False, 'Verheiratet', '756.1251.5642.06', NULL, '1965-11-14', NULL),
              (5,'Herr',2,NULL,NULL,'Walter',NULL,'Rothlin'  ,'Meier'  , True,  'Verheiratet', NULL, NULL, '1936-10-12', 'Buerger,Landteilbesitzer,Waermebezueger'),
              (3,'Herr',1,NULL,NULL,'Tobias',NULL,'Rothlin'  ,NULL     , NULL,  'Ledig'      , '756.8382.6137.80', '1996-7-31', NULL,'Buerger'),
              (4,'Herr',1,NULL,NULL,'Lukas' ,NULL,'Rothlin'  ,NULL     , NULL,  'Ledig'      , '756.9954.2911.39', '1999-11-29', NULL,'Buerger'),
              (6,'Herr',3,NULL,NULL,'Remo'  ,NULL,'Collet'   ,'Troxler', True,  'Verwitwed'  , NULL,NULL,NULL, NULL),
              (7,NULL,4,NULL,'Genossame Wangen'    ,NULL ,NULL,NULL,NULL, NULL,NULL,NULL,NULL,NULL, NULL),
              (8,NULL,5,NULL,'Flurgenossenschaft'  ,NULL ,NULL,NULL,NULL, NULL,NULL,NULL,NULL,NULL, NULL),
              (9,NULL,8,NULL,'Feuerwehrverein'     ,NULL ,NULL,NULL,NULL, NULL,NULL,NULL,NULL,NULL, NULL),
              (10,'Frau',6,NULL,NULL,'Verena',NULL,'Bruhin','Mächler',True,'Verwitwed',NULL,'139.1.46', NULL,'Bewirtschafter,Landwirt'),
              (11,'Herr',9,NULL,NULL,'Urs',NULL,'Bruhin'  ,'Deuber'  , True,  'Verheiratet', NULL, NULL,NULL, 'Buerger,Landteilbesitzer');

              
-- SELECT * FROM `personen` WHERE FIND_IN_SET('Buerger',`Kategorien`)>0;
-- SELECT * FROM `personen` WHERE `Kategorien` LIKE '%Buerger%';


DELETE FROM `email_adressen`;
INSERT INTO `email_adressen` (`id`, `eMail`, `Type`, `prio`) 
       VALUES (1, 'walter@rothlin.com',                  'Private',   1),
              (2, 'walter.rothlin@bzu.ch',               'Schule',    2),
              (3, 'landwirtschaft@genossame-wangen.ch',  'Genossame', 3),
              (4, 'tobias@rothlin.com',  'Private', 1),
              (5, 'claudia@rothlin.com',  'Private', 1);
              
DELETE FROM `Personen_has_EMail_Adressen`;
INSERT INTO `Personen_has_EMail_Adressen` (`id`, `Personen_id`, `EMail_Adressen_id`) 
       VALUES (1, 1, 1),
              (2, 1, 2),
              (3, 1, 3),
              (4, 3, 4),
              (5, 2, 5);

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


               
DELETE FROM `landteil`;
INSERT INTO `landteil` (`id`,`AV_Parzellen_Nr`,`GENO_Parzellen_Nr`,`Flur_Bezeichnung`,`Flaeche_In_Aren`,`Buergerlandteil`,`Polygone_Flaeche`,`Vertragsende`,`Rueckgabe_Am`,`Paechter_Adresse`,`Verpaechter_Adresse`) 
        VALUES (1,'233.100','233.100.1','Winkelhöfli',36,NULL,NULL,Null,'2018-12-31',10,7),
               (2,'233.100','233.100.2','Winkelhöfli',16,'16a',NULL,Null,Null,       10,11);
               
-- ----------------------------------------------------------------
-- Testen der Views
-- ----------------------------------------------------------------

SELECT * FROM Ort_Land;
SELECT * FROM Personen_Daten;
SELECT * FROM EMail_Main;
*/