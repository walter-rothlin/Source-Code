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

SET @Candidate_Firstname  := 'Alexandra';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Vychytil';   -- Durch ihren Namen ersetzen
SET @Class                := 'BWI-A24';   -- z.B. BWI-A23

SET @Test_Name            := 'DB_Prüfung_2c';  -- NICHT ändern
SET @Test_Max_Punkte      := 15;               -- NICHT ändern

SET SQL_SAFE_UPDATES = 0;  -- damit UPDATE/ALTER-Statements ohne Key-WHERE im Workbench-Safe-Mode nicht blockiert werden

-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die "Personen_Liste" und erstellen Sie hier ein re-runable Migrations-Script.
--
-- Gehen Sie in folgenden Schritten vor (Test-Driven approach):

-- 1) Testdaten sammeln
-- ====================

-- 1.1) Wie viele Datensätze hat es in "Personen_Liste" 
--      (SQL-Statement und als Kommentar die effektive Anzahl)?

SELECT COUNT(*) AS Anzahl_Datensaetze FROM Personen_Liste;
-- Anzahl: 1169

-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statment und als Kommentar die effektive Anzahl)?

SELECT COUNT(*) AS Anzahl_Wangen FROM Personen_Liste WHERE PLZ_Ort = '8855 Wangen';
-- Anzahl: 703

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?

SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl_PLZ_Ort FROM Personen_Liste WHERE PLZ_Ort IS NOT NULL;
-- Anzahl: 82


-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================

-- 2.1) Renamen Sie "Personen_Liste" zu personen.

-- re-runable: nur umbenennen, falls "Personen_Liste" noch eine BASE TABLE ist
-- (beim 2. Lauf ist es bereits eine VIEW, "personen" existiert dann schon)
SET @v_is_table := (
    SELECT COUNT(*) FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'Personen_Liste'
      AND TABLE_TYPE = 'BASE TABLE'
);
SET @sql := IF(@v_is_table > 0,
    'RENAME TABLE Personen_Liste TO personen',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2.2) Erstellen Sie eine view "Personen_Liste" mit den gleichen Attributen.

-- re-runable: nur (neu) erstellen, falls noch im Originalzustand (Strasse + PLZ_Ort
-- vorhanden). Ist die Migration schon weiter (Schritt 3/4 bereits gelaufen), ist
-- dieser Zwischenschritt nicht mehr nötig - die finale View kommt in 4.5/4.7.
SET @strasse_col_exists := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'personen' AND COLUMN_NAME = 'Strasse'
);
SET @plzort_col_exists_22 := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'personen' AND COLUMN_NAME = 'PLZ_Ort'
);
SET @sql := IF(@strasse_col_exists > 0 AND @plzort_col_exists_22 > 0,
"CREATE OR REPLACE VIEW Personen_Liste AS
SELECT
    ID,
    Anrede,
    Vorname,
    Nachname,
    Strasse,
    PLZ_Ort,
    Tel_Nr,
    eMail
FROM personen",
'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2.3) Verifizieren

SELECT COUNT(*) AS Anzahl_Datensaetze FROM Personen_Liste;
SELECT COUNT(*) AS Anzahl_Wangen FROM Personen_Liste WHERE PLZ_Ort = '8855 Wangen';
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl_PLZ_Ort FROM Personen_Liste WHERE PLZ_Ort IS NOT NULL;


-- 3) Normalisieren I
-- ==================

-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu

-- re-runable: Spalte nur anlegen, falls sie noch nicht existiert
SET @col_exists := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'personen' AND COLUMN_NAME = 'Hausnummer'
);
SET @sql := IF(@col_exists = 0,
    'ALTER TABLE personen ADD COLUMN Hausnummer VARCHAR(20) NULL AFTER Strasse',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".

-- re-runable: Splitting nur ausführen, falls Spalte "Strasse" noch existiert
-- (d.h. solange Schritt 3.4 noch nicht gelaufen ist)
SET @strasse_exists := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'personen' AND COLUMN_NAME = 'Strasse'
);

SET @sql := IF(@strasse_exists > 0,
    "UPDATE personen SET Hausnummer = TRIM(SUBSTRING_INDEX(Strasse, ' ', -1)) WHERE Strasse IS NOT NULL AND Strasse REGEXP '[0-9]+[a-zA-Z]?$' AND ID > 0",
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(@strasse_exists > 0,
    "UPDATE personen SET Strasse = TRIM(SUBSTRING(Strasse, 1, CHAR_LENGTH(Strasse) - CHAR_LENGTH(SUBSTRING_INDEX(Strasse, ' ', -1)))) WHERE Strasse IS NOT NULL AND Strasse REGEXP '[0-9]+[a-zA-Z]?$' AND ID > 0",
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"

SET @sql := IF(@strasse_exists > 0,
    'ALTER TABLE personen CHANGE COLUMN Strasse Strassenname VARCHAR(150) NULL',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3.5) Passen Sie die Implementation der view "Personen_Liste" entsprechend an

-- Hinweis: falls PLZ_Ort schon nicht mehr existiert (Schritt 4 bereits komplett
-- gelaufen), ist dieser Zwischenschritt nicht mehr nötig - die finale View wird
-- ohnehin in 4.5/4.7 neu erstellt.
SET @plzort_exists_35 := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'personen' AND COLUMN_NAME = 'PLZ_Ort'
);
SET @sql := IF(@plzort_exists_35 > 0,
"CREATE OR REPLACE VIEW Personen_Liste AS
SELECT
    ID,
    Anrede,
    Vorname,
    Nachname,
    TRIM(CONCAT(Strassenname, ' ', IFNULL(Hausnummer, ''))) AS Strasse,
    PLZ_Ort,
    Tel_Nr,
    eMail
FROM personen",
'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;


-- 4) Normalisieren II
-- ===================

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"

-- re-runable: FK zuerst explizit droppen (falls vorhanden), zusätzlich FK-Checks
-- kurz deaktivieren als Sicherheitsnetz, damit "Orte" garantiert neu erstellt werden kann
SET FOREIGN_KEY_CHECKS = 0;

SET @fk_exists := (
    SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE()
      AND TABLE_NAME = 'personen'
      AND CONSTRAINT_TYPE = 'FOREIGN KEY'
);
SET @sql := IF(@fk_exists > 0,
    'ALTER TABLE personen DROP FOREIGN KEY Orte_FK',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DROP TABLE IF EXISTS Orte;
CREATE TABLE Orte (
    PLZ      VARCHAR(10) NOT NULL,
    Ortsname VARCHAR(100) NOT NULL,
    PRIMARY KEY (PLZ)
);

SET FOREIGN_KEY_CHECKS = 1;

-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.

-- Hinweis: Eine PLZ kann mehreren Ortsnamen zugeordnet sein (z.B. PLZ 8855 wird
-- sowohl für "Wangen" als auch für "Nuolen" verwendet - Nuolen ist ein Ortsteil
-- von Wangen SZ mit derselben PLZ). Da PLZ hier der Primary Key von "Orte" ist,
-- übernehmen wir pro PLZ den HÄUFIGSTEN Ortsnamen.
-- Hinweis 2: Solange "Personen_Liste"/"personen" PLZ_Ort noch als eigene Spalte hat
-- (d.h. Schritt 4.8 noch nicht gelaufen ist), wird hier aus "personen.PLZ_Ort" gelesen.
SET @plzort_exists := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'personen' AND COLUMN_NAME = 'PLZ_Ort'
);

SET @sql := IF(@plzort_exists > 0,
"INSERT INTO Orte (PLZ, Ortsname)
SELECT t.PLZ, t.Ortsname
FROM (
    SELECT
        TRIM(SUBSTRING_INDEX(PLZ_Ort, ' ', 1))             AS PLZ,
        TRIM(SUBSTRING(PLZ_Ort, LOCATE(' ', PLZ_Ort) + 1)) AS Ortsname,
        COUNT(*)                                            AS Anzahl,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(SUBSTRING_INDEX(PLZ_Ort, ' ', 1))
            ORDER BY COUNT(*) DESC, TRIM(SUBSTRING(PLZ_Ort, LOCATE(' ', PLZ_Ort) + 1))
        ) AS rn
    FROM personen
    WHERE PLZ_Ort IS NOT NULL
      AND PLZ_Ort <> ''
      AND LOCATE(' ', PLZ_Ort) > 0
    GROUP BY
        TRIM(SUBSTRING_INDEX(PLZ_Ort, ' ', 1)),
        TRIM(SUBSTRING(PLZ_Ort, LOCATE(' ', PLZ_Ort) + 1))
) t
WHERE t.rn = 1",
'INSERT INTO Orte (PLZ, Ortsname)
SELECT DISTINCT orte_fk, orte_fk
FROM personen
WHERE 1=0'  -- Fallback: falls PLZ_Ort bereits gelöscht ist (Schritt 4.8 schon gelaufen),
            -- existieren die Orte bereits aus einem vorherigen Lauf -> nichts zu tun
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.

SET @fk_col_exists := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'personen' AND COLUMN_NAME = 'orte_fk'
);
SET @sql := IF(@fk_col_exists = 0,
    'ALTER TABLE personen ADD COLUMN orte_fk VARCHAR(10) NULL AFTER PLZ_Ort',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.4) Setzen Sie "Personen.orte_fk" mit den korrekten Werten.

SET @sql := IF(@plzort_exists > 0,
"UPDATE personen
SET orte_fk = TRIM(SUBSTRING_INDEX(PLZ_Ort, ' ', 1))
WHERE PLZ_Ort IS NOT NULL
  AND PLZ_Ort <> ''
  AND ID > 0",
'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.5) Erweitern Sie die View durch einen Join mit "Orte".
--      Renamen Sie "PLZ_Ort" in "Personen_Liste" zu "PLZ_Ort_Old".
--      "PLZ_Ort" ist nun das Attribut über den Join

SET @sql := IF(@plzort_exists > 0,
"CREATE OR REPLACE VIEW Personen_Liste AS
SELECT
    p.ID,
    p.Anrede,
    p.Vorname,
    p.Nachname,
    TRIM(CONCAT(p.Strassenname, ' ', IFNULL(p.Hausnummer, ''))) AS Strasse,
    p.PLZ_Ort                                                   AS PLZ_Ort_Old,
    TRIM(CONCAT(o.PLZ, ' ', o.Ortsname))                        AS PLZ_Ort,
    p.Tel_Nr,
    p.eMail
FROM personen p
LEFT JOIN Orte o ON o.PLZ = p.orte_fk",
"SELECT 1"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.6) Entwickeln Sie ein SELECT, welches alle Personen zurück gibt, bei dem PLZ_Ort_Old <> PLZ_Ort ist.
-- (nur relevant, solange PLZ_Ort_Old in der View existiert, d.h. solange 4.8 noch nicht gelaufen ist)

SET @sql := IF(@plzort_exists > 0,
    'SELECT * FROM Personen_Liste WHERE PLZ_Ort_Old <> PLZ_Ort',
    'SELECT "PLZ_Ort_Old existiert nicht mehr - Migration bereits abgeschlossen" AS Hinweis');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View "PLZ_Ort_Old" auskommentieren.

CREATE OR REPLACE VIEW Personen_Liste AS
SELECT
    p.ID,
    p.Anrede,
    p.Vorname,
    p.Nachname,
    TRIM(CONCAT(p.Strassenname, ' ', IFNULL(p.Hausnummer, ''))) AS Strasse,
    -- p.PLZ_Ort                                                AS PLZ_Ort_Old,  -- auskommentiert, Migration verifiziert (siehe 4.6/4.7)
    TRIM(CONCAT(o.PLZ, ' ', o.Ortsname))                        AS PLZ_Ort,
    p.Tel_Nr,
    p.eMail
FROM personen p
LEFT JOIN Orte o ON o.PLZ = p.orte_fk;

-- 4.8) Löschen sie "PLZ_Ort" in "Personen" und fügen Sie noch 
--      einen Foreign-Key Contraint auf "Orte_FK" hinzu.

SET @sql := IF(@plzort_exists > 0,
    'ALTER TABLE personen DROP COLUMN PLZ_Ort',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- FK-Constraints
-- (FK wurde bereits am Anfang von Schritt 4.1 gedroppt, falls vorhanden -
-- hier nur noch neu anlegen)
ALTER TABLE personen
    ADD CONSTRAINT Orte_FK
        FOREIGN KEY (orte_fk) REFERENCES Orte (PLZ)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.

-- 4.9.1) Wie viele Datensätze hat es in personen_liste?

SELECT COUNT(*) AS Anzahl_Datensaetze FROM Personen_Liste;

-- 4.9.2) Wie viele Personen leben in 8855 Wangen?

SELECT COUNT(*) AS Anzahl_Wangen FROM Personen_Liste WHERE PLZ_Ort = '8855 Wangen';

-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?

SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl_PLZ_Ort FROM Personen_Liste WHERE PLZ_Ort IS NOT NULL;
