-- ---------------------------------------------------------------------------------------------
-- Create_MyBank.sql
--
-- Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Create_MyBank.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Kreiert MyBank Schema und managed Adressen von Kunden und Mitarbeitern und Kontis
--
-- History:
-- 16-Jun-2021   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------

-- Neues Schema kreieren
-- ---------------------
DROP SCHEMA IF EXISTS `MyBank`;
CREATE SCHEMA IF NOT EXISTS `MyBank` DEFAULT CHARACTER SET utf8;

-- Als default Schema setzen
SELECT SLEEP(1);  -- wait 1 sec, just to give a chance to set schema as default
USE `MyBank`;


-- Create tables
-- -------------
DROP TABLE IF EXISTS abteilungen;
CREATE TABLE IF NOT EXISTS abteilungen (
  id             INT           UNSIGNED NOT NULL AUTO_INCREMENT,
  bezeichnung    VARCHAR(45)   NOT NULL UNIQUE,
  chef_fk        INT           UNSIGNED NULL,   -- alter later to NOT NULL
  belognsto_fk   INT           UNSIGNED NULL,   -- alter later to NOT NULL
  PRIMARY KEY (id),
  INDEX idx_chef_fk      (chef_fk ASC),
  INDEX idx_belognsto_fk (belognsto_fk ASC)
);

DROP TABLE IF EXISTS laender;
CREATE TABLE IF NOT EXISTS laender (
  id          INT         UNSIGNED NOT NULL AUTO_INCREMENT,
  bezeichnung VARCHAR(45) NOT NULL UNIQUE,
  land        VARCHAR(3)  NOT NULL UNIQUE,
  vorwahl     INT         NOT NULL UNIQUE,
  PRIMARY KEY (id)
);
  
  
DROP TABLE IF EXISTS orte;
CREATE TABLE IF NOT EXISTS orte (
  id 		  INT           UNSIGNED NOT NULL AUTO_INCREMENT,
  plz    	  INT(4)        NOT NULL,
  bezeichnung VARCHAR(45)   NOT NULL UNIQUE,
  land_fk     INT           UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  INDEX idx_land_fk (land_fk ASC)
);


DROP TABLE IF EXISTS adressen;
CREATE TABLE IF NOT EXISTS adressen (
   id    	        INT 			UNSIGNED NOT NULL AUTO_INCREMENT,
   nachname         VARCHAR(45)    NOT NULL,
   vorname          VARCHAR(45)    NOT NULL,
   strasse          VARCHAR(45)    NOT NULL,
   hausnummer       VARCHAR(10)    NULL,
   mobileNr         INT            NULL,
   ort_fk           INT            UNSIGNED NOT NULL,
   abteilung_fk     INT            UNSIGNED NULL,
   PRIMARY KEY (id),
   INDEX idx_ort_fk (ort_fk ASC),
   INDEX idx_abteilung_fk (abteilung_fk ASC) 
); 


-- FK constraint to reflect the relation
ALTER TABLE orte 
ADD CONSTRAINT fk_orte_laender
  FOREIGN KEY (land_fk) REFERENCES laender (id) ON DELETE RESTRICT ON UPDATE CASCADE;    -- ON DELETE NO ACTION ON UPDATE NO ACTION


ALTER TABLE adressen 
ADD CONSTRAINT fk_adressen_orte
  FOREIGN KEY (ort_fk) REFERENCES orte (id) ON DELETE RESTRICT ON UPDATE CASCADE;    -- ON DELETE NO ACTION ON UPDATE NO ACTION
  
ALTER TABLE adressen 
ADD CONSTRAINT fk_adressen_abteilungen
  FOREIGN KEY (abteilung_fk) REFERENCES abteilungen (id) ON DELETE RESTRICT ON UPDATE CASCADE;    -- ON DELETE NO ACTION ON UPDATE NO ACTION


-- Test-Daten einfüllen
INSERT INTO abteilungen (id, bezeichnung, chef_fk, belognsto_fk)
	   VALUES
            (1, 'F+E'           ,  null, null),
            (2, 'Tools'         ,  null, 1),
            (3, 'Methodik'      ,  null, 1),
            (4, 'Handels-System',  null, 1);

INSERT INTO laender (id, bezeichnung, land, vorwahl) 
       VALUES 
            (1, 'Schweiz', 'CH', 41),
            (2, 'Italien', 'I' , 39);

INSERT INTO orte (id, plz, bezeichnung, land_fk) 
       VALUES 
            (1, 8855, 'Wangen' , 1),
            (2, 8855, 'Nuolen' , 1),
            (3, 8854, 'Siebnen', 1),
            (4, 6000, 'Rom'    , 2);

INSERT INTO adressen (id, vorname, nachname, strasse, hausnummer, mobileNr, ort_fk, abteilung_fk)
	   VALUES
            (1, 'Walter'    ,   'Rothlin',  'Peterliwiese', '33' ,  793689422, 1, 1),
            (2, 'Gianfranco',   'Rapino' ,  'via Firenze' , '27b',  797029590, 4, 2);

UPDATE abteilungen SET chef_fk=1  WHERE id=2;

-- -----------------------------------------------------------------------------------------------
-- Create functions
-- -----------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS formatPLZ;
Delimiter //
CREATE FUNCTION formatPLZ(p_input_plz SMALLINT, p_laenderCode VARCHAR(10)) RETURNS CHAR(50)
BEGIN
   RETURN  concat(p_laenderCode, '-', p_input_plz);
END
//
DELIMITER ;

SELECT
     A.id                                                       AS PID,
	 A.vorname                                                  AS Vorname,
	 A.nachname                                                 AS Nachname,
	 A.strasse                                                  AS Strasse,
	 A.hausnummer                                               AS Hausnummer,
     A.mobileNr                                                 AS Mobile,
     A.ort_fk                                                   AS FK_Ort,
	 O.plz                                                      AS PLZ,
     formatPLZ(O.plz, L.land)                                   AS PLZ_Formated,
	 O.bezeichnung                                              AS Ort,
     O.land_fk                                                  AS FK_Land,
     L.bezeichnung                                              As Land,
     A.abteilung_fk                                             AS FK_Abteilung,
     D.bezeichnung                                              AS Abteilung,
     D.chef_fk                                                  AS FK_Chef,
     concat(A1.vorname, ' ',A1.nachname)                        AS Chef,
     D.belognsto_fk                                             AS FK_BelongsTo,
     D1.bezeichnung                                             AS Ober_Abteilung
FROM adressen AS A
INNER JOIN orte        AS O  ON A.ort_fk        = O.id
INNER JOIN laender     AS L  ON O.land_fk       = L.id
LEFT  JOIN abteilungen AS D  ON A.abteilung_fk  = D.id
LEFT  JOIN adressen    AS A1 ON D.chef_fk       = A1.id
LEFT  JOIN abteilungen AS D1 ON D.belognsto_fk  = D1.id;


-- -----------------------------------------------------------------------------------------------
-- Create view for business (external) read access
-- -----------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS adress_liste;
CREATE VIEW adress_liste AS
	SELECT
		 A.id                                                       AS PID,
		 A.vorname                                                  AS Vorname,
		 A.nachname                                                 AS Nachname,
		 A.strasse                                                  AS Strasse,
		 A.hausnummer                                               AS Hausnummer,
		 A.mobileNr                                                 AS Mobile,
		 A.ort_fk                                                   AS FK_Ort,
		 O.plz                                                      AS PLZ,
		 formatPLZ(O.plz, L.land)                                   AS PLZ_Formated,
		 O.bezeichnung                                              AS Ort,
		 O.land_fk                                                  AS FK_Land,
		 L.bezeichnung                                              As Land,
		 A.abteilung_fk                                             AS FK_Abteilung,
		 D.bezeichnung                                              AS Abteilung,
		 D.chef_fk                                                  AS FK_Chef,
		 concat(A1.vorname, ' ',A1.nachname)                        AS Chef,
		 D.belognsto_fk                                             AS FK_BelongsTo,
		 D1.bezeichnung                                             AS Ober_Abteilung
	FROM adressen AS A
	INNER JOIN orte        AS O  ON A.ort_fk        = O.id
	INNER JOIN laender     AS L  ON O.land_fk       = L.id
	LEFT  JOIN abteilungen AS D  ON A.abteilung_fk  = D.id
	LEFT  JOIN adressen    AS A1 ON D.chef_fk       = A1.id
	LEFT  JOIN abteilungen AS D1 ON D.belognsto_fk  = D1.id;

SELECT * FROM adress_liste;

-- TO DOs
-- 1) fct für Telefonnummer zu formatieren
-- 2) Tabelle Konto (id, IBAN, Kontotype, 
-- 3) Stored Procedures überarbeiten

-- -----------------------------------------------------------------------------------------------
-- Create stored procedures for business (external) write access
-- -----------------------------------------------------------------------------------------------

-- getOrtId
DROP PROCEDURE IF EXISTS getOrtId;
DELIMITER $$
CREATE PROCEDURE getOrtId(IN plz SMALLINT(4), IN bezeichnung VARCHAR(45), OUT id SMALLINT(5))
BEGIN
    IF ((SELECT count(*) FROM orte WHERE orte.plz = plz AND orte.name = bezeichnung) = 0) THEN
        INSERT INTO orte (`plz`, `name`) VALUES (plz, bezeichnung);
    END IF;
    SELECT orte.ort_id FROM orte WHERE orte.plz = plz and orte.name = bezeichnung INTO id;
END$$
DELIMITER ;

-- Tests von getOrtId
-- bestehendes Ort
set @id = 0;
call getOrtId(8855, 'Wangen', @id);
select @id;
call getOrtId(8855, 'Nuolen', @id);
select @id;

-- neues Ort
set @id = 0;
call getOrtId(8310, 'Grafstal', @id);
select @id;


-- createAdresse
DROP PROCEDURE IF EXISTS createAdresse;
DELIMITER $$
CREATE PROCEDURE createAdresse(IN nachname VARCHAR(45), IN vorname VARCHAR(45), IN strasse VARCHAR(45), IN hausnummer VARCHAR(10), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45), OUT generatedId SMALLINT(5))
BEGIN
    CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    INSERT INTO adressen (nachname, vorname, strasse, hausnummer, orte_fk) VALUES (nachname, vorname, strasse, hausnummer, @ort_id);
    SELECT LAST_INSERT_ID() INTO generatedId;
END$$
DELIMITER ;

-- Tests von createAdresse
set @id = 0;
call createAdresse('Ruijter', 'Doron', 'Im Gräbler', '12', 8310, 'Grafstal', @id);
select @id;

-- updateAdresse
DROP PROCEDURE IF EXISTS updateAdresse;
DELIMITER $$
CREATE PROCEDURE updateAdresse(IN id SMALLINT(5), IN nachname VARCHAR(45), IN vorname VARCHAR(45), IN strasse VARCHAR(45), IN hausnummer VARCHAR(10), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45))
BEGIN
    CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    UPDATE adressen SET nachname=nachname, vorname=vorname, strasse=strasse, hausnummer=hausnummer, orte_fk=@ort_id WHERE adress_id=id;
END$$
DELIMITER ;

-- Tests von updateAdresse
set @id = 6;
call updateAdresse(@id, 'Ruijter', 'Doron', 'Schulhausstrasse', '1a', 8400, 'Winterthur');
select @id;

-- deleteAdresse
DROP PROCEDURE IF EXISTS deleteAdresse;
DELIMITER $$
CREATE PROCEDURE deleteAdresse(IN id SMALLINT(5))
BEGIN
    DELETE FROM adressen WHERE adress_id=id;
END$$
DELIMITER ;

-- Tests von deleteAdresse
set @id = 6;
call deleteAdresse(@id);
select @id;

-- deleteOrtIfUnused
DROP PROCEDURE IF EXISTS deleteOrtIfUnused;
DELIMITER $$
CREATE PROCEDURE deleteOrtIfUnused(IN id SMALLINT(5))
BEGIN
    IF ((SELECT COUNT(orte_fk) FROM adressen WHERE orte_fk=id) = 0) THEN
        DELETE FROM orte WHERE ort_id=id;
    END IF;
END$$
DELIMITER ;

-- Tests von deleteOrtIfUnused
set @id = 1;
call deleteOrtIfUnused(@id);

DROP PROCEDURE IF EXISTS deleteAdresseCascade;
-- Diese storeded procedure löscht auch Orte die nicht mehr von Adressen Referenziert werden
-- Kann auch über einen Konstraint ON DELETE CASCADE
DELIMITER $$
CREATE PROCEDURE deleteAdresseCascade(IN id SMALLINT(5))
BEGIN
    SET @ortID = (SELECT orte_fk FROM adressen WHERE adress_id = id);
    DELETE FROM adressen WHERE adress_id=id;
    CALL deleteOrtIfUnused(@ortID);
END$$
DELIMITER ;
