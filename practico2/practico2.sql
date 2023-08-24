-- mysql -u root -h localhost

CREATE DATABASE world;

USE `world`;

CREATE TABLE city (
    ID int NOT NULL PRIMARY KEY,
    Name varchar(35) NOT NULL,
    CountyCode varchar(35) NOT NULL,
    Disctrict varchar(35) NOT NULL,
    Population int NOT NULL,
)

SOURCE world-data.sql;

EXIT;