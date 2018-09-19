
USE sakila;

# 1.a
SELECT first_name, last_name From actor;

# 1.b

SELECT upper( concat( a.first_name, ' ', a.last_name )) AS `Actor Name`FROM actor as a;

# 2.a

SELECT a.actor_id, a.first_name, a.last_name from actor as a WHERE upper(a.first_name) = "JOE";

# 2.b 

SELECT actor_id, last_name FROM actor 
WHERE UPPER( last_name ) LIKE "%GEN%"
;

#2.c 

SELECT actor_id, last_name, first_name FROM actor 
WHERE upper(last_name) LIKE "%IE%"
Order BY last_name, first_name
;

# 2.d

SELECT country_id, country FROM country
WHERE  country IN ("Afghanistan", "Bangladesh", "China")
;

# 3.a

ALTER table actor 
	ADD COLUMN description blob
    AFTER `last_update`
;

# 3.b

ALTER TABLE actor
	DROP description
;

# 4.a 

SELECT Last_name, Count(last_name)
FROM actor
GROUP BY Last_name
;

# 4.b

SELECT Last_name, Count(last_name)
FROM actor
GROUP BY Last_name
HAVING COUNT(last_name) >= 2
;

# 4.c 

UPDATE actor
	SET first_name = 'HARPO'
WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO'
;

# 4.d

UPDATE actor
	SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
;

# 5.a 

# The Show Create Table command.

# 6.a

# Use `JOIN` to display the first and last names, as well as the address, 
# of each staff member. Use the tables `staff` and `address`:

SELECT concat_ws(" ", s.first_name, s.last_name) as `First & Last Name`, 
	   concat_ws(" ", a.address, a.address2) as `Address`
FROM staff s
	 JOIN address a
		ON s.address_id = a.address_id
;

# 6,b 

# Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
# Use tables `staff` and `payment`.

SELECT concat_ws(" ", s.first_name, s.last_name) as `Staff`, s.staff_id	as 'Staff ID',
	   Sum(p.amount) as "Amount"
FROM staff as s
	 JOIN payment as p 
		ON p.staff_Id = s.staff_id
WHERE p.payment_date BETWEEN '2005-08-01' and '2005-08-31'
GROUP BY s.staff_id
ORDER BY s.staff_id, p.payment_date asc
;

# 6.c 
# List each film and the number of actors who are listed for that film. 
# Use tables `film_actor` and `film`. Use inner join.

SELECT f.title, COUNT(*) 
FROM film	as f
	 JOIN film_actor as fa 
		ON f.film_id = fa.film_id
GROUP BY f.Title
;
    
# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT count(*)
FROM inventory
WHERE film_id in (
	SELECT f.film_id
	FROM   film as f
	WHERE f.title = 'Hunchback Impossible'      )
;

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, 
# list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.Last_name, c.first_name, sum(p.amount) as 'Payments'
FROM customer as c
	 JOIN payment as p 
		ON p.customer_ID = c.customer_id
GROUP BY c.last_name, c.first_name
ORDER BY c.Last_name, c.first_name
;

#  7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#  As an unintended consequence, films starting with the letters `K` and `Q` have 	
#  also soared in popularity. Use subqueries to display the titles of movies starting 
#  with the letters `K` and `Q` whose language is English.


SELECT f.TItle
From  Film f
	  JOIN language as l
		ON l.Name = 'English'
WHERE f.film_id in (
		select film_id
        from film
        where title like 'K%' or 
			  title like 'Q%'
	)
;

#  7b. Use subqueries to display all actors who appear in the film `Alone Trip`.


select concat_ws(',', a.last_name, a.first_name) as 'Actor Name (last, first)'
From actor a
where a.actor_id in (
		Select fa.actor_id
		from film_actor as fa
		where fa.film_id = (
						SELECT film_id
						from film
						where title = 'Alone Trip'
					)
		)
;

# 7c. You want to run an email marketing campaign in Canada, 
# for which you will need the names and email addresses of all Canadian customers. 
# Use joins to retrieve this information.

Select c.first_name, c.last_name, c.email
from customer as c
	 JOIN address as a 
		ON a.address_id = c.address_id
	 JOIN city as cty
		ON cty.city_id = a.city_id
	 JOIN country as cy
		On cy.country_id = cty.country_id
WHere cy.country = 'Canada'
;

# 7d. Sales have been lagging among young families, and you wish to target all family 
# movies for a promotion. Identify all movies categorized as family films.


select f.title
from film as f
	 JOIN film_category as fc
		ON fc.film_ID = f.film_id
	 JOIN category as c
		on c.category_id = fc.category_id
where
	c.name = "Family"
;


# 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(*)
FROM film as f
	 JOIN inventory as i
		ON i.film_id = f.film_id
	 JOIN rental as r
		ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY count(*) desc
;

# 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT i.store_id, sum(p.amount)
From inventory as i
	 Join rental as r
		ON r.inventory_id = i.inventory_id
	 Join payment p 
		ON p.rental_id = r.rental_id
GROUP BY i.store_id
;

# 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, cty.city, c.country
From store as s
	 Join address as a
		On a.address_id = s.address_id
	 Join city as cty
		On cty.city_id = a.city_id
	 join country as c
		On c.country_id = cty.country_id
;

# 7h. List the top five genres in gross revenue in descending order. 
#  (**Hint**: you may need to use the following tables: 
#		category, film_category, inventory, payment, and rental.)

SELECT c.name, sum(p.amount) as 'Gross Revenue'
From category as c
	 JOIN film_category as fc
		ON fc.category_id = c.category_id
	 JOIN inventory as i
		ON i.film_id = fc.film_id
	 Join rental as r
		ON r.inventory_id = i.inventory_id
	 Join payment as p
		On p.rental_id = r.rental_id
GROUP BY c.name
Limit 5
;

# 8a. In your new role as an executive, you would like to have an easy way of viewing 
# the Top five genres by gross revenue. 
# Use the solution from the problem above to create a view. 
# If you haven't solved 7h, you can substitute another query to create a view.

CREATE OR REPLACE
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `gross_top_5` AS
    SELECT 
        `c`.`name` AS `name`, SUM(`p`.`amount`) AS `Gross Revenue`
    FROM
        ((((`category` `c`
        JOIN `film_category` `fc` ON ((`fc`.`category_id` = `c`.`category_id`)))
        JOIN `inventory` `i` ON ((`i`.`film_id` = `fc`.`film_id`)))
        JOIN `rental` `r` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `payment` `p` ON ((`p`.`rental_id` = `r`.`rental_id`)))
    GROUP BY `c`.`name`
    LIMIT 5
;

# 8b. How would you display the view that you created in 8a?

Select *
from gross_top_5
;

 # 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW `sakila`.`gross_top_5`;
