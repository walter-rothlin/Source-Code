
-- ---------------------------------------------------------------------------------------------
-- Genossame-TestData.sql
-- ---------------------------------------------------------------------------------------------
--
-- Autor: Walter Rothlin
-- Description: Füllt Test-Daten ins Schema für die Genossame ein
--
-- History:
-- 03-Mar-2022   Walter Rothlin      Initial Version
-- ---------------------------------------------------------------------------------------------
INSERT INTO `sex` (`Status`) VALUES 
    ('Frau'),
    ('Mann');

INSERT INTO `land` (`Name`, `Code`) VALUES 
    ('Schweiz', 'CH'), 
    ('Deutschland', 'D');



INSERT INTO `ort` (`Plz`, `Name`, `Land_id`) VALUES 
    ('8855', 'Wangen', 1),
    ('8855', 'Nuolen', 1),
    ('8854', 'Siebnen', 1);
    

INSERT INTO `adresse` (`Strasse`, `Hausnummer`, `Ort_id`) VALUES
    ('Etzelstrasse', '7', 1),
    ('Etzelstrasse', '9', 1),
    ('Peterliwiese', '33', 1);
    

INSERT INTO `person` (`Name`, `Vorname`, `Postanschrift_FK`, `Sex_FK`) VALUES 
    ('Rothlin', 'Walter', 1, 2),
    ('Salzmann', 'Kurt', 2, 2),
    ('Rothlin', 'Walter', 3, 2);


INSERT INTO `adresstype` (`Name`, `Beschreibung`) VALUES 
    ('Privat', 'Privat'),
    ('Geschäft', 'Geschäft');

INSERT INTO `email` (`Adresse`, `Person_id`, `Type_FK`) VALUES 
    ('Walter@rothlin.com', '3', '1'),
    ('walter.rothlin@bzu.ch', '3', '2');

SELECT
    p.id         AS Id,
    s.Status     AS Sex,
    p.Name       AS Name,
    p.Vorname    AS Vorname,
    a.Strasse    AS Strasse,
    a.Hausnummer AS Hausnummer,
    o.Name       AS Ort,
    o.Plz        AS PLZ,
    l.Name       AS Land,
    l.code       AS Code,
    e.Adresse    AS eMail_PRIVAT,
    at.Name      AS eMailType,
    OrtBezeichnung(l.code, o.Plz, o.Name)  AS OrtsBezeichnung,
    Anrede(s.Status, p.Name)               AS Anrede
FROM
     Person  AS p
INNER JOIN       sex        AS s     ON p.Sex_FK           = s.id
INNER JOIN       adresse    AS a     ON p.Postanschrift_FK = a.id
INNER JOIN       ort        AS o     ON a.Ort_id           = o.id
INNER JOIN       land       AS l     ON o.Land_id          = l.id
LEFT OUTER JOIN  email      AS e     ON e.Person_id        = p.id
LEFT OUTER JOIN  adresstype AS at    ON at.id              = e.Type_FK;

SELECT
    e.Adresse    AS eMail,
    at.Name      As Type
FROM
	email      AS e
LEFT OUTER JOIN adresstype at     ON at.id = e.Type_FK;

SELECT 
    J.eMail
FROM (SELECT
    e.Adresse    AS eMail,
    at.Name      As Type
FROM
	email      AS e
LEFT OUTER JOIN adresstype at     ON at.id = e.Type_FK) AS J;

SELECT Distinct
    Name
FROM
	adresstype;