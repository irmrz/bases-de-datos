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

-- 2 