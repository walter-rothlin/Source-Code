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

SET @Candidate_Firstname  := 'Tim';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Mosbacher';   -- Durch ihren Namen ersetzen
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
SELECT COUNT(*) AS Anzahl_Datensaetze
FROM Personen_Liste;
-- 1169


-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statment und als Kommentar die effektive Anzahl)?
SELECT COUNT(*) AS Anzahl_Personen_8855_Wangen
FROM Personen_Liste
WHERE PLZ_Ort = '8855 Wangen';
-- 703


-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?
SELECT COUNT(DISTINCT PLZ_Ort) AS Anzahl_verschiedene_PLZ_Ort
FROM Personen_Liste
WHERE PLZ_Ort IS NOT NULL;
-- 82


-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================
-- Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
-- welche auf "Personen_Liste" zugreifen nichts davon merken (Abwärtskompatible).
USE `pruefung_2`;

-- 2.1) Renamen Sie "Personen_Liste" zu personen.
SET @schema_name := DATABASE();

SELECT COUNT(*)
INTO @personen_exists
FROM information_schema.tables
WHERE table_schema = @schema_name
  AND LOWER(table_name) = LOWER('personen')
  AND table_type = 'BASE TABLE';

SELECT table_name
INTO @personen_liste_table_name
FROM information_schema.tables
WHERE table_schema = @schema_name
  AND LOWER(table_name) = LOWER('Personen_Liste')
  AND table_type = 'BASE TABLE'
LIMIT 1;

SET @sql := IF(
    @personen_exists = 0 AND @personen_liste_table_name IS NOT NULL,
    CONCAT(
        'RENAME TABLE `',
        @schema_name,
        '`.`',
        @personen_liste_table_name,
        '` TO `',
        @schema_name,
        '`.`personen`'
    ),
    'SELECT ''Rename skipped'' AS Info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

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

-- 2.3) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
-- 1.1
SELECT COUNT(*) AS Anzahl_Datensaetze
FROM `Personen_Liste`;
-- 1169
-- 1.2
SELECT COUNT(*) AS Anzahl_Personen_8855_Wangen
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- 703
-- 1.3
SELECT COUNT(DISTINCT `PLZ_Ort`) AS Anzahl_verschiedene_PLZ_Ort
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;
-- 82

-- 3) Normalisieren I
-- ==================
-- Beim Analysieren der Daten stellen Sie fest, dass das Attribute "Strasse" zwei Informations-Elemente enthalten. 
-- Teilen Sie das auf "Strassenname" und "Hausnummer" auf.




-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu
SET @hausnummer_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'Hausnummer'
);

SET @strasse_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'Strasse'
);

SET @strassenname_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'Strassenname'
);

SET @sql := IF(
    @hausnummer_exists = 0 AND @strasse_exists = 1,
    'ALTER TABLE `personen` ADD COLUMN `Hausnummer` VARCHAR(20) NULL AFTER `Strasse`',
    IF(
        @hausnummer_exists = 0 AND @strassenname_exists = 1,
        'ALTER TABLE `personen` ADD COLUMN `Hausnummer` VARCHAR(20) NULL AFTER `Strassenname`',
        'SELECT ''Hausnummer already exists'' AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
    
-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".

-- Straße und Hausnummer extrahieren
UPDATE `personen`
SET
    `Hausnummer` = REGEXP_SUBSTR(`Strasse`, '[0-9]+[a-zA-Z]*$'),
    `Strasse` = TRIM(REGEXP_REPLACE(`Strasse`, '[[:space:]]+[0-9]+[a-zA-Z]*$', ''))
WHERE @strasse_exists = 1
  AND `Strasse` REGEXP '[[:space:]][0-9]+[a-zA-Z]*$'
  AND (`Hausnummer` IS NULL OR `Hausnummer` = '');

-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"
SET @strasse_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'Strasse'
);

SET @strassenname_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'Strassenname'
);

SET @sql := IF(
    @strasse_exists = 1 AND @strassenname_exists = 0,
    'ALTER TABLE `personen` RENAME COLUMN `Strasse` TO `Strassenname`',
    'SELECT ''Rename Strasse skipped'' AS Info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3.5) Passen Sie die Implementation der view "Personen_Liste" entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.
USE `pruefung_2`;

DROP VIEW IF EXISTS `Personen_Liste`;
CREATE VIEW `Personen_Liste` AS
SELECT
    `ID`,
    `Anrede`,
    `Vorname`,
    `Nachname`,
    TRIM(CONCAT_WS(' ', `Strassenname`, NULLIF(`Hausnummer`, ''))) AS `Strasse`,
    `PLZ_Ort`,
    `Tel_Nr`,
    `eMail`
FROM `personen`;

-- 4) Normalisieren II
-- ===================
-- Eliminieren Sie Redundanzen in dem Sie Postleitzahl und Ort trennen und in eine seperate
-- Tabelle auslagern.
USE `pruefung_2`;

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"
CREATE TABLE IF NOT EXISTS `Orte` (
    `ID`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `PLZ`       VARCHAR(10)  NOT NULL,
    `Ortsname`  VARCHAR(100) NOT NULL,

    PRIMARY KEY (`ID`),
    UNIQUE KEY `UX_Orte_PLZ_Ortsname` (`PLZ`, `Ortsname`)
);

-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.
SET @plz_ort_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'PLZ_Ort'
);

SET @sql := IF(
    @plz_ort_exists = 1,
    '
    INSERT IGNORE INTO `Orte` (`PLZ`, `Ortsname`)
    SELECT DISTINCT
        SUBSTRING_INDEX(`PLZ_Ort`, '' '', 1) AS `PLZ`,
        TRIM(SUBSTRING(`PLZ_Ort`, LENGTH(SUBSTRING_INDEX(`PLZ_Ort`, '' '', 1)) + 2)) AS `Ortsname`
    FROM `personen`
    WHERE `PLZ_Ort` IS NOT NULL
      AND TRIM(`PLZ_Ort`) <> ''''
    ',
    'SELECT ''PLZ_Ort already migrated'' AS Info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.
SET @orte_fk_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'Orte_FK'
);

SET @plz_ort_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'PLZ_Ort'
);

SET @sql := IF(
    @orte_fk_exists = 0 AND @plz_ort_exists = 1,
    'ALTER TABLE `personen` ADD COLUMN `Orte_FK` INT UNSIGNED NULL AFTER `PLZ_Ort`',
    IF(
        @orte_fk_exists = 0,
        'ALTER TABLE `personen` ADD COLUMN `Orte_FK` INT UNSIGNED NULL',
        'SELECT ''Orte_FK already exists'' AS Info'
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 4.4) Setzen Sie "Personen.orte_fk" mit den korrekten Werten.

SET @plz_ort_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'PLZ_Ort'
);

SET @orte_fk_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'Orte_FK'
);

SET @sql := IF(
    @plz_ort_exists = 1 AND @orte_fk_exists = 1,
    '
    UPDATE `personen` p
    JOIN `Orte` o
        ON o.`PLZ` = SUBSTRING_INDEX(p.`PLZ_Ort`, '' '', 1)
       AND o.`Ortsname` = TRIM(SUBSTRING(p.`PLZ_Ort`, LENGTH(SUBSTRING_INDEX(p.`PLZ_Ort`, '' '', 1)) + 2))
    SET p.`Orte_FK` = o.`ID`
    WHERE p.`PLZ_Ort` IS NOT NULL
      AND TRIM(p.`PLZ_Ort`) <> ''''
      AND p.`Orte_FK` IS NULL
    ',
    'SELECT ''PLZ_Ort or Orte_FK column missing, cannot set Orte_FK'' AS Info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 4.5) Erweitern Sie die View durch einen Join mit "Orte".
--      Renamen Sie "PLZ_Ort" in "Personen_Liste" zu "PLZ_Ort_Old".
--      "PLZ_Ort" ist nun das Attribut über den Join
USE `pruefung_2`;

DROP VIEW IF EXISTS `Personen_Liste`;
CREATE VIEW `Personen_Liste` AS
SELECT
    p.`ID`,
    p.`Anrede`,
    p.`Vorname`,
    p.`Nachname`,
    TRIM(CONCAT_WS(' ', p.`Strassenname`, NULLIF(p.`Hausnummer`, ''))) AS `Strasse`,
    p.`PLZ_Ort` AS `PLZ_Ort_Old`,
    CONCAT(o.`PLZ`, ' ', o.`Ortsname`) AS `PLZ_Ort`,
    p.`Tel_Nr`,
    p.`eMail`
FROM `personen` p
LEFT JOIN `Orte` o
    ON p.`Orte_FK` = o.`ID`;


-- 4.6) Entwickeln Sie ein SELECT, welches alle Personen zurück gibt, bei dem PLZ_Ort_Old <> PLZ_Ort ist.
SELECT
    `ID`,
    `PLZ_Ort_Old`,
    `PLZ_Ort`
FROM `Personen_Liste`
WHERE `PLZ_Ort_Old` <> `PLZ_Ort`
   OR (`PLZ_Ort_Old` IS NULL AND `PLZ_Ort` IS NOT NULL)
   OR (`PLZ_Ort_Old` IS NOT NULL AND `PLZ_Ort` IS NULL);

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View "PLZ_Ort_Old" auskommentieren.
CREATE OR REPLACE VIEW `Personen_Liste` AS
SELECT
    p.`ID`,
    p.`Anrede`,
    p.`Vorname`,
    p.`Nachname`,
    TRIM(CONCAT_WS(' ', p.`Strassenname`, NULLIF(p.`Hausnummer`, ''))) AS `Strasse`,
    CONCAT(o.`PLZ`, ' ', o.`Ortsname`) AS `PLZ_Ort`,
    p.`Tel_Nr`,
    p.`eMail`
FROM `personen` p
LEFT JOIN `Orte` o
    ON p.`Orte_FK` = o.`ID`;
-- 4.8) Löschen sie "PLZ_Ort" in "Personen" und fügen Sie noch 
--      einen Foreign-Key Contraint auf "Orte_FK" hinzu.
SET @plz_ort_exists := (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND column_name = 'PLZ_Ort'
);

SET @sql := IF(
    @plz_ort_exists = 1,
    'ALTER TABLE `personen` DROP COLUMN `PLZ_Ort`',
    'SELECT ''PLZ_Ort already dropped'' AS Info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- Index für FK erstellen, falls noch nicht vorhanden

SET @idx_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'personen'
      AND index_name = 'idx_personen_orte_fk'
);

SET @sql := IF(
    @idx_exists = 0,
    'ALTER TABLE `personen` ADD INDEX `idx_personen_orte_fk` (`Orte_FK`)',
    'SELECT ''Index already exists'' AS Info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
-- FK-Constraints
    SET @fk_exists := (
    SELECT COUNT(*)
    FROM information_schema.referential_constraints
    WHERE constraint_schema = DATABASE()
      AND table_name = 'personen'
      AND constraint_name = 'personen_orte_fk'
);

SET @sql := IF(
    @fk_exists = 0,
    '
    ALTER TABLE `personen`
    ADD CONSTRAINT `personen_orte_fk`
    FOREIGN KEY (`Orte_FK`)
    REFERENCES `Orte` (`ID`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    ',
    'SELECT ''Foreign Key already exists'' AS Info'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
-- 4.9.1) Wie viele Datensätze hat es in personen_liste?
SELECT COUNT(*) AS Anzahl_Datensaetze
FROM `Personen_Liste`;
-- 4.9.2) Wie viele Personen leben in 8855 Wangen?
SELECT COUNT(*) AS Anzahl_Personen_8855_Wangen
FROM `Personen_Liste`
WHERE `PLZ_Ort` = '8855 Wangen';
-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
 SELECT COUNT(DISTINCT `PLZ_Ort`) AS Anzahl_verschiedene_PLZ_Ort
FROM `Personen_Liste`
WHERE `PLZ_Ort` IS NOT NULL;