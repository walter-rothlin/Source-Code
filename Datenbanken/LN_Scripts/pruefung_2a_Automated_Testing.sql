-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Automated_Testing der Prüfung 2 
--
-- History:
-- 07-Jun-2025   Walter Rothlin      Initial Version
-- 15-Jun-2025   Walter Rothlin      Simplified Testing (refacotring using stored-procedures)
-- ---------------------------------------------------------------------------------

-- Test execution
-- ==============
USE `Pruefung_2`;
SET @time_testrun := now();
    
SET `SQL_SAFE_UPDATES` = 0;
DELETE FROM `Test_Results`.`Test_Logs` 
WHERE  `Class`               = @Class 
   AND `Test_Name`           = @Test_Name
   AND `Candidate_Firstname` = @Candidate_Firstname
   AND `Candidate_Name`      = @Candidate_Name;
SET `SQL_SAFE_UPDATES` = 1;

CALL `Test_Results`.`AddOrUpdateTestDefinition`(@Test_Name, @Test_Max_Punkte);   

-- -------------------------------------------------------------------------------------
-- 1) Ueberprüfen der Meta-Strukturen Table, Views und Attribute
-- -------------------------------------------------------------------------------------
SET @test_id  := '1.1 Table "Personen" existiert?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN table_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN table_exists = 1 THEN ''
        ELSE 'Tabelle "Personen" existiert nicht'
    END AS Test_Kommentar
FROM (
    SELECT 
        EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE TABLE_SCHEMA = DATABASE() 
              AND TABLE_NAME = 'Personen'
        ) AS table_exists
) AS sub;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '1.2 Table "Orte" existiert?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN table_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN table_exists = 1 THEN ''
        ELSE 'Table "Orte" existiert nicht'
    END AS Test_Kommentar
FROM (
    SELECT 
        EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE TABLE_SCHEMA = DATABASE() 
              AND TABLE_NAME = 'Orte'
        ) AS table_exists
) AS sub;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '1.3 View "Personen_Liste" existiert?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN table_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN table_exists = 1 THEN ''
        ELSE 'View "Personen_Liste" existiert nicht'
    END AS Test_Kommentar
FROM (
    SELECT 
        EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE TABLE_SCHEMA = DATABASE() 
              AND TABLE_NAME = 'Personen_Liste'
        ) AS table_exists
) AS sub;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '1.4 Attribute "Hausnummer" existiert in Table "Personen"?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN column_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN column_exists = 1 THEN ''
        ELSE '"Hausnummer" existiert nicht in "Personen"'
    END AS Test_Kommentar
FROM (
	SELECT 
		EXISTS (
			SELECT 1
			FROM information_schema.columns 
			WHERE TABLE_SCHEMA = DATABASE()
			  AND TABLE_NAME   = 'Personen'
			  AND COLUMN_NAME  = 'Hausnummer'
		) AS column_exists
) AS sub;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '1.5 Attribute "Orte_FK" existiert in Table "Personen"?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN column_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN column_exists = 1 THEN ''
        ELSE '"Orte_FK" existiert nicht in "Personen"'
    END AS Test_Kommentar
FROM (
	SELECT 
		EXISTS (
			SELECT 1
			FROM information_schema.columns 
			WHERE TABLE_SCHEMA = DATABASE()
			  AND TABLE_NAME   = 'Personen'
			  AND COLUMN_NAME  = 'Orte_FK'
		) AS column_exists
) AS sub;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '1.6 Attribute "PLZ" existiert in Table "Orte"?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN column_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN column_exists = 1 THEN ''
        ELSE '"PLZ" existiert nicht in "Orte"'
    END AS Test_Kommentar
FROM (
	SELECT 
		EXISTS (
			SELECT 1
			FROM information_schema.columns 
			WHERE TABLE_SCHEMA = DATABASE()
			  AND TABLE_NAME   = 'Orte'
			  AND COLUMN_NAME  = 'PLZ'
		) AS column_exists
) AS sub;-- -------------------------------------------------------------------------------------    
SET @test_id  := '1.7 Attribute "Ortsname" existiert in Table "Orte"?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN column_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN column_exists = 1 THEN ''
        ELSE '"Ortsname" existiert nicht in "Orte"'
    END AS Test_Kommentar
FROM (
	SELECT 
		EXISTS (
			SELECT 1
			FROM information_schema.columns 
			WHERE TABLE_SCHEMA = DATABASE()
			  AND TABLE_NAME   = 'Orte'
			  AND COLUMN_NAME  = 'Ortsname'
		) AS column_exists
) AS sub;
-- -------------------------------------------------------------------------------------
SET @test_id  := '1.8 Attribute "Strassenname" existiert in Table "Personen"?'; 
SET @expected := 1;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
SELECT
    @time_testrun        AS Timestamp,
    @Class               AS Class,
    @Test_Name           AS Test_Name,
    @Candidate_Firstname AS Candidate_Firstname,
    @Candidate_Name      AS Candidate_Name,
    @test_id             AS Testcase,
    CASE 
        WHEN column_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS Test_Status,
    CASE 
        WHEN column_exists = 1 THEN ''
        ELSE '"Strassenname" existiert nicht in "Personen"'
    END AS Test_Kommentar
FROM (
	SELECT 
		EXISTS (
			SELECT 1
			FROM information_schema.columns 
			WHERE TABLE_SCHEMA = DATABASE()
			  AND TABLE_NAME   = 'Personen'
			  AND COLUMN_NAME  = 'Strassenname'
		) AS column_exists
) AS sub;

-- -------------------------------------------------------------------------------------    
SET @test_id  := '1.9 Check "Personen" ob nur die gewünschten "Attributte" vorhanden sind';
SET @expected := 0;
INSERT INTO Test_Results.Test_Logs (
    Timestamp,
    Class,
    Test_Name,
    Candidate_Firstname,
    Candidate_Name,
    Testcase,
    Test_Status,
    Test_Kommentar
)
	SELECT
	  @time_testrun        AS Timestamp,
	  @Class               AS Class,
      @Test_Name           AS Test_Name,
	  @Candidate_Firstname AS Candidate_Firstname,
	  @Candidate_Name      AS Candidate_Name,
	  @test_id             AS Testcase,
	  CASE 
		WHEN cnt = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS Test_Status,
	  CASE 
		WHEN cnt = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        cnt, 
        '   expected:',
        @expected)
	  END                  AS Test_Kommentar
	FROM (
	  	SELECT count(*) AS cnt
		FROM information_schema.columns 
		WHERE TABLE_SCHEMA = DATABASE()
		  AND TABLE_NAME   = 'Personen'
		  AND (COLUMN_NAME  <> 'ID'
			AND COLUMN_NAME  <> 'Anrede'
			AND COLUMN_NAME  <> 'Vorname'
			AND COLUMN_NAME  <> 'Nachname'
			AND COLUMN_NAME  <> 'Strassenname'
			AND COLUMN_NAME  <> 'Hausnummer'
			AND COLUMN_NAME  <> 'Orte_FK'
			AND COLUMN_NAME  <> 'Tel_Nr'
			AND COLUMN_NAME  <> 'eMail'
		  )
	) AS sub;
/*

CALL `Test_Results`.`CheckTableExists`('1.1 Table "Personen" existiert?', 'Personen');
CALL `Test_Results`.`CheckTableExists`('1.2 Table "Orte" existiert?', 'Orte');
CALL `Test_Results`.`CheckTableExists`('1.3 View "Personen_Liste" existiert?', 'Personen_Liste');

CALL `Test_Results`.`CheckColumnExists`('1.4 Attribute "Hausnummer" existiert in Table "Personen"?', 'Personen', 'Hausnummer');
CALL `Test_Results`.`CheckColumnExists`('1.5 Attribute "Orte_FK" existiert in Table "Personen"?', 'Personen', 'Orte_FK');
CALL `Test_Results`.`CheckColumnExists`('1.6 Attribute "PLZ" existiert in Table "Orte"?', 'Orte', 'PLZ');
CALL `Test_Results`.`CheckColumnExists`('1.7 Attribute "Ortsname" existiert in Table "Orte"?', 'Orte', 'Ortsname');
CALL `Test_Results`.`CheckColumnExists`('1.8 Attribute "Strassenname" existiert in Table "Personen"?', 'Personen', 'Strassenname');

-- Check for unwanted columns in Personen table
SET @test_id := '1.9 Check "Personen" ob nur die gewünschten "Attributte" vorhanden sind';
SET @expected := 0;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`, `Class`, `Test_Name`, `Candidate_Firstname`, `Candidate_Name`,
    `Testcase`, `Test_Status`, `Test_Kommentar`
)
SELECT
    @time_testrun, @Class, @Test_Name, @Candidate_Firstname, @Candidate_Name,
    @test_id,
    CASE WHEN `cnt` = @expected THEN 'o.k.' ELSE 'Falsch' END,
    CASE WHEN `cnt` = @expected THEN '' 
         ELSE CONCAT('Result:', `cnt`, ' expected:', @expected) END
FROM (
    SELECT COUNT(*) AS `cnt`
    FROM `information_schema`.`columns` 
    WHERE `TABLE_SCHEMA` = DATABASE()
      AND `TABLE_NAME` = 'Personen'
      AND `COLUMN_NAME` NOT IN ('ID', 'Anrede', 'Vorname', 'Nachname', 'Strassenname', 'Hausnummer', 'Orte_FK', 'Tel_Nr', 'eMail')
) AS `sub`;

*/

-- -------------------------------------------------------------------------------------
-- 2) Ueberprüfen Daten-Migration (alle Daten korrekt vorhanden)
-- -------------------------------------------------------------------------------------
SET @test_id  := '2.1 Count Tuples in Personen';
SET @expected := 1169;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`,
    `Class`,
    `Test_Name`,
    `Candidate_Firstname`,
    `Candidate_Name`,
    `Testcase`,
    `Test_Status`,
    `Test_Kommentar`
)
	SELECT
	  @time_testrun        AS `Timestamp`,
	  @Class               AS `Class`,
      @Test_Name           AS `Test_Name`,
	  @Candidate_Firstname AS `Candidate_Firstname`,
	  @Candidate_Name      AS `Candidate_Name`,
	  @test_id             AS `Testcase`,
	  CASE 
		WHEN `cnt` = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS `Test_Status`,
	  CASE 
		WHEN `cnt` = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        `cnt`, 
        '   expected:',
        @expected)
	  END                  AS `Test_Kommentar`
	FROM (
	  SELECT COUNT(*) AS `cnt` FROM `Personen`
	) AS `sub`;
-- -------------------------------------------------------------------------------------
/*  
SET @test_id  := '2.2 Split von Strassenname und Hausnummer';
SET @expected := 36;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`,
    `Class`,
    `Test_Name`,
    `Candidate_Firstname`,
    `Candidate_Name`,
    `Testcase`,
    `Test_Status`,
    `Test_Kommentar`
)
	SELECT
	  @time_testrun        AS `Timestamp`,
	  @Class               AS `Class`,
      @Test_Name           AS `Test_Name`,
	  @Candidate_Firstname AS `Candidate_Firstname`,
	  @Candidate_Name      AS `Candidate_Name`,
	  @test_id             AS `Testcase`,
	  CASE 
		WHEN `cnt` = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS `Test_Status`,
	  CASE 
		WHEN `cnt` = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        `cnt`, 
        '   expected:',
        @expected)
	  END                  AS `Test_Kommentar`
FROM (
		SELECT COUNT(*) AS `cnt` FROM `Personen` 
		WHERE `Hausnummer` IS NULL OR (`Hausnummer` <> REGEXP_SUBSTR(`Strassenname`, '[0-9]+[a-zA-Z]*$'))
) AS `sub`;
*/

-- SELECT * FROM `Personen` 
-- 		WHERE `Hausnummer` IS NULL OR (`Hausnummer` <> REGEXP_SUBSTR(`Strassenname`, '[0-9]+[a-zA-Z]*$'));
-- -------------------------------------------------------------------------------------
SET @test_id  := '2.3 Anpassung View an Strasse und Hausnummer';
SET @expected := 0;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`,
    `Class`,
    `Test_Name`,
    `Candidate_Firstname`,
    `Candidate_Name`,
    `Testcase`,
    `Test_Status`,
    `Test_Kommentar`
)
	SELECT
	  @time_testrun        AS `Timestamp`,
	  @Class               AS `Class`,
      @Test_Name           AS `Test_Name`,
	  @Candidate_Firstname AS `Candidate_Firstname`,
	  @Candidate_Name      AS `Candidate_Name`,
	  @test_id             AS `Testcase`,
	  CASE 
		WHEN `cnt` = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS `Test_Status`,
	  CASE 
		WHEN `cnt` = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        `cnt`, 
        '   expected:',
        @expected)
	  END                  AS `Test_Kommentar`
FROM (
		SELECT 
			COUNT(`Personen_Liste`.`ID`)  AS `cnt`
		FROM `Personen`, `Personen_Liste`
		WHERE `Personen`.`ID` = `Personen_Liste`.`ID`
		  AND `Personen_Liste`.`Strasse` <> CONCAT(`Personen`.`Strassenname`, ' ', `Personen`.`Hausnummer`)
) AS `sub`;
-- -------------------------------------------------------------------------------------
SET @test_id  := '2.4 Orte richtig übernommen?';
SET @expected := 82;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`,
    `Class`,
    `Test_Name`,
    `Candidate_Firstname`,
    `Candidate_Name`,
    `Testcase`,
    `Test_Status`,
    `Test_Kommentar`
)
	SELECT
	  @time_testrun        AS `Timestamp`,
	  @Class               AS `Class`,
      @Test_Name           AS `Test_Name`,
	  @Candidate_Firstname AS `Candidate_Firstname`,
	  @Candidate_Name      AS `Candidate_Name`,
	  @test_id             AS `Testcase`,
	  CASE 
		WHEN `cnt` = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS `Test_Status`,
	  CASE 
		WHEN `cnt` = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        `cnt`, 
        '   expected:',
        @expected)
	  END                  AS `Test_Kommentar`
FROM (
		SELECT COUNT(*) AS `cnt` FROM `Orte`
) AS `sub`;
-- -------------------------------------------------------------------------------------
SET @test_id  := '2.6 Count Tuples in Personen_Liste';
SET @expected := 1169;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`,
    `Class`,
    `Test_Name`,
    `Candidate_Firstname`,
    `Candidate_Name`,
    `Testcase`,
    `Test_Status`,
    `Test_Kommentar`
)
	SELECT
	  @time_testrun        AS `Timestamp`,
	  @Class               AS `Class`,
      @Test_Name           AS `Test_Name`,
	  @Candidate_Firstname AS `Candidate_Firstname`,
	  @Candidate_Name      AS `Candidate_Name`,
	  @test_id             AS `Testcase`,
	  CASE 
		WHEN `cnt` = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS `Test_Status`,
	  CASE 
		WHEN `cnt` = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        `cnt`, 
        '   expected:',
        @expected)
	  END                  AS `Test_Kommentar`
	FROM (
	  SELECT COUNT(*) AS `cnt` FROM `Personen_Liste`
	) AS `sub`;
-- ------------------------------------------------------------------------------------- 
SET @test_id  := '2.7 Count Tuples in "Personen_Liste" in "8855 W%"';
SET @expected := 703;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`,
    `Class`,
    `Test_Name`,
    `Candidate_Firstname`,
    `Candidate_Name`,
    `Testcase`,
    `Test_Status`,
    `Test_Kommentar`
)
	SELECT
	  @time_testrun        AS `Timestamp`,
	  @Class               AS `Class`,
      @Test_Name           AS `Test_Name`,
	  @Candidate_Firstname AS `Candidate_Firstname`,
	  @Candidate_Name      AS `Candidate_Name`,
	  @test_id             AS `Testcase`,
	  CASE 
		WHEN `cnt` = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS `Test_Status`,
	  CASE 
		WHEN `cnt` = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        `cnt`, 
        '   expected:',
        @expected)
	  END                  AS `Test_Kommentar`
	FROM (
	  SELECT count(*) AS `cnt` FROM `Personen_Liste` WHERE `PLZ_Ort` LIKE '8855 W%'
	) AS `sub`;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '2.8 Count Tuples in "Personen_Liste" in distinct("PLZ_Ort")';
SET @expected := 82;
INSERT INTO `Test_Results`.`Test_Logs` (
    `Timestamp`,
    `Class`,
    `Test_Name`,
    `Candidate_Firstname`,
    `Candidate_Name`,
    `Testcase`,
    `Test_Status`,
    `Test_Kommentar`
)
	SELECT
	  @time_testrun        AS `Timestamp`,
	  @Class               AS `Class`,
      @Test_Name           AS `Test_Name`,
	  @Candidate_Firstname AS `Candidate_Firstname`,
	  @Candidate_Name      AS `Candidate_Name`,
	  @test_id             AS `Testcase`,
	  CASE 
		WHEN `cnt` = @expected
		THEN 'o.k.'
		ELSE 'Falsch'
	  END AS `Test_Status`,
	  CASE 
		WHEN `cnt` = @expected
		THEN ''
		ELSE CONCAT('Result:', 
        `cnt`, 
        '   expected:',
        @expected)
	  END                  AS `Test_Kommentar`
	FROM (
	  SELECT count(distinct `PLZ_Ort`) AS `cnt` FROM `Personen_Liste`
	) AS `sub`;

-- ------------------------------------------------------------------------------------- 
/*
SELECT * 
FROM `Test_Results`.`Test_Logs` 
WHERE `Class` = @Class AND `Test_Name` = @Test_Name 
ORDER BY `Timestamp`;

SELECT
 -- Candidate_Firstname,
 Candidate_Name,
 Testcase,
 Test_Status,
 Test_Kommentar
FROM test_results.test_logs 
WHERE Candidate_Name LIKE '%Catanjal';

SELECT * FROM test_results.test_statistics WHERE Candidate_Name LIKE '%Catanjal';

*/

SELECT * FROM `Test_Results`.`Test_Logs`
WHERE DATE(Timestamp) = CURDATE();


SELECT *
FROM `Test_Results`.`Test_Statistics`;   
