-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Testing-Results Schema for Automated_Testing
--
-- History:
-- 07-Jun-2025   Walter Rothlin      Initial Version
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

DROP VIEW IF EXISTS `Test_Statisticts`; 
CREATE VIEW `Test_Statisticts` AS
	SELECT 
		`Test_Name`,
		`Class`,
		`Candidate_Firstname`,
		`Candidate_Name`,
		SUM(`Test_Status` = 'o.k.') AS `ok_count`,
		SUM(`Test_Status` <> 'o.k.') AS `nok_count`,
        ROUND((5 * SUM(`Test_Status` = 'o.k.') / NULLIF(SUM(`Test_Status` = 'o.k.') + SUM(`Test_Status` <> 'o.k.'), 0)) + 1, 2) AS `Rating`
	FROM `Test_Logs`
	GROUP BY 
		`Class`,
		`Test_Name`,
		`Candidate_Firstname`,
		`Candidate_Name`;
