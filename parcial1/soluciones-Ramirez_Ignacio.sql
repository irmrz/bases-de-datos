-- 1
/*
Crear un campo nuevo `total_medals` en la tabla `person` que 
almacena la cantidad de medallas ganadas por cada persona. 
Por defecto, con valor 0.
*/
ALTER TABLE person ADD total_medals INT DEFAULT 0;


-- 2
/*Actualizar la columna  `total_medals` de cada persona con 
el recuento real de medallas que ganó. Por ejemplo, para 
Michael Fred Phelps II, luego de la actualización debería 
tener como valor de `total_medals` igual a 28.
*/

UPDATE person, (
    SELECT person.`id` AS Persona, COUNT(medal_id) AS medallas
    FROM competitor_event
    JOIN games_competitor ON (competitor_event.competitor_id = games_competitor.person_id)
    JOIN person ON (games_competitor.person_id = person.`id`)
    GROUP BY person.`id`
) AS MedallasPorPersona
SET total_medals = MedallasPorPersona.Medallas
WHERE person.`id` = MedallasPorPersona.Persona;

-- 3
/*
Devolver todos los medallistas olímpicos de Argentina, 
es decir, los que hayan logrado alguna medalla de oro, 
plata, o bronce, enumerando la cantidad por tipo de medalla.  
Por ejemplo, la query debería retornar casos como el siguiente:
(Juan Martín del Potro, Bronze, 1), (Juan Martín del Potro, Silver,1)
*/

SELECT full_name, medal_name, COUNT(competitor_event.medal_id)
FROM person 
INNER JOIN games_competitor ON (person.`id` = games_competitor.person_id)
INNER JOIN competitor_event ON (games_competitor.person_id = competitor_event.competitor_id)
INNER JOIN medal ON (competitor_event.medal_id = medal.`id`)
INNER JOIN person_region ON (person.`id` = person_region.person_id)
INNER JOIN noc_region ON (noc_region.`id` = person_region.region_id)
WHERE noc_region.noc = 'ARG' 
GROUP BY full_name, medal_name
HAVING medal_name <> 'NA'
ORDER BY full_name;

SELECT full_name, medal_name, COUNT(competitor_event.medal_id)
FROM person
INNER JOIN competitor_event ON (person.`id` = competitor_event.competitor_id)
INNER JOIN medal ON (competitor_event.medal_id = medal.`id`)
INNER JOIN person_region ON (person.`id` = person_region.person_id)
WHERE person_region.region_id = 9
GROUP BY full_name, medal_name
HAVING medal_name <> 'NA'
ORDER BY full_name;


-- 4
/*Listar el total de medallas ganadas por los 
deportistas argentinos en cada deporte
*/
SELECT sport_name AS Deporte, 
    COUNT(medal_id) AS MedallasArgentinas
FROM competitor_event AS ce 
INNER JOIN person_region AS pr ON (ce.competitor_id = pr.person_id)
INNER JOIN `event` AS e ON (ce.event_id = e.`id`)
INNER JOIN sport AS s ON (e.sport_id = s.`id`)
WHERE pr.region_id = 9 AND ce.medal_id <> 4
GROUP BY Deporte
ORDER BY sport_name;


-- 5
/* Listar el número total de medallas de oro, plata y bronce ganadas por cada país
 (país representado en la tabla `noc_region`), agruparlas los resultados por pais.*/
CREATE VIEW Oros AS
    SELECT region_name AS Pais,
        COUNT(m.id) AS Oro
    FROM noc_region AS nr
    INNER JOIN person_region AS pr ON (pr.region_id = nr.`id`)
    INNER JOIN person AS p ON (p.id = pr.person_id)
    INNER JOIN games_competitor AS gc ON (gc.person_id = p.id)
    INNER JOIN competitor_event AS ce ON (ce.competitor_id = gc.person_id)
    INNER JOIN medal as m ON (m.id = ce.medal_id)
    WHERE m.medal_name = 'Gold'
    GROUP BY Pais
    ORDER BY PAIS; 

CREATE VIEW Platas AS
    SELECT region_name AS Pais,
        COUNT(m.id) AS Plata
    FROM noc_region AS nr
    INNER JOIN person_region AS pr ON (pr.region_id = nr.`id`)
    INNER JOIN person AS p ON (p.id = pr.person_id)
    INNER JOIN games_competitor AS gc ON (gc.person_id = p.id)
    INNER JOIN competitor_event AS ce ON (ce.competitor_id = gc.person_id)
    INNER JOIN medal as m ON (m.id = ce.medal_id)
    WHERE m.medal_name = 'Silver'
    GROUP BY Pais
    ORDER BY PAIS;

CREATE VIEW Bronzes AS
    SELECT region_name AS Pais,
        COUNT(m.id) AS Bronze
    FROM noc_region AS nr
    INNER JOIN person_region AS pr ON (pr.region_id = nr.`id`)
    INNER JOIN person AS p ON (p.id = pr.person_id)
    INNER JOIN games_competitor AS gc ON (gc.person_id = p.id)
    INNER JOIN competitor_event AS ce ON (ce.competitor_id = gc.person_id)
    INNER JOIN medal as m ON (m.id = ce.medal_id)
    WHERE m.medal_name = 'Bronze'
    GROUP BY Pais
    ORDER BY PAIS;

SELECT Oros.Pais, Oros.Oro, Platas.Plata, Bronzes.Bronze
FROM Oros
INNER JOIN Platas ON (Oros.Pais = Platas.Pais)
INNER JOIN Bronzes ON (Oros.Pais = Bronzes.Pais);


-- 6
/* Listar el país con más y menos medallas 
ganadas  en la historia de las olimpiadas. */

SELECT region_name AS Pais , COUNT(medal_id) AS Medallas
FROM noc_region AS nr 
INNER JOIN person_region AS pr ON (nr.`id` = pr.region_id)
INNER JOIN competitor_event AS ce ON (pr.person_id = ce.competitor_id)
GROUP BY region_name
HAVING Medallas =   (SELECT MAX(MaxMedallas) FROM ( SELECT COUNT(medal_id) AS MaxMedallas
                    FROM noc_region AS nr 
                    INNER JOIN person_region AS pr ON (nr.`id` = pr.region_id)
                    INNER JOIN competitor_event AS ce ON (pr.person_id = ce.competitor_id)
                    GROUP BY region_name) AS Maximo)
OR 
Medallas = (SELECT MIN(MinMedallas) FROM ( SELECT COUNT(medal_id) AS MinMedallas
                    FROM noc_region AS nr 
                    INNER JOIN person_region AS pr ON (nr.`id` = pr.region_id)
                    INNER JOIN competitor_event AS ce ON (pr.person_id = ce.competitor_id)
                    GROUP BY region_name) AS Minimo)
ORDER BY Medallas DESC;


-- 7
/*
Crear dos triggers:
Un trigger llamado `increase_number_of_medals` que incrementará 
en 1 el valor del  campo `total_medals` de la tabla `person`.

El primer trigger se ejecutará luego de un `INSERT` en la tabla `competitor_event` 
y deberá actualizar el valor en la tabla `person` de acuerdo al valor introducido 
(i.e. sólo aumentará en 1 el valor de `total_medals` para la persona que ganó una medalla). 
*/

CREATE TRIGGER increase_number_of_medals 
AFTER INSERT ON competitor_event
FOR EACH ROW
UPDATE person
SET total_medals = total_medals + 1
WHERE `id` = NEW.competitor_id;

/*
Un trigger llamado `decrease_number_of_medals` que decrementará 
en 1 el valor del campo `totals_medals` de la tabla `person`.

Análogamente, el segundo trigger se ejecutará luego de un `DELETE` en la tabla `competitor_event`
y sólo actualizará el valor en la persona correspondiente. */

CREATE TRIGGER decrease_number_of_medals
AFTER DELETE ON competitor_event
FOR EACH ROW
UPDATE person
SET total_medals = total_medals - 1
WHERE `id` = OLD.competitor_id AND total_medals > 0;


-- 8
/*
Crear un procedimiento  `add_new_medalists` que tomará un `event_id`, 
y tres ids de atletas `g_id`, `s_id`, y `b_id` donde se deberá insertar 
tres registros en la tabla `competitor_event`  asignando a `g_id` la 
medalla de oro, a `s_id` la medalla de plata, y a `b_id` la medalla de bronce
*/
DELIMITER //
CREATE PROCEDURE add_new_medalists (IN event_id INT, 
                                    IN g_id INT,
                                    IN s_id INT,
                                    IN b_id INT)
BEGIN
    INSERT INTO competitor_event VALUES (event_id, g_id, 1);
    INSERT INTO competitor_event VALUES (event_id, s_id, 2);
    INSERT INTO competitor_event VALUES (event_id, b_id, 3);
END //
DELIMITER ;


-- 9
/*
Crear el rol `organizer` y asignarle permisos de eliminación 
sobre la tabla `games` y permiso de actualización sobre la 
columna `games_name`  de la tabla `games` .
*/
CREATE ROLE organizer;
GRANT DELETE ON olympics.games TO organizer;
GRANT UPDATE (games_name) ON olympics.games TO organizer;