-- --------------------------------Bitte hier ändern--------------------------------
SET @vorname  = 'Walter';    -- Durch ihren Vornamen ersetzen
SET @nachname = 'Rothlin';   -- Durch ihren Namen ersetzen
-- ---------------------------------------------------------------------------------



-- --------------------------------Ab hier NICHTS mehr ändern-----------------------
SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

SET @username = CONCAT(@vorname, ' ',  @nachname);
-- =========================================
-- == Schema Prüfung_2 kreieren           ==
-- =========================================

DROP SCHEMA IF EXISTS `Pruefung_2`;
CREATE SCHEMA IF NOT EXISTS `Pruefung_2`  DEFAULT CHARACTER SET utf8mb4;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `Pruefung_2`;


-- =========================================
-- == Create Tables                       ==
-- =========================================

-- -----------------------------------------
-- Table `Personen_Liste`
-- -----------------------------------------
DROP TABLE IF EXISTS `Personen_Liste`;
CREATE TABLE IF NOT EXISTS `Personen_Liste` (
	`ID`            		      INT UNSIGNED NOT NULL,
	`Anrede`        		      VARCHAR(100) NULL,
	`Vorname_Initial`             VARCHAR(100) NULL,
	`Familien_Name`               VARCHAR(100) NULL,
    `Strasse`                     VARCHAR(100) NULL,
	`PLZ_Ort`                     VARCHAR(100) NULL,
	`Tel_Nr`                      VARCHAR(100) NULL,
	`eMail`                       VARCHAR(100) NULL,
	`Ledig_Name`                  VARCHAR(100) NULL,
	`Partner_Name`     			  VARCHAR(100) NULL,
	`Partner_Name_Angenommen`     VARCHAR(10)  NULL,
  
  -- PK-Constraints
  PRIMARY KEY (`ID`));
  
  
-- -----------------------------------------
-- Table `Properties`
-- -----------------------------------------
DROP TABLE IF EXISTS `Properties`;
CREATE TABLE IF NOT EXISTS `Properties` (
  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name`          VARCHAR(25) NOT NULL,
  `Value`         VARCHAR(25) NULL,
  `last_update`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
  
  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------
-- Table `User Log`
-- -----------------------------------------
DROP TABLE IF EXISTS `user_logs`;
CREATE TABLE IF NOT EXISTS  `user_logs` (
    `id`          INT AUTO_INCREMENT PRIMARY KEY,
    `username`    VARCHAR(100),
    `action`      VARCHAR(100),
    `login_time`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO `user_logs` (`username`,`action`) VALUES (@username, 'Added User-Name');
INSERT INTO `user_logs` (`username`,`action`) VALUES (CURRENT_USER(), 'Added Login-User');


-- -----------------------------------------
-- Table `Priviliges`
-- -----------------------------------------
DROP TABLE IF EXISTS `Priviliges`;
CREATE TABLE IF NOT EXISTS `Priviliges` (
  `ID`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Application`  VARCHAR(45)  NOT NULL,
  `Privilege`    VARCHAR(45)  NOT NULL,
  `last_update`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,

  -- PK-Constraints
  PRIMARY KEY (`ID`));



  

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
