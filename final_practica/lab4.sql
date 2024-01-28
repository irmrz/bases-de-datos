-- Parte 1

-- 1
/* Listar el nombre de la ciudad y el nombre del país de 
todas las ciudades que pertenezcan a países con una población 
menor a 10000 habitantes. */

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
    AND country.Population < 1000;

-- 2
/* Listar todas aquellas ciudades cuya población sea mayor 
que la población promedio entre todas las ciudades. */

SELECT Name
FROM city
WHERE Population > (SELECT AVG(Population) FROM city);

-- 3
/* Listar todas aquellas ciudades no asiáticas cuya población 
sea igual o mayor a la población total de algún país de Asia. 
*/

SELECT city.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Continent NOT LIKE 'Asia'
    AND city.Population >= (SELECT MIN(Population)
                            FROM country
                            WHERE Continent = 'Asia');

-- 4
/* Listar aquellos países junto a sus idiomas no oficiales, 
que superen en porcentaje de hablantes a cada uno de los 
idiomas oficiales del país. */

SELECT country.Name, Language
FROM country
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE IsOfficial = 'F' AND
    Percentage > (SELECT MAX(Percentage)
                  FROM countrylanguage
                  WHERE IsOfficial = 'T' AND 
                  country.Code = countrylanguage.CountryCode);

-- 5
/* Listar (sin duplicados) aquellas regiones que tengan países con 
una superficie menor a 1000 km2 y exista (en el país) al menos una 
ciudad con más de 100000 habitantes. (Hint: Esto puede resolverse 
con o sin una subquery, intenten encontrar ambas respuestas).*/

-- Con subquery

SELECT Region
FROM country
WHERE SurfaceArea < 1000 AND
    EXISTS (
        SELECT Population
        FROM city
        WHERE Population > 100000 AND
            city.CountryCode = country.Code
    );

-- 6 
/* Listar el nombre de cada país con la cantidad de habitantes de 
su ciudad más poblada. (Hint: Hay dos maneras de llegar al mismo 
resultado. Usando consultas escalares o usando agrupaciones, 
encontrar ambas). */

SELECT country.Name,
    (
        SELECT MAX(city.Population)
        FROM city
        WHERE country.Code = city.CountryCode
    )
FROM country;

-- 7 
/* Listar aquellos países y sus lenguajes no oficiales cuyo 
porcentaje de hablantes sea mayor al promedio de hablantes de 
los lenguajes oficiales. */

SELECT country.Name, Language
FROM country
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE IsOfficial = 'F' 
    AND countrylanguage.Percentage > (
    SELECT AVG(Percentage)
    FROM countrylanguage
    WHERE country.Code = countrylanguage.CountryCode 
        AND IsOfficial = 'T'
);

-- 8
/* Listar la cantidad de habitantes por continente ordenado 
en forma descendente. */

SELECT continent, SUM(Population) as Poblacion
FROM country
GROUP BY continent
ORDER BY Poblacion DESC;


-- 9
/* Listar el promedio de esperanza de vida (LifeExpectancy) 
por continente con una esperanza de vida entre 40 y 70 años. */

SELECT AVG(LifeExpectancty) as EsperanzaVida, continent
FROM country
GROUP BY continent
HAVING EsperanzaVida BETWEEN 40 AND 70;

-- 10
/* Listar la cantidad máxima, mínima, promedio y suma de 
habitantes por continente. */

SELECT MAX(Population), MIN(Population), AVG(Population), SUM(Population), continent
FROM country
GROUP BY continent;

-- Parte 2

/* -- 1
Si en la consulta 6 se quisiera devolver, además de las columnas 
ya solicitadas, el nombre de la ciudad más poblada. ¿Podría 
lograrse con agrupaciones? ¿y con una subquery escalar? */

SELECT country.Name,
    (
        SELECT MAX(city.Population)
        FROM city
        WHERE country.Code = city.CountryCode
    ) AS maxpop,
    (
        SELECT city.Name
        FROM city
        WHERE country.Code = city.CountryCode
            AND city.Population = maxpop
        LIMIT 1
    ) as Ciudad
FROM country;