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

SET @Candidate_Firstname  := 'Thushara';    -- Durch ihren Vornamen ersetzen
SET @Candidate_Name       := 'Koneswaran';   -- Durch ihren Namen ersetzen
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
-- Effektive Anzahl: 1169
SELECT
    COUNT(*) AS `Anzahl Datensaetze`
FROM
    `Personen_Liste`;

-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statment und als Kommentar die effektive Anzahl)?
-- Effektive Anzahl Personen: 703
SELECT
    COUNT(*) AS `Anzahl Personen in 8855 Wangen`
FROM
    `Personen_Liste` AS `P`
WHERE
    `P`.`PLZ_Ort` = '8855 Wangen';

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?
-- Effektive Anzahl: 82

SELECT
    COUNT(DISTINCT `P`.`PLZ_Ort`) AS `Anzahl verschiedene PLZ_Ort`
FROM
    `Personen_Liste` AS `P`
WHERE
    `P`.`PLZ_Ort` IS NOT NULL;

-- 2) Entkoppeln der Rohdaten zu den Benutzern und Applikationen
-- =============================================================
-- Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
-- welche auf "Personen_Liste" zugreifen nichts davon merken (Abwärtskompatible).

-- 2.1) Renamen Sie "Personen_Liste" zu personen.
SET @table_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`TABLES`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'Personen_Liste'
      AND `TABLE_TYPE` = 'BASE TABLE'
);

SET @personen_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`TABLES`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `TABLE_TYPE` = 'BASE TABLE'
);

SET @sql = IF(
    @table_exists = 1 AND @personen_exists = 0,
    'RENAME TABLE `Personen_Liste` TO `personen`',
    'SELECT ''Tabelle wurde bereits umbenannt'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.2) Erstellen Sie eine view "Personen_Liste" mit den gleichen Attributen. In der Folge wird dieses Interface
--      nicht mehr geändert, lediglich die Implemenation der View wird angepasst.  
DROP VIEW IF EXISTS `Personen_Liste`;

SET @plz_ort_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'PLZ_Ort'
);

SET @strassenname_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'Strassenname'
);

SET @sql = IF(
    @plz_ort_exists = 1 AND @strassenname_exists = 0,

    'CREATE VIEW `Personen_Liste` AS
     SELECT
        `P`.`ID` AS `ID`,
        `P`.`Anrede` AS `Anrede`,
        `P`.`Vorname` AS `Vorname`,
        `P`.`Nachname` AS `Nachname`,
        `P`.`Strasse` AS `Strasse`,
        `P`.`PLZ_Ort` AS `PLZ_Ort`,
        `P`.`Tel_Nr` AS `Tel_Nr`,
        `P`.`eMail` AS `eMail`
     FROM `personen` AS `P`',

    IF(
        @plz_ort_exists = 1 AND @strassenname_exists = 1,

        'CREATE VIEW `Personen_Liste` AS
         SELECT
            `P`.`ID` AS `ID`,
            `P`.`Anrede` AS `Anrede`,
            `P`.`Vorname` AS `Vorname`,
            `P`.`Nachname` AS `Nachname`,
            CONCAT_WS('' '', `P`.`Strassenname`, `P`.`Hausnummer`) AS `Strasse`,
            `P`.`PLZ_Ort` AS `PLZ_Ort`,
            `P`.`Tel_Nr` AS `Tel_Nr`,
            `P`.`eMail` AS `eMail`
         FROM `personen` AS `P`',

        'CREATE VIEW `Personen_Liste` AS
         SELECT
            `P`.`ID` AS `ID`,
            `P`.`Anrede` AS `Anrede`,
            `P`.`Vorname` AS `Vorname`,
            `P`.`Nachname` AS `Nachname`,
            CONCAT_WS('' '', `P`.`Strassenname`, `P`.`Hausnummer`) AS `Strasse`,
            CONCAT(`O`.`PLZ`, '' '', `O`.`Ortsname`) AS `PLZ_Ort`,
            `P`.`Tel_Nr` AS `Tel_Nr`,
            `P`.`eMail` AS `eMail`
         FROM `personen` AS `P`
         LEFT JOIN `Orte` AS `O`
            ON `P`.`Orte_FK` = `O`.`ID`'
    )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.3) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
-- Verifikation erfolgreich: Test Selects laufen gelassen uns genau die gleichen effektive Anzahlen. 
-- 1.1. 1169
-- 1.2. 703
-- 1.3. 82


-- 3) Normalisieren I
-- ==================
-- Beim Analysieren der Daten stellen Sie fest, dass das Attribute "Strasse" zwei Informations-Elemente enthalten. 
-- Teilen Sie das auf "Strassenname" und "Hausnummer" auf.
-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: "Hausnummer" hinzu

SET @column_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'Hausnummer'
);

SET @sql = IF(
    @column_exists = 0,
    'ALTER TABLE `personen` ADD COLUMN `Hausnummer` VARCHAR(15) NULL AFTER `Strasse`',
    'SELECT ''Spalte Hausnummer existiert bereits'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3.2) Splitten Sie die "Strasse" in "Strassenname" und "Hausnummer".
-- Straße und Hausnummer extrahieren

SET @strasse_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'Strasse'
);

SET @sql = IF(
    @strasse_exists = 1,
    'UPDATE
        `personen`
     SET
        `Strasse` = REPLACE(`Strasse`, CONVERT(UNHEX(''C2A0'') USING utf8mb4), '' '')
     WHERE
        `ID` > 0',
    'SELECT ''Spalte Strasse existiert nicht mehr'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @sql = IF(
    @strasse_exists = 1,
    'UPDATE
        `personen`
     SET
        `Hausnummer` = TRIM(SUBSTRING_INDEX(TRIM(`Strasse`), '' '', -1)),
        `Strasse` = TRIM(
            LEFT(
                TRIM(`Strasse`),
                CHAR_LENGTH(TRIM(`Strasse`)) -
                CHAR_LENGTH(TRIM(SUBSTRING_INDEX(TRIM(`Strasse`), '' '', -1)))
            )
        )
     WHERE
        `ID` > 0
        AND (`Hausnummer` IS NULL OR `Hausnummer` = '''')
        AND LEFT(TRIM(SUBSTRING_INDEX(TRIM(`Strasse`), '' '', -1)), 1) BETWEEN ''0'' AND ''9''',
    'SELECT ''Split wurde bereits gemacht'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
    
# Testing ob es schön gesplittet worden ist.     
SET @strasse_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'Strasse'
);

SET @sql = IF(
    @strasse_exists = 1,
    'SELECT `ID`, `Strasse`, `Hausnummer` FROM `personen` LIMIT 20',
    'SELECT `ID`, `Strassenname`, `Hausnummer` FROM `personen` LIMIT 20'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3.4) Renamen Sie das Attribut "Strasse" zu "Strassenname"

SET @strasse_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'Strasse'
);

SET @strassenname_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'Strassenname'
);

SET @sql = IF(
    @strasse_exists = 1 AND @strassenname_exists = 0,
    'ALTER TABLE `personen` RENAME COLUMN `Strasse` TO `Strassenname`',
    'SELECT ''Spalte wurde bereits umbenannt'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3.5) Passen Sie die Implementation der view "Personen_Liste" entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.

DROP VIEW IF EXISTS `Personen_Liste`;

SET @plz_ort_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'PLZ_Ort'
);

SET @sql = IF(
    @plz_ort_exists = 1,

    'CREATE VIEW `Personen_Liste` AS
     SELECT
        `P`.`ID` AS `ID`,
        `P`.`Anrede` AS `Anrede`,
        `P`.`Vorname` AS `Vorname`,
        `P`.`Nachname` AS `Nachname`,
        CONCAT_WS('' '', `P`.`Strassenname`, `P`.`Hausnummer`) AS `Strasse`,
        `P`.`PLZ_Ort` AS `PLZ_Ort`,
        `P`.`Tel_Nr` AS `Tel_Nr`,
        `P`.`eMail` AS `eMail`
     FROM `personen` AS `P`',

    'CREATE VIEW `Personen_Liste` AS
     SELECT
        `P`.`ID` AS `ID`,
        `P`.`Anrede` AS `Anrede`,
        `P`.`Vorname` AS `Vorname`,
        `P`.`Nachname` AS `Nachname`,
        CONCAT_WS('' '', `P`.`Strassenname`, `P`.`Hausnummer`) AS `Strasse`,
        CONCAT(`O`.`PLZ`, '' '', `O`.`Ortsname`) AS `PLZ_Ort`,
        `P`.`Tel_Nr` AS `Tel_Nr`,
        `P`.`eMail` AS `eMail`
     FROM `personen` AS `P`
     LEFT JOIN `Orte` AS `O`
        ON `P`.`Orte_FK` = `O`.`ID`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

#Testing:
SELECT
    *
FROM
    `Personen_Liste`
LIMIT 10;

-- 4) Normalisieren II
-- ===================
-- Eliminieren Sie Redundanzen in dem Sie Postleitzahl und Ort trennen und in eine seperate
-- Tabelle auslagern.

-- 4.1) Erstellen Sie eine neue Tabelle "Orte" mit den Attributten "PLZ" und "Ortsname"

CREATE TABLE IF NOT EXISTS `Orte` (
    `ID`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `PLZ`      VARCHAR(10)  NOT NULL,
    `Ortsname` VARCHAR(100) NOT NULL,

    PRIMARY KEY (`ID`),

    UNIQUE INDEX `PLZ_Ortsname_UNIQUE` (`PLZ`, `Ortsname`)
);
    
-- 4.2) Lagern Sie alle Orte und PLZ von der "Personen" Tabelle in "Orte" aus.
SET @plz_ort_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'PLZ_Ort'
);

SET @sql = IF(
    @plz_ort_exists = 1,
    'INSERT IGNORE INTO `Orte` (`PLZ`, `Ortsname`)
     SELECT DISTINCT
        SUBSTRING_INDEX(TRIM(`P`.`PLZ_Ort`), '' '', 1) AS `PLZ`,
        TRIM(SUBSTRING(TRIM(`P`.`PLZ_Ort`), LOCATE('' '', TRIM(`P`.`PLZ_Ort`)) + 1)) AS `Ortsname`
     FROM
        `personen` AS `P`
     WHERE
        `P`.`PLZ_Ort` IS NOT NULL
        AND TRIM(`P`.`PLZ_Ort`) <> ''''',
    'SELECT ''PLZ_Ort wurde bereits ausgelagert'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.3) Fügen Sie ein Foreignkey (FK) mit Name "Orte_FK" in "Personen" nach dem Attribut PLZ_Ort ein.

SET @column_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'Orte_FK'
);

SET @sql = IF(
    @column_exists = 0,
    'ALTER TABLE `personen` ADD COLUMN `Orte_FK` INT UNSIGNED NULL AFTER `PLZ_Ort`',
    'SELECT ''Spalte Orte_FK existiert bereits'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.4) Setzen Sie "Personen.orte_fk" mit den korrekten Werten.
SET @plz_ort_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'PLZ_Ort'
);

SET @sql = IF(
    @plz_ort_exists = 1,
    'UPDATE
        `personen` AS `P`
     INNER JOIN `Orte` AS `O`
        ON `O`.`PLZ` = SUBSTRING_INDEX(TRIM(`P`.`PLZ_Ort`), '' '', 1)
        AND `O`.`Ortsname` = TRIM(SUBSTRING(TRIM(`P`.`PLZ_Ort`), LOCATE('' '', TRIM(`P`.`PLZ_Ort`)) + 1))
     SET
        `P`.`Orte_FK` = `O`.`ID`
     WHERE
        `P`.`ID` > 0',
    'SELECT ''Orte_FK wurde bereits gesetzt'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.5) Erweitern Sie die View durch einen Join mit "Orte".
--      Renamen Sie "PLZ_Ort" in "Personen_Liste" zu "PLZ_Ort_Old".
--      "PLZ_Ort" ist nun das Attribut über den Join
DROP VIEW IF EXISTS `Personen_Liste`;

SET @plz_ort_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'PLZ_Ort'
);

SET @sql = IF(
    @plz_ort_exists = 1,

    'CREATE VIEW `Personen_Liste` AS
     SELECT
        `P`.`ID` AS `ID`,
        `P`.`Anrede` AS `Anrede`,
        `P`.`Vorname` AS `Vorname`,
        `P`.`Nachname` AS `Nachname`,
        CONCAT_WS('' '', `P`.`Strassenname`, `P`.`Hausnummer`) AS `Strasse`,
        `P`.`PLZ_Ort` AS `PLZ_Ort_Old`,
        CONCAT(`O`.`PLZ`, '' '', `O`.`Ortsname`) AS `PLZ_Ort`,
        `P`.`Tel_Nr` AS `Tel_Nr`,
        `P`.`eMail` AS `eMail`
     FROM
        `personen` AS `P`
     LEFT JOIN `Orte` AS `O`
        ON `P`.`Orte_FK` = `O`.`ID`',

    'CREATE VIEW `Personen_Liste` AS
     SELECT
        `P`.`ID` AS `ID`,
        `P`.`Anrede` AS `Anrede`,
        `P`.`Vorname` AS `Vorname`,
        `P`.`Nachname` AS `Nachname`,
        CONCAT_WS('' '', `P`.`Strassenname`, `P`.`Hausnummer`) AS `Strasse`,
        CONCAT(`O`.`PLZ`, '' '', `O`.`Ortsname`) AS `PLZ_Ort`,
        `P`.`Tel_Nr` AS `Tel_Nr`,
        `P`.`eMail` AS `eMail`
     FROM
        `personen` AS `P`
     LEFT JOIN `Orte` AS `O`
        ON `P`.`Orte_FK` = `O`.`ID`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4.6) Entwickeln Sie ein SELECT, welches alle Personen zurück gibt, bei dem PLZ_Ort_Old <> PLZ_Ort ist.
SET @plz_ort_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'PLZ_Ort'
);

SET @sql = IF(
    @plz_ort_exists = 1,
    'SELECT
        `P`.`ID`,
        `P`.`Vorname`,
        `P`.`Nachname`,
        `P`.`PLZ_Ort_Old`,
        `P`.`PLZ_Ort`
     FROM
        `Personen_Liste` AS `P`
     WHERE
        NOT (`P`.`PLZ_Ort_Old` <=> `P`.`PLZ_Ort`)',
    'SELECT ''PLZ_Ort_Old existiert nicht mehr, Migration wurde bereits durchgeführt'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
    
# Keine Ausgaben: Migration ok. 

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View "PLZ_Ort_Old" auskommentieren.

DROP VIEW IF EXISTS `Personen_Liste`;
CREATE VIEW `Personen_Liste` AS
SELECT
    `P`.`ID` AS `ID`,
    `P`.`Anrede` AS `Anrede`,
    `P`.`Vorname` AS `Vorname`,
    `P`.`Nachname` AS `Nachname`,
    CONCAT_WS(' ', `P`.`Strassenname`, `P`.`Hausnummer`) AS `Strasse`,
    CONCAT(`O`.`PLZ`, ' ', `O`.`Ortsname`) AS `PLZ_Ort`,
    `P`.`Tel_Nr` AS `Tel_Nr`,
    `P`.`eMail` AS `eMail`
FROM
    `personen` AS `P`
LEFT JOIN `Orte` AS `O`
    ON `P`.`Orte_FK` = `O`.`ID`;

-- 4.8) Löschen sie "PLZ_Ort" in "Personen" und fügen Sie noch 
SET @column_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`COLUMNS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `COLUMN_NAME` = 'PLZ_Ort'
);

SET @sql = IF(
    @column_exists = 1,
    'ALTER TABLE `personen` DROP COLUMN `PLZ_Ort`',
    'SELECT ''Spalte PLZ_Ort wurde bereits gelöscht'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
--      einen Foreign-Key Contraint auf "Orte_FK" hinzu.
SET @fk_exists = (
    SELECT COUNT(*)
    FROM `information_schema`.`TABLE_CONSTRAINTS`
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'personen'
      AND `CONSTRAINT_NAME` = 'fk_personen_orte'
);

SET @sql = IF(
    @fk_exists = 0,
    'ALTER TABLE `personen`
     ADD CONSTRAINT `fk_personen_orte`
     FOREIGN KEY (`Orte_FK`)
     REFERENCES `Orte` (`ID`)',
    'SELECT ''Foreign Key existiert bereits'' AS `Info`'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- FK-Constraints
-- 4.9) Verifizieren: Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.
-- Verification erfolgreich: bekomme immer noch die gleichen Zahlen. 

-- 4.9.1) Wie viele Datensätze hat es in personen_liste?
-- Effektive Anzahl: 1169
SELECT
    COUNT(*) AS `Anzahl Datensaetze`
FROM
    `Personen_Liste`;
-- 4.9.2) Wie viele Personen leben in 8855 Wangen?
-- Effektive Anzahl: 703
SELECT
    COUNT(*) AS `Anzahl Personen in 8855 Wangen`
FROM
    `Personen_Liste` AS `P`
WHERE
    `P`.`PLZ_Ort` = '8855 Wangen';
-- 4.9.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
-- Effektive Anzahl: 82
SELECT
    COUNT(DISTINCT `P`.`PLZ_Ort`) AS `Anzahl verschiedene PLZ_Ort`
FROM
    `Personen_Liste` AS `P`
WHERE
    `P`.`PLZ_Ort` IS NOT NULL;
    