-- ---------------------------------------------------------------------------------
-- Autor: Walter Rothlin
-- Description: Kreiert ein Prüfungs-Schema
--
-- History:
-- 28-Apr-2025   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------

SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ===============================
-- == Schema kreieren           ==
-- ===============================

DROP SCHEMA IF EXISTS `migration_2`;
CREATE SCHEMA IF NOT EXISTS `migration_2`  DEFAULT CHARACTER SET utf8mb4;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `migration_2`;


-- =========================================
-- == Create Tables                       ==
-- =========================================

-- -----------------------------------------
-- Table `Personen_Liste`
-- -----------------------------------------
DROP TABLE IF EXISTS `Personen_Liste`;
CREATE TABLE IF NOT EXISTS `Personen_Liste` (
	`ID`            	INT UNSIGNED NOT NULL,
	`Anrede`        	VARCHAR(100) NULL,
	`Vorname`           VARCHAR(100) NULL,
	`Nachname`          VARCHAR(100) NULL,
    `Strasse`           VARCHAR(100) NULL,
	`PLZ_Ort`           VARCHAR(100) NULL,
	`Tel_Nr`            VARCHAR(100) NULL,
	`eMail`             VARCHAR(100) NULL,

  -- PK-Constraints
  PRIMARY KEY (`ID`));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
