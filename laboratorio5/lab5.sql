USE sakila;

-- 1

CREATE TABLE directors (
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    number_movies INT NOT NULL,
    PRIMARY KEY (first_name,last_name)
);

-- 2
INSERT INTO directors (first_name, last_name, number_movies)
SELECT
    actor.first_name AS Nombre,
    actor.last_name AS Apellido,
    COUNT(film_actor.film_id) AS cantidad_peliculas
FROM
    actor 
JOIN
    film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY
    actor.actor_id, actor.first_name, actor.last_name
ORDER BY
    cantidad_peliculas DESC
LIMIT 5;


-- 3

/*
Agregue una columna `premium_customer` que tendrá un valor 
'T' o 'F' de acuerdo a si el cliente es "premium" o no. 
Por defecto ningún  cliente será premium
*/
ALTER TABLE customer
ADD premium_customer CHAR(1) DEFAULT 'F';


-- 4

/*
Modifique la tabla customer. Marque con 'T' en la columna 
`premium_customer` de los 10 clientes con mayor dinero 
gastado en la plataforma
*/

CREATE VIEW ejercicio4 AS
    (SELECT customer.customer_id as ID,
        SUM(payment.amount) AS Gastaron
    FROM customer
    INNER JOIN payment ON (customer.customer_id = payment.customer_id)
    GROUP BY customer.customer_id
    ORDER BY Gastaron DESC
    LIMIT 10);

UPDATE customer 
SET premium_customer = 'T'
WHERE customer.customer_id IN (SELECT ID FROM ejercicio4);


-- 5

/*
Listar, ordenados por cantidad de películas (de mayor a menor), 
los distintos ratings de las películas existentes 
*/

SELECT rating, COUNT(rating) AS CantidadPeliculas
FROM film 
GROUP BY rating
ORDER BY CantidadPeliculas DESC;


-- 6

/* ¿Cuáles fueron la primera y última fecha donde hubo pagos? */

(SELECT payment_date AS Pagos
FROM payment
ORDER BY Pagos ASC
LIMIT 1)
UNION 
(SELECT payment_date AS Pagos
FROM payment
ORDER BY Pagos DESC
LIMIT 1);


-- 7

/*Calcule, por cada mes, el promedio de pagos 
(Hint: vea la manera de extraer el nombre del mes de una fecha).
*/

SELECT MONTH(payment_date) AS Mes,
    AVG(amount) AS 'Promedio de Pago'
FROM payment
GROUP BY Mes
ORDER BY Mes;


-- 8 

/*
Listar los 10 distritos que tuvieron mayor cantidad de 
alquileres (con la cantidad total de alquileres).
*/

SELECT district AS Distrito,
    COUNT(rental.rental_id) AS CantidadAlquileres
FROM address 
INNER JOIN customer ON (customer.address_id = address.address_id)
INNER JOIN rental ON (rental.customer_id = customer.customer_id)
GROUP BY district
ORDER BY CantidadAlquileres DESC
LIMIT 10;


-- 9 

/*
Modifique la table `inventory_id` agregando una columna `stock` 
que sea un número entero y representa la cantidad de copias de 
una misma película que tiene determinada tienda. El número por 
defecto debería ser 5 copias
*/

ALTER TABLE inventory
ADD stock SMALLINT NOT NULL DEFAULT 5 AFTER last_update;


-- 10

/*
Cree un trigger `update_stock` que, cada vez que se agregue 
un nuevo registro a la tabla rental, haga un update en la 
tabla `inventory` restando una copia al stock de la película 
rentada (Hint: revisar que el rental no tiene información 
directa sobre la tienda, sino sobre el cliente, que está 
asociado a una tienda en particular).
*/