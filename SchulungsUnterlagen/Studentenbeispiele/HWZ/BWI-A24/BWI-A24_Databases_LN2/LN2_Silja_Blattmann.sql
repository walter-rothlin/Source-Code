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
-- ---------------------------------------------------------------------------------
-- -------------- Hier bitte ihre persönlichen Angaben erfassen --------------------

SET @Candidate_Firstname  := 'Silja';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Blattmann';   -- Durch ihren Namen ersetzen
SET @Class                := 'BWI-A24';   -- z.B. BWI-A23


SET @Test_Name            := 'DB_Prüfung_2c';  -- NICHT ändern
SET @Test_Max_Punkte      := 15;               -- NICHT ändern

-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die "Personen_Liste" und erstellen Sie hier ein re-runable Migrations-Script.
--
-- Gehen Sie in folgenden Schritten vor (Test-Driven approach):

-- 1) Testdaten sammeln
-- ====================
-- Sammeln Sie zuerst einige Informationen über die bestehenden Daten,
-- welche später bei der Test-Driven Entwicklung zum Verifizieren 
-- gebraucht werden können.

-- 1.1) Wie viele Datensätze hat es in "Personen_Liste"?
SELECT COUNT(*) AS `Anzahl_Datensaetze` FROM `Personen_Liste`;
-- Ergebnis: 1169

-- 1.2) Wie viele Personen leben in 8855 Wangen?
SELECT COUNT(*) AS `Personen_in_Wangen` FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- Ergebnis: 703

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es (Not Null)?
SELECT COUNT(DISTINCT `PLZ_Ort`) AS `Verschiedene_PLZ_Ort` FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;
-- Ergebnis: 82


-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================
-- Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
-- welche auf "Personen_Liste" zugreifen nichts davon merken (Abwärtskompatible).

-- 2.1) Renamen Sie "Personen_Liste" zu personen.
RENAME TABLE `Personen_Liste` TO `personen`;

-- 2.2) Erstellen Sie eine view "Personen_Liste" mit den gleichen Attributen. In der Folge wird dieses Interface
--      nicht mehr geändert, lediglich die Implemenation der View wird angepasst.  

DROP VIEW IF EXISTS `Personen_Liste`;
CREATE VIEW `Personen_Liste` AS
SELECT
    `ID`,
    `Anrede`,
    `Vorname`,
    `Nachname`,
    `Strasse`,
    `PLZ_Ort`,
    `Tel_Nr`,
    `eMail`
FROM `personen`;


-- 2.3) Verifikation – muss exakt gleiche Ergebnisse wie 1.1–1.3 liefern
SELECT COUNT(*) AS `Anzahl_Datensaetze` FROM `Personen_Liste`;
-- Ergebnis: 1169  - ok

SELECT COUNT(*) AS `Personen_in_Wangen` FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- Ergebnis: 703  - ok

SELECT COUNT(DISTINCT `PLZ_Ort`) AS `Verschiedene_PLZ_Ort` FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;
-- Ergebnis: 82 - ok


-- 3) Normalisieren I
-- ==================
-- Beim Analysieren der Daten stellen Sie fest, dass das Attribute "Strasse" zwei Informations-Elemente enthalten. 
-- Teilen Sie das auf "Strassenname" und "Hausnummer" auf.

-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu
ALTER TABLE `personen`
    ADD COLUMN `Hausnummer` VARCHAR(20) NULL AFTER `Strasse`;
    
-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".
UPDATE `personen`
SET
    `Hausnummer` = REGEXP_SUBSTR(`Strasse`, '[0-9][^ ]*$'),
    `Strasse`    = NULLIF(TRIM(REGEXP_REPLACE(`Strasse`, '[0-9][^ ]*$', '')), '');
    
    -- Amnerkung: Unter Preferences Safe Updates deaktivieren, dann nochmals neu connecten und dann funktionierts.

-- Kontroll-SELECT: Vorher/Nachher-Stichprobe
SELECT `ID`, `Strasse` AS `Strassenname_temp`, `Hausnummer`
FROM `personen`
ORDER BY `ID`
LIMIT 10;
    
-- Straße und Hausnummer extrahieren


-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"
ALTER TABLE `personen`
    RENAME COLUMN `Strasse` TO `Strassenname`;

-- 3.5) Passen Sie die Implementation der view "Personen_Liste" entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.


DROP VIEW IF EXISTS `Personen_Liste`;
CREATE VIEW `Personen_Liste` AS
SELECT
    `ID`,
    `Anrede`,
    `Vorname`,
    `Nachname`,
    CONCAT(
        `Strassenname`,
        IF(`Hausnummer` IS NOT NULL, CONCAT(' ', `Hausnummer`), '')
    ) AS `Strasse`,
    `PLZ_Ort`,
    `Tel_Nr`,
    `eMail`
FROM `personen`;

-- 4) Normalisieren II
-- ===================
-- Eliminieren Sie Redundanzen in dem Sie Postleitzahl und Ort trennen und in eine seperate
-- Tabelle auslagern.

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"
CREATE TABLE IF NOT EXISTS `Orte` (
    `ID`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `PLZ`      CHAR(4)      NOT NULL,
    `Ortsname` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `PLZ_Ortsname_UQ` (`PLZ`, `Ortsname`)
);
    
-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.
INSERT INTO `Orte` (`PLZ`, `Ortsname`)
SELECT DISTINCT
    SUBSTRING(`PLZ_Ort`, 1, 4)     AS `PLZ`,
    TRIM(SUBSTRING(`PLZ_Ort`, 6))  AS `Ortsname`
FROM `personen`
WHERE `PLZ_Ort` IS NOT NULL
  AND TRIM(`PLZ_Ort`) != '';
  
  -- Kontroll-SELECT: alle Orte
SELECT * FROM `Orte` ORDER BY `PLZ`, `Ortsname`;
    
-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.
ALTER TABLE `personen`
    ADD COLUMN `orte_fk` INT UNSIGNED NULL AFTER `PLZ_Ort`;

-- 4.4) Setzen Sie "Personen.orte_fk" mit den korrekten Werten.
UPDATE `personen` p
    JOIN `Orte` o
        ON  o.`PLZ`      = SUBSTRING(p.`PLZ_Ort`, 1, 4)
        AND o.`Ortsname` = TRIM(SUBSTRING(p.`PLZ_Ort`, 6))
SET p.`orte_fk` = o.`ID`
WHERE p.`PLZ_Ort` IS NOT NULL;

-- 4.5) Erweitern Sie die View durch einen Join mit "Orte".
--      Renamen Sie "PLZ_Ort" in "Personen_Liste" zu "PLZ_Ort_Old".
--      "PLZ_Ort" ist nun das Attribut über den Join

DROP VIEW IF EXISTS `Personen_Liste`;
CREATE VIEW `Personen_Liste` AS
SELECT
    p.`ID`,
    p.`Anrede`,
    p.`Vorname`,
    p.`Nachname`,
    CONCAT(
        p.`Strassenname`,
        IF(p.`Hausnummer` IS NOT NULL, CONCAT(' ', p.`Hausnummer`), '')
    )                                  AS `Strasse`,
    p.`PLZ_Ort`                        AS `PLZ_Ort_Old`,
    CONCAT(o.`PLZ`, ' ', o.`Ortsname`) AS `PLZ_Ort`,
    p.`Tel_Nr`,
    p.`eMail`
FROM `personen` p
LEFT JOIN `Orte` o ON o.`ID` = p.`orte_fk`;

-- 4.6) Entwickeln Sie ein SELECT, welches alle Personen zurück gibt, bei dem PLZ_Ort_Old <> PLZ_Ort ist.
SELECT *
FROM `Personen_Liste`
WHERE NOT (`PLZ_Ort_Old` <=> `PLZ_Ort`);   -- NULL-sicher via <=>
-- Ergebnis: 0 Zeilen → Migration korrekt

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View "PLZ_Ort_Old" auskommentieren.
DROP VIEW IF EXISTS `Personen_Liste`;
CREATE VIEW `Personen_Liste` AS
SELECT
    p.`ID`,
    p.`Anrede`,
    p.`Vorname`,
    p.`Nachname`,
    CONCAT(
        p.`Strassenname`,
        IF(p.`Hausnummer` IS NOT NULL, CONCAT(' ', p.`Hausnummer`), '')
    )                                  AS `Strasse`,
    -- p.`PLZ_Ort`                     AS `PLZ_Ort_Old`,   -- auskommentiert nach erfolgreicher Migration
    CONCAT(o.`PLZ`, ' ', o.`Ortsname`) AS `PLZ_Ort`,
    p.`Tel_Nr`,
    p.`eMail`
FROM `personen` p
LEFT JOIN `Orte` o ON o.`ID` = p.`orte_fk`;


-- 4.8) Löschen sie "PLZ_Ort" in "Personen" und fügen Sie noch 
--      einen Foreign-Key Constraint auf "Orte_FK" hinzu.
ALTER TABLE `personen`
    DROP COLUMN `PLZ_Ort`,
    ADD CONSTRAINT `Orte_FK` FOREIGN KEY (`orte_fk`) REFERENCES `Orte` (`ID`);
    
    
-- FK-Constraints
    
-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.

-- 4.9.1) Wie viele Datensätze hat es in personen_liste?
SELECT COUNT(*) AS `Anzahl_Datensaetze` FROM `Personen_Liste`;
-- Ergebnis: 1169  - ok

-- 4.9.2) Wie viele Personen leben in 8855 Wangen?
SELECT COUNT(*) AS `Personen_in_Wangen` FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- Ergebnis: 703  - ok

-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
SELECT COUNT(DISTINCT `PLZ_Ort`) AS `Verschiedene_PLZ_Ort` FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;
-- Ergebnis: 82 - ok
    