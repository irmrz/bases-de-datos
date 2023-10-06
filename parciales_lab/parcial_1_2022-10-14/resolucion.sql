-- 1
CREATE TABLE reviews (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user` INT NOT NULL,
    `game` INT NOT NULL,
    `rating` DECIMAL (2,1) NOT NULL,
    `comment` VARCHAR (250) DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user`) REFERENCES `user` (`id`),
    FOREIGN KEY (`game`) REFERENCES `game` (`id`),
    UNIQUE KEY one_review_per_user (`user`, `game`)
);


-- 2
/*
Eliminar de la tabla `reviews` todas aquellas filas cuyo campo `comment` sea nulo y
modificar la tabla `reviews` de manera que no acepte valores nulos en el campo
`comment`.
*/

DELETE FROM reviews WHERE `comment` IS NULL;

ALTER TABLE reviews MODIFY `comment` VARCHAR (250) NOT NULL;


-- 3
/*
Devolver el nombre y el rating promedio del género con mayor rating promedio y
del género con menor rating promedio de acuerdo a los ratings de los reviews de
juegos de cada género. Deberán realizar una sóla consulta para dicha tarea.
*/
SELECT `name`, 
        AVG(`rating`) AS RatingPromedio
FROM genre
INNER JOIN game_genres ON (genre.`id` = game_genres.`genre` )
INNER JOIN game ON (game_genres.`game` = game.`id` )
INNER JOIN reviews ON (game.`id` = reviews.`game`)
GROUP BY `name`
HAVING AVG(`rating`) = (SELECT MAX(avg_rating) FROM (SELECT AVG(`rating`) AS avg_rating FROM genre
                     INNER JOIN game_genres ON genre.`id` = game_genres.`genre`
                     INNER JOIN game ON game_genres.`game` = game.`id`
                     INNER JOIN reviews ON game.`id` = reviews.`game`
                     GROUP BY `name`) AS max_ratings)
    OR
    AVG(`rating`) = (SELECT MIN(avg_rating) FROM (SELECT AVG(`rating`) AS avg_rating FROM genre
                     INNER JOIN game_genres ON genre.`id` = game_genres.`genre`
                     INNER JOIN game ON game_genres.`game` = game.`id`
                     INNER JOIN reviews ON game.`id` = reviews.`game`
                     GROUP BY `name`) AS max_ratings);


-- 4
/*
Agregar una columna a la tabla `user` llamada `number_of_reviews` que deberá
ser un entero. La columna deberá tener por defecto el valor 0 y no podrá ser nula.
*/

ALTER TABLE `user` ADD `number_of_reviews` INT NOT NULL DEFAULT 0;


-- 5
/*
Crear un procedimiento `set_user_number_of_reviews` que tomará un nombre
de usuario y actualizará el valor `number_of_reviews` de acuerdo a la cantidad de
reviews hechos por dicho usuario.
*/
CREATE PROCEDURE set_user_number_of_reviews (IN nombreusuario VARCHAR (100))
    UPDATE `user` 
    SET `number_of_reviews` = (
        SELECT COUNT(*)
        FROM reviews
        WHERE `user`.`id` = `user` AND `user`.`username` = nombreusuario
    )
    WHERE `username` = nombreusuario;


-- 6
/*
Crear dos triggers:
a. Un trigger llamado `increase_number_of_reviews` que incrementará en 1
el valor del campo `number_of_reviews` de la tabla `user`.

b. Un trigger llamado `decrease_number_of_reviews` que decrementará en
1 el valor del campo `number_of_reviews` de la tabla `user`.

El primer trigger se ejecutará luego de un `INSERT` en la tabla `reviews` y deberá
actualizar el valor en la tabla `user` de acuerdo al valor introducido (i.e. sólo
aumentará en 1 el valor de `number_of_reviews` para el usuario que hizo la
review). Análogamente, el segundo trigger se ejecutará luego de un `DELETE` en la
tabla `reviews` y sólo actualizará el valor en `user` correspondiente.
*/

-- a
CREATE TRIGGER increase_number_of_reviews
AFTER INSERT ON reviews
FOR EACH ROW
UPDATE `user` 
SET number_of_reviews = number_of_reviews + 1
WHERE `id` = NEW.`user`;

-- b
CREATE TRIGGER decrease_number_of_reviews
AFTER DELETE ON reviews
FOR EACH ROW
UPDATE `user` 
SET number_of_reviews = number_of_reviews - 1
WHERE `id` = OLD.`user` AND number_of_reviews > 0;


-- 7
/*
Devolver el nombre y el rating promedio de las 5 compañías desarrolladoras (i.e.
pertenecientes a la tabla `developers`) con mayor rating promedio, entre aquellas
compañías que hayan desarrollado un mínimo de 50 juegos.
*/
SELECT company.name,
    AVG(rating)
FROM company
INNER JOIN developers ON (company.id = developers.developer)
INNER JOIN game ON (developers.game = game.id)
INNER JOIN reviews ON (game.id = reviews.game)
GROUP BY company.name
LIMIT 5;


-- 8
/*
Crear el rol `moderator` y asignarle permisos de eliminación 
sobre la tabla `reviews` y permiso de actualización sobre la 
columna `comment` de la tabla `reviews`.
*/