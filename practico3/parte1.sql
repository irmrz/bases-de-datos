-- SOURCE world-schema.sql
-- SOURCE world-data.sql

USE `world`;

-- 1

SELECT city.Name AS Ciudad, 
    city.Population AS Poblacion,
    country.Name AS PAIS,
    country.Region,
    country.GovernmentForm
FROM city 
INNER JOIN country ON city.CountryCode = country.Code
ORDER BY city.Population DESC
LIMIT 10;

-- 2

