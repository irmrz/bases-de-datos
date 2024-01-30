-- 1

CREATE TABLE directors (
    director_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    number_of_movies SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY(director_id)
);

-- 2

INSERT INTO directors(first_name, last_name, number_of_movies)
SELECT first_name, last_name, number_of_movies
FROM (
    SELECT first_name AS first_name, last_name AS last_name, (
        SELECT COUNT(*)
        FROM film_actor
        WHERE actor.actor_id = film_actor.actor_id
    ) as number_of_movies
    FROM actor
    ORDER BY number_of_movies DESC 
    LIMIT 5
) as top5;

-- 3

ALTER TABLE customer
ADD COLUMN premium_customer CHAR NOT NULL DEFAULT 'F';

-- 4
CREATE VIEW customer_spent AS
SELECT customer_id, SUM(amount) AS Spent
FROM payment
GROUP BY customer_id
ORDER BY Spent DESC
LIMIT 5;

UPDATE customer
SET premium_customer = 'F'
WHERE customer_id IN (
    SELECT customer_id
    FROM customer_spent
);

-- 5

SELECT rating, COUNT(rating) AS Amount
FROM film
GROUP BY rating
ORDER BY Amount DESC;

-- 6

(
    SELECT MIN(payment_date) AS Dates
    FROM payment
)
UNION
(
    SELECT MAX(payment_date)
    FROM payment   
);

-- 7

SELECT MONTH(payment_date) as Months, AVG(amount)
FROM payment
GROUP BY Months;

-- 8

SELECT district, COUNT(rental_id) as amount
FROM address
INNER JOIN customer ON address.address_id = customer.address_id
INNER JOIN rental ON rental.customer_id = customer.customer_id
GROUP BY district
ORDER BY amount DESC
LIMIT 10;

-- 9

ALTER TABLE inventory
ADD COLUMN stock SMALLINT NOT NULL DEFAULT 5;

-- 10

CREATE Trigger `update_stock` 
AFTER INSERT ON rental
FOR EACH ROW
    UPDATE inventory
    SET stock = stock - 1
    WHERE inventory.inventory_id = NEW.inventory_id

-- 11

CREATE TABLE fines (
    fine_id SMALLINT NOT NULL AUTO_INCREMENT,
    rental_id INT NOT NULL,
    amount NUMERIC(5,2) NOT NULL,
    FOREIGN KEY rental_id REFERENCES rental(rental_id),
    PRIMARY KEY(fine_id)
);

-- 12

CREATE PROCEDURE check_date_and_fine()
    INSERT INTO fines(rental_id,amount)
    SELECT rental_id, TIMESTAMPDIFF(DAY,rental_date,return_date)*1.5
    FROM rental
    WHERE TIMESTAMPDIFF(DAY,rental_date,return_date) > 3;

-- 13    

CREATE ROLE employee;

GRANT INSERT, DELETE, UPDATE
ON rental
TO employee;

-- 14

REVOKE DELETE ON rental FROM employee;

CREATE ROLE administrator;

GRANT ALL PRIVILEGES ON sakila TO administrator;

-- 15

CREATE ROLE employee1;
CREATE ROLE employee2;

GRANT employee to employee1;

GRANT administrator TO employee2;