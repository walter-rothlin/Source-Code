-- Owner: Walter Rothlin
-- History:
-- 07-Feb-2025 Walter Rothlin	Initial Version
-- 14-Feb-2025 Walter Rothlin	String-Functions
-- 07-Mar-2025 Walter Rothlin   Date / Time Functions
-- ---------------------------------------------------------------------------

-- ==============================
-- Beispiele mit String-Functions
-- ==============================
-- siehe https://dev.mysql.com/doc/refman/5.7/en/string-functions.html
SELECT count(*) FROM staff;
SELECT count(staff_id) FROM staff;
SELECT count(3) AS `Anzahl Tuples` FROM `staff`;

SELECT
	`first_name` AS `Vorname`,
    CONCAT(UPPER(LEFT(`first_name`, 1)), '.')        AS `Initial`,
	`last_name`  AS `Nachname`,
    CONCAT(UPPER(LEFT(`first_name`, 1)), '.',`last_name`) AS `Initial_Nachname`
FROM `staff`
WHERE CONCAT(UPPER(LEFT(`first_name`, 1)), '.') = 'J.';










-- ==============================
-- Beispiele mit Date/Time
-- ==============================
SELECT * FROM `language`;

INSERT INTO `language` (`name`) VALUES ('Schweizerdeutsch');
UPDATE `language` SET `name` = 'Deutsch' WHERE (`language_id` = '6');
UPDATE `language` SET `last_update` = STR_TO_DATE('07.03.2023 08:54:00', '%d.%m.%Y %H:%i:%s') WHERE (`language_id` = '1');

SELECT
	`language_id`    AS `ID`,
    `name`           AS `Name der Sprache`,
    `last_update`    AS `Letzte Aenderung`,
    Date_Format(`last_update`, '%a, %d.%m.%Y %H:%i')  AS `Last Change CH`,
    Date_Format(now(), '%a, %d.%m.%Y %H:%i')  AS `Heute`
FROM `language`;
