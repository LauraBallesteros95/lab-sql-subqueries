-- SQL Subqueries
-- How many copies of the film Hunchback Impossible exist in the inventory system?
select count(f.film_id) as "number_of_films" from film f
join inventory i on f.film_id =i.film_id
where title = (select title from film where title = "hunchback impossible");
-- List all films whose length is longer than the average of all the films.
select title, length from film
where length > (select avg(length) as "avg_length" from film);
-- Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name from (select fa.actor_id from film_actor fa 
join film f on f.film_id= fa.film_id
where f.title ="Alone Trip") sub1 
join actor a on a.actor_id = sub1.actor_id;
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.film_id, f.title, c.name as category
from film as f
join film_category as fc on f.film_id = fc.film_id
join category as c on fc.category_id = c.category_id
where c.name = 'Family';
-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select first_name, last_name, email
from customer
where customer_id in (
    select customer_id
    from address
    where city_id in (
        select city_id
        from city
        where country_id = (
            select country_id
            from country
            where country = 'Canada'
        )
    )
);
select c.first_name, c.last_name, c.email
from customer as c
join address as a on c.address_id = a.address_id
join city as ct on a.city_id = ct.city_id
join country as co on ct.country_id = co.country_id
where co.country = 'Canada';
-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select actor_id
from film_actor
group by actor_id
order by count(*) desc
limit 1;
-- Second part
select f.film_id, f.title
from film_actor as fa
join film as f on fa.film_id = f.film_id
where fa.actor_id = actor_id;
-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select customer_id
from payment
group by customer_id
order by sum(amount) desc
limit 1;
-- Second part
select f.film_id, f.title
from customer as c
join rental as r on c.customer_id = r.customer_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
where c.customer_id = r.customer_id;
-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select customer_id as client_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having sum(amount) > (select avg(total_amount) from (select sum(amount) as total_amount from payment group by customer_id) as subquery);