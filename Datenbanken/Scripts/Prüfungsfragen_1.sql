select * from actor;

select * from payment where amount = 0  order by rental_id;

select * from payment where rental_id = 0;

select count(*) from film_category;

select count(*) from city order by city;
select * from city order by city;
select count(distinct city) from city order by city;
select city.city as Stadt, country.country as Land from city, country;
select city, country from city, country where city_id = country.country_id;
select city.city, country.country from city inner join country on city_id = country.country_id;
select city.city, country.country from city left join country on city_id = country.country_id;

select city.city, country.country from country left join city on city_id = country.country_id;

UPDATE film SET original_language_id=1 WHERE film_id=1;
UPDATE film SET original_language_id=6 WHERE film_id=2;

select film.title, language.name 
from film
left join language on language.language_id = film.original_language_id; 

select film.title, language.name 
from language
right join film on language.language_id = film.original_language_id;   


select film.title, actor.first_name,actor.last_name from film_actor
left join actor on actor.actor_id = film_actor.actor_id
left join film on film.film_id = film_actor.film_id
where actor.last_name like 'zell%'
order by actor.last_name;

select count(*) from rental where rental.return_date is null;

select customer.first_name, customer.lafilm_listst_name, film.title, rental.rental_date 
from rental
left join inventory on rental.inventory_id = inventory.inventory_id
left join customer on rental.customer_id = customer.customer_id
left join film on inventory.film_id = film.film_id
where rental.return_date is null 
order by customer.first_name, customer.last_name, rental_date;

UPDATE category SET name='Dramen' WHERE category_id=7;