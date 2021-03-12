DROP VIEW IF EXISTS test_city_country;
CREATE VIEW test_city_country AS
	SELECT city.city, country.country FROM city
    INNER JOIN country ON city.country_id=country.country_id
    ORDER BY city.city ASC;
    
 select * from test_city_country;
 

DROP FUNCTION IF EXISTS HelloFct;
Delimiter //
CREATE FUNCTION HelloFct(p_input_string CHAR(20)) RETURNS CHAR(50)
Begin
  RETURN  concat('Hallo: ', p_input_string);
end//

select HelloFct('Walti');


DROP PROCEDURE IF EXISTS test_searchCountry;
Delimiter // 
CREATE PROCEDURE `test_searchCountry`(IN searchQuery VARCHAR(20), IN caseSesitive BOOLEAN)
BEGIN
    IF caseSesitive THEN
		SELECT country FROM sakila.country WHERE country LIKE BINARY searchQuery;
    ELSE
		SELECT country FROM sakila.country WHERE country LIKE searchQuery;
    END IF;
END//

call sakila.test_searchCountry('GermanY', false);

