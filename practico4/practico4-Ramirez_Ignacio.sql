USE world;

-- 1

SELECT city.Name AS Ciudad, country.Name AS Pais
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Population < 10000;

-- 2

SELECT Name AS "La poblacion es mayor que el promedio", Population
FROM city
WHERE Population > (SELECT AVG(Population) FROM city);

-- 3

/* Listar todas aquellas ciudades no asiáticas cuya población sea 
igual o mayor a la población total de algún país de Asia.

Nota: Antes de hacerlo con ANY use la funcion MIN, el resultado 
pareceria ser el mismo, a checkear*/

SELECT city.Name AS "Ciudades no Asiaticas"
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE city.Population >  ANY (SELECT country.Population 
                         FROM country 
                         WHERE Continent = 'Asia')
    AND (country.Continent != 'Asia');

-- 4

/* Listar aquellos países junto a sus idiomas no oficiales, 
que superen en porcentaje de hablantes a cada uno de los idiomas oficiales del país. */

SELECT country.Name AS Pais, countrylanguage.Language AS 'Idioma no oficial'
FROM country
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'F';

-- 5

/*
Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor 
a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. 
(Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas)
*/
