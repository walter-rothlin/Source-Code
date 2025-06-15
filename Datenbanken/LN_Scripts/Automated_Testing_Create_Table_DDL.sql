-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Testing-Results Schema for Automated_Testing
--
-- History:
-- 07-Jun-2025   Walter Rothlin      Initial Version
-- 15-Jun-2025   Walter Rothlin      Added stored procedurs to perform tests
-- ---------------------------------------------------------------------------------

-- Creating Testing-Results Schema
-- ===============================
DROP SCHEMA   IF EXISTS     `Test_Results`;
CREATE SCHEMA IF NOT EXISTS `Test_Results`  DEFAULT CHARACTER SET utf8mb4;
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `Test_Results`;


DROP TABLE   IF EXISTS      `Test_Logs`;
CREATE TABLE IF NOT EXISTS  `Test_Logs` (
    `id`                  INT           AUTO_INCREMENT PRIMARY KEY,
    `Timestamp`           DATETIME      DEFAULT CURRENT_TIMESTAMP,
    `Class`               VARCHAR(50),
    `Test_Name`           VARCHAR(100),
    `Candidate_Firstname` VARCHAR(100),
    `Candidate_Name`      VARCHAR(100),
    `Testcase`            VARCHAR(100),
    `Test_Status`         VARCHAR(10),
    `Test_Kommentar`      VARCHAR(255)
);

DROP TABLE   IF EXISTS      `Test_Definitions`;
CREATE TABLE IF NOT EXISTS  `Test_Definitions` (
    `id`                  INT           AUTO_INCREMENT PRIMARY KEY,
    `Timestamp`           DATETIME      DEFAULT CURRENT_TIMESTAMP,
    `Test_Name`           VARCHAR(100),
    `Max_Points`          FLOAT
);

ALTER TABLE `test_definitions`
	ADD UNIQUE (`Test_Name`);

DROP VIEW IF EXISTS `Test_Statistics`;
CREATE VIEW `Test_Statistics` AS
SELECT 
    `l`.`Test_Name`,
    `l`.`Class`,
    `l`.`Candidate_Firstname`,
    `l`.`Candidate_Name`,
    SUM(`l`.`Test_Status` = 'o.k.') AS `ok_count`,
    SUM(`l`.`Test_Status` <> 'o.k.') AS `nok_count`,
    ROUND((5 * SUM(`l`.`Test_Status` = 'o.k.') / NULLIF(SUM(`l`.`Test_Status` = 'o.k.') + SUM(`l`.`Test_Status` <> 'o.k.'), 0)) + 1, 2) AS `Rating`,
    `d`.`Max_Points`,
    ROUND((5 * SUM(`l`.`Test_Status` = 'o.k.') / NULLIF(`d`.`Max_Points`, 0)) + 1, 2) AS `Note`
FROM `Test_Logs` `l`
LEFT JOIN `Test_Definitions` `d` ON `l`.`Test_Name` = `d`.`Test_Name`
GROUP BY 
    `l`.`Test_Name`,
    `l`.`Class`,
    `l`.`Candidate_Firstname`,
    `l`.`Candidate_Name`;


-- ========================================
-- Procedures to perform tests
-- ========================================
-- Datenbank aktivieren
USE `Test_Results`;

-- ---------------------------------------------------------------------------------
-- Stored Procedures for Testing
-- ---------------------------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS `AddOrUpdateTestDefinition`//
CREATE PROCEDURE `AddOrUpdateTestDefinition` (
    IN p_Test_Name VARCHAR(100),
    IN p_Max_Points INT
)
BEGIN
    INSERT INTO `Test_Results`.`Test_Definitions` (`Test_Name`, `Max_Points`) 
    VALUES (p_Test_Name, p_Max_Points)
    ON DUPLICATE KEY UPDATE `Max_Points` = VALUES(`Max_Points`);
END//

-- Generic procedure to log test results
DROP PROCEDURE IF EXISTS `LogTestResult`//
CREATE PROCEDURE `LogTestResult`(
    IN p_test_id VARCHAR(100),
    IN p_actual_value INT,
    IN p_expected_value INT,
    IN p_success_message VARCHAR(255),
    IN p_error_message VARCHAR(255)
)
BEGIN
    INSERT INTO `Test_Results`.`Test_Logs` (
        `Timestamp`, `Class`, `Test_Name`, `Candidate_Firstname`, `Candidate_Name`,
        `Testcase`, `Test_Status`, `Test_Kommentar`
    )
    VALUES (
        @time_testrun, @Class, @Test_Name, @Candidate_Firstname, @Candidate_Name,
        p_test_id,
        CASE WHEN p_actual_value = p_expected_value THEN 'o.k.' ELSE 'Falsch' END,
        CASE 
            WHEN p_actual_value = p_expected_value THEN p_success_message
            ELSE CONCAT(p_error_message, ' Result:', p_actual_value, ' expected:', p_expected_value)
        END
    );
END//

-- Check if table exists
DROP PROCEDURE IF EXISTS `CheckTableExists`//
CREATE PROCEDURE `CheckTableExists`(
    IN p_test_id VARCHAR(100),
    IN p_table_name VARCHAR(100)
)
BEGIN
    DECLARE v_exists INT;
    
    SELECT EXISTS (
        SELECT 1 FROM `information_schema`.`tables` 
        WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = p_table_name
    ) INTO v_exists;
    
    CALL `Test_Results`.`LogTestResult`(
        p_test_id, v_exists, 1, '', 
        CONCAT('Table "', p_table_name, '" existiert nicht')
    );
END//

-- Check if column exists in table
DROP PROCEDURE IF EXISTS `CheckColumnExists`//
CREATE PROCEDURE `CheckColumnExists`(
    IN p_test_id VARCHAR(100),
    IN p_table_name VARCHAR(100),
    IN p_column_name VARCHAR(100)
)
BEGIN
    DECLARE v_exists INT;
    
    SELECT EXISTS (
        SELECT 1 FROM `information_schema`.`columns` 
        WHERE `TABLE_SCHEMA` = DATABASE() 
          AND `TABLE_NAME` = p_table_name 
          AND `COLUMN_NAME` = p_column_name
    ) INTO v_exists;
    
    CALL `Test_Results`.`LogTestResult`(
        p_test_id, v_exists, 1, '', 
        CONCAT('"', p_column_name, '" existiert nicht in "', p_table_name, '"')
    );
END//

-- Check count with expected value
DROP PROCEDURE IF EXISTS `CheckCount`//
CREATE PROCEDURE `CheckCount`(
    IN p_test_id VARCHAR(100),
    IN p_sql_query TEXT,
    IN p_expected_count INT
)
BEGIN
    DECLARE v_actual_count INT;
    
    SET @sql = p_sql_query;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Get the result from the last query (this is a simplified approach)
    -- In practice, you might need to use a temporary table or OUT parameter
    SET v_actual_count = FOUND_ROWS();
    
    CALL `Test_Results`.`LogTestResult`(
        p_test_id, v_actual_count, p_expected_count, '', ''
    );
END//

-- Specific procedure for counting records in a table
DROP PROCEDURE IF EXISTS `CheckTableCount`//
CREATE PROCEDURE `CheckTableCount`(
    IN p_test_id VARCHAR(100),
    IN p_sql_query TEXT,
    IN p_expected_count INT
)
BEGIN
    DECLARE v_actual_count INT;
    
    SET @sql = p_sql_query;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Get the result from the last query (this is a simplified approach)
    -- In practice, you might need to use a temporary table or OUT parameter
    SET v_actual_count = FOUND_ROWS();
    
    CALL `Test_Results`.`LogTestResult`(
        p_test_id, v_actual_count, p_expected_count, '', ''
    );
END//


/*
CREATE PROCEDURE `CheckTableCount`(
    IN p_test_id VARCHAR(100),
    IN p_table_name VARCHAR(100),
    IN p_expected_count INT,
    IN p_where_clause VARCHAR(500)
)
BEGIN
    DECLARE v_actual_count INT;
    DECLARE v_sql VARCHAR(500);
    DECLARE v_where_clause VARCHAR(500);

    -- Kopiere p_where_clause in lokale Variable (IN-Parameter sind readonly)
    SET v_where_clause = p_where_clause;

    IF v_where_clause IS NULL OR v_where_clause = '' THEN
        SET v_where_clause = '';
    END IF;

    SET v_sql = CONCAT('SELECT COUNT(*) FROM `', p_table_name, '`');
    IF v_where_clause != '' THEN
        SET v_sql = CONCAT(v_sql, ' WHERE ', v_where_clause);
    END IF;

    PREPARE stmt FROM v_sql;
    EXECUTE stmt INTO v_actual_count;
    DEALLOCATE PREPARE stmt;

    CALL `Test_Results`.`LogTestResult`(
        p_test_id, v_actual_count, p_expected_count, '', ''
    );
END//
*/

DELIMITER ;