
/*Before you run these queries, make sure to create Sakila DB and import the related data first*/

/* Email Campaigns for customers of Store 2
First, Last name and Email address of customers from Store 2*/
SELECT first_name, last_name,email
FROM customer
WHERE store_id = 2;

/* movie with rental rate of 0.99$*/
SELECT COUNT(*) FROM film
WHERE rental_rate = 0.99;

/* we want to see rental rate and how many movies are in each rental rate categories*/
SELECT rental_rate, COUNT(*) AS total_number_of_movies
FROM film
GROUP BY rental_rate;

SELECT rental_rate, COUNT(*) AS total_number_of_movies
FROM film
GROUP BY 1;

/*Which rating do we have the most films in?*/
SELECT rating,COUNT(*) AS total_number_of_movies
FROM film
GROUP BY 1;

/*Which rating is most prevalant in each store?*/
SELECT s.store_id, f.rating, COUNT(f.rating) AS total_number_of_films
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON f.film_id = i.film_id
GROUP BY 1,2;

/* List of films by Film Name, Category, Language*/
SELECT f.title,c.name,l.name
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON l.language_id = f.language_id;

/* How many times each movie has been rented out? */
SELECT i.film_id, f.title, COUNT(i.film_id) AS total_number_of_rental_times
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY i.film_id
ORDER BY 3 DESC;

/*Revenue per Movie */
SELECT i.film_id, f.title, COUNT(i.film_id) AS total_number_of_rental_times, f.rental_rate, COUNT(i.film_id)*f.rental_rate AS revenue_per_movie
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY i.film_id
ORDER BY 5 DESC;

/* Most Spending Customer so that we can send him/her rewards or debate points*/
SELECT c.customer_id, SUM(p.amount) AS "Total Spending"
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 1
ORDER BY 2 DESC;

--The same query can be written as the below without aditionally using the JOIN clause as proposed in the original Project

SELECT customer_id, sum(amount) from payment GROUP by customer_id ORDER by sum(amount) DESC;






/* What Store has historically brought the most revenue */
SELECT s.store_id, SUM(p.amount) AS "Total Spending"
FROM store s
JOIN inventory i ON i.store_id = s.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY 1
ORDER BY 2 DESC;


/* Last Rental Date of every customer */
SELECT c.customer_id, c.first_name, c.last_name, MAX(r.rental_date) AS "Last Rental Date"
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY 1;

/* Revenue Per Month */
SELECT strftime("%m",payment_date) AS "Month", SUM(amount) AS "Revenue Per Month"
FROM payment
GROUP BY 1;

/* How many distint Renters per month*/
SELECT strftime("%m",rental_date) AS "Month", 
	COUNT(DISTINCT(rental_id)) AS "Total Rentals",
	COUNT(DISTINCT(customer_id)) AS "Number Of Unique Renter", 
    COUNT(DISTINCT(rental_id))/COUNT(DISTINCT(customer_id)) AS "Average Rent Per Renter"
FROM rental
GROUP BY 1;

/*Number of Distinct Film Rented Each Month */
SELECT i.film_id, f.title, strftime("%m",r.rental_date) AS "Month", COUNT(i.film_id) AS "Total Number Of Rental Times"
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY i.film_id, strftime("%m",r.rental_date)
ORDER BY 1, 2, 3;

/* Number of Rentals in Comedy , Sports and Family */
SELECT c.name, COUNT(c.name) AS "Number of Rentals"
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE c.name IN ("Comedy", "Sports", "Family")
GROUP BY 1;

/*Users who have been rented at least 3 times*/
SELECT c.customer_id, c.first_name||" "||c.last_name AS "Customer Name", COUNT(c.customer_id) AS "Total Rentals"
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY 1
HAVING COUNT(c.customer_id) >= 3
ORDER BY 1;

/*How much revenue has one single store made over PG13 and R rated films*/
SELECT s.store_id, f.rating, SUM(p.amount) AS "Total Revenue"
FROM store s 
JOIN inventory i ON i.store_id = s.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
JOIN film f ON f.film_id = i.film_id
WHERE f.rating IN ("PG-13", "R")
GROUP BY 1,2;
