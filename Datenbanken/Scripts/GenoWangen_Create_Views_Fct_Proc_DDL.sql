-- -----------------------------------------
-- Filename: GenoWangen_Create_Views_Fct_Proc_DDL.sql
-- Source  : https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/GenoWangen_Create_Views_Fct_Proc_DDL.sql
-- -----------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert Functions, Views and Procedures for Genossame Wangen
--
-- History:
-- 13-May-2023   Walter Rothlin      Splitted file in DDL Tables / Fct, Views, Proc
-- 25-May-2023   Walter Rothlin      Added Landteilviews
-- 08-Jun-2023   Walter Rothlin      Added Neubürger
-- 09-Jun-2023   Walter Rothlin      Added Paechterstatistik
-- 05-Jul-2023   Walter Rothlin      Added Wärmeanschlüsse
-- 07-Jul-2023   Walter Rothlin      Detail definition Wärmebezüger mit Remo und Adrian
-- 10-Jul-2023   Walter Rothlin      Added Telnr-Details to Telnr_liste and Personen_daten
-- 10-Jul-2023   Walter Rothlin      Added ENUM and SET values view
-- 11-Jul-2023   Walter Rothlin      Added IBAN/EMAIL-Details to EMAIL_liste/IBAN_liste and Personen_daten
-- 12-Jul-2023   Walter Rothlin      Cleanup script (removed unused fct, views)
-- -----------------------------------------

-- To-Does
-- Split Strasse Hausnummer
-- Split, eliminate Spaces and Format Telefonnummer (fct)  41 --> 0041   554601440    055 460 14 40
-- Eliminate space and Format IBAN (fct)
-- View PERSONEN_DATEN mit Partner, Vater und Mutter erweitern
-- If Todestag is not NULL then alle Telefonnummer, iban, eMail Adressen löschen
-- Ueberprüfen ob jede Person nur 1 Telnr, IBAN und eMail addresse pro Prioritaet hat und die schön aufsteigend von 0 an sind
-- -----------------------------------------
SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ===============================================================================================
-- == Create Funtions used in Joins                                                             ==
-- ===============================================================================================
SET GLOBAL log_bin_trust_function_creators = 1;

-- -----------------------------------------
DROP FUNCTION IF EXISTS getRowCount;
DELIMITER //
CREATE FUNCTION getRowCount(tableName varchar(255))
RETURNS int
BEGIN
  DECLARE rowCount int;
  SET rowCount = (SELECT COUNT(*) FROM tableName);
  RETURN rowCount;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getRowCount('land') AS rc_land;

-- -----------------------------------------
--  Added a value to a SET
DROP FUNCTION IF EXISTS addSetValue;
DELIMITER //
CREATE FUNCTION  addSetValue(oldSetValue VARCHAR(500), valueToAdd VARCHAR(100)) RETURNS VARCHAR(500)
BEGIN
   IF oldSetValue IS NULL OR length(oldSetValue) = 0 THEN
         RETURN  valueToAdd;
   ELSE
         RETURN  CONCAT(oldSetValue, ',', valueToAdd);
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- UPDATE `personen` SET Kategorien = addSetValue(Kategorien, 'Pächter') WHERE  id = 1112;

-- -----------------------------------------
--  Remove a value from a SET
DROP FUNCTION IF EXISTS removeSetValue;
DELIMITER //
CREATE FUNCTION  removeSetValue(oldSetValue VARCHAR(500), valueToRremove VARCHAR(100)) RETURNS VARCHAR(500)
BEGIN
   IF oldSetValue IS NULL OR length(oldSetValue) = 0 THEN
         RETURN  oldSetValue;
   ELSE
         -- RETURN REPLACE(REPLACE(oldSetValue, valueToRremove, ''),',,', ',');
	  SET valueToRremove = CONCAT('\'',valueToRremove,'\'');
	  RETURN TRIM(BOTH ',' FROM REPLACE(REPLACE(CONCAT(',',REPLACE(oldSetValue, ',', ',,'), ','),valueToRremove, ''), ',,', ','));
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- UPDATE `personen` SET Kategorien = removeSetValue(Kategorien, 'Pächter') WHERE  id = 1112;

-- -----------------------------------------
--  Fct 10.0) Gibt den aelteren Timestamp zurueck
DROP FUNCTION IF EXISTS getOlder;
DELIMITER //
CREATE FUNCTION  getOlder(timeStamp_1 datetime, timeStamp_2 datetime) RETURNS datetime
BEGIN
   IF timeStamp_1 < timeStamp_2 THEN
         RETURN  timeStamp_1;
   ELSE
         RETURN  timeStamp_2;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getOlder(STR_TO_DATE('20050527-194523', '%Y%m%d-%H%i%s'), STR_TO_DATE('20050527-194524', '%Y%m%d-%H%i%s')) AS latest_change;

-- -----------------------------------------
--  Fct 10.1) Gibt den juengeren Timestamp zurueck
DROP FUNCTION IF EXISTS getYounger;
DELIMITER //
CREATE FUNCTION  getYounger(timeStamp_1 datetime, timeStamp_2 datetime) RETURNS datetime
BEGIN
   IF timeStamp_1 > timeStamp_2 THEN
         RETURN  timeStamp_1;
   ELSE
         RETURN  timeStamp_2;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getYounger(STR_TO_DATE('20050527-194523', '%Y%m%d-%H%i%s'), STR_TO_DATE('20050527-194524', '%Y%m%d-%H%i%s')) AS latest_change;

-- -----------------------------------------
--  Fct 10.2) getAge() Aktuelles Alter berechnen, wenn Todestag dann Alter fixiert, sonst NOW() - Birthday (Nur Jahre)
DROP FUNCTION IF EXISTS getAge;
DELIMITER //
CREATE FUNCTION  getAge(birthday date, deathDate date) RETURNS int
BEGIN
	IF deathDate IS NULL THEN
		RETURN timestampdiff(YEAR,birthday, CURDATE());
    ELSE
       RETURN timestampdiff(YEAR,birthday, deathDate);
	END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getAge(STR_TO_DATE('1960-08-05', '%Y-%m-%d'), STR_TO_DATE('2023-04-28', '%Y-%m-%d')) AS Age;
-- SELECT getAge(STR_TO_DATE('1960-08-05', '%Y-%m-%d'), NULL) AS Age;

-- -----------------------------------------
--  Fct 10.3) Gibt die internationale PLZ zurueck
DROP FUNCTION IF EXISTS formatPLZinternational;
DELIMITER //
CREATE FUNCTION formatPLZinternational(p_countryCode CHAR(50), p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  CONCAT(p_countryCode, '-', p_input_plz);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZinternational('CH', 8854) AS PLZ_Formated;     -- --> CH-8854
-- SELECT formatPLZinternational('D', 10115) AS PLZ_Formated;     -- --> D-10115

-- -----------------------------------------
--  Fct 10.3.1) Gibt die internationale PLZ mit dem Ort zurueck
DROP FUNCTION IF EXISTS formatPLZinternational_ort;
DELIMITER //
CREATE FUNCTION formatPLZinternational_ort(p_countryCode CHAR(50), p_input_plz SMALLINT, p_ort CHAR(50)) RETURNS CHAR(50)
BEGIN
   RETURN  CONCAT(p_countryCode, '-', p_input_plz, ' ', p_ort);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZinternational_ort('CH', 8854, 'Siebnen') AS PLZ_Ort;     -- --> CH-8854 Siebnen
-- SELECT formatPLZinternational_ort('D', 10115, 'Berlin') AS PLZ_Ort;     -- --> D-10115 Berlin

-- -----------------------------------------
--  Fct 10.3.2) Gibt die PLZ mit dem Ort zurueck
DROP FUNCTION IF EXISTS formatPLZ_ort;
DELIMITER //
CREATE FUNCTION formatPLZ_ort(p_input_plz SMALLINT, p_ort CHAR(50)) RETURNS CHAR(50)
BEGIN
   RETURN  CONCAT(p_input_plz, ' ', p_ort);
END//
DELIMITER ;

-- Test-Cases
-- SELECT formatPLZ_ort(8854, 'Siebnen') AS PLZ_Ort;     -- --> 8854 Siebnen
-- SELECT formatPLZ_ort(10115, 'Berlin') AS PLZ_Ort;     -- --> 10115 Berlin

-- -----------------------------------------
--  Fct 10.4) Gibt p_str zurueck mit erstem Buchstaben als Grossbuchstabe
--
-- TBC:  Letzter Testcase funktioniert nicht!!
DROP FUNCTION IF EXISTS firstUpper;
DELIMITER //
CREATE FUNCTION firstUpper(p_str VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
   RETURN  CONCAT(UPPER(LEFT(p_str, 1)), LOWER(RIGHT(p_str,CHAR_LENGTH(p_str)-1)));
END//
DELIMITER ;

-- Test-Cases
-- SHOW CHARACTER SET;
-- SELECT firstUpper("herr");    -- --> Herr
-- SELECT firstUpper("HERR");    -- --> Herr
-- SELECT firstUpper("Herr");    -- --> Herr
-- SELECT firstUpper("hERR");    -- --> Herr
-- SELECT firstUpper("züger");   -- --> Zzaüger
-- SELECT firstUpper("zueger");  -- --> Zzaüger
-- SELECT firstUpper("Philip Mike");  -- --> Philip Mike

-- -----------------------------------------
--  Fct 10.5) Gibt ersten Buchstaben von p_name als Grossbuchstabe zurueck gefolgt von p_tail
DROP FUNCTION IF EXISTS getInitial;
DELIMITER //
CREATE FUNCTION getInitial(p_name CHAR(100), p_tail CHAR(5)) RETURNS CHAR(10)
BEGIN
   RETURN  CONCAT(UPPER(LEFT(p_name, 1)), p_tail);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getInitial("Walter",".");  -- --> W.
-- SELECT getInitial("walti", ".");  -- --> W.
-- SELECT getInitial("Max", ",");    -- --> M,
-- SELECT getInitial("max", ",");    -- --> M,

-- -----------------------------------------
--  Fct 10.6) Gibt p_firstname gefolgt von, falls existiert, einem Space und ersten 
--            Buchstaben von p_firstname2 als Grossbuchstabe zurueck 
DROP FUNCTION IF EXISTS getName_With_Initial;
DELIMITER //
CREATE FUNCTION getName_With_Initial(p_firstname CHAR(100), p_firstname2 CHAR(100)) RETURNS CHAR(45)
BEGIN
   IF (p_firstname2 = '' OR p_firstname2 is NULL) THEN
	   RETURN  firstUpper(p_firstname);
   ELSE
       RETURN  CONCAT(firstUpper(p_firstname), ' ', getInitial(p_firstname2, '.'));
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getName_With_Initial('Walter', 'Max');  -- --> Walter M.
-- SELECT getName_With_Initial('Walti', '');      -- --> Walti
-- SELECT getName_With_Initial('Walti', NULL);    -- --> Walti

-- -----------------------------------------
--  Fct 10.7) Gibt Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getAnrede;
DELIMITER //
CREATE FUNCTION getAnrede(p_sex CHAR(20), p_firstname CHAR(45), p_vorname_short BOOLEAN, p_lastname CHAR(100) ) RETURNS CHAR(150)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  '';
   ELSE
      IF p_firstname = '' THEN
           RETURN  CONCAT(p_sex,' ', p_lastname);
	  ELSE
		IF (p_vorname_short) THEN
			RETURN  CONCAT(p_sex, ' ', LEFT(p_firstname, 1), '.', p_lastname);
		ELSE
            RETURN  CONCAT(p_sex, ' ', p_firstname, ' ', p_lastname);
		END IF;
	  END IF;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getAnrede("Herr", "Walter", TRUE, "Rothlin");         -- --> Herr W.Rothlin
-- SELECT getAnrede("Frau", "Claudia", TRUE, "Collet Rothlin"); -- --> Frau C.Collet Rothlin

-- -----------------------------------------
--  Fct 10.8) Gibt Brief-Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getBrief_Anrede;
DELIMITER //
CREATE FUNCTION getBrief_Anrede(p_sex CHAR(20), p_lastname CHAR(100) ) RETURNS CHAR(100)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  'Sehr geehrte Damen, Sehr geehrte Herren,';
   ELSE
		IF (p_sex = 'Herr') THEN 
			RETURN  CONCAT('Sehr geehrter ',firstUpper(p_sex), ' ', p_lastname);
		ELSE
            RETURN  CONCAT('Sehr geehrte ',firstUpper(p_sex), ' ', p_lastname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getBrief_Anrede("Herr", "Walter", "Rothlin"); -- --> Sehr geehrter Herr Rothlin
-- SELECT getBrief_Anrede("Frau", "Claudia", "Collet"); -- --> Sehr geehrte Frau Collet

-- -----------------------------------------
--  Fct 10.8.1) Gibt Brief-Anrede_Text zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getBrief_Anrede_Text;
DELIMITER //
CREATE FUNCTION getBrief_Anrede_Text(p_sex CHAR(20), p_lastname CHAR(100) ) RETURNS CHAR(100)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  'Sehr geehrte Damen, Sehr geehrte Herren,';
   ELSE
		IF (p_sex = 'Herr') THEN 
			RETURN  CONCAT('geschätzter ',firstUpper(p_sex), ' ', p_lastname);
		ELSE
            RETURN  CONCAT('geschätzte ',firstUpper(p_sex), ' ', p_lastname);
		END IF;
   END IF;
END//
DELIMITER ;

-- -----------------------------------------
--  Fct 10.9) Gibt perDu Brief-Anrede zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getBrief_Anrede_PerDu;
DELIMITER //
CREATE FUNCTION getBrief_Anrede_PerDu(p_sex CHAR(20), p_firstname CHAR(100) ) RETURNS CHAR(100)
BEGIN
   IF (p_sex = 'Firma') THEN 
		RETURN  '';
   ELSE
		IF (p_sex = 'Herr') THEN 
			RETURN  CONCAT('Lieber ', p_firstname);
		ELSE
            RETURN  CONCAT('Liebe ', p_firstname);
		END IF;
   END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getBrief_Anrede("Herr", "Walter", "Rothlin"); -- --> Sehr geehrter Herr Rothlin
-- SELECT getBrief_Anrede("Frau", "Claudia", "Collet"); -- --> Sehr geehrte Frau Collet
 
-- -----------------------------------------
--  Fct 10.10) Gibt Familienname zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getFamilieName;
DELIMITER //
CREATE FUNCTION getFamilieName(p_sex CHAR(5) , p_name_angenommen BOOLEAN , p_ledig_name CHAR(45) , p_partner_name CHAR(45)) RETURNS CHAR(100)
BEGIN
	IF (p_sex = 'Herr' or p_sex = 'Frau') THEN
		IF (p_partner_name = '') THEN
			RETURN  p_ledig_name;
		ELSE
            IF (p_sex = 'Herr') THEN
				IF (p_name_angenommen = True) THEN
					RETURN CONCAT(p_partner_name,' ', p_ledig_name);
				ELSE
					RETURN CONCAT(p_ledig_name,'-', p_partner_name);
                END IF;
			ELSE
                IF (p_name_angenommen = True) THEN
					RETURN CONCAT(p_partner_name,'-', p_ledig_name);
				ELSE
					RETURN CONCAT(p_ledig_name,' ', p_partner_name);
                END IF;
            END IF;
        END IF;
	ELSE 
		RETURN  CONCAT(p_ledig_name, ' ', p_partner_name);
    END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getFamilieName('Herr', FALSE, 'Rothlin', '');        -- --> Rothlin
-- SELECT getFamilieName('Frau', FALSE, 'Collet', '');         -- --> Collet
-- SELECT getFamilieName('Herr', TRUE,  'Rothlin', '');        -- --> Rothlin
-- SELECT getFamilieName('Frau', TRUE,  'Collet', '');         -- --> Collet

-- SELECT getFamilieName('Herr', FALSE, 'Rothlin', 'Collet');  -- --> Rothlin-Collet
-- SELECT getFamilieName('Frau', FALSE, 'Collet', 'Rothlin');  -- --> Collet Rothlin
-- SELECT getFamilieName('Herr', TRUE,  'Rothlin', 'Collet');  -- --> Collet Rothlin
-- SELECT getFamilieName('Frau', TRUE,  'Collet', 'Rothlin');  -- --> Rothlin-Collet

-- -----------------------------------------
--  Fct 10.11) Gibt LastName zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getLastName;
DELIMITER //
CREATE FUNCTION getLastName(p_sex CHAR(5) , p_name_angenommen BOOLEAN , p_ledig_name CHAR(45) , p_partner_name CHAR(45)) RETURNS CHAR(50)
BEGIN
	IF (p_sex = 'Herr' or p_sex = 'Frau') THEN
		IF (p_partner_name = '' OR p_partner_name is NULL) THEN
			RETURN  firstUpper(p_ledig_name);
		ELSE
            IF (p_sex = 'Herr') THEN
				IF (p_name_angenommen = True) THEN
					RETURN p_partner_name;
				ELSE
					RETURN p_ledig_name;
                END IF;
			ELSE
                IF (p_name_angenommen = True) THEN
					RETURN p_partner_name;
				ELSE
					RETURN p_ledig_name;
                END IF;
            END IF;
        END IF;
	ELSE 
		RETURN  CONCAT(p_ledig_name, ' ', p_partner_name);
    END IF;
END//
DELIMITER ;

-- Test-Cases

-- -----------------------------------------
DROP FUNCTION IF EXISTS calc_yearly_pachtfee;
DELIMITER //
CREATE FUNCTION calc_yearly_pachtfee(flaeche_in_aren FLOAT, preis_pro_are FLOAT) RETURNS FLOAT
BEGIN
   RETURN  flaeche_in_aren * preis_pro_are;
END//
DELIMITER ;

-- Test-Cases

-- -----------------------------------------
DROP FUNCTION IF EXISTS padding_telNr;
DELIMITER //
CREATE FUNCTION padding_telNr(p_nummer CHAR(20)) RETURNS CHAR(18)
BEGIN
	DECLARE tel_nr CHAR(20);
    SET tel_nr = REPLACE(p_nummer, ' ','');
    IF LENGTH(tel_nr) = 7 THEN
		RETURN CONCAT(LEFT(tel_nr, 3), ' ', MID(tel_nr, 4, 2), ' ', RIGHT(tel_nr, 2));
    ELSE 
		RETURN CONCAT(p_nummer);
	END IF;
END//
DELIMITER ;

-- SELECT padding_telNr('460 14 5 1');
-- SELECT padding_telNr('055 460 14 40');

-- -----------------------------------------
DROP FUNCTION IF EXISTS remove_leading_0;
DELIMITER //
CREATE FUNCTION remove_leading_0(p_string CHAR(20)) RETURNS CHAR(20)
BEGIN
    RETURN REPLACE(LTRIM(REPLACE(p_string, '0', ' ')), ' ', '0');
END//
DELIMITER ;

-- SELECT remove_leading_0('00401');

-- =========================================
--                  telnr                 --
-- =========================================
DROP FUNCTION IF EXISTS format_telNr;
DELIMITER //
CREATE FUNCTION format_telNr(p_laender_code CHAR(20), p_vorwahl CHAR(20), p_nummer CHAR(20)) RETURNS CHAR(60)
BEGIN
    IF p_laender_code = '0041' THEN
		RETURN CONCAT(p_vorwahl, '  ', padding_telNr(p_nummer));
    ELSE
		RETURN CONCAT('+', remove_leading_0(p_laender_code), ' ', remove_leading_0(p_vorwahl), ' ', padding_telNr(p_nummer));
	END IF;
END//
DELIMITER ;

-- SELECT format_telNr('0041', '055', '4601440');    -- 055 460 14 40
-- SELECT format_telNr('0001', '055', '4601440');    -- +41 1 460 14 40

-- -----------------------------------------
DROP FUNCTION IF EXISTS format_telNr_with_Detail;
DELIMITER //
CREATE FUNCTION format_telNr_with_Detail(p_laender_code CHAR(20), p_vorwahl CHAR(20), p_nummer CHAR(20), p_id INT UNSIGNED, p_type CHAR(20), p_endgeraet CHAR(10), p_prio TINYINT, p_short BOOLEAN) RETURNS CHAR(80)
BEGIN
    IF p_short = TRUE THEN
		RETURN CONCAT(format_telNr(p_laender_code, p_vorwahl, p_nummer), '  :',p_id,':  ', p_prio, ':', LEFT(p_type, 1), LEFT(p_endgeraet,1));
	ELSE
        RETURN CONCAT(format_telNr(p_laender_code, p_vorwahl, p_nummer), '  :',p_id,':  ', p_prio, ':', p_type, ':', p_endgeraet);
    END IF;
END//
DELIMITER ;

-- SELECT format_telNr_with_Detail('0041', '055', '4601440', 4711, 'Geschaeft', 'Mobile', '0', False); 

-- -----------------------------------------
DROP FUNCTION IF EXISTS get_TelNr_With_Details;
DELIMITER //
CREATE FUNCTION get_TelNr_With_Details(p_id INT, p_prio TINYINT, p_short BOOLEAN, p_with_details BOOLEAN) RETURNS CHAR(100)
BEGIN
    DECLARE ret_val CHAR(100) DEFAULT '';
    IF p_with_details = TRUE THEN
		IF p_short = TRUE THEN
			SET ret_val = (SELECT Tel_Nr_Detailed        FROM telnr_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
		ELSE
			SET ret_val = (SELECT Tel_Nr_Detailed_Long   FROM telnr_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
		END IF;
	ELSE
		SET ret_val = (SELECT Tel_Nr   FROM telnr_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
    END IF;
    IF ret_val is NULL THEN
		SET ret_val = '';
	END IF;
    RETURN ret_val;
END//
DELIMITER ;

/* TEST-Cases
SELECT 
      get_TelNr_With_Details(897, 0, FALSE,  FALSE)   AS Teln_Nr,
      get_TelNr_With_Details(897, 0, TRUE,   TRUE)    AS Teln_Nr_Detailed,
      get_TelNr_With_Details(897, 0, FALSE,  TRUE)    AS Teln_Nr_Detailed_Long
 UNION
 SELECT 
      get_TelNr_With_Details(897, 1, FALSE,  FALSE)   AS Teln_Nr,
      get_TelNr_With_Details(897, 1, TRUE,   TRUE)    AS Teln_Nr_Detailed,
      get_TelNr_With_Details(897, 1, FALSE,  TRUE)    AS Teln_Nr_Detailed_Long
 UNION
 SELECT 
      get_TelNr_With_Details(897, 2, FALSE,  FALSE)   AS Teln_Nr,
      get_TelNr_With_Details(897, 2, TRUE,   TRUE)    AS Teln_Nr_Detailed,
      get_TelNr_With_Details(897, 2, FALSE,  TRUE)    AS Teln_Nr_Detailed_Long
 UNION
 SELECT 
      get_TelNr_With_Details(897, 3, FALSE,  FALSE)   AS Teln_Nr,
      get_TelNr_With_Details(897, 3, TRUE,   TRUE)    AS Teln_Nr_Detailed,
      get_TelNr_With_Details(897, 3, FALSE,  TRUE)    AS Teln_Nr_Detailed_Long
UNION
SELECT 
      get_TelNr_With_Details(644, 0, FALSE,  FALSE)   AS Teln_Nr,
      get_TelNr_With_Details(644, 0, TRUE,   TRUE)    AS Teln_Nr_Detailed,
      get_TelNr_With_Details(644, 0, FALSE,  TRUE)    AS Teln_Nr_Detailed_Long;
*/

-- -----------------------------------------
DROP FUNCTION IF EXISTS getPrio_0_TelNr_ID;
DELIMITER //
CREATE FUNCTION getPrio_0_TelNr_ID(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT Tel_ID FROM Telnr_Liste WHERE Pers_ID = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getPrio_0_TelNr_ID(4);  -- --> xxxxxx

-- =========================================
--                    email               --
-- =========================================
DROP FUNCTION IF EXISTS format_eMail_with_Detail;
DELIMITER //
CREATE FUNCTION format_eMail_with_Detail(p_email CHAR(45), p_id INT UNSIGNED, p_type CHAR(20), p_prio TINYINT, p_short BOOLEAN) RETURNS CHAR(80)
BEGIN
    IF p_short = TRUE THEN
		RETURN CONCAT(p_email, '  :',p_id,':  ', p_prio, ':', LEFT(p_type, 1));
	ELSE
        RETURN CONCAT(p_email, '  :',p_id,':  ', p_prio, ':', p_type, ':');
    END IF;
END//
DELIMITER ;

-- SELECT format_eMail_with_Detail('walti@rothlin.ch', 4711, 'Geschaeft', '0', False);   -- walti@rothlin.ch  :4711:  0:Geschaeft:
-- SELECT format_eMail_with_Detail('walti@rothlin.ch', 4711, 'Geschaeft', '0', True);    -- walti@rothlin.ch  :4711:  0:G

-- -----------------------------------------
DROP FUNCTION IF EXISTS get_Email_With_Details;
DELIMITER //
CREATE FUNCTION get_Email_With_Details(p_id INT, p_prio TINYINT, p_short BOOLEAN, p_with_details BOOLEAN) RETURNS CHAR(100)
BEGIN
    DECLARE ret_val CHAR(100) DEFAULT '';
    IF p_with_details = TRUE THEN
		IF p_short = TRUE THEN
			SET ret_val = (SELECT Email_Detailed        FROM email_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
		ELSE
			SET ret_val = (SELECT Email_Detailed_Long   FROM email_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
		END IF;
	ELSE
		SET ret_val = (SELECT eMail_adresse   FROM email_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
    END IF;
    IF ret_val is NULL THEN
		SET ret_val = '';
	END IF;
    RETURN ret_val;
END//
DELIMITER ;

-- SELECT get_Email_With_Details(644, 0, FALSE,  FALSE)  AS Email;      -- walter@rothlin.com
-- SELECT get_Email_With_Details(644, 0, FALSE,  TRUE)   AS Email;      -- walter@rothlin.com  :321:  0:Sonstige:
-- SELECT get_Email_With_Details(644, 0, TRUE,   TRUE)   AS Email;      -- walter@rothlin.com  :321:  0:S

-- -----------------------------------------
DROP FUNCTION IF EXISTS getPrio_0_EMail_ID;
DELIMITER //
CREATE FUNCTION getPrio_0_EMail_ID(p_id INT) RETURNS CHAR(100)
BEGIN
    -- RETURN (SELECT eMail FROM email_adressen WHERE id = p_id AND prio=0 LIMIT 1);
    RETURN (SELECT eMail_ID FROM email_liste WHERE Pers_id = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;


-- Test-Cases
-- SELECT getPrio_0_EMail_ID(4);  -- --> xxxxxxx

-- =========================================
--                    IBAN                --
-- =========================================
DROP FUNCTION IF EXISTS format_IBAN_with_Detail;
DELIMITER //
CREATE FUNCTION format_IBAN_with_Detail(p_nummer CHAR(26), p_id INT UNSIGNED, p_bezeichnung CHAR(20), p_bankname CHAR(45), p_bankort CHAR(45), p_prio TINYINT, p_short BOOLEAN) RETURNS CHAR(200)
BEGIN
    IF p_short = TRUE THEN
		RETURN CONCAT(p_nummer, '  :',p_id,':  ', p_prio, ':', p_bankname);
	ELSE
        RETURN CONCAT(p_nummer, '  :',p_id,':  ', p_prio, ':', CONCAT(p_bankname,':',p_bankort,':',p_bezeichnung), ':');
    END IF;
END//
DELIMITER ;

-- SELECT format_IBAN_with_Detail('CH05 0077 7003 5367 6115 8', 1, 'Bezeichnung', 'Credit-Suisse', 'Zürich', 0, False);   -- CH05 0077 7003 5367 6115 8  :1:  0:Credit-Suisse:Zürich:Bezeichnung:
-- SELECT format_IBAN_with_Detail('CH05 0077 7003 5367 6115 8', 1, 'Bezeichnung', 'Credit-Suisse', 'Zürich', 1, True);    -- CH05 0077 7003 5367 6115 8  :1:  1:Credit-Suisse

-- -----------------------------------------
DROP FUNCTION IF EXISTS get_IBAN_With_Details;
DELIMITER //
CREATE FUNCTION get_IBAN_With_Details(p_id INT, p_prio TINYINT, p_short BOOLEAN, p_with_details BOOLEAN) RETURNS CHAR(100)
BEGIN
    DECLARE ret_val CHAR(100) DEFAULT '';
    IF p_with_details = TRUE THEN
		IF p_short = TRUE THEN
			SET ret_val = (SELECT IBAN_Detailed        FROM IBAN_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
		ELSE
			SET ret_val = (SELECT IBAN_Detailed_Long   FROM IBAN_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
		END IF;
	ELSE
		SET ret_val = (SELECT IBAN_Nummer   FROM IBAN_liste WHERE Pers_ID = p_id AND Prio=p_prio LIMIT 1);
    END IF;
    IF ret_val is NULL THEN
		SET ret_val = '';
	END IF;
    RETURN ret_val;
END//
DELIMITER ;

-- SELECT get_IBAN_With_Details(644, 0, FALSE,  FALSE)  AS IBAN;      -- CH95 8080 8006 9894 2234 3
-- SELECT get_IBAN_With_Details(644, 0, FALSE,  TRUE)   AS IBAN;      -- CH95 8080 8006 9894 2234 3  :303:  0:Raiffeisen:Lachen:Waltis:
-- SELECT get_IBAN_With_Details(644, 0, TRUE,   TRUE)   AS IBAN;      -- CH95 8080 8006 9894 2234 3  :303:  0:Raiffeisen

-- -----------------------------------------
DROP FUNCTION IF EXISTS getPrio_0_IBAN_ID;
DELIMITER //
CREATE FUNCTION getPrio_0_IBAN_ID(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT IBAN_ID FROM iban_liste WHERE Pers_id = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getPrio_0_IBAN_ID(16);  -- --> xxxxxxxxx

-- -----------------------------------------
--  Fct 10.12) Gibt Strasse mit Nr resp Postfach zurueck (siehe Testcases) 
DROP FUNCTION IF EXISTS getStrassenAdresse;
DELIMITER //
CREATE FUNCTION getStrassenAdresse(p_strasse VARCHAR(45), p_hausnummer VARCHAR(15), p_postfach VARCHAR(5)) RETURNS CHAR(100)
BEGIN
    IF (p_postfach = "") THEN
		RETURN CONCAT(p_strasse, ' ', p_hausnummer);
	ELSE
    	RETURN CONCAT(p_strasse, ' ', p_hausnummer, ' / Postfach:', p_postfach);
    END IF;
    
    IF (p_strasse = '') THEN
         IF (p_postfach = '' OR p_postfach = NULL) THEN
			RETURN '';
		 ELSE
            RETURN CONCAT('Postfach ', p_postfach);
         END IF;
    ELSE
       IF (p_hausnummer = '') THEN
          IF (p_postfach = '') THEN
               RETURN CONCAT('', p_strasse);
		  ELSE
               RETURN CONCAT(p_strasse, ' / Postfach:', p_postfach);
		  END IF;
	   ELSE
		  IF (p_postfach = '') THEN
		       RETURN CONCAT(p_strasse, ' ', p_hausnummer);
		  ELSE
               RETURN CONCAT(p_strasse, ' ', p_hausnummer, ' / Postfach:', p_postfach);
		  END IF;
       END IF;
    END IF;
END//
DELIMITER ;

-- Test-Cases
-- SELECT getStrassenAdresse('Peterliwiese', '33a', '');      -- --> Peterliwiese 33
-- SELECT getStrassenAdresse('Peterliwiese', '33a', '243' );  -- --> Peterliwiese 33 / Postfach:243

-- ===============================================================================================
-- == Create Views                                                                              ==
-- ===============================================================================================
DROP VIEW IF EXISTS Länder; 
CREATE VIEW Länder AS
	SELECT
        l.ID                                     AS ID,
		l.Name                                   AS Land,
        l.Code                                   AS Code,
		l.Landesvorwahl                          AS Landesvorwahl,
        l.last_update                            AS last_update
	FROM Land AS l;

-- SELECT * FROM Länder;

-- -----------------------------------------
DROP VIEW IF EXISTS Ort_Land; 
CREATE VIEW Ort_Land AS
	SELECT
        o.ID                                     AS ID,
		o.PLZ                                    AS PLZ,
        formatPLZinternational(l.Code, o.PLZ)    AS PLZ_International,
		l.Code                                   AS Code,
		o.Name                                   AS Ort,
        l.ID                                     AS Land_ID,
		l.Name                                   AS Land,
		l.Landesvorwahl                          AS Landesvorwahl,
        getYounger(l.last_update, o.last_update) AS last_update,
        o.last_update                            AS o_last_update,
        l.last_update                            AS l_last_update
	FROM orte AS o
	LEFT OUTER JOIN Land AS l ON o.Land_ID = l.ID;

-- SELECT * FROM Ort_Land;

-- -----------------------------------------
DROP VIEW IF EXISTS Adress_Daten; 
CREATE VIEW Adress_Daten AS
	SELECT
		a.ID                                      AS ID,
		a.Strasse                                 AS Strasse,
		a.Hausnummer                              AS Hausnummer,
        a.postfachnummer                          AS Postfachnummer,
        a.Adresszusatz                            AS Adresszusatz,
        a.Wohnung                                 AS Wohnung,
		getStrassenAdresse(a.Strasse, 
                           a.Hausnummer, 
                           a.postfachnummer)      AS Strassen_Adresse,
        a.Kataster_Nr                             AS Kataster_Nr,
        a.x_CH1903                                AS x_CH1903,
        a.y_CH1903                                AS y_CH1903,
        a.Politisch_Wangen                        AS Politisch_Wangen,
        ol.ID                                     AS Ort_ID,
		ol.PLZ	                                  AS PLZ,
        ol.`Code`                                 AS Land_Code,
        ol.PLZ_International	                  AS PLZ_International,
		ol.Ort	                                  AS Ort,
        ol.Land_ID                                AS Land_ID,
		ol.Land	                                  AS Land,
		getYounger(a.last_update, ol.last_update) AS last_update,
        a.last_update                             AS a_last_update,
        ol.last_update                            AS o_last_update
	FROM Adressen AS a
	LEFT OUTER JOIN ORT_LAND AS ol ON ol.ID = a.Orte_ID;

-- SELECT * FROM Adress_Daten;

-- -----------------------------------------
DROP VIEW IF EXISTS Telnr_Liste; 
CREATE VIEW Telnr_Liste AS
	SELECT
        -- Allgemeine Daten
        pers.ID                                      AS Pers_ID,
        'Nein'                                       AS `Geändert`,
        pers.Kategorien                              AS Kategorien,
        pers.Sex                                     AS Sex,
		getName_With_Initial(pers.Vorname, 
                             pers.Vorname_2)         AS Vorname_Initial,
		getFamilieName(pers.Sex, 
                  pers.Partner_Name_Angenommen, 
                  pers.Ledig_Name, 
                  pers.Partner_Name)                 AS Familien_Name,          -- Rothlin-Collet

        
        -- Spezifische Daten
		tel.ID                                       AS Tel_ID,
        tel.laendercode                              AS Laendercode,
        tel.vorwahl									 AS Vorwahl,
        tel.Nummer                                   AS Nummer,
		tel.prio                                     AS Prio,
		tel.`Type`                                   AS `Type`,
        tel.endgeraet                                AS Endgeraet,
        format_telNr(tel.laendercode,
                tel.vorwahl,
                tel.Nummer)                          AS Tel_Nr,
        format_telNr_with_Detail(tel.laendercode,
                tel.vorwahl,
                tel.Nummer,
                tel.ID,
                tel.`Type`,
                tel.endgeraet,
                tel.prio,
                TRUE)                                AS Tel_Nr_Detailed,
		format_telNr_with_Detail(tel.laendercode,
                tel.vorwahl,
                tel.Nummer,
                tel.ID,
                tel.`Type`,
                tel.endgeraet,
                tel.prio,
                FALSE)                               AS Tel_Nr_Detailed_Long,
                
        -- Personen Details
	    DATE_FORMAT(pers.Geburtstag,'%d.%m.%Y')      AS Geburtstag,
		DATE_FORMAT(pers.Todestag ,'%d.%m.%Y')       AS Todestag,
		getAge(pers.Geburtstag, pers.Todestag)       AS `Alter`,
        
        -- Personen Grunddaten
		pers.Partner_Name_Angenommen                 AS Name_Angenommen,
		pers.Ledig_Name                              AS Ledig_Name, 
		pers.Partner_Name                            AS Partner_Name,
		pers.Privat_Adressen_ID                      AS Privat_Adressen_ID,
        pers.Geschaefts_Adressen_ID                  AS Geschaefts_Adressen_ID,
        
        getYounger(pt.last_update, tel.last_update)  AS last_update
        
	FROM personen_has_telefonnummern AS pt
	LEFT OUTER JOIN Telefonnummern AS tel  ON pt.telefonnummern_ID = tel.ID
    LEFT OUTER JOIN Personen       AS pers ON pt.personen_ID       = pers.ID
    ORDER BY Familien_Name, Pers_ID, Prio;

-- -----------------------------------------
DROP VIEW IF EXISTS EMail_Liste; 
CREATE VIEW EMail_Liste AS
	SELECT
        -- Allgemeine Daten
        pers.ID                                      AS Pers_ID,
        'Nein'                                       AS `Geändert`,
        pers.Kategorien                              AS Kategorien,
        pers.Sex                                     AS Sex,
		getName_With_Initial(pers.Vorname, 
                             pers.Vorname_2)         AS Vorname_Initial,
		getFamilieName(pers.Sex, 
                  pers.Partner_Name_Angenommen, 
                  pers.Ledig_Name, 
                  pers.Partner_Name)                 AS Familien_Name,          -- Rothlin-Collet

        
        -- Spezifische Daten
		email.ID                                     AS Email_ID,
		email.prio                                   AS Prio,
        email.`Type`                                 AS `Type`,
		email.eMail                                  AS eMail_adresse,
        format_eMail_with_Detail(email.eMail,
                 email.ID, 
                 email.`Type`,
                 email.prio, True)                   AS Email_Detailed,
		format_eMail_with_Detail(email.eMail,
                 email.ID, 
                 email.`Type`,
                 email.prio, False)                  AS Email_Detailed_Long,

		-- Personen Details
	    DATE_FORMAT(pers.Geburtstag,'%d.%m.%Y')      AS Geburtstag,
		DATE_FORMAT(pers.Todestag ,'%d.%m.%Y')       AS Todestag,
		getAge(pers.Geburtstag, pers.Todestag)       AS `Alter`,
        
        -- Personen Grunddaten
		pers.Partner_Name_Angenommen                 AS Name_Angenommen,
		pers.Ledig_Name                              AS Ledig_Name, 
		pers.Partner_Name                            AS Partner_Name,
		pers.Privat_Adressen_ID                      AS Privat_Adressen_ID,
        pers.Geschaefts_Adressen_ID                  AS Geschaefts_Adressen_ID,
        
        getYounger(pt.last_update, email.last_update)  AS last_update
        
	FROM personen_has_email_adressen AS pt
	LEFT OUTER JOIN email_adressen AS email  ON pt.EMail_Adressen_ID   = email.ID
	LEFT OUTER JOIN Personen       AS pers   ON pt.personen_ID         = pers.ID
    ORDER BY Familien_Name, Pers_ID, Prio;

-- -----------------------------------------
DROP VIEW IF EXISTS IBAN_Liste; 
CREATE VIEW IBAN_Liste AS
	SELECT
        -- Allgemeine Daten
        pers.ID                                      AS Pers_ID,
        'Nein'                                       AS 'Geändert',
        pers.Kategorien                              AS Kategorien,
        pers.Sex                                     AS Sex,
		getName_With_Initial(pers.Vorname, 
                             pers.Vorname_2)         AS Vorname_Initial,
		getFamilieName(pers.Sex, 
                  pers.Partner_Name_Angenommen, 
                  pers.Ledig_Name, 
                  pers.Partner_Name)                 AS Familien_Name,          -- Rothlin-Collet

        -- Spezifische Daten
		iban.ID                                      AS IBAN_ID,
		iban.prio                                    AS Prio,
		iban.Nummer                                  AS IBAN_Nummer,
		iban.Bezeichnung                             AS Bezeichnung,
		iban.Bankname                                AS Bankname,
		iban.Bankort                                 AS Bankort,
        format_IBAN_with_Detail(iban.Nummer,
                   iban.ID, 
                   iban.Bezeichnung,
                   iban.Bankname,
                   iban.Bankort,
                  iban.prio, TRUE)   				 AS IBAN_Detailed,
        format_IBAN_with_Detail(iban.Nummer,
                   iban.ID, 
                   iban.Bezeichnung,
                   iban.Bankname,
                   iban.Bankort,
                  iban.prio, FALSE)   				 AS IBAN_Detailed_Long,
               
		-- Personen Details
	    DATE_FORMAT(pers.Geburtstag,'%d.%m.%Y')      AS Geburtstag,
		DATE_FORMAT(pers.Todestag ,'%d.%m.%Y')       AS Todestag,
		getAge(pers.Geburtstag, pers.Todestag)       AS `Alter`,
        
        -- Personen Grunddaten
		pers.Partner_Name_Angenommen                 AS Name_Angenommen,
		pers.Ledig_Name                              AS Ledig_Name, 
		pers.Partner_Name                            AS Partner_Name,
		pers.Privat_Adressen_ID                      AS Privat_Adressen_ID,
        pers.Geschaefts_Adressen_ID                  AS Geschaefts_Adressen_ID,
        
        getYounger(pers.last_update, iban.last_update)  AS last_update
        
	FROM IBAN AS iban
	LEFT OUTER JOIN Personen AS pers   ON iban.personen_ID  = pers.ID
	WHERE pers.Todestag IS NULL;

-- --------------------------------------------------------------------------------    
DROP VIEW IF EXISTS Personen_Daten; 
CREATE VIEW Personen_Daten AS
	SELECT
		  P.ID                                         AS ID,
          P.Zivilstand                                 AS Zivilstand,
          P.Kategorien                                 AS Kategorien,
		  P.Funktion                                   AS Funktion,
          P.Sex                                        AS Geschlecht,       -- Herr | Frau

		  getName_With_Initial(P.Vorname, 
                               P.Vorname_2)            AS Vorname_Initial,  -- Walter M.
          getFamilieName(P.Sex, 
                      P.Partner_Name_Angenommen, 
                      P.Ledig_Name, 
                      P.Partner_Name)                 AS Familien_Name,     -- Rothlin-Collet
		  
          getLastName(P.Sex, 
                      P.Partner_Name_Angenommen, 
                      P.Ledig_Name, 
                      P.Partner_Name)                 AS Last_Name,         -- Rothlin           
			
		  pAdr.ID                                     AS Priv_Adr_ID,      
		  getStrassenAdresse(pAdr.Strasse, 
                             pAdr.Hausnummer, 
							 pAdr.Postfachnummer)      AS Private_Strassen_Adresse,
          formatPLZ_ort(pAdr.PLZ, 
                        pAdr.Ort)                      AS Private_PLZ_Ort,  
                        
		  get_TelNr_With_Details(P.ID, 0, TRUE,  FALSE)                  AS Tel_Nr,
          get_TelNr_With_Details(P.ID, 0, FALSE, TRUE)                   AS Tel_Nr_Detail_Long,
          
		  get_TelNr_With_Details(P.ID, 1, TRUE,  FALSE)                  AS Tel_Nr_1,
          get_TelNr_With_Details(P.ID, 1, FALSE, TRUE)                   AS Tel_Nr_1_Detail_Long,
          
		  get_TelNr_With_Details(P.ID, 2, TRUE,  FALSE)                  AS Tel_Nr_2,
          get_TelNr_With_Details(P.ID, 2, FALSE, TRUE)                   AS Tel_Nr_2_Detail_Long,
          
          
		  get_Email_With_Details(P.ID, 0, TRUE,  FALSE)                  AS eMail,
          get_Email_With_Details(P.ID, 0, FALSE, TRUE)                   AS eMail_Detail_Long,
          
		  get_Email_With_Details(P.ID, 1, TRUE,  FALSE)                  AS eMail_1,
          get_Email_With_Details(P.ID, 1, FALSE, TRUE)                   AS eMail_1_Detail_Long,
          
		  get_Email_With_Details(P.ID, 2, TRUE,  FALSE)                  AS eMail_2,
          get_Email_With_Details(P.ID, 2, FALSE, TRUE)                   AS eMail_2_Detail_Long,
          
		  get_IBAN_With_Details(P.ID, 0, TRUE,  FALSE)                   AS IBAN,
          get_IBAN_With_Details(P.ID, 0, FALSE, TRUE)                    AS IBAN_Detail_Long,

                   
		  DATE_FORMAT(P.Geburtstag,'%d.%m.%Y')                                 AS Geburtstag,
          DATE_FORMAT(P.Geburtstag,'%Y')                                       AS Geburtsjahr,
		  DATE_FORMAT(P.Todestag ,'%d.%m.%Y')                                  AS Todestag,
          DATE_FORMAT(P.Todestag ,'%Y')                                        AS Todesjahr,
          getAge(P.Geburtstag, P.Todestag)                                     AS `Alter`,
          
		  P.AHV_Nr                                     AS AHV_Nr,
		  P.Betriebs_Nr                                AS Betriebs_Nr,
          
		  P.History                                    AS History,
          P.Bemerkungen                                AS Bemerkungen,
		  
          -- Personen-Details Rohdaten
		  P.Firma                                      AS Firma,
		  -- P.Vorname                                    AS Vorname,
		  IF (P.Vorname is NULL, "",  P.Vorname)       AS Vorname,
		  -- P.Vorname_2                                  AS Vorname_2,
          IF (P.Vorname_2 is NULL, "",  P.Vorname_2)   AS Vorname_2,
		  P.Ledig_Name                                 AS Ledig_Name,
          P.Partner_Name                               AS Partner_Name,
		  P.Partner_Name_Angenommen                    AS Partner_Name_Angenommen,
		  getLastName(P.Sex, 
                      P.Partner_Name_Angenommen, 
                      P.Ledig_Name, 
                      P.Partner_Name)                  AS LastName,         -- Rothlin
          
          -- Verwandtschaft
          -- ==============
          P.Partner_ID                                 AS Partner_ID,
          P.Mutter_ID                                  AS Mutter_ID,
          P.Vater_ID                                   AS Vater_ID,

          -- ID
          -- ==
          pAdr.ID                                      AS Private_Adressen_ID,
          pAdr.Ort_ID                                  AS Private_Ort_ID,
          pAdr.Land_ID                                 AS Private_Land_ID,
          
          gAdr.ID                                      AS Geschaeft_Adressen_ID,
          gAdr.Ort_ID                                  AS Geschaeft_Ort_ID,
          gAdr.Land_ID                                 AS Geschaeft_Land_ID,
          
          getPrio_0_IBAN_ID(P.ID)                      AS IBAN_ID,
          getPrio_0_EMail_ID(P.ID)                     AS eMail_ID,
          getPrio_0_TelNr_ID(P.ID)                     AS Tel_Nr_ID,
          
          
          DATE_FORMAT(P.Nach_Wangen_Gezogen,'%d.%m.%Y')                        AS Nach_Wangen_Gezogen,
          DATE_FORMAT(P.Von_Wangen_Weggezogen,'%d.%m.%Y')                      AS Von_Wangen_Weggezogen,
          
		  DATE_FORMAT(P.Angemeldet_Am,'%d.%m.%Y')                              AS Angemeldet_Am,
          DATE_FORMAT(P.Angemeldet_Am,'%Y')                                    AS Angemeldet_Am_Jahr,
          Bezahlt_Aufnahme_Gebühr                                             AS Bezahlte_Aufnahme_Gebühr,
          DATE_FORMAT(P.Aufgenommen_Am,'%d.%m.%Y')                             AS Aufgenommen_Am,
          DATE_FORMAT(P.Aufgenommen_Am,'%Y')                                   AS Aufgenommen_Am_Jahr,
          DATE_FORMAT(P.`Sich_Für_Bürgertag_Angemeldet_Am`,'%d.%m.%Y')         AS `Sich_Für_Bürgertag_Angemeldet_Am`,
          DATE_FORMAT(P.`Neubürgertag_gemacht_Am`,'%d.%m.%Y')                  AS `Neubürgertag_gemacht_Am`,
          Ausbezahlter_Bürgertaglohn                                           AS Ausbezahlter_Bürgertaglohn,
          
          DATE_FORMAT(P.Baulandgesuch_Eingereicht_Am,'%d.%m.%Y')               AS Baulandgesuch_Eingereicht_Am,
          DATE_FORMAT(P.Bauland_Gekauft_Am,'%d.%m.%Y')                         AS Bauland_Gekauft_Am,

          DATE_FORMAT(P.Funktion_Uebernommen_Am,'%d.%m.%Y')                    AS Funktion_Uebernommen_Am,
          DATE_FORMAT(P.Funktion_Abgegeben_Am,'%d.%m.%Y')                      AS Funktion_Abgegeben_Am,
          DATE_FORMAT(P.Chronik_Bezogen_Am,'%d.%m.%Y')                         AS Chronik_Bezogen_Am,
          DATE_FORMAT(P.Newsletter_Abonniert_Am,'%d.%m.%Y')                    AS Newsletter_Abonniert_Am,
          
		  pAdr.Strasse                                 AS Private_Strasse,
		  pAdr.Hausnummer                              AS Private_Hausnummer,
          pAdr.Postfachnummer                          AS Private_Postfachnummer,
		  pAdr.Politisch_Wangen                        AS Politisch_Wangen,
		  pAdr.PLZ                                     AS Private_PLZ,
          pAdr.Land_Code                               AS Private_Land_Code,
          pAdr.PLZ_International                       AS Private_PLZ_International,
		  pAdr.Ort                                     AS Private_Ort,
		  pAdr.Land                                    AS Private_Land,
          
          gAdr.ID                                      AS Gesch_Adr_ID,
		  gAdr.Strasse                                 AS Geschaeft_Strasse,
		  gAdr.Hausnummer                              AS Geschaeft_Hausnummer,
          gAdr.Postfachnummer                          AS Geschaeft_Postfachnummer,
          getStrassenAdresse(gAdr.Strasse, 
                             gAdr.Hausnummer, 
                             gAdr.Postfachnummer)      AS Geschaeft_Strassen_Adresse,
		  gAdr.PLZ                                     AS Geschaeft_PLZ,
          gAdr.Land_Code                               AS Geschaeft_Land_Code,
          gAdr.PLZ_International                       AS Geschaeft_PLZ_International,    -- CH-8855
		  gAdr.Ort                                     AS Geschaeft_Ort,
		  formatPLZ_ort(gAdr.PLZ, 
                        gAdr.Ort)                      AS Geschaeft_PLZ_Ort,
		  gAdr.Land                                    AS Geschaeft_Land,
          

		  -- Anreden
          -- =======
		  getAnrede(P.Sex, 
					'',
                    TRUE,
                    getLastName(P.Sex, 
                                P.Partner_Name_Angenommen, 
                                P.Ledig_Name, 
                                P.Partner_Name))       AS Anrede_1_Short_Short,		 -- Herr Rothlin
                                
		  getAnrede(P.Sex, 
					P.Vorname,
                    TRUE,
                    getLastName(P.Sex, 
                                P.Partner_Name_Angenommen, 
                                P.Ledig_Name, 
                                P.Partner_Name))       AS Anrede_Short_Short,		 -- Herr W.Rothlin
                                
          getAnrede(P.Sex, 
					P.Vorname,
                    FALSE,
				    getLastName(P.Sex, 
                                P.Partner_Name_Angenommen, 
                                P.Ledig_Name, 
                                P.Partner_Name))       AS Anrede_Long_Short,		 -- Herr Walter Rothlin
		  getAnrede(P.Sex, 
                    P.Vorname,
                    TRUE,
                    getFamilieName(P.Sex, 
                                   P.Partner_Name_Angenommen, 
                                   P.Ledig_Name, 
                                   P.Partner_Name))    AS Anrede_Short_Long,		-- Herr W.Rothlin-Collet

		  getAnrede(P.Sex, 
                    P.Vorname,
                    FALSE,
                    getFamilieName(P.Sex, 
                                   P.Partner_Name_Angenommen, 
                                   P.Ledig_Name, 
                                   P.Partner_Name))    AS Anrede_Long_Long,		  -- Herr Walter Rothlin-Collet
          
          getBrief_Anrede(P.Sex,
						  getLastName(P.Sex, 
									  P.Partner_Name_Angenommen, 
                                      P.Ledig_Name, 
                                      P.Partner_Name))       AS Brief_Anrede,           -- Sehr geehrter Herr Rothlin | Sehr geehrte Frau Collet | Sehr geehrte Damen, Sehr geehrte Herren
		  getBrief_Anrede(P.Sex,
		                  getFamilieName(P.Sex, 
                                         P.Partner_Name_Angenommen, 
                                         P.Ledig_Name, 
                                         P.Partner_Name))    AS Brief_Anrede_Long,     -- Sehr geehrter Herr Rothlin-Collet | Sehr geehrte Frau Collet Rothlin | Sehr geehrte Damen, Sehr geehrte Herren    

		 getBrief_Anrede_Text(P.Sex,
		                  getLastName(P.Sex, 
									  P.Partner_Name_Angenommen, 
									  P.Ledig_Name, 
									  P.Partner_Name))    AS Brief_Anrede_Text,        -- geschätzte Frau Badat 

          getBrief_Anrede_PerDu(P.Sex,
		                        P.Vorname)                   AS Brief_Anrede_PerDu,     -- Lieber Walter | Liebe Claudia 
		
          -- Such-Felder
			CASE 
			  WHEN FIND_IN_SET('Bürger', P.Kategorien) > 0   THEN 'Ja'
			  ELSE ''
			END AS Ist_Bürger,
            
			CASE 
			  WHEN FIND_IN_SET('Nutzungsberechtigt', P.Kategorien) > 0   THEN 'Ja'
			  ELSE ''
			END AS Ist_Nutzungsberechtigt,
            
			CASE 
			  WHEN FIND_IN_SET('Hat_16a', P.Kategorien) > 0   THEN 'Ja'
			  ELSE ''
			END AS Hat_16a_Teil,
            
			CASE 
			  WHEN FIND_IN_SET('Hat_35a', P.Kategorien) > 0   THEN 'Ja'
			  ELSE ''
			END AS Hat_35a_Teil,
            
			CASE 
			  WHEN FIND_IN_SET('Hat_35a', P.Kategorien) > 0   THEN 'Ja'
              WHEN FIND_IN_SET('Hat_16a', P.Kategorien) > 0   THEN 'Ja'
			  ELSE ''
			END AS Hat_Bürger_Teil,
            
			CASE 
			  WHEN FIND_IN_SET('Pächter', P.Kategorien) >  0   THEN 'Ja'
			  ELSE ''
			END AS Ist_Pächter,
            
			CASE 
			  WHEN FIND_IN_SET('Landwirt EFZ', P.Kategorien) >  0  THEN 'Ja'
			  ELSE ''
			END AS Ist_DZ_berechtigt,
            
          -- IF(P.Geburtstag is NULL, "NoGeburi", "GeburiFound") AS NoYesGeburi,
          -- IF(P.Geburtstag is NULL, "NoGeburi", DATE_FORMAT(P.Geburtstag,'%Y%m%d')) AS NoWithGeburi,
          CONCAT(P.Vorname,';',
                 P.Ledig_Name,';',
                 P.Partner_Name,';',
                 getStrassenAdresse(pAdr.Strasse, 
                             pAdr.Hausnummer, 
							 pAdr.Postfachnummer),';',
                 pAdr.Ort,';',
                 -- IF(P.Geburtstag is NULL, "NoGeburi", DATE_FORMAT(P.Geburtstag,'%Y%m%d')),';',
                 IF(P.Betriebs_Nr is NULL, "NoBetriebsNr", P.Betriebs_Nr),';',
                 IF(P.Geburtstag is NULL, "NoGeburi", DATE_FORMAT(P.Geburtstag,'%Y%m%d')))   AS Such_Begriff,     -- YYYYMMDD
        
		  -- Last_Update
          getYounger(P.last_update, pAdr.last_update)  AS last_update
	FROM Personen AS P
    LEFT OUTER JOIN Adress_Daten AS pAdr ON  P.Privat_Adressen_ID         = pAdr.ID
	LEFT OUTER JOIN Adress_Daten AS gAdr ON  P.Geschaefts_Adressen_ID     = gAdr.ID
    ORDER BY Familien_Name, Vorname_Initial;

-- SELECT * FROM Personen_Daten;
-- -----------------------------------------------------
-- SELECT * FROM Personen_Daten ;
-- -----------------------------------------------------
DROP VIEW IF EXISTS Personen_Daten_Lebend; 
CREATE VIEW Personen_Daten_Lebend AS
    SELECT
	    *
    FROM Personen_Daten
    WHERE Todestag IS NULL
    ORDER BY Geschlecht, Familien_Name, Vorname;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Bürger_Lebend; 
CREATE VIEW Bürger_Lebend AS
    SELECT
        *
    FROM Personen_Daten
    WHERE Todestag IS NULL AND FIND_IN_SET('Bürger', Kategorien) >  0
    ORDER BY Familien_Name, Vorname;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Genossenrat; 
CREATE VIEW Genossenrat AS
    SELECT
        *
    FROM Personen_Daten
    WHERE FIND_IN_SET('Genossenrat', Kategorien) >  0 OR
          FIND_IN_SET('GPK', Kategorien) >  0
    ORDER BY Funktion, Familien_Name, Vorname;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Mitarbeiter;
CREATE VIEW Mitarbeiter AS
    SELECT
        *
    FROM Personen_Daten
    WHERE FIND_IN_SET('Angestellter', Kategorien) >  0
    ORDER BY Funktion, Familien_Name, Vorname;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Graue_Panter; 
CREATE VIEW Graue_Panter AS
    SELECT
        *
    FROM Personen_Daten
    WHERE FIND_IN_SET('Grauer Panter', Kategorien) >  0
    ORDER BY Funktion, Familien_Name, Vorname;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Bürger_Nutzungsberechtigt; 
CREATE VIEW Bürger_Nutzungsberechtigt AS
    SELECT
        *
    FROM Personen_Daten
    WHERE Todestag IS NULL AND FIND_IN_SET('Bürger', Kategorien) >  0 AND FIND_IN_SET('Nutzungsberechtigt', Kategorien) >  0
    ORDER BY Familien_Name, Vorname;


-- -----------------------------------------------------
DROP VIEW IF EXISTS Bürger_eMailing; 
CREATE VIEW Bürger_eMailing AS
    SELECT
        *
    FROM Bürger_Nutzungsberechtigt
    WHERE eMail is Not Null and eMail != '' and eMail != 'keine';
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Bürger_Mailing; 
CREATE VIEW Bürger_Mailing AS
    SELECT
        *
    FROM Bürger_Nutzungsberechtigt
    WHERE eMail is Null or eMail = '' or eMail = 'keine';   
-- -----------------------------------------------------
DROP VIEW IF EXISTS Bürger_Nicht_Nutzungsberechtigt; 
CREATE VIEW Bürger_Nicht_Nutzungsberechtigt AS
    SELECT
        *
    FROM Personen_Daten
    WHERE Todestag IS NULL AND FIND_IN_SET('Bürger', Kategorien) >  0 AND FIND_IN_SET('Nutzungsberechtigt', Kategorien) =  0
    ORDER BY Familien_Name, Vorname;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Unbereinigt_Email_TelNr_IBAN; 
CREATE VIEW Unbereinigt_Email_TelNr_IBAN AS
    SELECT
        *
    FROM Bürger_Lebend
	-- WHERE eMail  IS NULL OR eMail  = '' OR
    --       Tel_Nr IS NULL OR Tel_Nr = '' OR
    --       IBAN   IS NULL OR IBAN   = ''
    WHERE eMail_ID  IS NULL OR
          Tel_Nr_ID IS NULL OR
          IBAN_ID   IS NULL
    ORDER BY Familien_Name, Vorname;

-- -----------------------------------------------------    
DROP VIEW IF EXISTS Bürger_Gestorben; 
CREATE VIEW Bürger_Gestorben AS
    SELECT 
        ID,
        Geschlecht,
        Vorname_Initial,
        Familien_Name,
        CONCAT(Private_Strassen_Adresse,'; ',Private_PLZ_Ort) AS `Letzte Adresse`,
        Geburtstag,
		Geburtsjahr,
        Todestag,
        Todesjahr,
        IF (Todesjahr = DATE_FORMAT(now(),'%Y'), 'Ja', '') AS `Dieses Jahr gestorben`,
        `Alter`,
        last_update
    FROM Personen_Daten 
    WHERE Todestag IS NOT NULL AND FIND_IN_SET('Bürger', Kategorien) >  0
    ORDER BY STR_TO_DATE(Todestag,'%d.%m.%Y');

-- -----------------------------------------------------    
DROP VIEW IF EXISTS Nicht_Bürger_Gestorben; 
CREATE VIEW Nicht_Bürger_Gestorben AS
    SELECT 
        * 
    FROM Personen_Daten 
    WHERE Todestag IS NOT NULL AND FIND_IN_SET('Bürger', Kategorien) =  0
    ORDER BY STR_TO_DATE(Todestag,'%d.%m.%Y');

-- -----------------------------------------------------
DROP VIEW IF EXISTS Pächter; 
CREATE VIEW Pächter AS
	SELECT
		ID                       AS ID,
        Ist_Bürger               AS `Ist_Bürger`,
		Kategorien,
		Geschlecht               AS Sex,
		Vorname_Initial          AS Vorname,
		Familien_Name            AS `Name`,
		Private_Strassen_Adresse AS Adresse,
		Private_PLZ_Ort          AS Ort,
		eMail,
		Tel_Nr,
		Betriebs_Nr,
        `Alter`,
		Geburtstag,
		IBAN,
        Bemerkungen
	FROM Personen_Daten
    WHERE FIND_IN_SET('Pächter',        Kategorien) >  0
	ORDER BY `ID`;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Verpächter; 
CREATE VIEW Verpächter AS
	SELECT
		ID                       AS ID,
        Ist_Bürger               AS `Ist_Bürger`,
		Kategorien,
		Geschlecht               AS Sex,
		Vorname_Initial          AS Vorname,
		Familien_Name            AS `Name`,
		Private_Strassen_Adresse AS Adresse,
		Private_PLZ_Ort          AS Ort,
		eMail,
		Tel_Nr,
		Betriebs_Nr,
        `Alter`,
		Geburtstag,
		IBAN,
        Bemerkungen
	FROM Personen_Daten
    WHERE FIND_IN_SET('Hat_16a',        Kategorien) >  0 OR
          FIND_IN_SET('Hat_35a',        Kategorien) >  0 OR
          `ID` IN (625)   /*,416,411,341,340,86,371,226,268,298,100,125) OR
          `ID` IN (121,84,88,244,303,258,438,350,165,438,119,63,73,94,72) OR
          `ID` IN (135,88,175,224,326,368,322,437,359)  OR
          `ID` IN (261,93,281,369,97,85,293,114,85,259,244,279,182,192,383,119,97,93,281,95,144) */
	ORDER BY `ID`;
    
/*
SELECT ID, Vorname_Initial, Familien_Name, Private_Strassen_Adresse, Private_PLZ_Ort
      FROM personen_daten 
      WHERE Such_Begriff LIKE BINARY '%Guntlin%' AND Such_Begriff LIKE BINARY '%Karl%';
*/
-- SELECT * FROM personen_daten WHERE Such_Begriff LIKE BINARY '%Lüönd%';

-- -----------------------------------------------------
DROP VIEW IF EXISTS Personen_Daten_Raw; 
CREATE VIEW Personen_Daten_Raw AS
	SELECT
		  ID,
          Zivilstand,
		  Kategorien,
          Funktion,
		  Geschlecht,               -- Herr | Frau
		  Vorname,
          Vorname_2,
          Ledig_Name,
          Partner_Name,
		  Partner_Name_Angenommen,
          
          Private_Adressen_ID,		  
		  Private_Strasse,
		  Private_Hausnummer,
          Private_Postfachnummer,
          Private_Ort_ID,
		  Private_PLZ,
		  Private_Ort,
          Private_Land_ID,
		  Private_Land,
          
          AHV_Nr,
		  Betriebs_Nr,

          Tel_Nr_Detail_Long,
          Tel_Nr_1_Detail_Long,
          Tel_Nr_2_Detail_Long,

          eMail_Detail_Long,
          eMail_1_Detail_Long,
          eMail_2_Detail_Long,
          
          IBAN_Detail_Long,
          
          Geburtstag,
          Todestag,
          
          Nach_Wangen_Gezogen,
          Von_Wangen_Weggezogen,
          Baulandgesuch_Eingereicht_Am,
          Bauland_Gekauft_Am,
          Angemeldet_Am,
          Aufgenommen_Am,
          Funktion_Uebernommen_Am,
          Funktion_Abgegeben_Am,
          Chronik_Bezogen_Am,
          
		  Geschaeft_Adressen_ID,		  
		  Geschaeft_Strasse,
		  Geschaeft_Hausnummer,
          Geschaeft_Postfachnummer,
          Geschaeft_Ort_ID,
		  Geschaeft_PLZ,
		  Geschaeft_Ort,
          Geschaeft_Land_ID,
		  Geschaeft_Land
	FROM Personen_Daten
    WHERE Todestag IS NULL
    ORDER BY ID;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Neubürger_Vorvorjahr; 
CREATE VIEW Neubürger_Vorvorjahr AS
	SELECT 
	  ID, 
	  Kategorien,
	  Geschlecht, 
	  Vorname_Initial           AS Vorname, 
	  Familien_Name             AS Familienname, 
	  Private_Strassen_Adresse  AS Strasse,
	  Private_PLZ_Ort           AS PLZ_Ort,
	  Tel_Nr,
	  eMail,
	  IBAN,
	  Geburtstag,
	  `Alter`,
	  Angemeldet_Am,
	  Bezahlte_Aufnahme_Gebühr,
	  Aufgenommen_Am,
	  Sich_Für_Bürgertag_Angemeldet_Am,
	  Neubürgertag_gemacht_Am,
	  Ausbezahlter_Bürgertaglohn,
	  Partner_ID,
	  Mutter_ID,
	  Vater_ID
	FROM Personen_Daten WHERE Angemeldet_Am_Jahr  = DATE_FORMAT(now() - INTERVAL 2 YEAR,'%Y');
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Neubürger_Vorjahr; 
CREATE VIEW Neubürger_Vorjahr AS
	SELECT 
	  ID, 
	  Kategorien,
	  Geschlecht, 
	  Vorname_Initial           AS Vorname, 
	  Familien_Name             AS Familienname, 
	  Private_Strassen_Adresse  AS Strasse,
	  Private_PLZ_Ort           AS PLZ_Ort,
	  Tel_Nr,
	  eMail,
	  IBAN,
	  Geburtstag,
	  `Alter`,
	  Angemeldet_Am,
	  Bezahlte_Aufnahme_Gebühr,
	  Aufgenommen_Am,
	  Sich_Für_Bürgertag_Angemeldet_Am,
	  Neubürgertag_gemacht_Am,
	  Ausbezahlter_Bürgertaglohn,
	  Partner_ID,
	  Mutter_ID,
	  Vater_ID
	FROM Personen_Daten WHERE Angemeldet_Am_Jahr  = DATE_FORMAT(now() - INTERVAL 1 YEAR,'%Y');
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Neubürger_Dieses_Jahr; 
CREATE VIEW Neubürger_Dieses_Jahr AS
	SELECT 
	  ID, 
	  Kategorien,
	  Geschlecht, 
	  Vorname_Initial           AS Vorname, 
	  Familien_Name             AS Familienname, 
	  Private_Strassen_Adresse  AS Strasse,
	  Private_PLZ_Ort           AS PLZ_Ort,
	  Tel_Nr,
	  eMail,
	  IBAN,
	  Geburtstag,
	  `Alter`,
	  Angemeldet_Am,
	  Bezahlte_Aufnahme_Gebühr,
	  Aufgenommen_Am,
	  Sich_Für_Bürgertag_Angemeldet_Am,
	  Neubürgertag_gemacht_Am,
	  Ausbezahlter_Bürgertaglohn,
	  Partner_ID,
	  Mutter_ID,
	  Vater_ID
	FROM Personen_Daten WHERE Angemeldet_Am_Jahr  = DATE_FORMAT(now(),'%Y');

-- SELECT  DATE_FORMAT(now() - INTERVAL 1 YEAR,'%Y');
-- -----------------------------------------------------
DROP VIEW IF EXISTS Newsletter_Abo; 
CREATE VIEW Newsletter_Abo AS
	SELECT 
	  ID, 
	  Kategorien,
	  Geschlecht, 
	  Vorname_Initial           AS Vorname, 
	  Familien_Name             AS Familienname, 
	  Private_Strassen_Adresse  AS Strasse,
	  Private_PLZ_Ort           AS PLZ_Ort,
	  Tel_Nr,
	  eMail,
	  Geburtstag,
	  `Alter`,
      Newsletter_Abonniert_Am
	FROM Personen_Daten WHERE Newsletter_Abonniert_Am IS NOT NULL;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Pachtlandzuteilung; 
CREATE VIEW Pachtlandzuteilung AS
	SELECT
		  -- Landteil Details
          -- ----------------
		  L.ID                                       AS ID,
          L.AV_Parzellen_Nr                          AS AV_Parzelle,
          L.GENO_Parzellen_Nr                        AS GENO_Parzelle,
          L.Flur_Bezeichnung                         AS Flur_Bezeichnung,
          L.Flaeche_In_Aren                          AS Flaeche,
          ROUND(L.Pachtzins_Pro_Are, 2)              AS Pachtzins_pro_Are,
		  ROUND(L.Fix_Pachtzins, 2)                  AS FixPachtPreis,
          
          IF (L.Verpaechter_ID = 625,
              IF (L.Pachtzins_Pro_Are > 0, 
				  ROUND(calc_yearly_pachtfee(
									   L.Flaeche_In_Aren,
									   L.Pachtzins_Pro_Are), 0),
				  ROUND(L.Fix_Pachtzins, 0)),
			  '')     AS Geno_Pachtzins_pro_Jahr,

	      
          L.Buergerlandteil                          AS Buergerteil,
          -- L.Polygone_Flaeche                         AS Polygone,
          -- L.x_CH1903                                 AS x_zentrum,
          -- L.y_CH1903                                 AS y_zentrum,
          
		  -- Pächter Daten
          -- -------------          
		  -- L.Vorheriger_Paechter_ID                   AS Vorheriger_Paechter_ID,
          L.Paechter_ID                              AS Paechter_ID,
		  Paechter_Adr.Betriebs_Nr                   AS Pachter_Betriebs_Nr,
          Paechter_Adr.Kategorien                    AS Paechter_Kategorien,
          Paechter_Adr.Zivilstand                    AS Paechter_Zivilstand,
          Paechter_Adr.Geschlecht                    AS Paechter_Geschlecht,
          -- Paechter_Adr.Firma                         AS Pachter_Firma,
		  Paechter_Adr.Vorname_Initial               AS Paechter_Vorname,
          Paechter_Adr.Familien_Name                 AS Paechter_Name,

          Paechter_Adr.Private_Strassen_Adresse      AS Paechter_Strasse,
          -- Paechter_Adr.Private_Hausnummer            AS Paechter_Hausnummer,
          Paechter_Adr.Private_PLZ_Ort               AS Paechter_PLZ_Ort,
          Paechter_Adr.Tel_Nr                        AS Paechter_Tel_Nr,
          Paechter_Adr.eMail                         AS Paechter_eMail,
          Paechter_Adr.Geburtsjahr                   AS Paechter_Geburtsjahr,
          Paechter_Adr.Geburtstag                    AS Paechter_Geburtstag,
          Paechter_Adr.Todestag                      AS Paechter_Todestag,
          Paechter_Adr.Todesjahr                     AS Paechter_Todesjahr,
          Paechter_Adr.`Alter`                       AS Paechter_Alter,
          -- Paechter_Adr.Private_Ort                   AS Paechter_Ort,

		  -- Verpächtere Daten
          -- -----------------
          -- L.Vorheriger_Verpaechter_ID                AS Vorheriger_Verpaechter_ID,
          L.Verpaechter_ID                           AS Verpaechter_ID,
          Verpaechter_Adr.Kategorien                 AS Verpaechter_Kategorien,
          Verpaechter_Adr.Zivilstand                 AS Verpaechter_Zivilstand,
          Verpaechter_Adr.Geschlecht                 AS Verpaechter_Geschlecht,
		  Verpaechter_Adr.Firma                      AS Verpaechter_Firma,
		  Verpaechter_Adr.Vorname_Initial            AS Verpaechter_Vorname,
          Verpaechter_Adr.Familien_Name              AS Verpaechter_Name,
          Verpaechter_Adr.Private_Strassen_Adresse   AS Verpaechter_Strasse,
          -- Verpaechter_Adr.Private_Hausnummer         AS Verpaechter_Hausnummer,
          Verpaechter_Adr.Private_PLZ_Ort            AS Verpaechter_PLZ_Ort,
          Verpaechter_Adr.Tel_Nr                     AS Verpaechter_Tel_Nr,
          Verpaechter_Adr.eMail                      AS Verpaechter_eMail,
		  Verpaechter_Adr.Geburtsjahr                AS Verpaechter_Geburtsjahr,
          Verpaechter_Adr.Geburtstag                 AS Verpaechter_Geburtstag,
          Verpaechter_Adr.Todestag                   AS Verpaechter_Todestag,
          Verpaechter_Adr.Todesjahr                  AS Verpaechter_Todesjahr,
          Verpaechter_Adr.`Alter`                    AS Verpaechter_Alter,
          -- Verpaechter_Adr.Private_Ort                AS Verpaechter_Ort,
          
		  -- Vertragliche Daten
          -- ------------------
          L.Vertragsart                              AS Vertragsart,
          L.Pachtbeginn_Am                           AS Pachtbeginn,
          L.Rueckgabe_Am                             AS Rueckgabe,
          L.Vertragsende_Am                          AS Vertragsende,
          L.Pachtende_Am                             AS Pachtende
	FROM Landteile AS L
    LEFT OUTER JOIN Personen_Daten AS Paechter_Adr    ON  L.Paechter_ID     = Paechter_Adr.ID
	LEFT OUTER JOIN Personen_Daten AS Verpaechter_Adr ON  L.Verpaechter_ID  = Verpaechter_Adr.ID;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Paechterstatistik; 
CREATE VIEW Paechterstatistik AS
	SELECT Paechter_ID,
		   Paechter_Geschlecht,
		   Paechter_Vorname,
		   Paechter_Name,
		   Paechter_Strasse,
		   Paechter_PLZ_Ort,
           Paechter_Alter,
		   ROUND(SUM(Flaeche),2)                  AS Geno_Flaeche,
		   SUM(Geno_Pachtzins_pro_Jahr)  AS Geno_Pachtzins
	FROM Pachtlandzuteilung
	WHERE Verpaechter_ID = 625
	GROUP BY Paechter_ID
	ORDER BY Paechter_Name;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Buergerteile; 
CREATE VIEW Buergerteile AS
	SELECT Verpaechter_ID,
		   Verpaechter_Geschlecht,
		   Verpaechter_Vorname,
		   Verpaechter_Name,
		   Verpaechter_Strasse,
		   Verpaechter_PLZ_Ort,
           Verpaechter_Geburtstag,
	       Verpaechter_Todestag,
           Verpaechter_Alter,
           Verpaechter_Kategorien,
           ID                     AS ID,
           AV_Parzelle,
           GENO_Parzelle,
           Flur_Bezeichnung,
		   Flaeche                AS Flaeche,
           Paechter_ID,
		   Paechter_Geschlecht,
		   Paechter_Vorname,
		   Paechter_Name,
		   Paechter_Strasse,
		   Paechter_PLZ_Ort,
           Paechter_Kategorien
	FROM Pachtlandzuteilung
	WHERE Verpaechter_ID != 625
    ORDER BY Verpaechter_Name, Verpaechter_Vorname;
    
-- -----------------------------------------------------
DROP VIEW IF EXISTS Buergerteile_Speziell; 
CREATE VIEW Buergerteile_Speziell AS
	SELECT *
	FROM Buergerteile
	WHERE Verpaechter_Todestag != '' OR
          FIND_IN_SET('Nutzungsberechtigt', Verpaechter_Kategorien) =  0 OR
          FIND_IN_SET('Bürger',             Verpaechter_Kategorien) =  0
    ORDER BY Verpaechter_Name, Verpaechter_Vorname;

-- -----------------------------------------------------
DROP VIEW IF EXISTS Wärmeanschlüsse_View; 
CREATE VIEW Wärmeanschlüsse_View AS
	SELECT 
       `anschluss`.`ID`                                         AS `ID`,
	   -- `standort`.`ID`                                       AS `Stao_ID`,
       `standort`.`Strassen_Adresse`                            AS `Standort`,
       `anschluss`.`Parzellen_Nummer`                           AS `Parzellen_Nummer`,
       `anschluss`.`Korrenspondenz`                             AS `Korrenspondenz`,
       `anschluss`.`Gebietsbezeichnung`                         AS `Gebietsbezeichnung`,
       `anschluss`.`Anschluss_Type`                             AS `Anschluss_Type`,
       `anschluss`.`Anschluss_Gebühr`                           AS `Anschluss_Gebühr`,
       `anschluss`.`Vertrag_unterzeichnet_Am`                   AS `Vertrag_unterzeichnet_Am`,
       `anschluss`.`Teilanschluss_Vereinbarung_Endet_Am`        AS `Teilanschluss_Vereinbarung_Endet_Am`,
       `anschluss`.`Verrechnet_Am`                              AS `Verrechnet_Am`,
       `anschluss`.`Bezahlt_Am`                                 AS `Bezahlt_Am`,
  
       `anschluss`.`kW_Leistung`                                AS `kW_Leistung`,
       `anschluss`.`Stations_Type`                              AS `Stations_Type`,

       `anschluss`.`Fabrikations_Nr`                            AS `Fabrikations_Nr`,
       `anschluss`.`Steuerungs_Type`                            AS `Steuerungs_Type`,
       `anschluss`.`Zähler_Nr`                                  AS `Zähler_Nr`,
       `anschluss`.`Baujahr_Station`                            AS `Baujahr_Station`,
  
       `anschluss`.`Inbetrieb_genommen_Am`                      AS `Inbetrieb_genommen_Am`,
       `anschluss`.`Letzte_Kontrolle_Am`                        AS `Letzte_Kontrolle_Am`,
       `anschluss`.`Sieb_Primär_gereinigt_Am`                   AS `Sieb_Primär_gereinigt_Am`,
       `anschluss`.`Sieb_Sekundär_gereinigt_Am`                 AS `Sieb_Sekundär_gereinigt_Am`,
       `anschluss`.`SBS_Baterrien_gewechselt_Am`                AS `SBS_Baterrien_gewechselt_Am`,
  
       `anschluss`.`Parameter`                                  AS `Parameter`,
       `anschluss`.`Durchleitungsvertrag_unterzeichnet_Am`      AS `Durchleitungsvertrag_unterzeichnet_Am`,
       `anschluss`.`Durchleitungsvertrag_endet_Am`              AS `Durchleitungsvertrag_endet_Am`,
       `anschluss`.`Bezahlte_Durchleitungs_Gebühr`              AS `Bezahlte_Durchleitungs_Gebühr`,
       `anschluss`.`Bemerkungen`                                AS `Bemerkungen`,
       
       -- eigentümer.ID                               AS Eigentümer_ID,
       eigentümer.Vorname_Initial                  AS Eigentümer_Vorname,
       eigentümer.Familien_Name                    AS Eigentümer_Familienname,
       eigentümer.Private_Strassen_Adresse         AS Eigentümer_Adresse,
       eigentümer.Private_PLZ_Ort                  AS Eigentümer_PLZ_Ort,
       eigentümer.Tel_Nr                           AS Eigentümer_Tel_Nr,
       eigentümer.eMail                            AS Eigentümer_eMail,
       
       -- eigentümer_2.ID                               AS Eigentümer_2_ID,
	   eigentümer_2.Vorname_Initial                  AS Eigentümer_2_Vorname,
       eigentümer_2.Familien_Name                    AS Eigentümer_2_Familienname,
       eigentümer_2.Private_Strassen_Adresse         AS Eigentümer_2_Adresse,
       eigentümer_2.Private_PLZ_Ort                  AS Eigentümer_2_PLZ_Ort,
       eigentümer_2.Tel_Nr                           AS Eigentümer_2_Tel_Nr,
       eigentümer_2.eMail                            AS Eigentümer_2_eMail,
       
	   -- kontakt.ID                                  AS Kontakt_ID,
       kontakt.Vorname_Initial                     AS Kontakt_Vorname,
       kontakt.Familien_Name                       AS Kontakt_Familienname,
       kontakt.Private_Strassen_Adresse            AS Kontakt_Adresse,
       kontakt.Private_PLZ_Ort                     AS Kontakt_PLZ_Ort,
       kontakt.Tel_Nr                              AS Kontakt_Tel_Nr,
       kontakt.eMail                               AS Kontakt_eMail,
       
	   -- rechAdr.ID                                  AS Rechnung_ID,
       rechAdr.Vorname_Initial                     AS Rechnung_Vorname,
       rechAdr.Familien_Name                       AS Rechnung_Familienname,
       rechAdr.Private_Strassen_Adresse            AS Rechnung_Adresse,
       rechAdr.Private_PLZ_Ort                     AS Rechnung_PLZ_Ort,
       rechAdr.Tel_Nr                              AS Rechnung_Tel_Nr,
       rechAdr.eMail                               AS Rechnung_eMail,
       
	   -- heiziger.ID                                  AS Heiziger_ID,
       heiziger.Vorname_Initial                     AS Heiziger_Vorname,
       heiziger.Familien_Name                       AS Heiziger_Familienname,
       heiziger.Private_Strassen_Adresse            AS Heiziger_Adresse,
       heiziger.Private_PLZ_Ort                     AS Heiziger_PLZ_Ort,
       heiziger.Tel_Nr                              AS Heiziger_Tel_Nr,
       heiziger.eMail                               AS Heiziger_eMail,
       
	   -- elektriker.ID                                  AS Elektriker_ID,
       elektriker.Vorname_Initial                     AS Elektriker_Vorname,
       elektriker.Familien_Name                       AS Elektriker_Familienname,
       elektriker.Private_Strassen_Adresse            AS Elektriker_Adresse,
       elektriker.Private_PLZ_Ort                     AS Elektriker_PLZ_Ort,
       elektriker.Tel_Nr                              AS Elektriker_Tel_Nr,
       elektriker.eMail                               AS Elektriker_eMail
       
	FROM Wärmeanschlüsse AS anschluss
    LEFT OUTER JOIN Adress_Daten   AS standort     ON standort.ID     = anschluss.Standort_Adresse_ID
    LEFT OUTER JOIN Personen_Daten AS eigentümer   ON eigentümer.ID   = anschluss.Eigentümer_ID
    LEFT OUTER JOIN Personen_Daten AS eigentümer_2 ON eigentümer_2.ID = anschluss.Eigentümer_2_ID
    LEFT OUTER JOIN Personen_Daten AS kontakt      ON kontakt.ID      = anschluss.Kontakt_ID
    LEFT OUTER JOIN Personen_Daten AS rechAdr      ON rechAdr.ID      = anschluss.Rechnungs_Adresse_ID
    LEFT OUTER JOIN Personen_Daten AS heiziger     ON heiziger.ID     = anschluss.Heizungs_Installateur_ID
    LEFT OUTER JOIN Personen_Daten AS elektriker   ON elektriker.ID   = anschluss.Elektro_Installateur_ID;

-- -----------------------------------------------------
/*
DROP VIEW IF EXISTS Wärmeanschlüsse_Reco; 
CREATE VIEW Wärmeanschlüsse_Reco AS
	SELECT 
       `anschluss`.`ID`                                         AS `ID`,
	   `standort`.`ID`                                          AS `Stao_ID`,
       -- `standort`.`Strassen_Adresse`                            AS `Standort`,
       `anschluss`.`Parzellen_Nummer`                           AS `Parzellen_Nummer`,
       `anschluss`.`Korrenspondenz`                             AS `Korrenspondenz`,
       `anschluss`.`Gebietsbezeichnung`                         AS `Gebietsbezeichnung`,
       `anschluss`.`Anschluss_Type`                             AS `Anschluss_Type`,
       `anschluss`.`Anschluss_Gebühr`                           AS `Anschluss_Gebühr`,
       `anschluss`.`Vertrag_unterzeichnet_Am`                   AS `Vertrag_unterzeichnet_Am`,
       `anschluss`.`Teilanschluss_Vereinbarung_Endet_Am`        AS `Teilanschluss_Vereinbarung_Endet_Am`,
       `anschluss`.`Verrechnet_Am`                              AS `Verrechnet_Am`,
       `anschluss`.`Bezahlt_Am`                                 AS `Bezahlt_Am`,
  
       `anschluss`.`kW_Leistung`                                AS `kW_Leistung`,
       `anschluss`.`Stations_Type`                              AS `Stations_Type`,

       `anschluss`.`Fabrikations_Nr`                            AS `Fabrikations_Nr`,
       `anschluss`.`Steuerungs_Type`                            AS `Steuerungs_Type`,
       `anschluss`.`Zähler_Nr`                                  AS `Zähler_Nr`,
       `anschluss`.`Baujahr_Station`                            AS `Baujahr_Station`,
  
       `anschluss`.`Inbetrieb_genommen_Am`                      AS `Inbetrieb_genommen_Am`,
       `anschluss`.`Letzte_Kontrolle_Am`                        AS `Letzte_Kontrolle_Am`,
       `anschluss`.`Sieb_Primär_gereinigt_Am`                   AS `Sieb_Primär_gereinigt_Am`,
       `anschluss`.`Sieb_Sekundär_gereinigt_Am`                 AS `Sieb_Sekundär_gereinigt_Am`,
       `anschluss`.`SBS_Baterrien_gewechselt_Am`                AS `SBS_Baterrien_gewechselt_Am`,
  
       `anschluss`.`Parameter`                                  AS `Parameter`,
       `anschluss`.`Durchleitungsvertrag_unterzeichnet_Am`      AS `Durchleitungsvertrag_unterzeichnet_Am`,
       `anschluss`.`Durchleitungsvertrag_endet_Am`              AS `Durchleitungsvertrag_endet_Am`,
       `anschluss`.`Bezahlte_Durchleitungs_Gebühr`              AS `Bezahlte_Durchleitungs_Gebühr`,
       `anschluss`.`Bemerkungen`                                AS `Bemerkungen`,
       
       eigentümer.ID                                  AS Eigentümer_ID,
	   kontakt.ID                                     AS Kontakt_ID,
       rechAdr.ID                                     AS Rechnung_ID,
       heiziger.ID                                    AS Heiziger_ID,
       elektriker.ID                                  AS Elektriker_ID
       
	FROM Wärmeanschlüsse AS anschluss
    LEFT OUTER JOIN Adress_Daten   AS standort   ON standort.ID   = anschluss.Standort_Adresse_ID
    LEFT OUTER JOIN Personen_Daten AS eigentümer ON eigentümer.ID = anschluss.Eigentümer_ID
    LEFT OUTER JOIN Personen_Daten AS kontakt    ON kontakt.ID    = anschluss.Kontakt_ID
    LEFT OUTER JOIN Personen_Daten AS rechAdr    ON rechAdr.ID    = anschluss.Rechnungs_Adresse_ID
    LEFT OUTER JOIN Personen_Daten AS heiziger   ON heiziger.ID   = anschluss.Heizungs_Installateur_ID
    LEFT OUTER JOIN Personen_Daten AS elektriker ON elektriker.ID = anschluss.Elektro_Installateur_ID;
 */
 
-- --------------------------------------------------------------------------------    
DROP VIEW IF EXISTS PD_Row_Counts; 
CREATE VIEW PD_Row_Counts AS
	SELECT
		'Land'                          AS `Table Name`,
		(SELECT count(*) FROM `Land`)   AS `Row Count`
	UNION
	SELECT
		'Orte'                          AS `Table Name`,
		(SELECT count(*) FROM `Orte`)   AS `Row Count`
	UNION
	SELECT
		'Adressen'                          AS `Table Name`,
		(SELECT count(*) FROM `Adressen`)   AS `Row Count`
	UNION
	SELECT
		'Personen'                          AS `Table Name`,
		(SELECT count(*) FROM `Personen`)   AS `Row Count`
	UNION
	SELECT
		'IBAN'                          AS `Table Name`,
		(SELECT count(*) FROM `IBAN`)   AS `Row Count`
	UNION
	SELECT
		'email_adressen'                          AS `Table Name`,
		(SELECT count(*) FROM `email_adressen`)   AS `Row Count`
	UNION
	SELECT
		'Personen_has_email_adressen'                          AS `Table Name`,
		(SELECT count(*) FROM `Personen_has_email_adressen`)   AS `Row Count`
	UNION
	SELECT
		'Telefonnummern'                          AS `Table Name`,
		(SELECT count(*) FROM `telefonnummern`)   AS `Row Count`
	UNION
	SELECT
		'Personen_has_telefonnummern'                          AS `Table Name`,
		(SELECT count(*) FROM `Personen_has_telefonnummern`)   AS `Row Count`
	UNION
	SELECT
		'++-----------------------------+'                        AS `Table Name`,
		'++--------------+'                                       AS `Row Count`
	UNION
    SELECT
		'Nutzungsberechtigte Bürger'                          AS `Table Name`,
		(SELECT count(*) FROM `bürger_Nutzungsberechtigt`)    AS `Row Count`
	UNION
        SELECT
		'Bürger mit eMail'                                    AS `Table Name`,
		(SELECT count(*) FROM `bürger_eMailing`)              AS `Row Count`
	UNION
        SELECT
		'Bürger ohne eMail'                                   AS `Table Name`,
		(SELECT count(*) FROM `bürger_mailing`)               AS `Row Count`
	UNION
        SELECT
		'Nutzungsberechtigte Bürger'                          AS `Table Name`,
		(SELECT count(*) FROM `bürger_Nutzungsberechtigt`)    AS `Row Count`
	UNION
	SELECT
		'+++----------------------------+'                        AS `Table Name`,
		'+++-------------+'                                       AS `Row Count`
	UNION
        SELECT
		'Neubürger Vorvorjahr'                                AS `Table Name`,
		(SELECT count(*) FROM `Neubürger_Vorvorjahr`)         AS `Row Count`
	UNION
        SELECT
		'Neubürger Vorjahr'                                   AS `Table Name`,
		(SELECT count(*) FROM `Neubürger_Vorjahr`)            AS `Row Count`
	UNION
        SELECT
		'Neubürger Dieses Jahr'                               AS `Table Name`,
		(SELECT count(*) FROM `Neubürger_dieses_Jahr`)        AS `Row Count`
	UNION
	SELECT
		'++++---------------------------+'                        AS `Table Name`,
		'++++------------+'                                       AS `Row Count`
	UNION
	SELECT
		'Landteile Total'                                      AS `Table Name`,
		(SELECT count(*) FROM `Landteile`)                     AS `Row Count`
	UNION
	SELECT
		'Landteile Genossame'                                  AS `Table Name`,
		(SELECT count(*) FROM `Landteile` WHERE Verpaechter_ID = 625)                     AS `Row Count`
	UNION
	SELECT
		'Landteile'                                            AS `Table Name`,
		(SELECT count(*) FROM `Landteile` WHERE Verpaechter_ID != 625)                     AS `Row Count`
	UNION
	SELECT
		'+++++--------------------------+'                        AS `Table Name`,
		'+++++-----------+'                                       AS `Row Count`
	UNION
	SELECT
		'Verpächter mit 16a Teilen'                            AS `Table Name`,
		(SELECT count(*) FROM Verpächter WHERE FIND_IN_SET('Hat_16a',        Kategorien) >  0)         AS `Row Count`
	UNION
	SELECT
		'Verpächter mit 35a Teilen'                            AS `Table Name`,
		(SELECT count(*) FROM Verpächter WHERE FIND_IN_SET('Hat_35a',        Kategorien) >  0)         AS `Row Count`
	UNION
	SELECT
		'Verpächter mit 16a und 35a Teilen'                            AS `Table Name`,
		(SELECT count(*) FROM Verpächter WHERE FIND_IN_SET('Hat_16a',        Kategorien) >  0 AND  
                                               FIND_IN_SET('Hat_35a',        Kategorien) >  0)        AS `Row Count`
	UNION
	SELECT
		'+-----------------------------++'                        AS `Table Name`,
		'+--------------++'                                       AS `Row Count`
	UNION
	SELECT
		'Pächter'                                              AS `Table Name`,
		(SELECT count(*) FROM Pächter )                        AS `Row Count`
	UNION
	SELECT
		'+----------------------------+++'                        AS `Table Name`,
		'+-------------+++'                                       AS `Row Count`
	UNION
	SELECT
		'Bezogene Chroniken'                            AS `Table Name`,
		(SELECT count(*) FROM Personen WHERE Chronik_Bezogen_Am IS NOT NULL)  AS `Row Count`
	UNION
	SELECT
		'Abos Newsletter'                            AS `Table Name`,
		(SELECT count(*) FROM Personen WHERE Newsletter_Abonniert_Am IS NOT NULL)  AS `Row Count`
	UNION
	SELECT
		'+---------------------------++++'                        AS `Table Name`,
		'+------------++++'                                       AS `Row Count`
	UNION
	SELECT
		'Wärmeverbund Vollanschlüsse'                        AS `Table Name`,
		(SELECT count(*) FROM Wärmeanschlüsse_View)  AS `Row Count`
	;


/*	SELECT 
		(select COUNT(*) FROM land) rc_land,
		(select COUNT(*) FROM orte) rc_orte,
		(select COUNT(*) FROM adressen) rc_adressen,
		(select COUNT(*) FROM personen) rc_personen,
		(select COUNT(*) FROM iban) rc_iban,
		(select COUNT(*) FROM email_adressen) rc_email_adressen,
		(select COUNT(*) FROM personen_has_email_adressen) rc_personen_has_email_adressen,
		(select COUNT(*) FROM telefonnummern) rc_telefonnummern,
		(select COUNT(*) FROM personen_has_telefonnummern) rc_personen_has_telefonnummern;
*/

DROP VIEW IF EXISTS ENUM_SET_Values; 
CREATE VIEW ENUM_SET_Values AS
	SELECT
		CONCAT(`TABLE_NAME`,'__',
			   `COLUMN_NAME`)         AS `Full_Attr_Name`,
		REPLACE(
			REPLACE(
				REPLACE(
				  REPLACE(`COLUMN_TYPE`,')',''),
				'enum(',''),
			'set(',''),
		'\'','')        AS `Attr_Type_Values_Str`,
        
		`TABLE_SCHEMA`   AS `Schema`,
		`TABLE_NAME`     AS `Table`,
		`COLUMN_NAME`    AS `Attribute`,

		`DATA_TYPE`      AS `Attr_Type`,
		`COLUMN_TYPE`    AS `Attr_Type_Values`

	FROM
		`INFORMATION_SCHEMA`.`COLUMNS`
	WHERE
		`TABLE_SCHEMA` = 'genossame_wangen' AND
		(`DATA_TYPE` = 'set' OR `DATA_TYPE` = 'enum') AND
		TABLE_NAME IN (SELECT TABLE_NAME 
					   FROM `INFORMATION_SCHEMA`.`TABLES`
					   WHERE
						   `TABLE_SCHEMA` = 'genossame_wangen' AND
						   `TABLE_TYPE`   = 'BASE TABLE') -- 'Personen'
	ORDER BY `TABLE_SCHEMA` , `TABLE_NAME` , `COLUMN_NAME`;
    
-- --------------------------------------------------------------------------------    
-- ===============================================================================================
-- == Create stored procedures for business (external) write access                             ==
-- ===============================================================================================
-- to do:
--    1) Procedure prioritaeten bei email, iban und tel_nr unique und aufsteigen setzen innerhalb einer Person
-- ------------------------------------------------------
-- EMail Adressen
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getEmailAdrId;
DELIMITER $$
CREATE PROCEDURE getEmailAdrId(IN  email_addr VARCHAR(45),
                               IN  email_type ENUM('Privat', 'Geschaeft', 'Sonstige'), 
                               IN  Prio       TINYINT, 
                               OUT email_id   SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM email_adressen WHERE eMail=email_addr) = 0) THEN
        INSERT INTO email_adressen (`eMail`,`Type`,`Prio`) VALUES (email_addr, email_type, Prio);
        COMMIT;
    END IF;
    SELECT id FROM email_adressen WHERE eMail=email_addr AND Type=email_type INTO email_id;
END$$
DELIMITER ;

-- SELECT * FROM EMail_Adressen WHERE ID in (SELECT EMail_Adressen_ID FROM personen_has_email_adressen WHERE Personen_ID = 644);

-- Tests
-- set @id = 0;
-- call getEmailAdrId('yyyy.yyyy@rothlin.com', 'Sonstige', 0,  @id);
-- select @id;

-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS addEmailAdr;
DELIMITER $$
CREATE PROCEDURE addEmailAdr(IN  pers_id    SMALLINT(5), 
                             IN  email_addr VARCHAR(45), 
                             IN  email_type ENUM('Privat', 'Geschaeft', 'Sonstige'), 
							 IN  Prio       TINYINT, 
                             OUT email_id   SMALLINT(5))
BEGIN
    CALL getEmailAdrId(email_addr, email_type, Prio, @email_id);
    -- SELECT 'ID', @email_id;
    IF ((SELECT count(*) 
         FROM Personen_has_email_adressen 
		 WHERE Personen_has_email_adressen.Personen_ID       = pers_id AND 
			   Personen_has_email_adressen.EMail_Adressen_ID = @email_id) = 0) THEN
					INSERT INTO Personen_has_email_adressen (`Personen_ID`,`EMail_Adressen_ID`) VALUES (pers_id, @email_id);
					COMMIT;
	END IF;
END$$
DELIMITER ;

-- SELECT count(*) FROM Personen_has_email_adressen WHERE Personen_has_email_adressen.Personen_ID=644 AND 
-- 													   Personen_has_email_adressen.EMail_Adressen_ID=319;
-- Tests
-- set @id = 0;
-- call addEmailAdr('644', 'yyyy.yyyy@rothlin.com', 'Sonstige', 0, @id);
-- select @id;

-- ------------------------------------------------------
-- Telefonnummer
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getTelefonnummerId;
DELIMITER $$
CREATE PROCEDURE getTelefonnummerId(IN  Laendercode VARCHAR(4), 
                                    IN  Vorwahl     VARCHAR(3), 
								    IN  Nummer      VARCHAR(11), 
                                    IN  TEL_Type    ENUM('Privat', 'Geschaeft', 'Sonstige'), 
                                    IN  Endgeraet   ENUM('Festnetz', 'Mobile', 'FAX'), 
                                    IN  Prio        TINYINT, 
                                    OUT tel_id      SMALLINT(5))
BEGIN
    IF ((SELECT count(*) 
         FROM Telefonnummern 
         WHERE Telefonnummern.Laendercode = Laendercode AND 
               Telefonnummern.Vorwahl     = Vorwahl AND 
               Telefonnummern.Nummer=Nummer) = 0) THEN
					INSERT INTO Telefonnummern (`Laendercode`,`Vorwahl`,`Nummer`,`Type`,`Endgeraet`,`Prio`) VALUES (Laendercode, Vorwahl, Nummer, TEL_Type, Endgeraet, Prio);
					COMMIT;
    END IF;
    SELECT id FROM Telefonnummern WHERE Telefonnummern.Laendercode=Laendercode AND Telefonnummern.Vorwahl=Vorwahl AND Telefonnummern.Nummer=Nummer INTO tel_id;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call getTelefonnummerId('0041', '', '0554601440', 'Privat','Festnetz',0, @id);
-- select @id;

-- set @id = 0;
-- call getTelefonnummerId('0041', '', '0793689492', 'Privat','Mobile',1, @id);
-- select @id;

-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS addTelNr;
DELIMITER $$
CREATE PROCEDURE addTelNr(IN  pers_id     SMALLINT(5), 
                          IN  Laendercode VARCHAR(4),
                          IN  Vorwahl     VARCHAR(3), 
                          IN  Telnummer   VARCHAR(11), 
                          IN  TEL_Type    ENUM('Privat', 'Geschaeft', 'Sonstige'), 
                          IN  Endgeraet   ENUM('Festnetz', 'Mobile', 'FAX'),
                          IN  Prio        TINYINT, 
                          OUT tel_id      SMALLINT(5))
BEGIN
    CALL getTelefonnummerId(Laendercode, Vorwahl, Telnummer, TEL_Type, Endgeraet, Prio, @tel_id);
    IF ((SELECT count(*) 
         FROM Personen_has_telefonnummern 
         WHERE Personen_has_telefonnummern.Personen_ID       = pers_id AND 
               Personen_has_telefonnummern.Telefonnummern_ID = @tel_id) = 0) THEN
					INSERT INTO Personen_has_telefonnummern (`Personen_ID`,`Telefonnummern_ID`) VALUES (pers_id, @tel_id);
					COMMIT;
	END IF;
END$$
DELIMITER ;

-- SELECT count(*) FROM Personen_has_telefonnummern WHERE     Personen_has_telefonnummern.Personen_ID=644;  
--                                                        AND Personen_has_telefonnummern.Telefonnummer_ID=319;
-- Tests
-- set @id = 0;
-- call addTelNr('644', '0041', '079', '3689422', 'Sonstige', 'Mobile', 0, @id);
-- select @id;


-- ------------------------------------------------------
-- IBAN
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getIBANId;
DELIMITER $$
CREATE PROCEDURE getIBANId(IN   pers_id        SMALLINT,
                           IN   iban_nummer    VARCHAR(26), 
						   OUT  iban_id        SMALLINT)
BEGIN
    IF ((SELECT count(*) 
         FROM IBAN 
         WHERE IBAN.Personen_ID = pers_id AND
               IBAN.Nummer = iban_nummer  AND
               IBAN.Prio = 0) = 0) THEN
					INSERT INTO IBAN (`ID`, `Nummer`, `prio`) VALUES (pers_id, iban_nummer, 0);
					COMMIT;
    END IF;
    SELECT ID 
    FROM IBAN 
    WHERE IBAN.Personen_ID = pers_id AND
		  IBAN.Nummer = iban_nummer AND
          IBAN.Prio = 0 INTO iban_id;
END$$
DELIMITER ;

/*
set @id = 0;
call getIBANId(990, 'CH46 0077 7002 5458 0007 8', @id);   -- Andre Schättin 990  -- IBAN=474
select @id;
*/

-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS addIBAN;
DELIMITER $$
CREATE PROCEDURE addIBAN(IN   pers_id          SMALLINT, 
                         IN   iban_nummer      VARCHAR(26),
						 OUT  iban_id          SMALLINT)
BEGIN
    IF ((SELECT count(*) 
         FROM IBAN 
         WHERE IBAN.Personen_ID = pers_id AND
               IBAN.Nummer = iban_nummer  AND
               IBAN.Prio = 0) = 0) THEN
					INSERT INTO IBAN (`Personen_ID`, `Nummer`, `prio`) VALUES (pers_id, iban_nummer, 0);
					COMMIT;
    END IF;
    SELECT ID 
    FROM IBAN 
    WHERE IBAN.Personen_ID = pers_id AND
		  IBAN.Nummer = iban_nummer AND
          IBAN.Prio = 0 INTO iban_id;
END$$
DELIMITER ;

/*
    SELECT *
    FROM IBAN 
    WHERE IBAN.Personen_ID = 990 AND
		  IBAN.Nummer      = 'CH46 0077 7002 5458 0007 8';
         
-- Tests
set @id = 0;
call addIBAN(527, 'CH15 0077 7000 0324 3489 7', @id);
select @id;
*/ 

-- ------------------------------------------------------
-- Land
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getLandId;
DELIMITER $$
CREATE PROCEDURE getLandId(IN landname VARCHAR(45), IN land_code VARCHAR(5), IN landesvorwahl VARCHAR(4), OUT id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM land WHERE land.name = landname) = 0) THEN
        INSERT INTO land (`name`, `code`, `landesvorwahl`) VALUES (landname, land_code, landesvorwahl);
        COMMIT;
    END IF;
    SELECT land.id FROM land WHERE land.name = landname or land.code = land_code or land.landesvorwahl = landesvorwahl INTO id;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call getLandId('Schweiz', 'CH', '0041', @id);
-- select @id;


-- ------------------------------------------------------
-- Ort
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getOrtId;
DELIMITER $$
CREATE PROCEDURE getOrtId(IN plz SMALLINT(4), IN ortsname VARCHAR(45), IN kanton VARCHAR(10), IN tel_vorwahl VARCHAR(3), OUT id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM orte WHERE orte.plz = plz AND orte.name = ortsname) = 0) THEN
        INSERT INTO orte (`plz`, `name`, `kanton`, `tel_vorwahl`) VALUES (plz, ortsname, kanton, tel_vorwahl);
        COMMIT;
    END IF;
    SELECT orte.id FROM orte WHERE orte.plz = plz and orte.name = ortsname INTO id;
END$$
DELIMITER ;

-- Tests
-- bestehendes Ort
-- set @id = 0;
-- call getOrtId(8855, 'Wangen', NULL, NULL, @id);
-- select @id;

-- call getOrtId(8854, 'Siebnen', NULL, NULL, @id);
-- select @id;

-- call getOrtId(8854, 'Galgenen', NULL, NULL, @id);
-- select @id;

-- call getOrtId(8853, 'Lachen', NULL, NULL, @id);
-- select @id;


-- try to reenter duplicate plz, Ort
-- call getOrtId(8854, 'Galgenen', NULL, NULL, @id);
-- select @id;
-- call getOrtId(8853, 'Lachen', NULL, NULL, @id);
-- select @id;

-- deleteOrtIfUnused
DROP PROCEDURE IF EXISTS deleteOrtIfUnused;
DELIMITER $$
CREATE PROCEDURE deleteOrtIfUnused(IN id SMALLINT(5))
BEGIN
    IF ((SELECT COUNT(orte_id) FROM adressen WHERE id=id) = 0) THEN
        DELETE FROM orte WHERE id=id;
        COMMIT;
    END IF;
END$$
DELIMITER ;

-- Tests
-- set @id = 1;
-- call deleteOrtIfUnused(@id);


-- ------------------------------------------------------
-- Adresse
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getAdressId;
DELIMITER $$
CREATE PROCEDURE getAdressId(IN strasse VARCHAR(45), 
							 IN hausnummer VARCHAR(15), 
                             IN plz SMALLINT(4), 
                             IN ortsname VARCHAR(45), 
                             OUT adress_id SMALLINT(5))
BEGIN
    CALL getOrtId(plz, ortsname, NULL, NULL, @ort_id);
    IF ((SELECT count(*) FROM adressen WHERE adressen.strasse    = strasse AND 
											 adressen.hausnummer = hausnummer AND 
                                             adressen.Orte_id    = @ort_id) = 0) THEN
        INSERT adressen (`strasse`, `hausnummer`, `orte_id`) VALUES (strasse, hausnummer, @ort_id);
        COMMIT;
    END IF;
    SELECT id FROM adressen WHERE adressen.strasse = strasse and 
                                  adressen.hausnummer = hausnummer and 
                                  adressen.orte_id = @ort_id INTO adress_id;
END$$
DELIMITER ;

-- Tests von AdressenId
-- bestehende Adresse
-- set @id = 0;
-- call getAdressId('Peterliwiese', '33', '8855', 'Wangen', @id);
-- select @id;

-- createAdresse
DROP PROCEDURE IF EXISTS createAdresse;
DELIMITER $$
CREATE PROCEDURE createAdresse(IN strasse VARCHAR(45), 
                               IN hausnummer VARCHAR(15), 
                               IN plz SMALLINT(4), 
                               IN ortsname VARCHAR(45), 
                               OUT generatedId SMALLINT(5))
BEGIN
    CALL getOrtId(plz, ortsname, @ort_id);
    INSERT INTO adressen (strasse, hausnummer, orte_id) VALUES (strasse, hausnummer, @ort_id);
    COMMIT;
    SELECT LAST_INSERT_ID() INTO generatedId;
END$$
DELIMITER ;

-- set @id = 0;
-- call createAdresse('Im Gräbler', '12', 8310, 'Grafstal', @id);
-- select @id;

-- updateAdresse
DROP PROCEDURE IF EXISTS updateAdresse;
DELIMITER $$
CREATE PROCEDURE updateAdresse(IN id SMALLINT(5), IN strasse VARCHAR(45), IN hausnummer VARCHAR(15), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45))
BEGIN
    CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    UPDATE adressen SET strasse=strasse, hausnummer=hausnummer, orte_id=@ort_id WHERE id=id;
    COMMIT;
END$$
DELIMITER ;

-- Tests
-- set @id = 6;
-- call updateAdresse(@id, 'Schulhausstrasse', '1a', 8400, 'Winterthur');
-- select @id;

-- deleteAdresse
DROP PROCEDURE IF EXISTS deleteAdresse;
DELIMITER $$
CREATE PROCEDURE deleteAdresse(IN id SMALLINT(5))
BEGIN
    DELETE FROM adressen WHERE id=id;
END$$
DELIMITER ;

-- Tests
-- set @id = 6;
-- call deleteAdresse(@id);
-- select @id;

DROP PROCEDURE IF EXISTS deleteAdresseCascade;
-- Diese storeded procedure löscht auch Orte die nicht mehr von Adressen Referenziert werden
-- Kann auch über einen Konstraint ON DELETE CASCADE
DELIMITER $$
CREATE PROCEDURE deleteAdresseCascade(IN id SMALLINT(5))
BEGIN
    SET @ortID = (SELECT orte_fk FROM adressen WHERE id = id);
    DELETE FROM adressen WHERE id=id;
    COMMIT;
    CALL deleteOrtIfUnused(@ortID);
END$$
DELIMITER ;


-- ------------------------------------------------------
-- Personen
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS getPersonenId;
DELIMITER $$
CREATE PROCEDURE getPersonenId(IN source ENUM('Initial_1', 'Loader_1', 'BuergerDB', 'ImmoTop'),
							   IN sex VARCHAR(45),
                               IN firma VARCHAR(45),
							   IN vorname VARCHAR(45),
                               IN ledig_name VARCHAR(45),
                               IN partner_name VARCHAR(45),
                               IN partner_name_angenommen BOOLEAN,
							   IN strasse VARCHAR(45), 
							   IN hausnummer VARCHAR(15), 
							   IN plz SMALLINT(4), 
							   IN ortsname VARCHAR(45), 
                               OUT personen_id SMALLINT(5))
BEGIN
    CALL getAdressId(strasse, hausnummer, plz, ortsname, @adressen_id);
    IF ((SELECT count(*) 
         FROM personen 
         WHERE personen.sex = sex AND
               personen.firma = firma AND 
               personen.vorname = vorname AND 
               personen.ledig_name = ledig_name AND 
               personen.partner_name = partner_name AND 
               personen.partner_name_angenommen = partner_name_angenommen AND 
               personen.privat_adressen_id = @adressen_id) = 0) THEN
        INSERT personen (`source`, `sex`, `firma`, `vorname`, `ledig_name`, `partner_name`,`partner_name_angenommen`, `privat_adressen_id`) VALUES (source, sex, firma, vorname, ledig_name, partner_name, partner_name_angenommen, @adressen_id);
        COMMIT;
    END IF;
    SELECT id FROM personen WHERE personen.sex = sex AND
                                  personen.firma = firma AND 
								  personen.vorname = vorname AND 
                                  personen.ledig_name = ledig_name AND
                                  personen.partner_name = partner_name AND
                                  personen.partner_name_angenommen = partner_name_angenommen AND 
                                  personen.privat_adressen_id = @adressen_id INTO personen_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS getPersonenId_New;
DELIMITER $$
CREATE PROCEDURE getPersonenId_New(IN source ENUM('Initial_1', 'Loader_1', 'BuergerDB', 'ImmoTop'),
							       IN personen_id_old SMALLINT(5),
                                   IN sex VARCHAR(45),
                                   IN firma VARCHAR(45),
							       IN vorname VARCHAR(45),
                                   IN ledig_name VARCHAR(45),
                                   IN partner_name VARCHAR(45),
                                   IN partner_name_angenommen BOOLEAN,
							       IN strasse VARCHAR(45), 
							       IN hausnummer VARCHAR(15), 
							       IN plz SMALLINT(4), 
							       IN ortsname VARCHAR(45), 
                                   OUT personen_id SMALLINT(5))
BEGIN
    CALL getAdressId(strasse, hausnummer, plz, ortsname, @adressen_id);
    IF ((SELECT count(*) 
         FROM personen 
         WHERE personen.id = personen_id_old) = 0) THEN
        INSERT personen (`source`, `ID`, `sex`, `firma`, `vorname`, `ledig_name`, `partner_name`,`partner_name_angenommen`, `privat_adressen_id`) VALUES (source, personen_id_old, sex, firma, vorname, ledig_name, partner_name, partner_name_angenommen, @adressen_id);
        COMMIT;
    END IF;
    SELECT id FROM personen WHERE personen.sex = sex AND
                                  personen.firma = firma AND 
								  personen.vorname = vorname AND 
                                  personen.ledig_name = ledig_name AND
                                  personen.partner_name = partner_name AND
                                  personen.partner_name_angenommen = partner_name_angenommen AND 
                                  personen.privat_adressen_id = @adressen_id INTO personen_id;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call getPersonenId_New('BuergerDB', 9999, 'Herr', 'M_Firma', 'M_Vorname','M_LedigName', 'M_PartnerName', 1, 'M_Strasse', '33_M', '8855', 'M_Wangen', @id);
-- select @id;
-- call getPersonenId('Walter','Rothlin',NULL,NULL,'Peterliwiese', '33', '8855', 'Wangen', @id);
-- select @id;

DROP PROCEDURE IF EXISTS createPerson;
DELIMITER $$
CREATE PROCEDURE createPerson(IN vorname VARCHAR(45),
							  IN ledig_name VARCHAR(45),
                              IN partner_name VARCHAR(45),
                              IN firma VARCHAR(45),
							  IN strasse VARCHAR(45), 
							  IN hausnummer VARCHAR(15), 
							  IN plz SMALLINT(4), 
							  IN ortsname VARCHAR(45),
							  OUT generatedId SMALLINT(5))
BEGIN
    CALL getAdressId(strasse, hausnummer, plz, ortsname, @adressen_id);
    INSERT personen (`vorname`, `ledig_name`, `partner_name`, `firma`,  `privat_adressen_id`) VALUES (vorname, ledig_name, partner_name, firma, @adressen_id);
    COMMIT;
    SELECT LAST_INSERT_ID() INTO generatedId;
END$$
DELIMITER ;

-- Tests
-- set @id = 0;
-- call createPerson('Walter','Rothlin','BZU','Im Gräbler', '12', 8310, 'Grafstal', @id);
-- select @id;



-- ------------------------------------------------------
-- Zwingende Data updates
-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS important_updates;
DELIMITER $$
CREATE PROCEDURE important_updates()
BEGIN
	-- Adressen Felder richtig setzen, so dass views und Fct funktionieren
	UPDATE `Personen` SET `Partner_Name`           = ''  WHERE Partner_Name   IS NULL;
	UPDATE `Personen` SET `History`                = ''  WHERE `History`      IS NULL;
	UPDATE `Personen` SET `Bemerkungen`            = ''  WHERE `Bemerkungen`  IS NULL;
	UPDATE `Personen` SET `Firma`                  = ''  WHERE `Firma`        IS NULL;
	UPDATE `Personen` SET `Vorname_2`              = ''  WHERE `Vorname_2`    IS NULL;
	UPDATE `Personen` SET `AHV_Nr`                 = ''  WHERE `AHV_Nr`       IS NULL;
	UPDATE `Personen` SET `Betriebs_Nr`            = ''  WHERE `Betriebs_Nr`  IS NULL;
	UPDATE `IBAN`     SET `Bezeichnung`            = ''  WHERE Bezeichnung    IS NULL;
	UPDATE `Adressen` SET `Hausnummer`             = ''  WHERE Hausnummer     IS NULL;
	UPDATE `Adressen` SET `Postfachnummer`         = ''  WHERe Postfachnummer IS NULL;
	UPDATE `Adressen` SET `Adresszusatz`           = ''  WHERE Adresszusatz   IS NULL;
	UPDATE `Adressen` SET `Wohnung`                = ''  WHERE Wohnung        IS NULL;
	UPDATE `Adressen` SET `Kataster_Nr`            = ''  WHERE Kataster_Nr    IS NULL;
	UPDATE `Adressen` SET `x_CH1903`               = 0   WHERE x_CH1903       IS NULL;
	UPDATE `Adressen` SET `y_CH1903`               = 0   WHERE y_CH1903       IS NULL;
	UPDATE `Adressen` SET Postfachnummer  = REPLACE(Postfachnummer, '.0', '');

	UPDATE Telefonnummern SET Laendercode = ''                          WHERE Laendercode IS NULL;
	UPDATE Telefonnummern SET Laendercode = '41'                        WHERE Laendercode = '41.0';
	UPDATE Telefonnummern SET Laendercode = CONCAT('000',Laendercode)   WHERE LENGTH(Laendercode) = 1;
	UPDATE Telefonnummern SET Laendercode = CONCAT('00',Laendercode)    WHERE LENGTH(Laendercode) = 2;
	UPDATE Telefonnummern SET Laendercode = CONCAT('0',Laendercode)     WHERE LENGTH(Laendercode) = 3;
	UPDATE Telefonnummern SET Vorwahl = ''                              WHERE Vorwahl IS NULL;
	UPDATE Telefonnummern SET Vorwahl = REPLACE(Vorwahl, '.0', '');
	UPDATE Telefonnummern SET Nummer  = REPLACE(Nummer, '.0', '');
	UPDATE Telefonnummern SET Vorwahl = CONCAT('0',LEFT(Nummer,2))      WHERE length(Nummer) = 9 AND Vorwahl = '';
	UPDATE Telefonnummern SET Vorwahl = CONCAT('00',Vorwahl)            WHERE LENGTH(Vorwahl) = 1;
	UPDATE Telefonnummern SET Vorwahl = CONCAT('0',Vorwahl)             WHERE LENGTH(Vorwahl) = 2;
	UPDATE Telefonnummern SET Nummer  = RIGHT(Nummer,7)                 WHERE length(Nummer) = 9;

	UPDATE email_adressen SET eMail = lower(eMail);

	UPDATE Land SET Landesvorwahl = CONCAT('000',Landesvorwahl)         WHERE LENGTH(Landesvorwahl) = 1;
	UPDATE Land SET Landesvorwahl = CONCAT('00',Landesvorwahl)          WHERE LENGTH(Landesvorwahl) = 2;
	UPDATE Land SET Landesvorwahl = CONCAT('0',Landesvorwahl)           WHERE LENGTH(Landesvorwahl) = 3;
    
	/* -- NUR bei inital load ab Stammdaten
	UPDATE Adressen SET Orte_ID=(SELECT ID FROM Orte WHERE `Name` = 'Nuolen') 
		   WHERE ID IN (SELECT Privat_Adressen_ID FROM Personen 
						WHERE ID IN (147,947,307,536,661,144,138,145,307,343,474,693));


	UPDATE `Adressen` SET Politisch_Wangen       = 1   WHERE Orte_ID IN (SELECT ID FROM Orte WHERE `Name`= 'Wangen' AND Kanton = 'SZ');
	UPDATE `Adressen` SET Politisch_Wangen       = 1   WHERE Orte_ID IN (SELECT ID FROM Orte WHERE `Name`= 'Nuolen' AND Kanton = 'SZ');
	-- UPDATE `Adressen` SET Politisch_Wangen       = 1   WHERE Orte_ID IN (SELECT ID FROM Orte WHERE `Name`= 'Siebnen' AND Kanton = 'SZ');
	*/


	-- Gestorbene Personen_Daten
	-- -------------------------
	UPDATE `Personen` SET Zivilstand = 'Gestorben' WHERE Todestag IS NOT NULL;
	UPDATE `Personen` SET Kategorien = addSetValue(Kategorien, 'Bürger')  WHERE  Todestag IS NOT NULL;
	DELETE FROM iban WHERE ID IN (SELECT ID FROM Personen WHERE Zivilstand = 'Gestorben');
    
	/* 
    DELETE 
    FROM email_adressen 
    WHERE ID IN (SELECT EMail_Adressen_ID 
                 FROM personen_has_email_adressen 
                 WHERE Personen_ID IN (SELECT ID 
                                       FROM Personen 
                                       WHERE Zivilstand = 'Gestorben'));
                                  
	DELETE 
    FROM personen_has_email_adressen 
    WHERE Personen_ID IN (SELECT ID 
                          FROM Personen 
                          WHERE Zivilstand = 'Gestorben');
    
    
	DELETE
    FROM telefonnummern 
    WHERE ID IN (SELECT Telefonnummern_ID 
                 FROM personen_has_telefonnummern 
                 WHERE Personen_ID IN (SELECT ID 
                                       FROM Personen 
                                       WHERE Zivilstand = 'Gestorben'));
	DELETE 
    FROM personen_has_telefonnummern 
    WHERE Personen_ID IN (SELECT ID 
                          FROM Personen 
                          WHERE Zivilstand = 'Gestorben'); 
    */
    
	-- Bürger / Nutzungberechtigt (wer Bürger ist und in der politschen Gemeinde Wangen lebt ist Nutzungsberechtigt)
	-- --------------------------
	/*
    DROP TABLE IF EXISTS Temp_Table;
	CREATE TABLE IF NOT EXISTS Temp_Table (
	  `ID`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
	  `last_update`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	  PRIMARY KEY (`ID`));

	INSERT Temp_Table (`ID`)
		SELECT ID FROM `Personen` WHERE FIND_IN_SET('Bürger', Kategorien) >  0 AND Privat_Adressen_ID IN (SELECT ID FROM `Adressen` WHERE Politisch_Wangen = 1);
		
	UPDATE `Personen` SET Kategorien = removeSetValue(Kategorien, 'Nutzungsberechtigt');

	UPDATE `Personen` SET Kategorien = addSetValue(Kategorien, 'Nutzungsberechtigt')  
	   WHERE Todestag IS NULL AND 
			 ID IN (SELECT ID FROM `Temp_Table`);

	DROP TABLE IF EXISTS Temp_Table;
    */
    
    -- Landteile
    -- ---------
    /*
    UPDATE Landteile SET Buergerlandteil = 'Geno' WHERE Verpaechter_ID  = 625; 
    UPDATE Landteile SET Buergerlandteil = '16a'  WHERE Flaeche_In_Aren = 16;
    UPDATE Landteile SET Buergerlandteil = '35a'  WHERE Flaeche_In_Aren = 35; 

	UPDATE Personen SET Kategorien = addSetValue(Kategorien, 'Hat_16a')  
	WHERE ID in (SELECT DISTINCT Verpaechter_ID FROM landteile WHERE Buergerlandteil = '16a' AND Verpaechter_ID IS NOT NULL);

	UPDATE Personen SET Kategorien = addSetValue(Kategorien, 'Hat_35a')  
	WHERE ID in (SELECT DISTINCT Verpaechter_ID FROM landteile WHERE Buergerlandteil = '35a' AND Verpaechter_ID IS NOT NULL);
    */
	-- SELECT DISTINCT Verpaechter_ID FROM landteile WHERE Buergerlandteil = 'Geno' AND Verpaechter_ID IS NOT NULL;

END$$
DELIMITER ;

call important_updates();




-- ------------------------------------------------------
-- Hilfreiche Abfragen
-- ------------------------------------------------------
/*
 UPDATE EMail_Adressen SET Type='Fehlermeldung' 
		   WHERE ID IN (4,65,11,164,95,130,287,40,44,145,139,277,44,112,183,226,258,174,288,444);
 UPDATE EMail_Adressen SET Prio=100 
		   WHERE ID IN (4,65,11,164,95,130,287,40,44,145,139,277,44,112,183,226,258,174,288,444);

UPDATE EMail_Adressen SET eMail=CONCAT('FEHLER:',eMail)
		   WHERE ID IN (4,65,11,164,95,130,287,40,44,145,139,277,44,112,183,226,258,174,288,444);
*/
           
-- SELECT * FROM email_liste WHERE Pers_ID in (671,491,804,88,489);

-- SELECT ID,Vorname_Initial, Familien_Name, Private_Strassen_Adresse, Kategorien FROM personen_daten Where Such_Begriff LIKE Binary '%Züger%' ORDER BY Vorname_Initial;

 -- SELECT ID,Vorname_Initial, Familien_Name, Private_Strassen_Adresse, Kategorien FROM personen_daten Where ID in (11,23,42) ORDER BY Familien_Name, Vorname_Initial;
 
-- SELECT * FROM Personen_Daten WHERE ID IN (223, 644, 1103);   -- Rothlin-Meier, Rothlin-Collet, Tobias Rothlin
-- SELECT * FROM Personen  WHERE ID IN (223, 644, 1103);  

 /*
 SELECT Vorname_Initial,
       getFamilieName(P.Sex, 
                      P.Partner_Name_Angenommen, 
                      P.Ledig_Name, 
                      P.Partner_Name) AS Familien_Name,
       P.Sex, 
       P.Partner_Name_Angenommen, 
	   P.Ledig_Name, 
       P.Partner_Name
FROM personen AS P 
WHERE ID in (11,23,42,889) 
ORDER BY Familien_Name;
*/


/*
SELECT
    ID                                                 AS ID,
    Anrede_Long_Long                                   AS Anrede,
    Private_Strassen_Adresse                           AS Strasse,
    CONCAT(Private_PLZ_International,' ',Private_Ort)  AS PLZ_Ort,
    
    DATE_FORMAT(Geburtstag, '%d.%m.%Y') AS Geburtstag,

    Zivilstand    AS Zivilstand,
    Kategorien    AS Kategorien,
    Such_Begriff  AS Such_Begriff
FROM Personen_Daten 
WHERE 
        ID is NOT NULL
        -- AND ID in (11,23,42,488,487,889)
        -- AND (FIND_IN_SET('Landwirt', `Kategorien`) > 0 OR FIND_IN_SET('Bürger', `Kategorien`) > 0)
        AND (Such_Begriff LIKE BINARY '%Kä' AND Such_Begriff LIKE BINARY '%holz%')
ORDER BY Familien_Name, Vorname;
*/


        SELECT
            ID AS ID,
             Anrede_Long_Long                                   AS Anrede,
             Private_Strassen_Adresse                           AS Strasse,
             CONCAT(Private_PLZ_International,' ',Private_Ort)  AS PLZ_Ort
        FROM Personen_Daten 
        WHERE Such_Begriff LIKE BINARY '%Vogt%' AND 
              Such_Begriff LIKE BINARY '%Na%' AND 
              Such_Begriff LIKE BINARY '%%'
        ORDER BY Familien_Name, Vorname;
    

/*
SELECT * FROM personen_has_email_adressen WHERE Personen_ID = 305;
SELECT * FROM eMail_Adressen WHERE eMail = 'fam-schnellmann@bluewin.ch';

SELECT * FROM personen_has_telefonnummern WHERE Personen_ID = 590;
SELECT * FROM telefonnummern WHERE nummer = 7928579;
*/




-- ----------------------------------------------------------------------------------
-- TBD TBD TBD TBD TBD TBD TBD TBD TBD TBD TBD TBD
-- ----------------------------------------------------------------------------------
/* TBD 2023-07_10
DROP FUNCTION IF EXISTS getPrio_0_TelNr;
DELIMITER //
CREATE FUNCTION getPrio_0_TelNr(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT Tel_Nr FROM Telnr_Liste WHERE Pers_ID = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;

-- -----------------------------------------
DROP FUNCTION IF EXISTS getPrio_1_TelNr;
DELIMITER //
CREATE FUNCTION getPrio_1_TelNr(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT Tel_Nr FROM Telnr_Liste WHERE Pers_ID = p_id AND prio=1 LIMIT 1);
END//
DELIMITER ;

-- -----------------------------------------
DROP FUNCTION IF EXISTS getPrio_2_TelNr;
DELIMITER //
CREATE FUNCTION getPrio_2_TelNr(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT Tel_Nr FROM Telnr_Liste WHERE Pers_ID = p_id AND prio=2 LIMIT 1);
END//
DELIMITER ;

-- SELECT Laendercode FROM Telnr_Liste WHERE Pers_ID = 1103 AND prio=0 LIMIT 1;
-- SELECT Vorwahl     FROM Telnr_Liste WHERE Pers_ID = 1103 AND prio=0 LIMIT 1;
-- SELECT Nummer      FROM Telnr_Liste WHERE Pers_ID = 1103 AND prio=0 LIMIT 1;
-- Test-Cases
-- SELECT getPrio_0_TelNr(1103);  -- --> 0793315587
*/


/* TBD 2023-07-10 
DROP VIEW IF EXISTS Telnr_Liste_Sorted; 
CREATE VIEW Telnr_Liste_Sorted AS
	SELECT
        *
	FROM Telnr_Liste AS T
    ORDER BY Familien_Name;

-- -----------------------------------------
DROP VIEW IF EXISTS Telnr_Liste_Alle_TelNr; 
CREATE VIEW Telnr_Liste_Alle_TelNr AS
	   SELECT
		Pers_ID,
        Kategorien,
        Sex,
		Vorname_Initial,
		Familien_Name,          -- Rothlin-Collet
        GROUP_CONCAT(Tel_Nr_Detailed SEPARATOR ' ; ') AS Tel_Nr_Detailed_Alle,
        
        -- Personen Details
	    Geburtstag,
		`Alter`,
        
        -- Personen Grunddaten
		Name_Angenommen,
		Ledig_Name, 
		Partner_Name,
		Privat_Adressen_ID,
        Geschaefts_Adressen_ID
   
	   FROM Telnr_Liste_Sorted AS T
       GROUP BY Pers_ID
	   ORDER BY Familien_Name;

-- -----------------------------------------
DROP VIEW IF EXISTS Telnr_Liste_Prio_0; 
CREATE VIEW Telnr_Liste_Prio_0 AS
	SELECT
		* 
	FROM Telnr_Liste_Sorted 
    WHERE Prio=0;

-- -----------------------------------------
DROP VIEW IF EXISTS Telnr_Liste_Prio_1; 
CREATE VIEW Telnr_Liste_Prio_1 AS
	SELECT
		* 
	FROM Telnr_Liste_Sorted 
    WHERE Prio=1;
    
-- -----------------------------------------
DROP VIEW IF EXISTS Telnr_Liste_Prio_2; 
CREATE VIEW Telnr_Liste_Prio_2 AS
	SELECT
		* 
	FROM Telnr_Liste_Sorted 
    WHERE Prio=2;
*/    
-- -----------------------------------------

/*
-- -----------------------------------------
DROP FUNCTION IF EXISTS getAll_emailAddrs;
DELIMITER //
CREATE FUNCTION getAll_emailAddrs(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT eMail_Detailed_Alle FROM email_liste_alle_email WHERE Pers_ID = p_id);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getAll_emailAddrs(919);  -- --> xxxxxx
*/

/*
-- -----------------------------------------
DROP VIEW IF EXISTS EMail_Liste_Sorted; 
CREATE VIEW EMail_Liste_Sorted AS
	SELECT         
		*
	FROM EMail_Liste AS E
    ORDER BY Familien_Name;

-- -----------------------------------------
*/
/*
DROP VIEW IF EXISTS EMail_Liste_Alle_EMail; 
CREATE VIEW EMail_Liste_Alle_EMail AS
	   SELECT
		Pers_ID,
        Kategorien,
        Sex,
		Vorname_Initial,
		Familien_Name,          -- Rothlin-Collet
        GROUP_CONCAT(Email_Detailed SEPARATOR ' ; ') AS eMail_Detailed_Alle,
        
        -- Personen Details
	    Geburtstag,
		`Alter`,
        
        -- Personen Grunddaten
		Name_Angenommen,
		Ledig_Name, 
		Partner_Name,
		Privat_Adressen_ID,
        Geschaefts_Adressen_ID
   
	   FROM EMail_Liste_Sorted AS T
	   GROUP BY Pers_ID
	   ORDER BY Familien_Name;
*/

/*
-- -----------------------------------------
DROP VIEW IF EXISTS EMail_Liste_Prio_0; 
CREATE VIEW EMail_Liste_Prio_0 AS
	SELECT
        *
	FROM EMail_Liste_Sorted 
    WHERE Prio = 0;
 
 -- -----------------------------------------
DROP VIEW IF EXISTS EMail_Liste_Prio_1; 
CREATE VIEW EMail_Liste_Prio_1 AS
	SELECT
        *
	FROM EMail_Liste_Sorted 
    WHERE Prio = 1;
    

-- -----------------------------------------
DROP VIEW IF EXISTS EMail_Liste_Prio_2; 
CREATE VIEW EMail_Liste_Prio_2 AS
	SELECT
        *
	FROM EMail_Liste_Sorted 
    WHERE Prio = 2;

*/

/*
-- -----------------------------------------
DROP VIEW IF EXISTS EMailing_Liste_Spezial; 
CREATE VIEW EMailing_Liste_Spezial AS
	SELECT 
		Pers_ID AS ID,
		`Alter`,
        Kategorien,
        Sex, 
        Vorname_Initial AS Vorname, 
        Familien_Name AS Nachname,
        Privat_Adressen_ID,
        Geschaefts_Adressen_ID,
        eMail_Adresse AS eMail 
	FROM EMail_Liste 
    WHERE sex IN ('Herr', 'Frau') AND
                 (FIND_IN_SET('Bürger', `Kategorien`) > 0)
    ORDER BY Sex,`Alter`;
*/

/*

DROP FUNCTION IF EXISTS getPrio_0_IBAN;
DELIMITER //
CREATE FUNCTION getPrio_0_IBAN(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT IBAN_Nummer FROM iban_liste_prio_0 WHERE Pers_id = p_id AND prio=0 LIMIT 1);
END//
DELIMITER ;
*/

/*
-- -----------------------------------------
DROP FUNCTION IF EXISTS getAll_IBANs;
DELIMITER //
CREATE FUNCTION getAll_IBANs(p_id INT) RETURNS CHAR(100)
BEGIN
    RETURN (SELECT IBAN_Detailed_Alle FROM IBAN_liste_alle_IBAN WHERE Pers_ID = p_id);
END//
DELIMITER ;

-- Test-Cases
-- SELECT getAll_IBANs(919);  -- --> xxxxxx
*/

-- -----------------------------------------------------
/*
DROP VIEW IF EXISTS IBAN_Liste_Sorted;
CREATE VIEW IBAN_Liste_Sorted AS
	SELECT         
        *
	FROM IBAN_Liste AS ib
    ORDER BY Familien_Name;
*/
-- -----------------------------------------------------
/*
DROP VIEW IF EXISTS IBAN_Liste_Alle_IBAN; 
CREATE VIEW IBAN_Liste_Alle_IBAN AS
	   SELECT
		Pers_ID,
        Kategorien,
        Sex,
		Vorname_Initial,
		Familien_Name,          -- Rothlin-Collet
        GROUP_CONCAT(IBAN_Detailed SEPARATOR ' ; ') AS IBAN_Detailed_Alle,
        
        -- Personen Details
	    Geburtstag,
		`Alter`,
        
        -- Personen Grunddaten
		Name_Angenommen,
		Ledig_Name, 
		Partner_Name,
		Privat_Adressen_ID,
        Geschaefts_Adressen_ID
   
	   FROM IBAN_Liste_Sorted AS T
	   GROUP BY Pers_ID
	   ORDER BY Familien_Name;
*/
       
-- --------------------------------------------------------------------------------
/*
DROP VIEW IF EXISTS IBAN_Liste_Prio_0; 
CREATE VIEW IBAN_Liste_Prio_0 AS
	SELECT * FROM  IBAN_Liste_Sorted WHERE Prio = 0;

-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS IBAN_Liste_Prio_1; 
CREATE VIEW IBAN_Liste_Prio_1 AS
	SELECT * FROM  IBAN_Liste_Sorted WHERE Prio = 1;
    
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS IBAN_Liste_Prio_2; 
CREATE VIEW IBAN_Liste_Prio_2 AS
	SELECT * FROM  IBAN_Liste_Sorted WHERE Prio = 2;

*/