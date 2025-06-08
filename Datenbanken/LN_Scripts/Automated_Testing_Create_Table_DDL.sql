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
