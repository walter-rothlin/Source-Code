
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

UPDATE personen AS p1
JOIN (
    SELECT ID, removeSetValue(Kategorien, 'Hat_35a') AS replaceSetValue
    FROM personen
    WHERE FIND_IN_SET('Hat_35a', Kategorien) > 0
) AS subquery
ON p1.ID = subquery.ID
SET p1.Kategorien = subquery.replaceSetValue;


SELECT MAX(ID) + 1 AS MAX_ID INTO @max_value FROM landteile;
SELECT @max_value;   -- 701
-- ALTER TABLE landteile AUTO_INCREMENT = 702;




-- Personen
-- --------
UPDATE `personen` SET `Partner_ID`  = 644   WHERE `ID` = 1172;   -- Partner von Claudia		is 	Walti
UPDATE `personen` SET `Partner_ID`  = '1172'  WHERE `ID` = '644';    -- Partner von Walti   	is 	Claudia
UPDATE `personen` SET `Vater_ID`    = '644'   WHERE `ID` = '1103';   -- Vater   von Tobias     	is  Walti
UPDATE `personen` SET `Vater_ID`    = '1172'   WHERE `ID` = '1103';   -- Mutter  von Tobias     	is  Claudia
UPDATE `personen` SET `Vater_ID`    = '223'    WHERE (`ID` = '644');


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

SELECT * FROM personen_daten WHERE ID IN (1035); -- sonstige temp Abfragen
SELECT * FROM personen       WHERE ID IN (1211,1212,1213,1214,1215); -- sonstige temp Abfragen

SELECT * FROM personen WHERE ID IN (285, 1084);                   -- 285, 1084, Wegzug unklar; In Abklärung beim Schreiber; 285 hat Landteil noch bei Edgar Hüppin
SELECT * FROM personen_daten WHERE Bemerkungen != '' AND Bemerkungen LIKE '%weg%';
    
SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (289));


-- IBAN
-- ----
SELECT * FROM Personen_Daten WHERE (IBAN is NULL or IBAN = '') AND  FIND_IN_SET('Nutzungsberechtigt', Kategorien) >  0; -- Nutzungsberechtigte ohne IBAN
SELECT ID, Personen_ID, Nummer FROM iban WHERE Nummer NOT LIKE '% %' OR Nummer LIKE BINARY 'c%';                        -- Schlecht formatierte IBAN
SELECT * FROM iban       WHERE Personen_ID IN (657, 1091, 815, 1035, 483, 428);     
SELECT * FROM iban_liste WHERE Pers_ID     IN (610,1107, 934,534,619,806,820,721,508,1101,1104,509);
SELECT * FROM iban WHERE Personen_ID in (534,509,721,820,806,1209,202,12.10,783,1208,644);
SELECT -- *
   ID, Vorname_Name, IBAN
FROM Personen_Daten WHERE ID in (657, 1091, 815, 1035, 483, 428);  -- Fehler bei IBAN


-- Mutationen
-- ----------
SELECT * FROM Personen_Daten WHERE ID in (534,509,721,820,806,1209,202,12.10,783,1208);
SELECT * FROM Personen_Daten WHERE ID in (1083,204,585, 1103);                   -- Mutationen vom 15.11.23
SELECT * FROM Personen_Daten WHERE ID in (657, 1091, 815, 1035, 483, 428, 606);  -- Mutationen vom 17.11.23

-- Adressen
-- --------
SELECT * FROM adressen;
SELECT * FROM adressen
-- WHERE Strasse LIKE '%Zürcherstr.%';
WHERE ID IN (715);                     


-- email/telnr
-- -----------
SELECT * FROM email_adressen WHERE ID in (SELECT EMail_Adressen_ID FROM personen_has_email_adressen WHERE Personen_ID IN (1211,1212,1213,1214,1215));
SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (1211,1212,1213,1214,1215,644));

SELECT * FROM telefonnummern WHERE Nummer = '4804183';
SELECT * FROM personen_has_telefonnummern WHERE Personen_ID = 120;

SELECT * FROM email_adressen WHERE email LIKE '%Rothlin%';
SELECT * FROM personen_has_email_adressen WHERE Personen_ID IN (826);


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


