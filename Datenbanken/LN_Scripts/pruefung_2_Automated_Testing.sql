-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Automated_Testing der Prüfung 2 
--
-- History:
-- 07-Jun-2025   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------

-- Test execution
-- ==============
USE `Pruefung_2`;
SET @Class     := 'TI24_BLe_BMa';
SET @Test_Name := 'DB_Prüfung_2';
DELETE FROM `Test_Results`.`Test_Logs` WHERE `Class` = @Class AND `Test_Name` = @Test_Name;

SET @Candidate_Name      := 'MenaLupa';
SET @Candidate_Firstname := 'Joan';

-- -------------------------------------------------------------------------------------
SET @test_id  := '1.1 Count Tubles in Personen';
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
	  now()                AS `Timestamp`,
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
SET @test_id  := '2.1 Table "Personen" existiert?'; 
SET @expected := 1;
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
    NOW() AS `Timestamp`,
    @Class AS `Class`,
    @Test_Name AS `Test_Name`,
    @Candidate_Firstname AS `Candidate_Firstname`,
    @Candidate_Name AS `Candidate_Name`,
    @test_id AS `Testcase`,
    CASE 
        WHEN table_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS `Test_Status`,
    CASE 
        WHEN `table_exists` = 1 THEN ''
        ELSE 'Tabelle "Personen" existiert nicht'
    END AS `Test_Kommentar`
FROM (
    SELECT 
        EXISTS (
            SELECT 1 
            FROM `information_schema`.`tables` 
            WHERE `TABLE_SCHEMA` = DATABASE() 
              AND `TABLE_NAME` = 'Personen'
        ) AS `table_exists`
) AS `sub`;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '2.2 View "Personen_Liste" existiert?'; 
SET @expected := 1;
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
    NOW() AS `Timestamp`,
    @Class AS `Class`,
    @Test_Name AS `Test_Name`,
    @Candidate_Firstname AS `Candidate_Firstname`,
    @Candidate_Name AS `Candidate_Name`,
    @test_id AS `Testcase`,
    CASE 
        WHEN `table_exists` = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS `Test_Status`,
    CASE 
        WHEN `table_exists` = 1 THEN ''
        ELSE 'View "Personen_Liste" existiert nicht'
    END AS `Test_Kommentar`
FROM (
    SELECT 
        EXISTS (
            SELECT 1 
            FROM `information_schema`.`tables` 
            WHERE `TABLE_SCHEMA` = DATABASE() 
              AND `TABLE_NAME` = 'Personen_Liste'
        ) AS `table_exists`
) AS `sub`;
-- -------------------------------------------------------------------------------------    
SET @test_id  := '3.1 Attribute "Hausnr" existiert in Table "Personen"?'; 
SET @expected := 1;
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
    NOW() AS `Timestamp`,
    @Class AS `Class`,
    @Test_Name AS `Test_Name`,
    @Candidate_Firstname AS `Candidate_Firstname`,
    @Candidate_Name AS `Candidate_Name`,
    @test_id AS `Testcase`,
    CASE 
        WHEN `column_exists` = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS `Test_Status`,
    CASE 
        WHEN `column_exists` = 1 THEN ''
        ELSE 'View "Personen_Liste" existiert nicht'
    END AS `Test_Kommentar`
FROM (
	SELECT 
		EXISTS (
			SELECT 1
			FROM `information_schema`.`columns` 
			WHERE `TABLE_SCHEMA` = DATABASE()
			  AND `TABLE_NAME`   = 'Personen'
			  AND `COLUMN_NAME`  = 'Hausnr'
		) AS `column_exists`
) AS `sub`;
-- -------------------------------------------------------------------------------------
SET @test_id  := '3.2 Split von Strassenbezeichnung und Hausnummer';
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
	  now()                AS `Timestamp`,
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
		WHERE `Hausnr` IS NULL OR (`Hausnr` <> REGEXP_SUBSTR(`Strasse`, '[0-9]+[a-zA-Z]*$'))
) AS `sub`;
-- -------------------------------------------------------------------------------------
SET @test_id  := '3.3 Anpassung View an Strasse und Hausnummer';
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
	  now()                AS `Timestamp`,
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
		  AND `Personen_Liste`.`Strasse` <> CONCAT(`Personen`.`Strasse`, ' ', `Personen`.`Hausnr`)
) AS `sub`;
-- ------------------------------------------------------------------------------------- 
SET @test_id  := '4.1 Table "Orte" existiert?'; 
SET @expected := 1;
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
    NOW() AS `Timestamp`,
    @Class AS `Class`,
    @Test_Name AS `Test_Name`,
    @Candidate_Firstname AS `Candidate_Firstname`,
    @Candidate_Name AS `Candidate_Name`,
    @test_id AS `Testcase`,
    CASE 
        WHEN table_exists = 1 THEN 'o.k.'
        ELSE 'Falsch'
    END AS `Test_Status`,
    CASE 
        WHEN `table_exists` = 1 THEN ''
        ELSE 'Tabelle "Orte" existiert nicht'
    END AS `Test_Kommentar`
FROM (
    SELECT 
        EXISTS (
            SELECT 1 
            FROM `information_schema`.`tables` 
            WHERE `TABLE_SCHEMA` = DATABASE() 
              AND `TABLE_NAME` = 'Orte'
        ) AS `table_exists`
) AS `sub`;
-- -------------------------------------------------------------------------------------
SET @test_id  := '4.2 Orte richtig übernommen?';
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
	  now()                AS `Timestamp`,
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
SET @test_id  := '5.1 Count Tubles in Personen_Liste';
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
	  now()                AS `Timestamp`,
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
SET @test_id  := '5.2  Count Tubles in "Personen_Liste" in "8855 W%"';
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
	  now()                AS `Timestamp`,
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
SET @test_id  := '5.3 Count Tubles in "Personen_Liste" in distinct("PLZ_Ort")';
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
	  now()                AS `Timestamp`,
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
SET @test_id  := '4.6 Check "Personen" ob nur die gewünschten "Attributte" vorhanden sind';
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
	  now()                AS `Timestamp`,
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
	  	SELECT count(*) AS `cnt`
		FROM `information_schema`.`columns` 
		WHERE `TABLE_SCHEMA` = DATABASE()
		  AND `TABLE_NAME`   = 'Personen'
		  AND (`COLUMN_NAME`  <> 'ID'
			AND `COLUMN_NAME`  <> 'Anrede'
			AND `COLUMN_NAME`  <> 'Vorname'
			AND `COLUMN_NAME`  <> 'Nachname'
			AND `COLUMN_NAME`  <> 'Strasse'
			AND `COLUMN_NAME`  <> 'Hausnr'
			AND `COLUMN_NAME`  <> 'Orte_FK'
			AND `COLUMN_NAME`  <> 'Tel_Nr'
			AND `COLUMN_NAME`  <> 'eMail'
		  )
	) AS `sub`;
-- ------------------------------------------------------------------------------------- 

SELECT * 
FROM `Test_Results`.`Test_Logs` 
WHERE `Class` = @Class AND `Test_Name` = @Test_Name 
ORDER BY `Timestamp`;  
  
SELECT *
FROM `Test_Results`.`Test_Statisticts`;   
