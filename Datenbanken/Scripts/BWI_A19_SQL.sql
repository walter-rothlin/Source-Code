-- Hier ist das erste SELECT statement
-- ===================================
select
	country as Land,
    country_id,
    country
from country
where country = 'Angola';

select
	city_id,
    city,
    country_id
from city
where country_id = 4;

select * from country;

-- Join
select
	city_id,
    city,
    country
from city
inner join country on city.country_id = country.country_id;

select
	city.city_id,
    city.city,
    country.country
from city,country
where city.country_id = country.country_id;

select
	title,
    language_id,
    original_language_id
from film;

select * from language;

select
	title,
    lang.name
from film
inner join language as lang on film.language_id = lang.language_id;

select
	title,
    name
from film
left outer join language on film.original_language_id = language.language_id;

select * from film where original_language_id is not null;

select
	title         as Filmtitel,
    lang.name     as Sprache,
    org_lang.name as OrgSprache
from film
inner join language as lang on film.language_id = lang.language_id
left outer join language as org_lang on film.original_language_id = org_lang.language_id;