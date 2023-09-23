SELECT * FROM personen WHERE ID IN (213);
SELECT * FROM telefonnummern WHERE ID in (SELECT Telefonnummern_ID FROM personen_has_telefonnummern WHERE Personen_ID IN (213));
SELECT * FROM iban WHERE Personen_ID in (644, 213);

SELECT ID, Vorname_Initial, Familien_Name,Geburtstag,Tel_Nr_Detail_Long, IBAN_Detail_Long 
FROM personen_daten 
WHERE ID IN (204,213,644);

SELECT * FROM personen_has_email_adressen WHERE Personen_ID IN (826);

SELECT * FROM email_adressen WHERE ID in (139);

SELECT * FROM email_adressen WHERE ID = 139;
SELECT * FROM personen WHERE ID IN (574);
SELECT * FROM personen_daten WHERE ID IN (574);


UPDATE `personen` SET `Partner_ID` = 644 WHERE (`ID` = 1172);
UPDATE `personen` SET `Partner_ID` = '1172' WHERE (`ID` = '644');
UPDATE `personen` SET `Vater_ID` = '223'    WHERE (`ID` = '644');

UPDATE `personen` SET `Vater_ID` = '644'   WHERE (`ID` = '1103');
UPDATE `personen` SET `Mutter_ID` = '1172' WHERE (`ID` = '1103');



SELECT * FROM personen_has_email_adressen WHERE EMail_Adressen_ID = 287;
-- DELETE FROM `personen_has_email_adressen` WHERE (`Personen_ID` = '1082') and (`EMail_Adressen_ID` = '287');

SELECT * FROM email_adressen WHERE ID = 287;
-- DELETE FROM `email_adressen` WHERE (`ID` = '287');

SELECT * FROM email_adressen WHERE eMail LIKE 'fehler:%';
-- DELETE FROM `personen_has_email_adressen` WHERE `EMail_Adressen_ID` IN (SELECT ID FROM email_adressen WHERE eMail LIKE 'fehler:%');
-- DELETE FROM email_adressen WHERE eMail LIKE 'fehler:%';

SELECT * FROM `personen_has_email_adressen` WHERE `Personen_ID` = 1172 AND `EMail_Adressen_ID` = 485;

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