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
-- == Schema Prüfung_1 kreieren           ==
-- =========================================

DROP SCHEMA IF EXISTS `Verify`;
CREATE SCHEMA IF NOT EXISTS `Verify`  DEFAULT CHARACTER SET utf8mb4;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `Verify`;


-- =========================================
-- == Create Tables                       ==
-- =========================================

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


-- -----------------------------------------
-- Table `Telefonnummern`
-- -----------------------------------------
DROP TABLE IF EXISTS `Telefonnummern` ;
CREATE TABLE IF NOT EXISTS `Telefonnummern` (
  `ID`           INT UNSIGNED                                 NOT NULL AUTO_INCREMENT,
  `Laendercode`  VARCHAR(4)                                   NOT NULL DEFAULT '0041',
  `Vorwahl`      VARCHAR(5)                                   NULL,
  `Nummer`       VARCHAR(13)                                  NULL,
  `Type`         ENUM('Privat', 'Geschaeft', 'Sonstige')      NULL,
  `Endgeraet`    ENUM('Festnetz', 'Mobile', 'FAX')            NULL,
  `Prio`         TINYINT                                      NOT NULL DEFAULT 0, 
  `last_update`  TIMESTAMP                                    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `changed_by`    INT UNSIGNED NULL,
      
  -- PK-Constraints
  PRIMARY KEY (`ID`));


-- -----------------------------------------
-- Table `Polygon_Flaechen`
-- -----------------------------------------
DROP TABLE IF EXISTS `Polygon_Flaechen`;
CREATE TABLE IF NOT EXISTS `Polygon_Flaechen` (
  `AV_Parzellen_Nr`      VARCHAR(40) NOT NULL,
  `Polygone`             VARCHAR(2000) NULL,
  `Schwerpunkt_x`        VARCHAR(20)  NULL,
  `Schwerpunkt_y`        VARCHAR(20)  NULL,
  `Flaeche_In_Aren`      FLOAT UNSIGNED NULL,
  `Farbe_Fläche`         VARCHAR(10) NULL DEFAULT '6600ff00', 
  `Farbe_Linie`          VARCHAR(10) NULL DEFAULT 'ff0000ff', 
    -- PK-Constraints
  PRIMARY KEY (`AV_Parzellen_Nr`));
  

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
