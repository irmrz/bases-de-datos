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
