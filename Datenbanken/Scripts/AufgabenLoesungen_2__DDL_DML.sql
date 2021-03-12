-- Create new shema and use it
-- ===========================
SET @newSchema = 'hwz_test_1';
SELECT @newSchema;
-- funktioniert nicht!!! DROP SCHEMA IF EXISTS @newSchema;

DROP SCHEMA IF EXISTS hwz_test_1;
CREATE SCHEMA IF NOT EXISTS hwz_test_1 DEFAULT CHARACTER SET utf8;
USE hwz_test_1;

-- Create Table orte
-- =================
DROP TABLE IF EXISTS orte;
CREATE TABLE IF NOT EXISTS orte (
  ort_id      SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  plz         SMALLINT(4) NOT NULL,
  bezeichnung VARCHAR(45) CHARACTER SET 'big5' NOT NULL,
  PRIMARY KEY (ort_id));
  

-- Create Table adressen
-- =====================
DROP TABLE IF EXISTS adressen;
CREATE TABLE IF NOT EXISTS adressen (
  adress_id    SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  name         VARCHAR(45) NOT NULL,
  vorname      VARCHAR(45) NOT NULL,
  strasse      VARCHAR(45) NOT NULL,
  orte_ort_id  SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (adress_id),
  INDEX fk_adressen_orte_idx (orte_ort_id ASC),
  CONSTRAINT fk_adressen_orte
    FOREIGN KEY (orte_ort_id)
    REFERENCES orte (ort_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- Insert data into orte
-- =====================
INSERT INTO orte (ort_id, plz, bezeichnung) VALUES ('1', '8855', 'Wangen');
INSERT INTO orte (ort_id, plz, bezeichnung) VALUES ('2', '8855', 'Nuolen');
INSERT INTO orte (ort_id, plz, bezeichnung) VALUES ('3', '8854', 'Siebnen');
INSERT INTO orte (        plz, bezeichnung) VALUES (     '8800', 'Thalwil');
INSERT INTO orte (ort_id, plz, bezeichnung) VALUES ('5', '8810', 'Horgen');

DELETE FROM orte;    -- Wieso geht das aus der Workbench heraus nicht? Versuchen Sie es aus dem MySQL Command Line client heraus!
TRUNCATE TABLE orte; -- Wieso geht das nicht?

-- Insert data into adressen and "link" them with orte
-- ===================================================
INSERT INTO adressen (adress_id, name, vorname, strasse, orte_ort_id)
    VALUES 
       ('1', 'Rothlin' , 'Walter' , 'Peterliwiese 33', '1'),
       ('2', 'Friedlos', 'Josef'  , 'Ochsenboden 1a' , '2'),
       ('3', 'Meier'   , 'Muster' , 'Musterweg 6'    , '3'),
       ('4', 'Collet'  , 'Claudia', 'Peterliwiese 33', '1');


DELETE FROM orte WHERE ort_id = '5';   -- Geht weil es keine Adressen gibt mit Ort Horgen
DELETE FROM orte WHERE ort_id = '1';   -- Geht nicht, weil es noch Adressen gibt mit Ort Wangen
DELETE FROM adressen;    -- Wieso geht das aus der Workbench heraus nicht? Versuchen Sie es aus dem MySQL Command Line client heraus!
DELETE FROM adressen WHERE orte_ort_id = '1';

-- Create adressliste view
-- =======================
DROP VIEW IF EXISTS adressliste;
CREATE VIEW adressliste AS 
    SELECT 
        adressen.adress_id AS ID,
        adressen.name      AS Familienname,
        adressen.vorname   AS Vorname,
        adressen.strasse   AS Strasse,
        orte.plz           AS Postleitzahl,
        orte.bezeichnung   AS Ortschaft
    FROM adressen
        JOIN orte ON adressen.orte_ort_id = orte.ort_id
    ORDER BY adressen.name, adressen.vorname;

SELECT * FROM Adressliste;

-- Create function formatPLZ()
-- ===========================
DROP FUNCTION IF EXISTS formatPLZ;
Delimiter //
CREATE FUNCTION formatPLZ(p_input_plz SMALLINT) RETURNS CHAR(50)
BEGIN
   RETURN  concat('CH-', p_input_plz);
END
//

SELECT formatPLZ(plz) AS PLZ FROM orte;


-- Update von Daten
-- ================
-- Aendern Sie die Strasse von Claudia Collet auf Etzelstrasse 7
UPDATE Adressen SET Strasse='Etzelstrasse 7' WHERE adress_id='4';

SELECT * FROM Adressen WHERE Name = 'Collet' AND vorname = 'Claudia';
SELECT * FROM Adressen WHERE adress_id IN (SELECT adress_id FROM adressen WHERE Name = 'Collet' AND vorname = 'Claudia');
UPDATE Adressen SET Strasse='Etzelstrasse 7' WHERE Name = 'Collet' AND vorname = 'Claudia';


-- Claudia ist von Wangen weggezogen und wohnt nun in Nuolen am Ochsenbodenweg 8a
UPDATE Adressen 
   SET 
       Strasse     = 'Ochsenbodenweg 8a', 
       orte_ort_id = '2' WHERE adress_id='4';

UPDATE Adressen 
   SET 
       Strasse     = 'Ochsenbodenweg 8a',
       orte_ort_id = '2' 
WHERE Name = 'Collet' AND vorname = 'Claudia';

UPDATE Adressen 
   SET 
       Strasse     = 'Ochsenbodenweg 8a',
       orte_ort_id = (SELECT ort_id FROM orte WHERE plz=8855 AND bezeichnung='Wangen') 
WHERE Name = 'Collet' AND vorname = 'Claudia';

-- Löschen von Daten
-- =================
Delete FROM Orte     WHERE ort_id      IN ('1');   -- Change the order and it will work! Why?
Delete FROM Adressen WHERE orte_ort_id IN ('1');