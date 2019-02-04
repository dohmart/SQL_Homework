use sakila;

-- 1a
select first_name, last_name from actor;

-- 1b
select concat_ws(" ", first_name, last_name) as ACTOR from actor;

-- 2a
select actor_id, first_name, last_name from actor where first_name = "Joe";

-- 2b
select first_name, last_name from actor where last_name like '%GEN%';

-- 2c
select first_name, last_name from actor where last_name like '%LI%' order by last_name, first_name;

-- 2d
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
alter table actor
ADD COLUMN Description BLOB;

-- 3b
alter table actor
drop column Description;

-- 4a
select last_name, count(last_name) as NumActors 
from actor 
group by last_name order by NumActors desc;

-- 4b
select last_name, count(last_name) as NumActors 
from actor 
group by last_name 
having NumActors >= 2
order by NumActors ASC;

-- 4c
select * from actor where last_name = 'WILLIAMS';
update actor set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d
update actor set first_name = 'GROUCHO' where first_name = 'HARPO' ;

-- 5a
describe address;
-- OR
show create table address;
-- If the question is just understandin the schema, I think describe is a better solution

-- 6a
select s.first_name, s.last_name, a.address, a.address2, a.district
from staff as s inner join address as a on s.address_id = a.address_id;

-- 6b
select s.first_name, s.last_name, s.staff_id, sum(p.amount) as TotalRevenue
from staff as s inner join payment p on s.staff_id =  p.staff_id
group by s.first_name, s.last_name, s.staff_id;

-- 6c
select f.title, count(actor_id) as NumActors
from film as f inner join film_actor as fa where f.film_id = fa.film_id 
group by f.title;

-- 6d
select f.title, f.film_id, count(i.film_id) as Inventory
from film as f inner join inventory as i on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

-- 6e
select c.first_name, c.last_name, c.customer_id, sum(p.amount) as CustomerRevenue
from customer as c left outer join payment as p on c.customer_id = p.customer_id
group by c.first_name, c.last_name, c.customer_id
order by c.last_name;

-- 7a
select title from film
where title like 'K%' or title like 'Q%'
and language_id in (
  select language_id from language where name = 'English'
  );
  
  
-- 7b
select first_name, last_name from actor
where actor_id in (
  select actor_id from film_actor 
  where film_id in (
    select film_id from film where title = 'Alone Trip'
    )
  );
  
-- 7c
select c.first_name, c.last_name, c.email, co.country
from (customer as c inner join address as a on c.address_id = a.address_id
      inner join city as cy on a.city_id = cy.city_id)
	  inner join country as co on a.city_id = cy.city_id
where co.country = 'Canada';


-- 7d
select f.title, c.name 
from film f inner join film_category fc on f.film_id = fc.film_id
            inner join category c on fc.category_id = c.category_id
where c.name = 'Family';

-- 7e
select f.title, count(r.rental_id) as RentalCount
from film f inner join inventory i on f.film_id = i.film_id
            inner join rental r on i.inventory_id = r.inventory_id
group by f.title
order by RentalCount DESC;

-- 7f
select s.store_id, sum(p.amount) as StoreRevenue
from store s inner join inventory i on s.store_id = i.store_id
			 inner join rental r on i.inventory_id = r.inventory_id
             inner join payment p on r.rental_id = p.rental_id
group by s.store_id;

-- 7g
select s.store_id, a.city_id, c.city, co.country
from store s inner join address a on s.address_id = a.address_id
             inner join city c on a.city_id = c.city_id
             inner join country co on c.country_id = co.country_id;
             
-- 7h
select c.name, sum(p.amount) as GenreRevenue
from  inventory i inner join rental r on i.inventory_id = r.inventory_id
                  inner join payment p on r.rental_id = p.rental_id
                  inner join film_category fc on i.film_id = fc.film_id
                  inner join category c on fc.category_id = c.category_id
group by c.name
order by GenreRevenue DESC
limit 5;


-- 8a
create view GenreRevenue as
	select c.name, sum(p.amount) as GenreRevenue
	from  inventory i inner join rental r on i.inventory_id = r.inventory_id
					  inner join payment p on r.rental_id = p.rental_id
					  inner join film_category fc on i.film_id = fc.film_id
					  inner join category c on fc.category_id = c.category_id
	group by c.name
	order by GenreRevenue DESC
	limit 5;

-- 8b
select * from GenreRevenue;

-- 8c
drop view GenreRevenue;