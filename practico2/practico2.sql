-- mysql -u root -h localhost

CREATE DATABASE IF NOT EXISTS `world`;

USE `world`;

CREATE TABLE city (
    ID int NOT NULL PRIMARY KEY NOT NULL,
    Name varchar(35) NOT NULL,
    CountyCode varchar(35) FOREIGN KEY REFERENCES Country(Code),
    Disctrict varchar(35),
    Population int,
)

CREATE TABLE countrylanguage (
    CountryCode varchar(35) FOREIGN KEY REFERENCES Country(Code) NOT NULL,
    Language varchar(35) PRIMARY KEY NOT NULL,
    IsOfficial varchar(35),
    Percentage float,
)

CREATE TABLE country (
    Code varchar(35) PRIMARY KEY NOT NULL,
    Name varchar(35) FOREIGN KEY REFERENCES Continent(Name) NOT NULL,
    Continent varchar(35),
    Region varchar(35),
    SurfaceArea float,
    IndepYear int,
    Population int,
    LifeExpectancy float,
    GNP float,
    GNPOld float,
    LocalName varchar(35),
    GovernmentForm varchar(35),
    HeadOfState varchar(35),
    Capital int,
    Code2 varchar(35),
)

CREATE TABLE continent (
    Name varchar(35) PRIMARY KEY NOT NULL,
    Area float,
    MassPercentage float,
    MostPopulatedCity varchar(35),
)

SOURCE world-data.sql;

EXIT;