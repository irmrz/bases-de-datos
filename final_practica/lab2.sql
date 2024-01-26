-- Parte 1 --


-- 2

CREATE TABLE country (
  Code VARCHAR(3) NOT NULL,
  Name VARCHAR(250) NOT NULL,
  continent VARCHAR(250) NOT NULL,
  Region VARCHAR(250) NOT NULL,
  SurfaceArea INT,
  IndepYear INT,
  Population INT,
  LifeExpectancty INT,
  GNP INT,
  GNPOld INT,
  LocalName VARCHAR(250),
  GovernmentForm VARCHAR(250),
  HeadOfState VARCHAR(250),
  Capital INT,
  Code2 VARCHAR(2),
  PRIMARY KEY (Code)
);

CREATE TABLE city (
  ID INT NOT NULL,
  Name VARCHAR(250) NOT NULL,
  CountryCode VARCHAR(3) NOT NULL,
  District VARCHAR(250),
  Population INT,
  PRIMARY KEY (ID),
  FOREIGN KEY (CountryCode) REFERENCES country(Code)
);

CREATE TABLE countrylanguage (
  CountryCode VARCHAR(3) NOT NULL,
  Language VARCHAR(250) NOT NULL,
  IsOfficial CHAR,
  Percentage DECIMAL(4,1),
  PRIMARY KEY (Language, CountryCode),
  FOREIGN KEY (CountryCode) REFERENCES country(Code)
);

-- 4

CREATE Table continent (
  Name VARCHAR(250) NOT NULL,
  Area INT NOT NULL,
  MassPercentage DECIMAL(3,1),
  MostPopulatedCity VARCHAR(250),
  PRIMARY KEY(Name)
);


-- 5
INSERT INTO `continent` VALUES ('AFRICA', 30370000, 20.4, 'Cairo, Egypt');
INSERT INTO `continent` VALUES ('ANTARCTICA', 14000000, 9.2, 'McMurdo Station');
INSERT INTO `continent` VALUES ('ASIA', 45579000, 29.5, 'Mumbai, India');
INSERT INTO `continent` VALUES ('EUROPE', 10180000, 6.8, 'Instanbul, Turquia');
INSERT INTO `continent` VALUES ('NORTH AMERICA', 24709000, 16.5, 'Ciudad de Mexico, Mexico');
INSERT INTO `continent` VALUES ('OCEANIA', 8600000, 5.9, 'Sidney, Australia');
INSERT INTO `continent` VALUES ('SOUTH AMERICA', 1784000, 12.0, 'Sao Paulo, Brazil');

-- 6

ALTER Table country
ADD FOREIGN KEY (Continent) REFERENCES continent(Name);


--- Parte 2

-- 1

SELECT Name, Region
FROM country
ORDER BY Name DESC;

-- 2

SELECT Name, Population
FROM city
ORDER BY Population DESC
LIMIT 10;

-- 3

SELECT Name, Region, SurfaceArea, GovernmentForm
FROM country
ORDER BY SurfaceArea ASC
LIMIT 10;

-- 4

SELECT Name, GovernmentForm
FROM country
WHERE GovernmentForm LIKE 'Dependent%';

-- 5

SELECT Language, Percentage
FROM countrylanguage
WHERE IsOfficial = 'T';

-- 6

UPDATE countrylanguage
SET Percentage = 100.0
WHERE CountryCode = 'AIA';

-- 7

SELECT Name
FROM city
WHERE District = 'Córdoba' AND CountryCode = 'ARG';

-- 8

SELECT Name
FROM city
WHERE District = 'Córdoba' AND CountryCode NOT LIKE 'ARG';

-- 9

SELECT Name, HeadOfState
FROM country
WHERE HeadOfState LIKE '%John%';

-- 10

SELECT Name, Population
FROM country
WHERE Population BETWEEN 35000000 AND 45000000
ORDER BY Population DESC;

-- 11 ??? 