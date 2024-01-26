-- Parte 1

-- 1

SELECT city.Name, country.Name, country.Region, GovernmentForm
FROM city
INNER JOIN country ON country.Code = city.CountryCode
ORDER BY city.Population DESC
LIMIT 10;

-- 2
/* Listar los 10 países con menor población del mundo, 
junto a sus ciudades capitales (Hint: puede que uno de 
estos países no tenga ciudad capital asignada, en este 
caso deberá mostrar "NULL"). */

SELECT country.Name as pais, city.Name as ciudad, country.Population
FROM country
LEFT JOIN city ON country.Code = city.CountryCode
ORDER BY country.Population
LIMIT 10;

-- 3
/* Listar el nombre, continente y todos los lenguajes 
oficiales de cada país. (Hint: habrá más de una fila
por país si tiene varios idiomas oficiales). */

SELECT country.Name, country.Continent, Language
FROM country
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T'
ORDER BY country.Name;

-- 4 
/* Listar el nombre del país y nombre de capital, de los 20 
países con mayor superficie del mundo. */

SELECT country.Name, city.Name
FROM country
INNER JOIN city ON country.Capital = city.ID
ORDER BY country.SurfaceArea DESC
LIMIT 20;

-- 5
/* Listar las ciudades junto a sus idiomas oficiales 
(ordenado por la población de la ciudad) y el porcentaje 
de hablantes del idioma. */

SELECT city.Name, countrylanguage.Language, countrylanguage.Percentage
FROM city
INNER JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode
ORDER BY city.Population DESC;

-- 6
/* Listar los 10 países con mayor población y los 10 
países con menor población (que tengan al menos 100 habitantes) 
en la misma consulta. */

( 
    SELECT Name, Population 
    FROM country
    ORDER BY Population DESC
    LIMIT 10
)
UNION
(
    SELECT Name, Population 
    FROM country
    ORDER BY Population ASC
    LIMIT 10
);

-- 7
/* Listar aquellos países cuyos lenguajes oficiales son 
el Inglés y el Francés (hint: no debería haber filas duplicadas). */

(   
    SELECT Name
    FROM country
    INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
    WHERE countrylanguage.Language = 'French' 
    AND countrylanguage.IsOfficial = 'T'
)
INTERSECT
(
    SELECT Name
    FROM country
    INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
    WHERE countrylanguage.Language = 'English' 
    AND countrylanguage.IsOfficial = 'T'
);

-- 8
/* Listar aquellos países que tengan hablantes del Inglés 
pero no del Español en su población. */

(
    SELECT Name
    FROM country
    INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
    WHERE countrylanguage.Language = 'English' 
)
EXCEPT
(
    SELECT Name
    FROM country
    INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
    WHERE countrylanguage.Language = 'Spanish'
);


-- Parte 2: Preguntas
/*
-- 1

Ambas consultas deberían devolver lo mismo. En la primera se agrega
la condición del nombre del país a la reunión mientras que en la segunda
se hace la reunión natural típica y luego se le hace una selección de 
las tuplas donde country.Name = 'Argentina'.

-- 2

En caso de usar LEFT JOIN, en la primera consulta, todas las tuplas 
de city que no cumplan la condición del join van a tener valor nulo 
en country.Name. Es decir, se van a traer todas las tuplas de la
tabla, a las que no cumplan la condición le ponemos null.
Para la segunda consulta pasa lo mismo, el cambio es que al tener 
el WHERE estamos selececcionando solo las tuplas que cumplan la condición
Primero se traen todas las de city y despues quedan solo las que
son de argentina.
*/