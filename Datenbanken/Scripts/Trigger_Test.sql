-- Erstelle die Audit-Tabelle, wenn sie noch nicht existiert
CREATE TABLE IF NOT EXISTS salary_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date TIMESTAMP
);

-- Erstelle den Trigger, um Änderungen am Gehalt zu verfolgen
DELIMITER //
CREATE TRIGGER salary_change_trigger
BEFORE UPDATE ON employee FOR EACH ROW
BEGIN
    IF NEW.salary <> OLD.salary THEN
        INSERT INTO salary_audit (employee_id, old_salary, new_salary, change_date)
        VALUES (OLD.id, OLD.salary, NEW.salary, NOW());
    END IF;
END;
//
DELIMITER ;