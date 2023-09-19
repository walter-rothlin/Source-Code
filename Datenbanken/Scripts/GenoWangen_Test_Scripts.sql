SELECT ID, Vorname_Initial, Familien_Name,eMail_Detail_Long,eMail_1_Detail_Long,eMail_2_Detail_Long FROM personen_daten WHERE ID IN (660,97,164,669,336,470);
SELECT * FROM email_adressen WHERE ID = 484;
SELECT * FROM personen WHERE ID IN (574);
SELECT * FROM personen_daten WHERE ID IN (574);


UPDATE `personen` SET `Partner_ID` = 644 WHERE (`ID` = 1172);
UPDATE `personen` SET `Partner_ID` = '1172' WHERE (`ID` = '644');
UPDATE `personen` SET `Vater_ID` = '223'    WHERE (`ID` = '644');

UPDATE `personen` SET `Vater_ID` = '644'   WHERE (`ID` = '1103');
UPDATE `personen` SET `Mutter_ID` = '1172' WHERE (`ID` = '1103');



SELECT * FROM personen_has_email_adressen WHERE EMail_Adressen_ID = 287;
DELETE FROM `personen_has_email_adressen` WHERE (`Personen_ID` = '1082') and (`EMail_Adressen_ID` = '287');

SELECT * FROM email_adressen WHERE ID = 287;
DELETE FROM `email_adressen` WHERE (`ID` = '287');

SELECT * FROM email_adressen WHERE eMail LIKE 'fehler:%';
DELETE FROM `personen_has_email_adressen` WHERE `EMail_Adressen_ID` IN (SELECT ID FROM email_adressen WHERE eMail LIKE 'fehler:%');
DELETE FROM email_adressen WHERE eMail LIKE 'fehler:%';

SELECT * FROM `personen_has_email_adressen` WHERE `Personen_ID` = 1172 AND `EMail_Adressen_ID` = 485;