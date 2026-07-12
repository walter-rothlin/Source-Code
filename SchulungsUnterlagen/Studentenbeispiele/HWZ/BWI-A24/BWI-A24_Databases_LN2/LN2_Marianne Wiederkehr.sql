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

SET @Candidate_Firstname  := 'Marianne';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Wiederkehr';   -- Durch ihren Namen ersetzen
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

-- 1.1) Wie viele Datensätze hat es in "Personen_Liste" 
--      (SQL-Statement und als Kommentar die effektive Anzahl)?
SELECT COUNT(*) AS Anzahl FROM personen_liste;
-- Ergebnis: 1169

-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statment und als Kommentar die effektive Anzahl)?
SELECT COUNT(*) AS Anzahl 
FROM personen_liste 
WHERE PLZ_Ort = '8855 Wangen';
-- Ergebnis: 703

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl 
FROM personen_liste 
WHERE PLZ_Ort IS NOT NULL;
-- Ergebnis: 82

-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================
-- Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
-- welche auf "Personen_Liste" zugreifen nichts davon merken (Abwärtskompatible).

-- 2.1) Renamen Sie "Personen_Liste" zu personen.

SET @rename_needed := (
    SELECT COUNT(*) FROM information_schema.tables 
    WHERE table_schema = DATABASE() AND table_name = 'personen_liste' AND table_type = 'BASE TABLE'
);

-- View NUR droppen wenn auch wirklich renamed werden muss (sonst zerstört man eine bereits existierende View)
SET @sql := IF(@rename_needed > 0, 
    'DROP VIEW IF EXISTS personen_liste',
    'SELECT ''2.1 Schritt 1 übersprungen - kein Drop nötig'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(@rename_needed > 0, 
    'RENAME TABLE personen_liste TO personen', 
    'SELECT ''Tabelle bereits umbenannt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2.2) Erstellen Sie eine view "Personen_Liste" mit den gleichen Attributen. In der Folge wird dieses Interface
--      nicht mehr geändert, lediglich die Implemenation der View wird angepasst.  

SET @has_strasse := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND column_name = 'Strasse'
);
SET @sql := IF(@has_strasse > 0,
    'CREATE OR REPLACE VIEW personen_liste AS
     SELECT ID, Anrede, Vorname, Nachname, Strasse, PLZ_Ort, Tel_Nr, eMail
     FROM personen',
    'SELECT ''2.2 übersprungen - View wird in 3.5/4.7 in neuer Form erstellt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2.3) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.

-- 1.1 Test wiederholen
SELECT COUNT(*) AS Anzahl
FROM personen_liste;
-- Erwartet: 1169 / Erhalten: 1169

-- 1.2 Test wiederholen
SELECT COUNT(*) AS Anzahl
FROM personen_liste
WHERE PLZ_Ort = '8855 Wangen';
-- Erwartet: 703 / Erhalten: 703

-- 1.3 Test wiederholen
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl
FROM personen_liste
WHERE PLZ_Ort IS NOT NULL;
-- Erwartet: 82 / Erhalten: 82

-- 3) Normalisieren I
-- ==================
-- Beim Analysieren der Daten stellen Sie fest, dass das Attribute "Strasse" zwei Informations-Elemente enthalten. 
-- Teilen Sie das auf "Strassenname" und "Hausnummer" auf.

-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu
SET @col_exists := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND column_name = 'Hausnummer'
);
SET @sql := IF(@col_exists = 0,
    'ALTER TABLE personen ADD COLUMN Hausnummer VARCHAR(50) AFTER Strasse',
    'SELECT ''Spalte Hausnummer existiert bereits'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".

SET @strasse_col := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND column_name = 'Strasse'
);

-- Hauptsplit: nur splitten wenn letztes Wort eine Ziffer enthält
SET @sql := IF(@strasse_col > 0,
    'UPDATE personen 
     SET Hausnummer = TRIM(SUBSTRING_INDEX(Strasse, '' '', -1)),
         Strasse    = TRIM(LEFT(Strasse, LENGTH(Strasse) - LENGTH(SUBSTRING_INDEX(Strasse, '' '', -1)) - 1))
     WHERE Strasse IS NOT NULL 
       AND Hausnummer IS NULL 
       AND LOCATE('' '', Strasse) > 0
       AND SUBSTRING_INDEX(Strasse, '' '', -1) REGEXP ''[0-9]''',
    'SELECT ''Strasse bereits gesplittet'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Zusatz-Fix: "Strasse 69 b" zusammenführen zu Strasse | 69b
SET @sql := IF(@strasse_col > 0,
    'UPDATE personen
     SET Hausnummer = CONCAT(SUBSTRING_INDEX(Strasse, '' '', -1), Hausnummer),
         Strasse    = TRIM(LEFT(Strasse, LENGTH(Strasse) - LENGTH(SUBSTRING_INDEX(Strasse, '' '', -1)) - 1))
     WHERE Hausnummer REGEXP ''^[a-zA-Z]$''
       AND SUBSTRING_INDEX(Strasse, '' '', -1) REGEXP ''^[0-9]+$''',
    'SELECT ''Zusatz-Fix übersprungen - Strasse bereits umbenannt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;


-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"

SET @strasse_col := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND column_name = 'Strasse'
);
SET @sql := IF(@strasse_col > 0,
    'ALTER TABLE personen RENAME COLUMN Strasse TO Strassenname',
    'SELECT ''Strasse bereits zu Strassenname umbenannt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DESCRIBE personen;

-- 3.5) Passen Sie die Implementation der view "Personen_Liste" entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.

SET @plz_ort_still_exists := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND column_name = 'PLZ_Ort'
);
SET @sql := IF(@plz_ort_still_exists > 0,
    'CREATE OR REPLACE VIEW personen_liste AS
     SELECT 
         ID, 
         Anrede, 
         Vorname, 
         Nachname, 
         TRIM(CONCAT(Strassenname, '' '', IFNULL(Hausnummer, ''''))) AS Strasse, 
         PLZ_Ort, 
         Tel_Nr, 
         eMail
     FROM personen',
    'SELECT ''3.5 übersprungen - finale View aus 4.7 aktiv'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;


-- 4) Normalisieren II
-- ===================
-- Eliminieren Sie Redundanzen in dem Sie Postleitzahl und Ort trennen und in eine seperate
-- Tabelle auslagern.

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"

SET FOREIGN_KEY_CHECKS = 0;

SET @fk_exists := (
    SELECT COUNT(*) FROM information_schema.table_constraints 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND constraint_name = 'FK_Personen_Orte'
);
SET @sql := IF(@fk_exists > 0,
    'ALTER TABLE personen DROP FOREIGN KEY FK_Personen_Orte',
    'SELECT ''FK FK_Personen_Orte existiert noch nicht'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DROP TABLE IF EXISTS Orte;

CREATE TABLE Orte (
    Orte_ID  INT AUTO_INCREMENT PRIMARY KEY,
    PLZ      VARCHAR(10)  NOT NULL,
    Ortsname VARCHAR(100) NOT NULL,
    UNIQUE KEY uk_plz_ort (PLZ, Ortsname)
);

SET FOREIGN_KEY_CHECKS = 1;

    
-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.

SET @plz_ort_exists := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND column_name = 'PLZ_Ort'
);
SET @sql := IF(@plz_ort_exists > 0,
    'INSERT INTO Orte (PLZ, Ortsname)
     SELECT DISTINCT
         TRIM(SUBSTRING_INDEX(PLZ_Ort, '' '', 1))            AS PLZ,
         TRIM(SUBSTR(PLZ_Ort, LOCATE('' '', PLZ_Ort) + 1))   AS Ortsname
     FROM personen
     WHERE PLZ_Ort IS NOT NULL',
    'SELECT ''PLZ_Ort wurde bereits entfernt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    
-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.

SET @fk_col_exists := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND column_name = 'Orte_FK'
);
SET @sql := IF(@fk_col_exists = 0,
    IF(@plz_ort_exists > 0,
        'ALTER TABLE personen ADD COLUMN Orte_FK INT AFTER PLZ_Ort',
        'ALTER TABLE personen ADD COLUMN Orte_FK INT'
    ),
    'SELECT ''Spalte Orte_FK existiert bereits'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.4) Setzen Sie "Personen.orte_fk" mit den korrekten Werten.

SET @sql := IF(@plz_ort_exists > 0,
    'UPDATE personen p
     JOIN Orte o 
       ON o.PLZ      = TRIM(SUBSTRING_INDEX(p.PLZ_Ort, '' '', 1))
      AND o.Ortsname = TRIM(SUBSTR(p.PLZ_Ort, LOCATE('' '', p.PLZ_Ort) + 1))
     SET p.Orte_FK = o.Orte_ID
     WHERE p.PLZ_Ort IS NOT NULL',
    'SELECT ''Orte_FK bereits gesetzt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.5) Erweitern Sie die View durch einen Join mit "Orte".
--      Renamen Sie "PLZ_Ort" in "Personen_Liste" zu "PLZ_Ort_Old".
--      "PLZ_Ort" ist nun das Attribut über den Join

SET @sql := IF(@plz_ort_exists > 0,
    'CREATE OR REPLACE VIEW personen_liste AS
     SELECT
         p.ID,
         p.Anrede,
         p.Vorname,
         p.Nachname,
         TRIM(CONCAT(p.Strassenname, '' '', IFNULL(p.Hausnummer, '''')))  AS Strasse,
         p.PLZ_Ort                                                        AS PLZ_Ort_Old,
         CONCAT(o.PLZ, '' '', o.Ortsname)                                 AS PLZ_Ort,
         p.Tel_Nr,
         p.eMail
     FROM personen AS p
     LEFT JOIN Orte AS o ON p.Orte_FK = o.Orte_ID',
    'SELECT ''4.5 übersprungen - PLZ_Ort wurde bereits entfernt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4.6) Entwickeln Sie ein SELECT, welches alle Personen zurück gibt, bei dem PLZ_Ort_Old <> PLZ_Ort ist.

SET @plz_ort_old_in_view := (
    SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = DATABASE() AND table_name = 'personen_liste' AND column_name = 'PLZ_Ort_Old'
);
SET @sql := IF(@plz_ort_old_in_view > 0,
    'SELECT ID, PLZ_Ort_Old, PLZ_Ort FROM personen_liste
     WHERE PLZ_Ort_Old <> PLZ_Ort
        OR (PLZ_Ort_Old IS NULL     AND PLZ_Ort IS NOT NULL)
        OR (PLZ_Ort_Old IS NOT NULL AND PLZ_Ort IS NULL)',
    'SELECT ''4.6 übersprungen - PLZ_Ort_Old nicht mehr in View'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Erwartet: 0 Zeilen

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View "PLZ_Ort_Old" auskommentieren.

CREATE OR REPLACE VIEW personen_liste AS
SELECT
    p.ID,
    p.Anrede,
    p.Vorname,
    p.Nachname,
    TRIM(CONCAT(p.Strassenname, ' ', IFNULL(p.Hausnummer, '')))   AS Strasse,
    -- p.PLZ_Ort                                                  AS PLZ_Ort_Old,   -- nach erfolgreicher Migration entfernt
    CONCAT(o.PLZ, ' ', o.Ortsname)                                AS PLZ_Ort,
    p.Tel_Nr,
    p.eMail
FROM personen AS p
LEFT JOIN Orte AS o ON p.Orte_FK = o.Orte_ID;

-- 4.8) Löschen sie "PLZ_Ort" in "Personen" und fügen Sie noch 
--      einen Foreign-Key Contraint auf "Orte_FK" hinzu.

SET @sql := IF(@plz_ort_exists > 0,
    'ALTER TABLE personen DROP COLUMN PLZ_Ort',
    'SELECT ''PLZ_Ort bereits entfernt'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- FK-Constraints
 
SET @fk_exists := (
    SELECT COUNT(*) FROM information_schema.table_constraints 
    WHERE table_schema = DATABASE() AND table_name = 'personen' AND constraint_name = 'FK_Personen_Orte'
);
SET @sql := IF(@fk_exists = 0,
    'ALTER TABLE personen ADD CONSTRAINT FK_Personen_Orte FOREIGN KEY (Orte_FK) REFERENCES Orte(Orte_ID)',
    'SELECT ''FK FK_Personen_Orte existiert bereits'' AS Info'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

    
-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
-- 4.9.1) Wie viele Datensätze hat es in personen_liste?

SELECT COUNT(*) AS Anzahl FROM personen_liste;
-- Erwartet: 1169 / Erhalten: 1169

-- 4.9.2) Wie viele Personen leben in 8855 Wangen?

SELECT COUNT(*) AS Anzahl 
FROM personen_liste 
WHERE PLZ_Ort = '8855 Wangen';

-- Erwartet: 703 / Erhalten: 703

-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
  
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl 
FROM personen_liste 
WHERE PLZ_Ort IS NOT NULL;
-- Erwartet: 82 / Erhalten: 82

