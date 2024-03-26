

Select * from ERROR_Table; -- Just to produce an error when the whole script has been executed!

SELECT * FROM table_meta_data WHERE `Table` = 'Personen' AND Attr_Type in ('enum','set');
      

-- Landteile
-- ---------
SELECT * FROM personen WHERE FIND_IN_SET('Hat_16a', Kategorien) >  0;
SELECT * FROM personen WHERE FIND_IN_SET('Hat_35a', Kategorien) >  0;

SELECT * FROM landteile WHERE Verpaechter_ID IN (341);   
SELECT * FROM pachtlandzuteilung WHERE Verpaechter_ID IN (341);
      
SELECT count(*) FROM `Landteile` WHERE Verpaechter_ID != 625;  -- 182
SELECT count(*) FROM Verpächter WHERE FIND_IN_SET('Hat_16a', Kategorien) >  0;   -- 84
SELECT count(*) FROM Verpächter WHERE FIND_IN_SET('Hat_35a', Kategorien) >  0;   -- 97

SELECT Verpaechter_ID FROM `Landteile` WHERE Verpaechter_ID != 625;
SELECT * FROM `Landteile` WHERE Verpaechter_ID NOT IN (SELECT ID FROM Verpächter WHERE FIND_IN_SET('Hat_16a', Kategorien) >  0 OR FIND_IN_SET('Hat_35a', Kategorien));


SELECT * FROM Verpächter WHERE ID NOT IN (SELECT Verpaechter_ID FROM `Landteile` WHERE Verpaechter_ID != 625);
SELECT * FROM pachtlandzuteilung WHERE Verpaechter_ID NOT IN (SELECT Verpaechter_ID FROM `Landteile` WHERE Verpaechter_ID != 625);
SELECT * FROM Verpächter WHERE ID != 625;
      
SELECT * FROM Pachtlandzuteilung;
SELECT ID FROM pächter;

SELECT * FROM buergerteile;   -- WHERE Flaeche != 16.0 and Flaeche != 35.0;

SELECT DISTINCT Paechter_ID FROM Pachtlandzuteilung ORDER BY Paechter_ID;
SELECT ID FROM pächter;

-- Pächter ohne Pachtland
SELECT 'Pächter ohne Pachtland' AS Status, ID AS ID, Kategorien, Vorname, Name, Adresse, Ort
FROM pächter
WHERE ID NOT IN (SELECT DISTINCT Paechter_ID FROM Pachtlandzuteilung)
UNION
-- Haben Pachtland ohne den Pächter-Status zu haben
SELECT 'Nicht Pächter-Status' AS Status, Paechter_ID  AS ID, Paechter_Kategorien, Paechter_Vorname, Paechter_Name, Paechter_Strasse, Paechter_PLZ_Ort
FROM Pachtlandzuteilung
WHERE Paechter_ID NOT IN (SELECT ID FROM pächter)
ORDER BY Status, ID;


SELECT MAX(ID) + 1 AS MAX_ID INTO @max_value FROM landteile;
SELECT @max_value;   -- 701
-- ALTER TABLE landteile AUTO_INCREMENT = 702;


SELECT *
	-- ID, Vorname_Initial, Familien_Name, Private_Strassen_Adresse, Private_PLZ_Ort, Geburtstag,
	-- eMail_Detail_Long, Tel_Nr_Detail_Long, IBAN_Detail_Long 
FROM personen_daten 
-- WHERE ID IN (1176, 1177, 804, 996, 348, 1179) OR ID IN ((SELECT ID FROM personen_daten WHERE Such_Begriff LIKE Binary '%Vogt%' AND Such_Begriff LIKE Binary '%Urs%'))
WHERE ID IN ((SELECT ID FROM personen_daten WHERE Such_Begriff LIKE Binary '%Isabella%' AND Such_Begriff LIKE Binary '%Vogt%'))
ORDER BY Familien_Name;


SELECT * 
FROM personen 
WHERE FIND_IN_SET(Kategorien, 'Angestellter') >  0;

SELECT * FROM personen WHERE ID >= (SELECT max(id) FROM personen) - 10;
SELECT * FROM personen WHERE ID >= 1236;
SELECT * FROM personen_daten WHERE Such_Begriff LIKE Binary '%Muster%' OR ID >= (SELECT max(id) FROM personen) - 10;
SELECT * FROM personen_daten WHERE Such_Begriff LIKE Binary '%Muster%';


SELECT * from personen WHERE Privat_Adressen_ID IN (SELECT ID FROM adressen WHERE (
                               adressen.strasse  = 'Falkenstr' AND adressen.hausnummer = '9' AND adressen.orte_id = 2) OR
							  (adressen.strasse = CONCAT('Falkenstr', ' ', '9')             AND adressen.orte_id = 2)
                              );

SELECT * FROM personen_daten WHERE ID IN (1078);
SELECT * FROM personen       WHERE ID IN (771,917,772,1014,224,226,227,235,221,445);

SELECT * FROM personen WHERE ID IN (285, 1084);                   -- 285, 1084, Wegzug unklar; In Abklärung beim Schreiber; 285 hat Landteil noch bei Edgar Hüppin
SELECT * FROM personen_daten WHERE Bemerkungen != '' AND Bemerkungen LIKE '%weg%';
    
SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (289));

-- Passwords
-- ---------

SELECT *
FROM personen_daten 
WHERE ID IN ((SELECT ID FROM personen_daten WHERE Such_Begriff LIKE Binary '%Hansjörg%' AND Such_Begriff LIKE Binary '%Hüppin%'));


SELECT
   Pers_ID,
   eMail_adresse,
   Prio
FROM email_liste 
WHERE Pers_ID IN (644, 533, 202, 1125, 1120, 1121);

SELECT Pers_id FROM email_liste WHERE email_adresse = 'walter@rothlin.com';
SELECT ID, `Password` FROM personen WHERE ID=644;

SELECT * FROM priviliges;
SELECT * FROM personen_has_priviliges;

SELECT * FROM app_priviliges;



        
-- IBAN
-- ----
UPDATE `IBAN` SET `Lautend_auf` = ''  WHERE `Lautend_auf` IS NULL;
SELECT * FROM iban_liste WHERE Pers_ID IN (895, 471, 126, 1078, 644);
SELECT * FROM IBAN WHERE Personen_ID IN (895, 471, 126, 1078, 644);
SELECT ID, Vorname_Name, IBAN FROM Personen_Daten WHERE ID in (1081);
SELECT * FROM Personen_Daten WHERE (IBAN is NULL or IBAN = '') AND  FIND_IN_SET('Nutzungsberechtigt', Kategorien) >  0; -- Nutzungsberechtigte ohne IBAN
SELECT ID, Personen_ID, Nummer FROM iban WHERE Nummer NOT LIKE '% %' OR Nummer LIKE BINARY 'c%';                        -- Schlecht formatierte IBAN


-- Mutationen
-- ----------
SELECT * FROM Personen_Daten WHERE ID in (1125,1183,877);
SELECT * FROM Personen_Daten WHERE ID in (1083,204,585, 1103);                   -- Mutationen vom 15.11.23
SELECT * FROM Personen_Daten WHERE ID in (657, 1091, 815, 1035, 483, 428, 606);  -- Mutationen vom 17.11.23
SELECT * FROM Personen_Daten WHERE ID in (974, 437, 670, 357);                   -- Mutationen vom 11.12.23
SELECT * FROM Personen_Daten WHERE ID in (986,1107);                             -- Mutationen vom 13.12.23
SELECT * FROM Personen_Daten WHERE ID in (385, 840);  -- Falsch mutierte Bürger
SELECT * FROM Personen_Daten WHERE ID in (1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223);  -- Neubürger 13.12.23
SELECT * FROM Personen_Daten WHERE ID in (1224,1225,1226,1227);                             -- Neubürger 17.12.23
SELECT * FROM Personen_Daten WHERE ID in (840, 1058,1037,1104,615,1043,1088, 535);          -- Mutationen vom 17.12.23
SELECT * FROM Personen_Daten WHERE ID in (1228, 585, 226);                                  -- Mutationen vom 18.12.23
SELECT * FROM Personen_Daten WHERE ID in (838, 1096, 1036, 1029, 523, 606, 757);                                  -- Mutationen vom 26.12.23
SELECT * FROM Personen_Daten       WHERE ID in (1029);  -- 1029 Rückkehrer 2023 aber zu spät angemeldet
SELECT * FROM Personen       WHERE ID in (1109);  -- 1029 Rückkehrer 2023 aber zu spät angemeldet
SELECT * FROM Personen_Daten WHERE ID in (644);
SELECT * FROM Personen WHERE ID in (533, 644);


SELECT * FROM Personen       WHERE ID in (1058, 1045, 1108, 877, 1037, 1104, 546, 1083);  -- Wegzüger 2023
SELECT * FROM Personen       WHERE ID in (934, 1029);   -- Rückkehrer 2023
SELECT * FROM Personen       WHERE ID in (1216, 1225, 1220, 1223, 1226, 1219, 1222, 1221, 1228, 1217, 1224, 1227, 1218); -- Neubürger 2024
SELECT * FROM Personen       WHERE ID in (1216, 1241, 1242); -- Nachgemeldete Neubürger 2024
SELECT * FROM Personen       WHERE ID in (609, 1035);  -- Waisen Timi Vogt fehlt noch! Was ist mit behindertem Sohn von Marianne + Marcel?


-- Adressen bereinigen (double Adresses)
-- -------------------------------------
SELECT * FROM `adressen` WHERE ID in (733, 734);
SELECT * FROM `adressen`  WHERE Strasse LIKE Binary '%Zürcherstr.%' AND Orte_ID=2;

SELECT ID, 'Personen', Vorname, Ledig_Name, Privat_Adressen_ID, Geschaefts_Adressen_ID  
FROM `personen` WHERE Privat_Adressen_ID     in (733, 734) OR
					  Geschaefts_Adressen_ID in (733, 734)
UNION
SELECT ID, 'Durchleitungsrecht', '', '', Standort_Adresse_ID, ''  
FROM `Durchleitungsrechte` WHERE Standort_Adresse_ID     in (733, 734)
UNION
SELECT ID, 'Wärmeanschlüsse', '', '', Standort_Adresse_ID, ''  
FROM `Wärmeanschlüsse` WHERE Standort_Adresse_ID     in (733, 734);
                      
                             
UPDATE `personen` SET `Privat_Adressen_ID`     = 733 WHERE Privat_Adressen_ID     in (734);
UPDATE `personen` SET `Geschaefts_Adressen_ID` = 733 WHERE Geschaefts_Adressen_ID in (734);

DELETE FROM `adressen` WHERE ID in (734);


SELECT * FROM `adressen` WHERE Strasse LIKE '%Althof%';                  


-- telnr
-- -----
SELECT * FROM personen_has_telefonnummern WHERE Personen_ID IN (585);
SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (757)) Order by Prio;

DELETE FROM personen_has_telefonnummern WHERE Telefonnummern_ID = 155;
DELETE FROM telefonnummern WHERE ID = 155;

SELECT * FROM telefonnummern WHERE Nummer = '4804183';


-- email
-- -----
SELECT * FROM email_adressen WHERE ID in (SELECT EMail_Adressen_ID FROM personen_has_email_adressen WHERE Personen_ID IN (1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223)) Order by Prio;
SELECT Pers_id
FROM email_liste 
WHERE eMail_Adresse = 'isabella.vogt@bluewin.ch';
-- WHERE eMail_Adresse = 'walter@rothlin.com';
-- WHERE eMail_Adresse = 'landwirtschaft@genossame-wangen.ch';
select * from email_adressen WHERE id >= 535;


SELECT * FROM email_adressen WHERE eMail LIKE '%eugen.bruhin%';
SELECT * FROM personen_has_email_adressen WHERE EMail_Adressen_ID = 304 or EMail_Adressen_ID = 557;

-- IBAN
-- ----
select * from iban WHERE id >= 776;
DELETE FROM `iban` WHERE `ID` = '776';

-- TelNr
-- -----
SELECT * FROM telefonnummern WHERE Nummer = '4804183';
SELECT * FROM personen_has_telefonnummern WHERE Personen_ID = 120;

SELECT * FROM email_adressen WHERE email LIKE '%Rothlin%';
SELECT * FROM personen_has_email_adressen WHERE Personen_ID IN (1125,1183);


SELECT Strassen_Adresse_Ort FROM adress_daten GROUP BY Strassen_Adresse_Ort Having count(*) > 1;  # alle doppelten Einträget
SELECT * FROM adress_daten WHERE Strassen_Adresse_Ort in ('Allmeindstr. 32:     8855:Wangen', 'Löwenfeld 7:     8855:Wangen');

SELECT * FROM adress_daten WHERE Strassen_Adresse_Ort in ((SELECT Strassen_Adresse_Ort FROM adress_daten GROUP BY Strassen_Adresse_Ort Having count(*) > 1));

SELECT * FROM personen_has_email_adressen WHERE EMail_Adressen_ID = 287;
-- DELETE FROM `personen_has_email_adressen` WHERE (`Personen_ID` = '1082') and (`EMail_Adressen_ID` = '287');

SELECT * FROM email_adressen WHERE ID = 287;
-- DELETE FROM `email_adressen` WHERE (`ID` = '287');

SELECT * FROM email_adressen WHERE eMail LIKE 'fehler:%';
-- DELETE FROM `personen_has_email_adressen` WHERE `EMail_Adressen_ID` IN (SELECT ID FROM email_adressen WHERE eMail LIKE 'fehler:%');
-- DELETE FROM email_adressen WHERE eMail LIKE 'fehler:%';

SELECT * FROM `personen_has_email_adressen` WHERE `Personen_ID` = 644 AND `EMail_Adressen_ID` = 485;

-- Reset Auto-Increment to max + 1
/*
SELECT MAX(ID) INTO @max_value FROM adressen;
SELECT @max_value;   -- 701
ALTER TABLE adressen AUTO_INCREMENT = 702;
*/

SELECT * FROM personen WHERE FIND_IN_SET('GPK', Kategorien) >  0 OR
							 FIND_IN_SET('Genossenrat', Kategorien) >  0 OR
							 FIND_IN_SET('LWK', Kategorien) >  0 OR
							 FIND_IN_SET('Forst_Komm', Kategorien) >  0;
