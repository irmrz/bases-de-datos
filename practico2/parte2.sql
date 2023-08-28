-- Parte 2

USE `world`;

-- 1

SELECT Name, Region FROM country ORDER BY Region;

-- 2

SELECT Name, Population FROM country ORDER BY Population DESC LIMIT 10;

-- 3

SELECT Name, Region, SurfaceArea, GovernmentForm FROM country ORDER BY SurfaceArea LIMIT 10;

-- 4

SELECT Name, GovernmentForm FROM country  WHERE GovernmentForm LIKE '%Territory%';

-- 5

SELECT country.Name, Language, Percentage 
FROM countrylanguage 
INNER JOIN country ON countrylanguage.CountryCode = country.Code 
WHERE IsOfficial LIKE 'T';

-- Adicionales

-- 6

UPDATE countrylanguage
SET Percentage = 100.00
WHERE CountryCode = 'AIA';

-- 7

SELECT Name FROM city WHERE District = 'Córdoba';

-- 8

DELETE FROM city 
WHERE District = 'Córdoba' AND CountryCode != 'ARG';

-- 9

SELECT Name, HeadOfState 
FROM country 
WHERE HeadOfState LIKE '%John%';

-- 10

SELECT Name, Population 
FROM country 
WHERE Population >= 35000000 AND Population <= 45000000;

-- 11

