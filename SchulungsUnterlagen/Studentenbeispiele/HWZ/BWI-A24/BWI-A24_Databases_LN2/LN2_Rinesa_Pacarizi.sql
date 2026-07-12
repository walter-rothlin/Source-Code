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

SET @Candidate_Firstname  := 'Rinesa';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Pacarizi';   -- Durch ihren Namen ersetzen
SET @Class                := 'BWI-A24';   -- z.B. BWI-A23


SET @Test_Name            := 'DB_Prüfung_2c';  -- NICHT ändern
SET @Test_Max_Punkte      := 15;               -- NICHT ändern

-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die "Personen_Liste" und erstellen Sie hier ein re-runable Migrations-Script.
--
-- Gehen Sie in folgenden Schritten vor (Test-Driven approach):

USE `pruefung_2`;

-- 1) Testdaten sammeln
-- ====================
-- Sammeln Sie zuerst einige Informationen über die bestehenden Daten,
-- welche später bei der Test-Driven Entwicklung zum Verifizieren 
-- gebraucht werden können.

-- 1.1) Wie viele Datensätze hat es in "Personen_Liste" 
--      (SQL-Statement und als Kommentar die effektive Anzahl)?

SELECT COUNT(*) AS Anzahl_Datensaetze
FROM `Personen_Liste`;

-- Effektive Anzahl: 1169

-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statment und als Kommentar die effektive Anzahl)?

SELECT COUNT(*) AS Anzahl_Personen_8855_Wangen
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';

-- Effektive Anzahl: 703

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?

SELECT COUNT(DISTINCT `PLZ_Ort`) AS Anzahl_Verschiedene_PLZ_Ort
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;

-- Effektive Anzahl: 82


-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================
-- Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
-- welche auf "Personen_Liste" zugreifen nichts davon merken (Abwärtskompatible).

-- 2.1) Renamen Sie "Personen_Liste" zu personen.


SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'Personen_Liste'
              AND TABLE_TYPE = 'BASE TABLE'
        )
        AND NOT EXISTS (
            SELECT 1
            FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND TABLE_TYPE = 'BASE TABLE'
        ),
        'RENAME TABLE `Personen_Liste` TO `personen`',
        'SELECT "2.1 bereits erledigt" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 2.2) Erstellen Sie eine view "Personen_Liste" mit den gleichen Attributen. In der Folge wird dieses Interface
--      nicht mehr geändert, lediglich die Implemenation der View wird angepasst.  

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Strasse'
        )
        AND EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'PLZ_Ort'
        ),
        'CREATE OR REPLACE VIEW `Personen_Liste` AS
         SELECT
             `ID`,
             `Anrede`,
             `Vorname`,
             `Nachname`,
             `Strasse`,
             `PLZ_Ort`,
             `Tel_Nr`,
             `eMail`
         FROM `personen`',
        'SELECT "2.2 View ist bereits in neuer Form vorhanden" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.3) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.

-- 1.1 / 2.3) Wie viele Datensätze hat es in "Personen_Liste"?
SELECT COUNT(*) AS Anzahl_Datensaetze
FROM `Personen_Liste`;

-- Effektive Anzahl: 1169


-- 1.2 / 2.3) Wie viele Personen leben in 8855 Wangen?
SELECT COUNT(*) AS Anzahl_Personen_8855_Wangen
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';

-- Effektive Anzahl: 703

-- 1.3 / 2.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
SELECT COUNT(DISTINCT `PLZ_Ort`) AS Anzahl_Verschiedene_PLZ_Ort
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;

-- Effektive Anzahl: 82


-- 3) Normalisieren I
-- ==================
-- Beim Analysieren der Daten stellen Sie fest, dass das Attribute "Strasse" zwei Informations-Elemente enthalten. 
-- Teilen Sie das auf "Strassenname" und "Hausnummer" auf.

-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu

SET @sql = (
    SELECT IF(
        NOT EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Hausnummer'
        )
        AND EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Strasse'
        ),
        'ALTER TABLE `personen` ADD COLUMN `Hausnummer` VARCHAR(100) NULL AFTER `Strasse`',
        'SELECT "3.1 Hausnummer existiert bereits" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

    
-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Strasse'
        ),
        'UPDATE `personen`
         SET
             `Hausnummer` = REGEXP_SUBSTR(`Strasse`, ''[0-9]+[[:space:]]*[A-Za-z]*$''),
             `Strasse` = TRIM(REGEXP_REPLACE(`Strasse`, ''[[:space:]]+[0-9]+[[:space:]]*[A-Za-z]*$'', ''''))
         WHERE `ID` > 0
           AND `Strasse` REGEXP ''[0-9]+[[:space:]]*[A-Za-z]*$''',
        'SELECT "3.2 Strasse wurde bereits gesplittet" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 3.3) Straße und Hausnummer extrahieren

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Strasse'
        ),
        'SELECT
             `ID`,
             `Strasse`,
             `Hausnummer`
         FROM `personen`
         WHERE `Hausnummer` IS NOT NULL',
        'SELECT
             `ID`,
             `Strassenname`,
             `Hausnummer`
         FROM `personen`
         WHERE `Hausnummer` IS NOT NULL'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Strasse'
        )
        AND NOT EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Strassenname'
        ),
        'ALTER TABLE `personen` CHANGE COLUMN `Strasse` `Strassenname` VARCHAR(100) NULL',
        'SELECT "3.4 Strasse wurde bereits umbenannt" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 3.5) Passen Sie die Implementation der view "Personen_Liste" entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Strassenname'
        )
        AND EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'PLZ_Ort'
        ),
        'CREATE OR REPLACE VIEW `Personen_Liste` AS
         SELECT
             `ID`,
             `Anrede`,
             `Vorname`,
             `Nachname`,
             TRIM(CONCAT(`Strassenname`, '' '', COALESCE(`Hausnummer`, ''''))) AS `Strasse`,
             `PLZ_Ort`,
             `Tel_Nr`,
             `eMail`
         FROM `personen`',
        'SELECT "3.5 View wird später/final neu erstellt" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4) Normalisieren II
-- ===================
-- Eliminieren Sie Redundanzen in dem Sie Postleitzahl und Ort trennen und in eine seperate
-- Tabelle auslagern.

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"

CREATE TABLE IF NOT EXISTS `Orte` (
    `ID`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `PLZ`       VARCHAR(10)  NOT NULL,
    `Ortsname`  VARCHAR(100) NOT NULL,

    PRIMARY KEY (`ID`),
    UNIQUE KEY `uq_plz_ort` (`PLZ`, `Ortsname`)
);
    
-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'PLZ_Ort'
        ),
        'INSERT IGNORE INTO `Orte` (`PLZ`, `Ortsname`)
         SELECT DISTINCT
             SUBSTRING_INDEX(`PLZ_Ort`, '' '', 1) AS `PLZ`,
             TRIM(SUBSTRING(`PLZ_Ort` FROM LOCATE('' '', `PLZ_Ort`) + 1)) AS `Ortsname`
         FROM `personen`
         WHERE `PLZ_Ort` IS NOT NULL
           AND `PLZ_Ort` <> ''''',
        'SELECT "4.2 PLZ_Ort wurde bereits ausgelagert" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
    
-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.

SET @sql = (
    SELECT IF(
        NOT EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'Orte_FK'
        )
        AND EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'PLZ_Ort'
        ),
        'ALTER TABLE `personen` ADD COLUMN `Orte_FK` INT UNSIGNED NULL AFTER `PLZ_Ort`',
        'SELECT "4.3 Orte_FK existiert bereits" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.4) Setzen Sie "Personen.orte_fk" mit den korrekten Werten.

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'PLZ_Ort'
        ),
        'UPDATE `personen` p
         JOIN `Orte` o
           ON o.`PLZ` = SUBSTRING_INDEX(p.`PLZ_Ort`, '' '', 1)
          AND o.`Ortsname` = TRIM(SUBSTRING(p.`PLZ_Ort` FROM LOCATE('' '', p.`PLZ_Ort`) + 1))
         SET p.`Orte_FK` = o.`ID`
         WHERE p.`ID` > 0
           AND p.`PLZ_Ort` IS NOT NULL',
        'SELECT "4.4 Orte_FK wurde bereits gesetzt" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.5) Erweitern Sie die View durch einen Join mit "Orte".
--      Renamen Sie "PLZ_Ort" in "Personen_Liste" zu "PLZ_Ort_Old".
--      "PLZ_Ort" ist nun das Attribut über den Join

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'PLZ_Ort'
        ),
        'CREATE OR REPLACE VIEW `Personen_Liste` AS
         SELECT
             p.`ID`,
             p.`Anrede`,
             p.`Vorname`,
             p.`Nachname`,
             TRIM(CONCAT(p.`Strassenname`, '' '', COALESCE(p.`Hausnummer`, ''''))) AS `Strasse`,
             p.`PLZ_Ort` AS `PLZ_Ort_Old`,
             CONCAT(o.`PLZ`, '' '', o.`Ortsname`) AS `PLZ_Ort`,
             p.`Tel_Nr`,
             p.`eMail`
         FROM `personen` p
         LEFT JOIN `Orte` o
           ON o.`ID` = p.`Orte_FK`',
        'SELECT "4.5 PLZ_Ort_Old ist bereits entfernt" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.6) Entwickeln Sie ein SELECT, welches alle Personen zurück gibt, bei dem PLZ_Ort_Old <> PLZ_Ort ist.

SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'Personen_Liste'
              AND COLUMN_NAME = 'PLZ_Ort_Old'
        ),
        'SELECT *
         FROM `Personen_Liste`
         WHERE `PLZ_Ort_Old` <> `PLZ_Ort`',
        'SELECT "4.6 PLZ_Ort_Old ist nicht mehr in der View" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View "PLZ_Ort_Old" auskommentieren.

CREATE OR REPLACE VIEW `Personen_Liste` AS
SELECT
    p.`ID`,
    p.`Anrede`,
    p.`Vorname`,
    p.`Nachname`,
    TRIM(CONCAT(p.`Strassenname`, ' ', COALESCE(p.`Hausnummer`, ''))) AS `Strasse`,
    -- p.`PLZ_Ort` AS `PLZ_Ort_Old`,
    CONCAT(o.`PLZ`, ' ', o.`Ortsname`) AS `PLZ_Ort`,
    p.`Tel_Nr`,
    p.`eMail`
FROM `personen` p
LEFT JOIN `Orte` o
    ON o.`ID` = p.`Orte_FK`;


-- 4.8) Löschen sie "PLZ_Ort" in "Personen" und fügen Sie noch 
--      einen Foreign-Key Contraint auf "Orte_FK" hinzu.


SET @sql = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND COLUMN_NAME = 'PLZ_Ort'
        ),
        'ALTER TABLE `personen` DROP COLUMN `PLZ_Ort`',
        'SELECT "4.8 PLZ_Ort wurde bereits gelöscht" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- FK-Constraints

SET @sql = (
    SELECT IF(
        NOT EXISTS (
            SELECT 1
            FROM information_schema.TABLE_CONSTRAINTS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'personen'
              AND CONSTRAINT_NAME = 'fk_personen_orte'
        ),
        'ALTER TABLE `personen`
             ADD CONSTRAINT `fk_personen_orte`
             FOREIGN KEY (`Orte_FK`)
             REFERENCES `Orte` (`ID`)',
        'SELECT "4.8 Foreign Key existiert bereits" AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- FK-Constraints
    
-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.

-- 4.9.1) Wie viele Datensätze hat es in personen_liste?

SELECT COUNT(*) AS Anzahl_Datensaetze
FROM `Personen_Liste`;

-- Effektive Anzahl: 1169

-- 4.9.2) Wie viele Personen leben in 8855 Wangen?

SELECT COUNT(*) AS Anzahl_Personen_8855_Wangen
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';

-- Effektive Anzahl: 703

-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?

SELECT COUNT(DISTINCT `PLZ_Ort`) AS Anzahl_Verschiedene_PLZ_Ort
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;

-- Effektive Anzahl: 82
    
