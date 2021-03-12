SELECT * FROM sakila.actor;
select * from address;
select * from staff;
select COUNT(name) As Anzahl from category;
select name As Kategorie from category;

insert into category (name) values ('US-HERO'),('HEIMAT');

SELECT first_name, last_name FROM actor where first_name = 'Kirsten';

select table_schema, table_name, table_type from INFORMATION_SCHEMA.TABLES where table_name containing 'film';

SELECT table_schema, TABLE_NAME, column_name, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_schema = 'sakila'
  order by Table_NAME, column_name;
  
SELECT 
	first_name as Vorname, 
    last_name as Nachname,
    Date_Format(last_update,'%Y-%m-%d') as LastUpdate
FROM actor;

select film_id, title, rating, special_features from film
where rating = 'PG' and  find_in_set('Trailers', special_features);
  

update staff set picture=LOAD_FILE('C:\Users\admin\Pictures\portraet.jpg') where staff_id=2;
    
select * from staff where staff_id=2;

select * from payment;

select first_name,  last_name from staff;
select concat(left(first_name,1), '. ',last_name) as staff from staff;
select first_name, Date_Format(last_update,'%Y-%m-%d') as LastUpdate from staff;

select concat(left(first_name,1), '. ',last_name) as customer from rental;

select count(*) from rental;

select count(*) from staff;
select count(*) from category;
select count(*) from actor;
select count(*) from country;
select count(*) from city;
select count(*) from film;
select count(*) from language;
select count(*) from inventory;
select count(*) from customer;
select count(*) from store;
select count(*) from payment;
select count(*) from address;
select count(*) from film_actor;
select count(*) from film_text;




-- Joins
-- =====
select count(*) from city;          -- 600 rows
select count(*) from country;       -- 109 rows
select count(*) from city, country; -- 600 * 109 = 65400 rows

select count(*) from city inner join country on city.city_id = country.country_id;   -- 109 rows
select count(*) from country inner join city on city.city_id = country.country_id;   -- 109 rows

select count(*) from film;           -- 1000 rows
select count(*) from language;       -- 6 rows


select count(*) from film where film.original_language_id is not null;  -- 0 rows

select count(*) from film WHERE film_id=1;
select count(*) from language where language_id=1;
UPDATE film SET original_language_id=1 WHERE film_id=1;
UPDATE film SET original_language_id=6 WHERE film_id=2;

select count(*) from film where film.original_language_id is not null;  -- 2 rows

select film.title, language.name from film inner join language on language.language_id = film.original_language_id;  -- 2 rows
select count(*) from language inner join film on language.language_id = film.original_language_id;  -- 2 rows

select film.title, language.name from film left join language on language.language_id = film.original_language_id;   -- 1000 rows
select count(*) from film right join language on language.language_id = film.original_language_id;  -- 6 rows

select count(*) from language left join film on language.language_id = film.original_language_id;   -- 6 rows
select film.title, language.name from language right join film on language.language_id = film.original_language_id;  -- 1000 rows

select film.title, language.name from film, language where language.language_id = film.original_language_id;
select film.title, language.name from film left join language on language.language_id = film.original_language_id;   -- 1000 rows

UPDATE film SET original_language_id=null WHERE film_id in (1,2);



SELECT 
    *
FROM
    rental
WHERE
    return_date IS NOT NULL
        AND DATE_FORMAT(return_date, '%Y%m%d') = '20050527' 
ORDER BY inventory_id;  -- 49 rows


SELECT 
    CONCAT(LEFT(customer.first_name, 1),
            '. ',
            customer.last_name) AS renter
FROM
    rental
        INNER JOIN
    customer ON rental.customer_id = customer.customer_id
WHERE
    return_date IS NOT NULL
        AND DATE_FORMAT(return_date, '%Y%m%d') = '20050527'
ORDER BY return_date;  -- 49 rows

SELECT 
    CONCAT(LEFT(customer.first_name, 1),
            '. ',
            customer.last_name) AS renter,
    address.phone
FROM
    rental
        INNER JOIN
    customer ON rental.customer_id = customer.customer_id
        INNER JOIN
    address ON customer.address_id = address.address_id
WHERE
    return_date IS NOT NULL
        AND DATE_FORMAT(return_date, '%Y%m%d') = '20050527'
ORDER BY return_date; -- 49 rows


SELECT 
    CONCAT(LEFT(customer.first_name, 1),
            '. ',
            customer.last_name) AS renter,
    address.phone,
    film.title
FROM
    rental
        INNER JOIN
    customer ON rental.customer_id = customer.customer_id
        INNER JOIN
    address ON customer.address_id = address.address_id
        INNER JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        INNER JOIN
    film ON inventory.inventory_id = film.film_id
WHERE
    return_date IS NOT NULL
        AND DATE_FORMAT(return_date, '%Y%m%d') = '20050527'
ORDER BY return_date;



