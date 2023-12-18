

Select * from ERROR_Table; -- Just to produce an error when the whole script has been executed!

-- Personen Verwandtschaft
-- -----------------------
UPDATE `personen` SET `Partner_ID`  = 644      WHERE `ID`  = 1172;   -- Partner von Claudia		is 	Walti
SELECT ID, Vorname_Initial, Familien_Name, Partner_ID, Mutter_ID, Vater_ID 
FROM Personen_Daten 
WHERE ID in (644, 1172, 223, 1103,1216,1217,1218,1219,1220,1221,1222,1223,1224,1225,1226,1227);

Select * FROM Personen_Daten WHERE ID = 644;

SELECT 
    ID,
    Vorname_Initial,
    Familien_Name,
    Geburtstag,
    Todestag,
    Partner_ID,
    Partner_Reference,
    Mutter_ID,
    Mutter_Reference,
    Vater_ID,
    Vater_Reference
FROM Personen_Daten       
WHERE Partner_ID IS NOT NULL OR
	  Mutter_ID  IS NOT NULL OR
      Vater_ID   IS NOT NULL
ORDER BY Last_Name, Vorname;   

SELECT ID, Vorname, Ledig_name, Partner_name, Partner_ID, Vater_ID, Mutter_ID FROM personen       WHERE ID IN (771,917,772,1014,224,226,227,235,221,445);


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
WHERE ID IN ((SELECT ID FROM personen_daten WHERE Such_Begriff LIKE Binary '%%' AND Such_Begriff LIKE Binary '%Mühlestr. 3a%'))
ORDER BY Familien_Name;

SELECT * from personen WHERE Privat_Adressen_ID IN (SELECT ID FROM adressen WHERE (
                               adressen.strasse  = 'Falkenstr' AND adressen.hausnummer = '9' AND adressen.orte_id = 2) OR
							  (adressen.strasse = CONCAT('Falkenstr', ' ', '9')             AND adressen.orte_id = 2)
                              );

SELECT * FROM personen_daten WHERE ID IN (1126);
SELECT * FROM personen       WHERE ID IN (771,917,772,1014,224,226,227,235,221,445);

SELECT * FROM personen WHERE ID IN (285, 1084);                   -- 285, 1084, Wegzug unklar; In Abklärung beim Schreiber; 285 hat Landteil noch bei Edgar Hüppin
SELECT * FROM personen_daten WHERE Bemerkungen != '' AND Bemerkungen LIKE '%weg%';
    
SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (289));


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

-- Adressen bereinigen (double Adresses)
-- -------------------------------------
SELECT * FROM `adressen` WHERE ID in (399, 673);

SELECT ID, 'Personen', Vorname, Ledig_Name, Privat_Adressen_ID, Geschaefts_Adressen_ID  
FROM `personen` WHERE Privat_Adressen_ID     in (399, 673) OR
					  Geschaefts_Adressen_ID in (399, 673)
UNION
SELECT ID, 'Durchleitungsrecht', '', '', Standort_Adresse_ID, ''  
FROM `Durchleitungsrechte` WHERE Standort_Adresse_ID     in (399, 673)
UNION
SELECT ID, 'Wärmeanschlüsse', '', '', Standort_Adresse_ID, ''  
FROM `Wärmeanschlüsse` WHERE Standort_Adresse_ID     in (399, 673);
                      
                             
UPDATE `personen` SET `Privat_Adressen_ID`     = 399 WHERE Privat_Adressen_ID     in (673);
UPDATE `personen` SET `Geschaefts_Adressen_ID` = 399 WHERE Geschaefts_Adressen_ID in (673);

DELETE FROM `adressen` WHERE ID in (673);


SELECT * FROM `adressen` WHERE Strasse LIKE '%Zürcherstr.%';                  


-- telnr
-- -----
SELECT * FROM personen_has_telefonnummern WHERE Personen_ID IN (840);
SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (840)) Order by Prio;

DELETE FROM personen_has_telefonnummern WHERE Telefonnummern_ID = 155;
DELETE FROM telefonnummern WHERE ID = 155;

SELECT * FROM telefonnummern WHERE Nummer = '4804183';


-- email
-- -----
SELECT * FROM email_adressen WHERE ID in (SELECT EMail_Adressen_ID FROM personen_has_email_adressen WHERE Personen_ID IN (1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223)) Order by Prio;




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

/*
        SELECT
            ID AS ID,
             Anrede_Long_Long                                   AS Anrede,
             Private_Strassen_Adresse                           AS Strasse,
             CONCAT(Private_PLZ_International,' ',Private_Ort)  AS PLZ_Ort
        FROM Personen_Daten 
        WHERE Such_Begriff LIKE BINARY '%Vogt%' AND 
              Such_Begriff LIKE BINARY '%Na%' AND 
              Such_Begriff LIKE BINARY '%%'
        ORDER BY Familien_Name, Vorname;
*/