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

SET @Candidate_Firstname  := 'Yannick';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Gloor';   -- Durch ihren Namen ersetzen
SET @Class                := 'BWI-A24';   -- z.B. BWI-A23


SET @Test_Name            := 'DB_Prüfung_2c';  -- NICHT ändern
SET @Test_Max_Punkte      := 15;               -- NICHT ändern

USE pruefung_2;
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die "Personen_Liste" und erstellen Sie hier ein re-runable Migrations-Script.
--
-- Gehen Sie in folgenden Schritten vor (Test-Driven approach):

-- 1) Testdaten sammeln
-- ====================
-- Sammeln Sie zuerst einige Informationen über die bestehenden Daten,
-- welche später bei der Test-Driven Entwicklung zum Verifizieren
-- gebraucht werden können.

-- 1.1) Wie viele Datensätze hat es in "Personen_Liste"
--      (SQL-Statement und als Kommentar die effektive Anzahl)?
SELECT COUNT(*) AS Anzahl FROM Personen_Liste; -- 1169

-- 1.2) Wie viele Personen leben in 8855 Wangen
--      (SQL-Statment und als Kommentar die effektive Anzahl)?
SELECT COUNT(*) AS Anzahl_Wangen FROM Personen_Liste WHERE PLZ_Ort = '8855 Wangen'; -- 703

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl_PLZ_Ort FROM Personen_Liste WHERE PLZ_Ort IS NOT NULL; -- 82




-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================
-- Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
-- welche auf "Personen_Liste" zugreifen nichts davon merken (Abwärtskompatible).

-- 2.1) Renamen Sie "Personen_Liste" zu personen.
RENAME TABLE Personen_Liste TO personen;

-- 2.2) Erstellen Sie eine view "Personen_Liste" mit den gleichen Attributen. In der Folge wird dieses Interface
--      nicht mehr geändert, lediglich die Implemenation der View wird angepasst.
CREATE OR REPLACE VIEW Personen_Liste AS
    SELECT ID, Anrede, Vorname, Nachname, Strasse, PLZ_Ort, Tel_Nr, eMail
    FROM personen;

-- 2.3) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
SELECT COUNT(*) AS Anzahl FROM Personen_Liste;                                                   -- 1169
SELECT COUNT(*) AS Anzahl_Wangen FROM Personen_Liste WHERE PLZ_Ort = '8855 Wangen';             -- 703
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl_PLZ_Ort FROM Personen_Liste WHERE PLZ_Ort IS NOT NULL; -- 82




-- 3) Normalisieren I
-- ==================
-- Beim Analysieren der Daten stellen Sie fest, dass das Attribute "Strasse" zwei Informations-Elemente enthalten.
-- Teilen Sie das auf "Strassenname" und "Hausnummer" auf.

-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu
ALTER TABLE personen
    ADD COLUMN Hausnummer VARCHAR(20) NULL AFTER Strasse;

-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".

-- Straße und Hausnummer extrahieren
UPDATE personen
SET
    Hausnummer = CASE
                     WHEN Strasse REGEXP '^.+\\s+[0-9]+[a-zA-Z]?$'
                     THEN REGEXP_REPLACE(Strasse, '^(.+)\\s+([0-9]+[a-zA-Z]?)$', '$2')
                     ELSE NULL
                 END,
    Strasse    = CASE
                     WHEN Strasse REGEXP '^.+\\s+[0-9]+[a-zA-Z]?$'
                     THEN REGEXP_REPLACE(Strasse, '^(.+)\\s+([0-9]+[a-zA-Z]?)$', '$1')
                     ELSE Strasse
                 END;

-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"
ALTER TABLE personen RENAME COLUMN Strasse TO Strassenname;

-- 3.5) Passen Sie die Implementation der view "Personen_Liste" entsprechend an, so das in Strasse
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.
CREATE OR REPLACE VIEW Personen_Liste AS
    SELECT ID, Anrede, Vorname, Nachname,
           CONCAT(Strassenname, ' ', Hausnummer) AS Strasse,
           PLZ_Ort, Tel_Nr, eMail
    FROM personen;


-- 4) Normalisieren II
-- ===================
-- Eliminieren Sie Redundanzen in dem Sie Postleitzahl und Ort trennen und in eine seperate
-- Tabelle auslagern.

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"
CREATE TABLE IF NOT EXISTS Orte (
    ID       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    PLZ      CHAR(4)      NOT NULL,
    Ortsname VARCHAR(100) NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE KEY uq_plz_ort (PLZ, Ortsname)
);

-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.
INSERT IGNORE INTO Orte (PLZ, Ortsname)
SELECT DISTINCT
    SUBSTRING(PLZ_Ort, 1, 4)    AS PLZ,
    TRIM(SUBSTRING(PLZ_Ort, 6)) AS Ortsname
FROM personen
WHERE PLZ_Ort IS NOT NULL;

-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.
ALTER TABLE personen
    ADD COLUMN Orte_FK INT UNSIGNED NULL AFTER PLZ_Ort;

-- 4.4) Setzen Sie "Personen.orte_fk" mit den korrekten Werten.
UPDATE personen p
JOIN Orte o ON SUBSTRING(p.PLZ_Ort, 1, 4) = o.PLZ
           AND TRIM(SUBSTRING(p.PLZ_Ort, 6)) = o.Ortsname
SET p.Orte_FK = o.ID;

-- 4.5) Erweitern Sie die View durch einen Join mit "Orte".
--      Renamen Sie "PLZ_Ort" in "Personen_Liste" zu "PLZ_Ort_Old".
--      "PLZ_Ort" ist nun das Attribut über den Join
CREATE OR REPLACE VIEW Personen_Liste AS
    SELECT p.ID, p.Anrede, p.Vorname, p.Nachname,
           CONCAT(p.Strassenname, ' ', p.Hausnummer) AS Strasse,
           p.PLZ_Ort                                  AS PLZ_Ort_Old,
           CONCAT(o.PLZ, ' ', o.Ortsname)            AS PLZ_Ort,
           p.Tel_Nr, p.eMail
    FROM personen p
    LEFT JOIN Orte o ON p.Orte_FK = o.ID;

-- 4.6) Entwickeln Sie ein SELECT, welches alle Personen zurück gibt, bei dem PLZ_Ort_Old <> PLZ_Ort ist.
SELECT * FROM Personen_Liste WHERE PLZ_Ort_Old <> PLZ_Ort; -- 0 Zeilen = Migration korrekt

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können
--      die aus der View "PLZ_Ort_Old" auskommentieren.
CREATE OR REPLACE VIEW Personen_Liste AS
    SELECT p.ID, p.Anrede, p.Vorname, p.Nachname,
           CONCAT(p.Strassenname, ' ', p.Hausnummer) AS Strasse,
           -- p.PLZ_Ort AS PLZ_Ort_Old,
           CONCAT(o.PLZ, ' ', o.Ortsname)            AS PLZ_Ort,
           p.Tel_Nr, p.eMail
    FROM personen p
    LEFT JOIN Orte o ON p.Orte_FK = o.ID;

-- 4.8) Löschen sie "PLZ_Ort" in "Personen" und fügen Sie noch
--      einen Foreign-Key Contraint auf "Orte_FK" hinzu.
ALTER TABLE personen
    DROP COLUMN PLZ_Ort;

-- FK-Constraints
ALTER TABLE personen
    ADD CONSTRAINT fk_personen_orte FOREIGN KEY (Orte_FK) REFERENCES Orte(ID);

-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
-- 4.9.1) Wie viele Datensätze hat es in personen_liste?
SELECT COUNT(*) AS Anzahl FROM Personen_Liste;                                                   -- 1169

-- 4.9.2) Wie viele Personen leben in 8855 Wangen?
SELECT COUNT(*) AS Anzahl_Wangen FROM Personen_Liste WHERE PLZ_Ort = '8855 Wangen';             -- 703

-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl_PLZ_Ort FROM Personen_Liste WHERE PLZ_Ort IS NOT NULL; -- 82
