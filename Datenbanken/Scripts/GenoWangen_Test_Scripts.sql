UPDATE `personen` SET `Partner_ID`  = 644   WHERE `ID` = 1172;   -- Partner von Claudia		is 	Walti
UPDATE `personen` SET `Partner_ID`  = '1172'  WHERE `ID` = '644';    -- Partner von Walti   	is 	Claudia
UPDATE `personen` SET `Vater_ID`    = '644'   WHERE `ID` = '1103';   -- Vater   von Tobias     	is  Walti
UPDATE `personen` SET `Vater_ID`    = '223'    WHERE (`ID` = '644');
UPDATE `personen` SET `Mutter_ID`   = '1172'  WHERE `ID` = '1103';   -- Mutter  von Tobias     	is  Claudia



SELECT *
	-- ID, Vorname_Initial, Familien_Name, Private_Strassen_Adresse, Private_PLZ_Ort, Geburtstag,
	-- eMail_Detail_Long, Tel_Nr_Detail_Long, IBAN_Detail_Long 
FROM personen_daten 
-- WHERE ID IN (1176, 1177, 804, 996, 348, 1179) OR ID IN ((SELECT ID FROM personen_daten WHERE Such_Begriff LIKE Binary '%Vogt%' AND Such_Begriff LIKE Binary '%Urs%'))
WHERE ID IN ((SELECT ID FROM personen_daten WHERE Such_Begriff LIKE Binary '%Myrtha%' AND Such_Begriff LIKE Binary '%%'))
ORDER BY Familien_Name;

SELECT * FROM personen WHERE ID IN (171,193,555,561,619,785);  --  c/o Adressen
SELECT * FROM personen WHERE ID IN (552, 785, 137, 549);       --  Bemerkungen: Wegzug infolge Einschränkung
SELECT * FROM personen WHERE ID IN (644,1103,934,1045);        -- Testpersonen für Rückkehrer und Wegzüger




SELECT * FROM personen_daten WHERE ID IN (396,1026,1087,839,217); -- Mutationen vom 12.10.23

SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (723));
SELECT * FROM iban WHERE Personen_ID in (644, 213);

-- Adressen
-- --------
SELECT * FROM adressen;

SELECT * FROM adressen
-- WHERE Strasse LIKE '%Zürcherstr.%';
WHERE ID IN (715);

SELECT * FROM adressen WHERE (adressen.strasse  = 'Falkenstr.' AND adressen.hausnummer = '9' AND adressen.orte_id = 2) OR
							  (adressen.strasse = CONCAT('Falkenstr', ' ', '9')             AND adressen.orte_id = 2);
                              
SELECT * from personen WHERE ID IN (508, 585, 716, 390, 831, 248,610,193);
SELECT * from personen WHERE ID IN (1108);

SELECT * from personen WHERE Privat_Adressen_ID IN (SELECT ID FROM adressen WHERE (
                               adressen.strasse  = 'Falkenstr' AND adressen.hausnummer = '9' AND adressen.orte_id = 2) OR
							  (adressen.strasse = CONCAT('Falkenstr', ' ', '9')             AND adressen.orte_id = 2)
                              );

-- email
-- -----
SELECT * FROM personen_has_email_adressen WHERE Personen_ID IN (826);

SELECT * FROM email_adressen WHERE ID in (139);

SELECT * FROM email_adressen WHERE ID = 139;
SELECT * FROM personen WHERE ID IN (574);
SELECT * FROM personen_daten WHERE ID IN (574);



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

SELECT * FROM `personen_has_email_adressen` WHERE `Personen_ID` = 1172 AND `EMail_Adressen_ID` = 485;

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


