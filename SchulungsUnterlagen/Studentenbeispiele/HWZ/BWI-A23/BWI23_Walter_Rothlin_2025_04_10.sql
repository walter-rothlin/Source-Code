-- ---------------------------------------------------------------------------------------------
-- BWI23_Walter_Rothlin_YYYY_MM_DD.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Script mit Studiengruppe entwickelt und Aufgaben gelöst
--
-- History:
-- 18_Mar-2025   Walter Rothlin      Initial Version
-- 01-Apr-2025   Walter Rothlin	     SELECT-Statment
-- 10-Apr-2025   Walter Rothlin	     Joins, Views
-- 08-May-2025   Walter Rothlin      DDL / New schema
-- ---------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------
-- SELECT statments
-- ---------------------------------------------------------------------------------------------
UPDATE `actor` 
SET `first_name` = 'Ed', `last_name` = 'Chase' 
WHERE `actor_id` = 3;



SELECT
	 `a`.`actor_id`    AS `ID`,
	 `a`.`first_name`  AS `Vorname`,
	 `a`.`last_name`   AS `Nachname`,
	 `a`.`last_update` AS `Letzmals geändert`,
	 date_format(`a`.`last_update`, '%W %d.%m.%Y %T') AS `Format_1`,
     now() AS Heute
FROM `actor` AS `a`
-- WHERE LEFT(`a`.`first_name`, 1) = 'E'
-- WHERE `actor_id` IN (3, 5, 7)
-- WHERE `a`.`first_name` LIKE BINARY '_E_E%'
-- WHERE date_format(`a`.`last_update`, '%Y') = '2025'
WHERE `a`.`last_update` > STR_TO_DATE('01.02.2025', '%d.%m.%Y')

ORDER BY `actor_id` DESC;


SELECT
     `a`.`first_name`  AS `Vorname`,
	 `a`.`last_name`   AS `Nachname`,
      LEFT(`a`.`first_name`, 1)  AS `Inital`,
      CONCAT(LEFT(`a`.`first_name`, 1), '.', `a`.`last_name`)   AS `Inital_Name`
FROM `actor` AS `a`;


	SELECT 
		`Land`, 
		count(`FK`) AS `Anzahl Städte` FROM (
			SELECT
				`ci`.`city_id`    AS `CI_ID`,
				`ci`.`city`       AS `Stadt`,
				co.country    AS `Land`,
				co.country_id AS `CO_ID`,
				ci.country_id AS `FK`
			FROM Country AS co, City AS ci
			WHERE ci.country_id = co.country_id) AS `stadt_land`
	GROUP BY `FK`
	ORDER BY `Anzahl Städte` DESC;

	SELECT
		ci.city_id,
		ci.city
	FROM City AS ci;


-- ===============================================
-- Joins and views
-- ===============================================
DROP VIEW IF EXISTS `address_city_country`; 
CREATE VIEW `address_city_country` AS   
	SELECT
		`adr`.`address_id`      AS `Adressen ID`,
		`adr`.`address`         AS `Adresse`,
		`ci`.`city`             AS `Stadt Name`,
		`co`.`country`          AS `Land`,
		`adr`.`address2`        AS `Adresse 2`,
		`adr`.`district`        AS `Stadtteil`,
		-- `adr`.`city_id`      AS `FK`,
		-- `ci`.`city_id`       AS `PK`,
		`adr`.`postal_code`     AS `Postleitzahl`,
		`adr`.`phone`           AS `Tel. Nr.`,
		`adr`.`location`        AS `Lokation`
	FROM `address` AS `adr`
	INNER JOIN `city`    AS `ci` ON `adr`.`city_id`   = `ci`.`city_id`
	INNER JOIN `country` AS `co` ON `ci`.`country_id` = `co`.`country_id`;

SELECT * FROM `address_city_country`;

SELECT
	`f`.`title`                    AS `Film Titel`,
    -- `f`.`language_id`           AS `Sprache_ID`,
    `ton_lang`.`name`              AS `Ton Sprache`,
    -- `f`.`original_language_id`  AS `Original Sprache_ID`,
    
    -- IF (`org_lang`.`name` IS NULL, 
    --    'Keine Sprache',  
    --    `org_lang`.`name`)         AS `Original Sprache`
        
	CASE 
		WHEN `org_lang`.`name` IS NULL THEN 'Keine Sprache'
		ELSE `org_lang`.`name`
	END                            AS `Original Sprache`
FROM `film` AS `f`
INNER JOIN      `language` AS `ton_lang` ON `f`.`language_id`          = `ton_lang`.`language_id`
LEFT OUTER JOIN `language` AS `org_lang` ON `f`.`original_language_id` = `org_lang`.`language_id`;

-- ===============================================
-- Own functions
-- ===============================================

SELECT
	`Adressen ID`,
    `Adresse`,
    `Stadt Name`,
    `Land`,
    CONCAT(`Stadt Name`, ' (', `Land`, ')') AS `Stadt_Land`,
    format_ort_land(`Stadt Name`, `Land`) AS `f(Stadt_Land)`
FROM `address_city_country`;

SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS format_ort_land;
DELIMITER //
CREATE FUNCTION format_ort_land(p_ort VARCHAR(50), p_land VARCHAR(50)) RETURNS VARCHAR(150)
BEGIN
   RETURN  CONCAT(p_ort, ' (', p_land, ')');
END//
DELIMITER ;

select format_ort_land('Wangen', 'Schweiz') AS `Stadt_Land`;



-- ---------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------
-- DDL / New Schema
-- ---------------------------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `hwz` ;
CREATE SCHEMA `hwz` ;

SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `hwz`;


