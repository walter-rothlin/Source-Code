-- ---------------------------------------------------------------------------------------------
-- Create_Bankkonto.sql
--
-- Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Create_Bankkonto.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert ein neues Mini-Schema für eine Bank, um Transaktionen zu zeigen
--
-- History:
-- 15-May-2020   Walter Rothlin      Initial Version
-- 22-Oct-2021   Walter Rothlin	     Added some more attributes
-- ---------------------------------------------------------------------------------------------

-- Neues Schema kreieren
DROP SCHEMA IF EXISTS `MyBank`;
CREATE SCHEMA IF NOT EXISTS `MyBank` DEFAULT CHARACTER SET utf8;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `MyBank`;

DROP TABLE IF EXISTS bankkonto;
CREATE TABLE IF NOT EXISTS bankkonto (
  id_bankkonto int(11)     NOT NULL AUTO_INCREMENT,
  saldo        double      NOT NULL DEFAULT 0,
  limite       double      NOT NULL DEFAULT 0,
  kontoArt     varchar(15),
  owner        varchar(25),
  PRIMARY KEY (id_bankkonto)
);

INSERT INTO `bankkonto` VALUES 
         (1,2000,-100,'Lohnkonto','Walter Rothlin'),
         (2,5000,0,'Sparkonto','Walter Rothlin'),
         (3,10000,0,'Sparkonto','Claudia Collet Rothlin');
