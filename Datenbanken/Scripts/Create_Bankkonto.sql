-- ---------------------------------------------------------------------------------------------
-- Create_Bankkonto.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein neues Mini-Schema für eine Bank, um Transaktionen zu zeigen
--
-- History:
-- 15-May-2020   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

-- Neues Schema kreieren
DROP SCHEMA IF EXISTS `MyBank`;
CREATE SCHEMA IF NOT EXISTS `MyBank` DEFAULT CHARACTER SET utf8;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `MyBank`;

DROP TABLE IF EXISTS bankkonto;
CREATE TABLE IF NOT EXISTS bankkonto (
  id_bankkonto int(11) NOT NULL AUTO_INCREMENT,
  saldo double NOT NULL DEFAULT '0',
  PRIMARY KEY (id_bankkonto)
) AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


INSERT INTO `bankkonto` VALUES (1,1000),(2,35050),(3,200),(4,36000),(5,9);