-- sudo mysql -u root -h localhost

-- 1
/*
DROP DATABASE IF EXISTS `world`;

CREATE DATABASE `world`;
*/

USE `world`;


-- 2

CREATE TABLE country (
    Code char(3) PRIMARY KEY,
    Name varchar(128),
    Continent varchar(128),
    Region varchar(128),
    SurfaceArea numeric(10,2),
    IndepYear int,
    Population int,
    LifeExpectancy numeric(10,1),
    GNP numeric(10,2),
    GNPOld numeric(10,2),
    LocalName varchar(128),
    GovernmentForm varchar(128),
    HeadOfState varchar(128),
    Capital int,
    Code2 char(3)
);

CREATE TABLE city (
    ID int ,
    Name varchar(128),
    CountryCode char(3),
    District varchar(128),
    Population int,
    PRIMARY KEY(ID),
    FOREIGN KEY (CountryCode) REFERENCES country(Code)
);

CREATE TABLE countrylanguage (
    CountryCode char(3),
    Language varchar(128),
    IsOfficial char(1),
    Percentage numeric(10,2),
    PRIMARY KEY (CountryCode, Language),
    FOREIGN KEY (CountryCode) REFERENCES country(Code)
);

-- 3

-- SOURCE world-data.sql


-- 4

CREATE TABLE continent (
    Name varchar(128) PRIMARY KEY,
    Area int,
    MassPercentage numeric(10,2),
    MostPopulatedCity varchar(128)
);

-- 5

INSERT INTO continent VALUES ('Africa', 30370000, 20.4, 'Cairo, Egypt');
INSERT INTO continent VALUES ('Antarctica', 14000000, 9.2, 'McMurdo Station');
INSERT INTO continent VALUES ('Asia', 44579000, 29.5, 'Mumbai, India');
INSERT INTO continent VALUES ('Europe', 10180000, 6.8, 'Instanbul, Turquia');
INSERT INTO continent VALUES ('North America', 24709000, 16.5, 'Ciudad de Mexico, Mexico');
INSERT INTO continent VALUES ('Oceania', 8500000, 5.9, 'Sydney, Australia');
INSERT INTO continent VALUES ('South America', 17840000, 11.9, 'Sao Paulo, Brasil');


-- 6

ALTER TABLE country
ADD FOREIGN KEY (Continent) REFERENCES continent(Name);



-- Parte 2

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
WHERE HeadOfState LIKE '%John %'; -- Correccion
-- Agregado espacio para no borrar a Johnson

-- 10

SELECT Name, Population 
FROM country 
WHERE Population >= 35000000 AND Population <= 45000000;

-- 11