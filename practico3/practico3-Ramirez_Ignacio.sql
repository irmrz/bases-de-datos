-- SOURCE world-schema.sql
-- SOURCE world-data.sql

-- Parte 1

USE `world`;

-- 1

SELECT city.Name AS "Ciudades mas pobladas del mundo", 
    country.Name AS Pais,
    country.Region,
    country.GovernmentForm
FROM city 
INNER JOIN country 
ON country.Code = city.CountryCode
ORDER BY city.Population DESC
LIMIT 10;

-- 2

SELECT Name AS "Paises menos poblados",
    Capital
FROM country
ORDER BY Population 
LIMIT 10;

-- 3

SELECT Name AS Pais,
    Continent,
    countrylanguage.Language AS "Idiomas Oficiales"
FROM country
LEFT JOIN countrylanguage 
ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T';

-- 4

SELECT country.Name AS "Paises con mayor superficie del mundo",
    city.Name AS Capital
FROM country
INNER JOIN city
ON country.Capital = city.ID
ORDER BY SurfaceArea DESC
LIMIT 20;

-- 5 

SELECT city.Name AS "Ciudad",
    countrylanguage.Language AS "Idiomas Oficiales"
FROM city
LEFT JOIN countrylanguage
USING (CountryCode)
ORDER BY city.Population DESC, 
    countrylanguage.Percentage DESC
LIMIT 10;

-- 6

(SELECT Name AS Pais
FROM country
WHERE Population > 100
ORDER BY Population DESC
LIMIT 10)

UNION

(SELECT Name AS Pais
FROM country
WHERE Population > 100
ORDER BY Population
LIMIT 10);


-- 7

SELECT Name AS 'Paises que hablan Ingles y Frances'
FROM country
INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'English'
    AND countrylanguage.IsOfficial = 'T'

INTERSECT

SELECT Name 
FROM country
INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'French'
    AND countrylanguage.IsOfficial = 'T';

-- 8

SELECT Name AS 'Paises que hablan ingles pero no español'
FROM country
INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'English'

EXCEPT

SELECT Name AS 'Paises que hablan ingles pero no español'
FROM country
INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'Spanish';

/*
-- Parte 2

Preguntas


1)

-- Pregunta

¿Devuelven los mismos valores las siguientes consultas? ¿Por qué? 

-- Querys

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina';

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';

-- Respuesta

Ambas consultas devuelven lo mismo porque semanticamente hacen lo mismo. La unica diferencia
es que la primera aplica el filtro en el JOIN mientras que la segunda lo hace en el WHERE.
Dado que INNER JOIN funciona como una interseccion entre dos conjuntos, ambas querys buscan 
los resultados en el mismo lugar.


2)

-- Pregunta

¿Y si en vez de INNER JOIN fuera un LEFT JOIN?

-- Querys

SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina';

SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';

-- Respuesta

Al usar LEFT JOIN, en la primera consulta, se devuelven todos los resultados de la tabla city
incluyendo aquellos cuyo country.Name es NULL. En realidad no es NULL, sino que al tener un
country.name distinto de Argentina, el resultado es NULL.
En la segunda consulta, se devuelven solo los resultados de la tabla city que 
satisfacen la condicion descripta en el WHERE, es decir  aquellas ciudades que 
tienen country.name = Argentina.
*/