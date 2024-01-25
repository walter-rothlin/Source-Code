     select count(*) from actor;
     
     
    
    
    
    select 'actor'    AS `Table`, count(*) AS count from actor   UNION
	select 'address'  AS `Table`, count(*) AS count from address   UNION
	select 'category' AS `Table`, count(*) AS count from category;