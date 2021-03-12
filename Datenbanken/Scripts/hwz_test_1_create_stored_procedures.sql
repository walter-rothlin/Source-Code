-- getOrtId
DROP PROCEDURE IF EXISTS getOrtId;
DELIMITER $$
CREATE PROCEDURE getOrtId(IN plz SMALLINT(4), IN bezeichnung VARCHAR(45), out id SMALLINT(5))
BEGIN
	IF((select count(*) from orte where orte.plz = plz and orte.bezeichnung = bezeichnung) = 0) THEN
		INSERT INTO orte (`plz`, `bezeichnung`) VALUES (plz, bezeichnung);
    END IF;
    select orte.ort_id from orte where orte.plz = plz and orte.bezeichnung = bezeichnung into id;
END$$
DELIMITER ;

-- createAdresse
DROP PROCEDURE IF EXISTS createAdresse;
DELIMITER $$
CREATE PROCEDURE createAdresse(IN name VARCHAR(45), IN vorname VARCHAR(45), IN strasse VARCHAR(45), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45), OUT generatedId SMALLINT(5))
BEGIN
	CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    INSERT INTO adressen (name, vorname, strasse, orte_ort_id) VALUES (name, vorname, strasse, @ort_id);
	SELECT LAST_INSERT_ID() INTO generatedId;
END$$
DELIMITER ;

-- updateAdresse
DROP PROCEDURE IF EXISTS updateAdresse;
DELIMITER $$
CREATE PROCEDURE updateAdresse(IN id SMALLINT(5), IN name VARCHAR(45), IN vorname VARCHAR(45), IN strasse VARCHAR(45), IN plz SMALLINT(4), IN ortsBezeichnung VARCHAR(45))
BEGIN
	CALL getOrtId(plz, ortsBezeichnung, @ort_id);
    UPDATE adressen SET name=name, vorname=vorname, strasse=strasse, orte_ort_id=@ort_id WHERE adress_id=id;
END$$
DELIMITER ;

-- deleteAdresse
DROP PROCEDURE IF EXISTS deleteAdresse;
DELIMITER $$
CREATE PROCEDURE deleteAdresse(IN id SMALLINT(5))
BEGIN
	DELETE FROM adressen WHERE adress_id=id;
END$$
DELIMITER ;

-- deleteOrtIfUnused
DROP PROCEDURE IF EXISTS deleteOrtIfUnused;
DELIMITER $$
CREATE PROCEDURE deleteOrtIfUnused(IN id SMALLINT(5))
BEGIN
    IF (SELECT COUNT(orte_ort_id) FROM adressen WHERE orte_ort_id=id) = 0 THEN
        DELETE FROM orte WHERE ort_id=id;
    END IF;
END$$
DELIMITER ;

-- deleteAdresseCascade
DROP PROCEDURE IF EXISTS deleteAdresseCascade;
DELIMITER $$
CREATE PROCEDURE deleteAdresseCascade(IN id SMALLINT(5))
BEGIN
    SET @ortID = (SELECT orte_ort_id FROM adressen WHERE adress_id = id);
    DELETE FROM adressen WHERE adress_id=id;
    CALL deleteOrtIfUnused(@ortID);
END$$
DELIMITER ;