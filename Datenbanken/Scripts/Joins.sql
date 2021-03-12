-- Joins
-- =====
-- inner join auf language
select film.title,language.name
from film
inner join language on film.language_id = language.language_id;          -- 1000


-- inner join auf original_language
select film.title,language.name
from film
inner join language on film.original_language_id = language.language_id;  -- 0

-- welche Filme haben eine original_language gesetzt?
select film.title
from film
where film.original_language_id <> null;                            -- 0


-- Ich will eine Liste aller filmemit der original_language auch wenn ein Film kein original language gesetzt hat
-- Left Join ist natürlicher (normaler) outer Join
select film.title,language.name
from film
left outer join language on film.original_language_id  = language.language_id;    -- 1000

-- Ich will eine Liste aller filmemit der original_language auch wenn ein Film keien original language gesetzt hat
-- Right Join ist invertierter Join
select film.title,language.name
from language
right outer join film on film.original_language_id  = language.language_id;    -- 1000