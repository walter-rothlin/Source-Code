-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin 
-- Description: Aufgaben und Fragen zu Prüfung 2
--
-- History:
-- 24-Apr-2025   Walter Rothlin      Initial Version
-- 08-Jun-2025   Walter Rothlin      Added automated testing
-- 15-Jun-2025   Walter Rothlin      Changed it for BWI-A23
-- 16-Jun-2025   Walter Rothlin      Small corrections
-- 17-Jun-2025   Walter Rothlin      Small corrections
-- 03-Jun-2026   Walter Rothlin      Changed for BWI-A24
-- 26-Jun-2026   Walter Rothlin      Changed for BWI-A24
-- 30-Jun-2026   Vincenzo Nijboer    Loesung / Migrations-Script
-- ---------------------------------------------------------------------------------
-- -------------- Hier bitte ihre persönlichen Angaben erfassen --------------------

SET @Candidate_Firstname  := 'Vincenzo';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Nijboer';   -- Durch ihren Namen ersetzen
SET @Class                := 'BWI-A24';   -- z.B. BWI-A23


SET @Test_Name            := 'DB_Prüfung_2c';  -- NICHT ändern
SET @Test_Max_Punkte      := 15;               -- NICHT ändern

-- ---------------------------------------------------------------------------------
-- Default-Schema setzen
USE `pruefung_2`;

-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die "Personen_Liste" und erstellen Sie hier ein re-runable Migrations-Script.
-- (Vor einem erneuten Lauf das Schema + die Daten neu laden.)
--
-- Gehen Sie in folgenden Schritten vor (Test-Driven approach):

-- 1) Testdaten sammeln
-- ====================

-- 1.1) Wie viele Datensätze hat es in "Personen_Liste"?
SELECT COUNT(*) AS `Anzahl Datensätze`
FROM `Personen_Liste`;
-- 1169


-- 1.2) Wie viele Personen leben in 8855 Wangen?
SELECT COUNT(*) AS `Anzahl 8855 Wangen`
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- 703


-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
SELECT COUNT(DISTINCT `PLZ_Ort`) AS `Anzahl verschiedene PLZ_Ort`
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;
-- 82


-- 2) Entkoppeln der Rohdaten (Abwärtskompatibel über eine View)
-- =============================================================

-- 2.1) Renamen Sie "Personen_Liste" zu personen.
RENAME TABLE `Personen_Liste` TO `personen`;


-- 2.2) View "Personen_Liste" mit den gleichen Attributen erstellen.
--      Dieses Interface bleibt stabil, nur die Implementation der View wird angepasst.
CREATE OR REPLACE VIEW `Personen_Liste` AS
SELECT
    `ID`        AS `ID`,
    `Anrede`    AS `Anrede`,
    `Vorname`   AS `Vorname`,
    `Nachname`  AS `Nachname`,
    `Strasse`   AS `Strasse`,
    `PLZ_Ort`   AS `PLZ_Ort`,
    `Tel_Nr`    AS `Tel_Nr`,
    `eMail`     AS `eMail`
FROM `personen`;


-- 2.3) Verifizieren: gleiche Anzahlen wie in 1).
SELECT COUNT(*) AS `Anzahl Datensätze`
FROM `Personen_Liste`;
-- 1169

SELECT COUNT(*) AS `Anzahl 8855 Wangen`
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- 703

SELECT COUNT(DISTINCT `PLZ_Ort`) AS `Anzahl verschiedene PLZ_Ort`
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;
-- 82


-- 3) Normalisieren I: Strasse in Strassenname + Hausnummer aufteilen
-- =================================================================

-- 3.1) Attribut "Hausnummer" nach "Strasse" hinzufügen.
ALTER TABLE `personen`
    ADD COLUMN `Hausnummer` VARCHAR(100) NULL AFTER `Strasse`;


-- 3.2) Strasse aufteilen: Hausnummer = ab der ersten Ziffer, Strassenname = der Rest davor.
UPDATE `personen`
SET `Hausnummer` = TRIM(REGEXP_SUBSTR(`Strasse`, '[0-9].*$')),
    `Strasse`    = TRIM(REGEXP_REPLACE(`Strasse`, '[0-9].*$', ''));


-- 3.4) Attribut "Strasse" zu "Strassenname" umbenennen.
ALTER TABLE `personen`
    CHANGE COLUMN `Strasse` `Strassenname` VARCHAR(100) NULL;


-- 3.5) View anpassen, so dass "Strasse" wieder Strassenname und Hausnummer zeigt.
CREATE OR REPLACE VIEW `Personen_Liste` AS
SELECT
    `ID`                                          AS `ID`,
    `Anrede`                                      AS `Anrede`,
    `Vorname`                                     AS `Vorname`,
    `Nachname`                                    AS `Nachname`,
    CONCAT_WS(' ', `Strassenname`, `Hausnummer`)  AS `Strasse`,
    `PLZ_Ort`                                     AS `PLZ_Ort`,
    `Tel_Nr`                                      AS `Tel_Nr`,
    `eMail`                                       AS `eMail`
FROM `personen`;


-- 4) Normalisieren II: PLZ und Ort in eine eigene Tabelle auslagern
-- ================================================================

-- 4.1) Tabelle "Orte" erstellen.
--      ID als Schlüssel, weil eine PLZ nicht eindeutig ist (8855 -> Wangen und Nuolen).
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
  `ID`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PLZ`       VARCHAR(10)  NOT NULL,
  `Ortsname`  VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ID`));


-- 4.2) Alle Orte und PLZ aus "personen" in "Orte" auslagern.
INSERT INTO `Orte` (`PLZ`, `Ortsname`)
SELECT DISTINCT
    SUBSTRING_INDEX(`PLZ_Ort`, ' ', 1),
    TRIM(SUBSTRING(`PLZ_Ort`, LOCATE(' ', `PLZ_Ort`) + 1))
FROM `personen`
WHERE `PLZ_Ort` IS NOT NULL;


-- 4.3) Foreignkey-Attribut "Orte_FK" nach "PLZ_Ort" einfügen.
ALTER TABLE `personen`
    ADD COLUMN `Orte_FK` INT UNSIGNED NULL AFTER `PLZ_Ort`;


-- 4.4) "personen.Orte_FK" mit den korrekten Werten setzen.
UPDATE `personen` AS `p`
JOIN `Orte` AS `o` ON CONCAT(`o`.`PLZ`, ' ', `o`.`Ortsname`) = `p`.`PLZ_Ort`
SET `p`.`Orte_FK` = `o`.`ID`;


-- 4.5) View um einen Join mit "Orte" erweitern.
--      "PLZ_Ort" der Tabelle als "PLZ_Ort_Old", das neue "PLZ_Ort" kommt aus dem Join.
CREATE OR REPLACE VIEW `Personen_Liste` AS
SELECT
    `p`.`ID`                                          AS `ID`,
    `p`.`Anrede`                                      AS `Anrede`,
    `p`.`Vorname`                                     AS `Vorname`,
    `p`.`Nachname`                                    AS `Nachname`,
    CONCAT_WS(' ', `p`.`Strassenname`, `p`.`Hausnummer`) AS `Strasse`,
    `p`.`PLZ_Ort`                                     AS `PLZ_Ort_Old`,
    CONCAT(`o`.`PLZ`, ' ', `o`.`Ortsname`)            AS `PLZ_Ort`,
    `p`.`Tel_Nr`                                      AS `Tel_Nr`,
    `p`.`eMail`                                       AS `eMail`
FROM `personen` AS `p`
JOIN `Orte` AS `o` ON `o`.`ID` = `p`.`Orte_FK`;


-- 4.6) Alle Personen, bei denen PLZ_Ort_Old <> PLZ_Ort ist.
SELECT `ID`, `PLZ_Ort_Old`, `PLZ_Ort`
FROM `Personen_Liste`
WHERE `PLZ_Ort_Old` <> `PLZ_Ort`;
-- 0 Zeilen -> Migration ist konsistent


-- 4.7) Keine Fehler-Tuples -> "PLZ_Ort_Old" aus der View auskommentieren.
CREATE OR REPLACE VIEW `Personen_Liste` AS
SELECT
    `p`.`ID`                                          AS `ID`,
    `p`.`Anrede`                                      AS `Anrede`,
    `p`.`Vorname`                                     AS `Vorname`,
    `p`.`Nachname`                                    AS `Nachname`,
    CONCAT_WS(' ', `p`.`Strassenname`, `p`.`Hausnummer`) AS `Strasse`,
    -- `p`.`PLZ_Ort`                                  AS `PLZ_Ort_Old`,
    CONCAT(`o`.`PLZ`, ' ', `o`.`Ortsname`)            AS `PLZ_Ort`,
    `p`.`Tel_Nr`                                      AS `Tel_Nr`,
    `p`.`eMail`                                       AS `eMail`
FROM `personen` AS `p`
JOIN `Orte` AS `o` ON `o`.`ID` = `p`.`Orte_FK`;


-- 4.8) "PLZ_Ort" in "personen" löschen und Foreign-Key-Constraint auf "Orte_FK" setzen.
ALTER TABLE `personen`
    DROP COLUMN `PLZ_Ort`;

-- FK-Constraints
ALTER TABLE `personen`
    ADD CONSTRAINT `Orte_FK` FOREIGN KEY (`Orte_FK`) REFERENCES `Orte` (`ID`);


-- 4.9) Verifizieren: gleiche Anzahlen wie in 1).
-- 4.9.1) Wie viele Datensätze hat es in personen_liste?
SELECT COUNT(*) AS `Anzahl Datensätze`
FROM `Personen_Liste`;
-- 1169

-- 4.9.2) Wie viele Personen leben in 8855 Wangen?
SELECT COUNT(*) AS `Anzahl 8855 Wangen`
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- 703

-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
SELECT COUNT(DISTINCT `PLZ_Ort`) AS `Anzahl verschiedene PLZ_Ort`
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;
-- 82
