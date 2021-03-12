DROP PROCEDURE IF EXISTS deleteOrtIfUnused;
DELIMITER $$
CREATE PROCEDURE deleteOrtIfUnused(IN id SMALLINT(5))
BEGIN
	IF (SELECT COUNT(orte_ort_id) FROM adressen WHERE orte_ort_id=id) = 0 THEN
		DELETE FROM orte WHERE ort_id=id;
    END IF;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteAdresseCascade;
-- Diese storeded procedure löscht auch Orte die nicht mehr von Adressen Referenziert werden
-- Kann auch über einen Konstraint ON DELETE CASCADE
DELIMITER $$
CREATE PROCEDURE deleteAdresseCascade(IN id SMALLINT(5))
BEGIN
	SET @ortID = (SELECT orte_ort_id FROM adressen WHERE adress_id = id);
	DELETE FROM adressen WHERE adress_id=id;
    CALL deleteOrtIfUnused(@ortID);
END$$
DELIMITER ;

