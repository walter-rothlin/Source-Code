-- Create_Add_StoredProcedure.sql
-- ------------------------------

DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE add_num(IN num1 INT, IN num2 INT, OUT sum INT)
BEGIN
SET sum := num1 + num2;
END //

DELIMITER ;
