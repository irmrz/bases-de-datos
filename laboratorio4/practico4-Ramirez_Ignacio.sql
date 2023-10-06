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
WHERE countrylanguage.IsOfficial = 'F' 
    AND countrylanguage.Percentage > 
        (SELECT MAX(countrylanguage.Percentage)
         FROM countrylanguage
         WHERE IsOfficial = 'T' AND countrylanguage.CountryCode = country.Code);

-- 5

/*
Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor 
a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. 
(Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas)
*/

-- con subquery
SELECT Region 
FROM country
WHERE SurfaceArea < 1000
    AND EXISTS (SELECT *
                FROM city
                WHERE Population > 100000
                AND country.Code = city.CountryCode);

-- sin subquery
SELECT country.Region
FROM country
INNER JOIN city ON country.Code = city.CountryCode
WHERE country.SurfaceArea < 1000 AND city.Population > 100000;

-- 6

/*
Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. 
(Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o 
usando agrupaciones, encontrar ambas).
*/

-- Consulta Escalar
SELECT country.Name AS Pais, 
    (SELECT MAX(Population) 
     FROM city 
     WHERE CountryCode = country.Code ) AS Habitantes_ciudad_mas_poblada
FROM country
HAVING Habitantes_ciudad_mas_poblada IS NOT NULL;

-- Usando Agrupaciones
SELECT country.Name AS Pais,
    MAX(city.Population) AS Habitantes_ciudad_mas_poblada
FROM country
INNER JOIN city ON city.CountryCode = country.Code
GROUP BY country.Code;

-- 7

/*
Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea
 mayor al promedio de hablantes de los lenguajes oficiales.
*/

SELECT country.Name AS Pais,
    countrylanguage.Language AS LenguajeNoOficial
FROM country
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'F' 
    AND countrylanguage.Percentage > (SELECT AVG(Percentage) 
                                      FROM countrylanguage
                                      WHERE IsOfficial = 'T'
                                      AND CountryCode = country.Code);

-- 8

/*
Listar la cantidad de habitantes por continente ordenado en forma descendente
*/

SELECT Continent, SUM(Population) AS PoblacionContinentes
FROM country
GROUP BY (Continent)
ORDER BY PoblacionContinentes Desc;  

-- 9 

/*
Listar el promedio de esperanza de vida (LifeExpectancy) por continente 
con una esperanza de vida entre 40 y 70 años
*/

SELECT Continent, AVG(LifeExpectancy) AS EsperanzaVida
FROM country
GROUP BY (Continent)
HAVING EsperanzaVida BETWEEN 40 AND 70;

-- 10
/*
Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente
*/

SELECT  Continent,
     MAX(Population),
     MIN(Population),
     AVG(Population),
     SUM(Population)
FROM country
GROUP BY Continent;


-- Parte 2

/*
Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. 
(Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o
usando agrupaciones, encontrar ambas).

Si en la consulta 6 se quisiera devolver, además de las columnas ya solicitadas, 
el nombre de la ciudad más poblada. ¿Podría lograrse con agrupaciones? 
¿y con una subquery escalar?
*/

SELECT country.Name, 
    (SELECT MAX(Population) FROM city WHERE city.CountryCode = country.Code) AS Poblacion,
    (SELECT Name FROM city WHERE city.CountryCode = country.Code AND Poblacion = city.Population) AS Ciudad
FROM country;