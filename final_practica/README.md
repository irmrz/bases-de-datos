# Notas

## Lab 4
- Las agregaciones no devuelven tablas, devuelven un valor.
- Puedo referenciar una tabla externa desde una consulta anidada.

## Lab 5
- Descomposición de la siguiente consulta:
  
El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e. el mayor número de películas filmadas) son también directores de las películas en las que participaron. Basados en esta información, inserten, utilizando una subquery los valores correspondientes en la tabla `directors`.  
  
INSERT INTO directors(first_name, last_name, number_of_movies)
SELECT first_name, last_name, number_of_movies
FROM (
    SELECT first_name, last_name, (     -- consulta anidada 
        SELECT COUNT(*)                 -- consulta escalar
        FROM film_actor
        WHERE actor.actor_id = film_actor.actor_id
    ) as number_of_movies
    FROM actor
    ORDER BY number_of_movies DESC 
    LIMIT 5;
);  

- En la consulta escalar se cuenta la cantidad de pelicular en las que actuó un actor
- En la consulta anidada se selecciona nombre, apellido y la cantiadad de peliculas y se las ordena en base a la cantidad de peliculas

- Todas las tablas derivadas tiene que tener su alias

### ¿Cómo usar las vistas?
La vista nos va a dejar una tabla con unos valores ya calculados.
Creamos la vista como una consulta más con sus respectivos atributos.
Cuando queremos acceder a ella, accedemos por medio de sus atributos
haciendo select atributo from vista.

### ¿Como usar dos funciones de agregación?
Hay que usar sub-querys para extraer el resultado de la primera función y después aplicarlo para la segunda.

# Falta

- Pregunta 11 lab 2
- 6 lab 6