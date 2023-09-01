-- SOURCE world-schema.sql
-- SOURCE world-data.sql

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

SELECT Name AS Pais
FROM country
ORDER BY Population DESC
LIMIT 10

UNION ALL

SELECT Name AS Pais
FROM country
ORDER BY Population
LIMIT 10;

-- 7

SELECT Name AS 'Paises que hablan Ingles y Frances'
FROM country
INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'English'

INTERSECT

SELECT Name 
FROM country
INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'French';

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