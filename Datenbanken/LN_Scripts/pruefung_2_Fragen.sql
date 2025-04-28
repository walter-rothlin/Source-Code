-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Aufgaben und Fragen zu Prüfung 2 
--
-- History:
-- 24-Apr-2025   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------
-- Normalisieren Sie die personen_liste und erstellen Sie hier ein Migrations-Script.
--
-- Gehen Sie in folgenden Schritten vor:
-- 1) Sammeln Sie zuerst einige Informationen über die bestehenden Daten,
--    welche später bei der Test-Driven Entwicklung zum Verifizieren gebraucht werden 
--    können.

-- 1.1) Wie viele Datensätze hat es in personen_liste 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?
SELECT count(*) FROM `personen_liste`;                                            -- --> 1169

-- 1.2) Wie viele Personen leben in 8855 Wangen 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?
SELECT count(*) FROM `personen_liste` WHERE `PLZ_Ort` LIKE '8855 W%';             -- --> 703

-- 1.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null) 
--      (SQL-Statmwent und als Kommentar die effektive Anzahl)?
SELECT count(distinct `PLZ_Ort`) FROM `personen_liste`;                           -- --> 82


-- 2) Bevor Sie mit der Normalisierung beginnen, stellen Sie sicher, dass für Apps/Personen,
--    welche auf personen_liste zugreifen nichts davon merken.

-- 2.1) Renamen Sie personen_liste zu personen.
ALTER TABLE `personen_liste` RENAME TO  `personen`;

-- 2.2) Erstellen Sie eine view personen_liste mit den gleichen Attributen.
DROP VIEW IF EXISTS `Personen_Liste`; 
CREATE VIEW `Personen_Liste` AS
	SELECT
		 `ID`         AS `ID`,
		 `Anrede`     AS `Anrede`,
		 `Vorname`    AS `Vorname`,
		 `Nachname`   AS `Nachname`,
         `Strasse`    AS `Strasse`,
		 `PLZ_Ort`    AS `PLZ_Ort`,
		 `Tel_Nr`     AS `Tel_Nr`,
		 `eMail`      AS `eMail`
	FROM `personen`;

-- 2.3) Lassen Sie die Test-SELECTs von 1) nochmals laufen und sie sollten genau die gleichen Anzahlen bekommen.


-- 3) Normalisierung 1: Aufteilen der Strassenbezeichnung und der Hausnummer.

-- 3.1) Fügen Sie in der Tabelle ein weiteres Attribut nach dem Attribut Strasse hinzu: Hausnr VARCHAR(100) NULL hinzu
ALTER TABLE `personen` 
	ADD COLUMN `Hausnr` VARCHAR(100) NULL DEFAULT 'Null' AFTER `Strasse`;
    
-- 3.2) Splitten Sie die Strasse in Strassenbezeichnung und Hausnummer.

-- Straße und Hausnummer extrahieren
SELECT
  REGEXP_SUBSTR(`Strasse`, '^[^0-9]+') AS `Strassenname`,
  REGEXP_SUBSTR(`Strasse`, '[0-9]+[a-zA-Z]*$') AS `Hausnummer`
FROM `personen`;

UPDATE `personen`
	SET `Hausnr` = REGEXP_SUBSTR(`Strasse`, '[0-9]+[a-zA-Z]*$');
    
UPDATE `personen`
	SET `Strasse` = REGEXP_SUBSTR(`Strasse`, '^[^0-9]+');

-- 3.3) Passen Sie die Implementation der view personen_liste entsprechend an, so das in Strasse 
--      wieder die Strassenbezeichnung und die Hausnummer erscheint.
DROP VIEW IF EXISTS `Personen_Liste`; 
CREATE VIEW `Personen_Liste` AS
	SELECT
		 `ID`               AS `ID`,
		 `Anrede`           AS `Anrede`,
		 `Vorname`          AS `Vorname`,
		 `Nachname`         AS `Nachname`,
         CONCAT(`Strasse`,
                ' ',
                `Hausnr`)   AS `Strasse`,
		 `PLZ_Ort`          AS `PLZ_Ort`,
		 `Tel_Nr`           AS `Tel_Nr`,
		 `eMail`            AS `eMail`
	FROM `personen`;


-- 4) Normalisierung 2: Auslagern der PLZ_Ort in eine seperate Tabelle.

-- 4.1) Erstellen Sie eine neue Tabelle Orte mit den Attributten PLZ und Ortsname
DROP TABLE IF EXISTS `Orte`;
CREATE TABLE IF NOT EXISTS `Orte` (
	`ID`            	INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`PLZ`        	    VARCHAR(100) NOT NULL,
	`Ortsname`          VARCHAR(100) NOT NULL,
	
    -- PK-Constraints
    PRIMARY KEY (`ID`));
    
-- 4.2) Lagern Sie alle Orte und PLZ von der personen Tabelle in Orte aus.
INSERT INTO `Orte` (`PLZ`, `Ortsname`)
	SELECT 
	   TRIM(SUBSTRING_INDEX(`p`.`PLZ_Ort`, ' ', 1))                                       AS `PLZ`,
	   TRIM(SUBSTRING(`p`.`PLZ_Ort`, LENGTH(SUBSTRING_INDEX(`p`.`PLZ_Ort`, ' ', 1)) + 2)) AS `Ortsname`
	FROM (SELECT DISTINCT `PLZ_Ort` FROM `personen`) AS `p`
	WHERE `p`.`PLZ_Ort` IS NOT NULL
    ORDER BY `PLZ`;
    
-- 4.3) Fügen Sie ein FK zu Orte in personen nach dem attribut PLZ_Ort ein.
ALTER TABLE `personen` 
	ADD COLUMN `Orte_FK` INT UNSIGNED NULL AFTER `PLZ_Ort`;

-- 4.4) Setzen Sie personen.orte_fk correct.
UPDATE `personen`
JOIN `orte` ON `personen`.`PLZ_Ort` = CONCAT(`orte`.`PLZ`, ' ', `orte`.`Ortsname`)
SET `personen`.`Orte_fk` = `orte`.`id`;

-- 4.5) Erweitern Sie die View durch einen Join mit orte.
--      Renamen Sie PLZ_Ort in Personen_liste zu PLZ_Ort_old.
--      PLZ_Ort ist nun das Attribut über den Join

DROP VIEW IF EXISTS `Personen_Liste`; 
CREATE VIEW `Personen_Liste` AS
	SELECT
		 `p`.`ID`               AS `ID`,
		 `p`.`Anrede`           AS `Anrede`,
		 `p`.`Vorname`          AS `Vorname`,
		 `p`.`Nachname`         AS `Nachname`,
         CONCAT(`p`.`Strasse`,
                ' ',
                `p`.`Hausnr`)   AS `Strasse`,
		 `p`.`PLZ_Ort`          AS `PLZ_Ort_old`,
         CONCAT(`o`.`PLZ`,
                ' ',
                `o`.`Ortsname`)   AS `PLZ_Ort`,         
		 `p`.`Tel_Nr`           AS `Tel_Nr`,
		 `p`.`eMail`            AS `eMail`
	FROM `personen` as `p`
    INNER JOIN `orte` AS `o` ON `p`.`Orte_fk` = `o`.`id`;

-- 4.6) Entwickeln Sie ein SELECT welches alle Personen zurück gibt, bei dem PLZ_Ort_old <> PLZ_Ort ist.
SELECT * FROM `Personen_Liste` WHERE `PLZ_Ort_old` <> `PLZ_Ort`;

-- 4.7) Falls SELECT von vorheriger Aufgabe keine Fehler-Tuples zurück gibt, ist die Migration o.k. und Sie können 
--      die aus der View PLZ_Ort_old auskommentieren.
DROP VIEW IF EXISTS `Personen_Liste`; 
CREATE VIEW `Personen_Liste` AS
	SELECT
		 `p`.`ID`               AS `ID`,
		 `p`.`Anrede`           AS `Anrede`,
		 `p`.`Vorname`          AS `Vorname`,
		 `p`.`Nachname`         AS `Nachname`,
         CONCAT(`p`.`Strasse`,
                ' ',
                `p`.`Hausnr`)   AS `Strasse`,
		 -- `p`.`PLZ_Ort`          AS `PLZ_Ort_old`,
         CONCAT(`o`.`PLZ`,
                ' ',
                `o`.`Ortsname`)   AS `PLZ_Ort`,         
		 `p`.`Tel_Nr`           AS `Tel_Nr`,
		 `p`.`eMail`            AS `eMail`
	FROM `personen` as `p`
    INNER JOIN `orte` AS `o` ON `p`.`Orte_fk` = `o`.`id`;

-- 4.8) Löschen sie PLZ_Ort in personen und fügen Sie noch 
--      einen Foreign-Key Contraint auf Orte_FK hinzu.
ALTER TABLE `personen` DROP COLUMN `PLZ_Ort`;

-- FK-Constraints
ALTER TABLE `personen` 
  ADD CONSTRAINT `fk_personen_orte`
    FOREIGN KEY (`Orte_FK`)
    REFERENCES `Orte` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
    
-- 5) Final checks for the migration. Kopieren Sie die 3 Statements der Aufgabe 1 und führen Sie diese nochmals aus 
--    und schreiben die Resultate als Kommentar hin. Vergleichen Sie die Zahlen mit Aufgabe 1.

-- 5.1) Wie viele Datensätze hat es in personen_liste?
SELECT count(*) FROM `personen_liste`;                                            -- --> 1169

-- 5.2) Wie viele Personen leben in 8855 Wangen?
SELECT count(*) FROM `personen_liste` WHERE `PLZ_Ort` LIKE '8855 W%';             -- --> 703

-- 5.3) Wie viele verschiedene PLZ_Ort gibt es in der Tabelle (Not Null)?
SELECT count(distinct `PLZ_Ort`) FROM `personen_liste`;                           -- --> 82
    
