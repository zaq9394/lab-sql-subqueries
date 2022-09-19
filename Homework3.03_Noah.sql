use sakila;
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT  count(inventory_id) FROM sakila.inventory 
where film_id=(SELECT film_id FROM sakila.film
where title='Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.
SELECT film_id, title,length FROM sakila.film
where length>(SELECT AVG(length) FROM sakila.film);


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT concat(first_name,' ',last_name) as 'Name' FROM sakila.actor 
WHERE actor_id in (SELECT actor_id from sakila.film_actor
WHERE film_id = (SELECT film_id FROM sakila.film
where title='Alone Trip'));



-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT film_id,title FROM sakila.film
where film_id in (SELECT film_id from sakila.film_category
where category_id=(SELECT category_id FROM sakila.category
where name='Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- using subqueries
SELECT first_name,last_name,email FROM sakila.customer
WHERE address_id in (SELECT address_id FROM sakila.address
WHERE city_id in (SELECT city_id FROM sakila.city
WHERE country_id= (SELECT country_id FROM sakila.country
WHERE country='Canada')));
-- using JOINS
SELECT c.first_name,c.last_name,c.email FROM sakila.customer c
JOIN sakila.address a using(address_id)
JOIN sakila.city ci using(city_id)
JOIN sakila.country co using(country_id)
WHERE co.country='Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT film_id,title FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.film_actor
WHERE actor_id=(SELECT actor_id from sakila.film_actor
GROUP BY actor_id ORDER BY count(actor_id) desc LIMIT 1)) ;


-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT film_id,title FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.inventory
WHERE inventory_id in (SELECT inventory_id FROM sakila.rental
WHERE customer_id=(SELECT customer_id FROM sakila.payment
GROUP BY customer_id
ORDER BY sum(amount) desc
LIMIT 1))); 

-- 8.Customers who spent more than the average payments.
SELECT customer_id,first_name,last_name FROM sakila.customer 
WHERE customer_id in (SELECT customer_id FROM sakila.payment
GROUP BY customer_id
HAVING sum(amount)>=(SELECT AVG(SUM) FROM(
SELECT customer_id, sum(amount) as SUM FROM sakila.payment
GROUP BY customer_id) sub1));

