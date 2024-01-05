select * from film ORDER BY film_id;

--  list all tables in postges
select DISTINCT release_year from film;

-- select all film wit flim_id between 50 and 80
select * from film where film_id between 50 and 80;

--  count all the above rows in film table
select count(*) from film where film_id between 50 and 80;

-- using count(column_name) will ignore all NULL values
