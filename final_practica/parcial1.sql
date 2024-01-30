-- 1

alter table person
add column total_medals int not null default 0;

-- 2

CREATE VIEW medallas_por_persona AS
SELECT person.id AS pid, COUNT(medal_id) AS medallas
FROM person
INNER JOIN `games_competitor` ON person.id = games_competitor.person_id
INNER JOIN `competitor_event` ON games_competitor.id = competitor_event.competitor_id
WHERE medal_id != 4 AND medal_id IS NOT NULL
GROUP BY pid;

UPDATE person, medallas_por_persona
set person.total_medals = medallas_por_persona.medallas
WHERE person.id = medallas_por_persona.pid;

-- 3

CREATE View pais_persona AS
SELECT person.id as pid, person.full_name, noc_region.id as region_id, noc_region.region_name
FROM person
INNER JOIN person_region ON person.id = person_region.person_id
INNER JOIN noc_region ON region_id = noc_region.id;

CREATE View medalla_persona AS
SELECT person.id as pid, medal_name, medal_id
FROM person
INNER JOIN `games_competitor` ON person.id = games_competitor.person_id
INNER JOIN `competitor_event` ON games_competitor.id = competitor_event.competitor_id
INNER JOIN `medal` ON medal.id = competitor_event.medal_id
WHERE medal_id != 4 AND medal_id IS NOT NULL;

SELECT pais_persona.full_name as 'Nombre', 
        medal_name as 'Nombre medalla', 
        COUNT(*) as Medallas
FROM pais_persona
INNER JOIN medalla_persona ON pais_persona.pid = medalla_persona.pid
WHERE region_id = 9
GROUP BY Nombre, medal_name
ORDER BY full_name;

-- 4

CREATE View deporte_evento AS
SELECT `event`.id,`event`.sport_id as did, sport.sport_name as dep
FROM `event`
INNER JOIN sport ON `event`.sport_id = sport.id;

CREATE VIEW medallas_persona_evento AS
SELECT person.id AS pid, competitor_event.event_id as eid, COUNT(medal_id) AS medallas
FROM person
INNER JOIN `games_competitor` ON person.id = games_competitor.person_id
INNER JOIN `competitor_event` ON games_competitor.id = competitor_event.competitor_id
WHERE medal_id != 4 AND medal_id IS NOT NULL
GROUP BY pid, eid;

SELECT dep, SUM(medallas)
from deporte_evento
INNER JOIN medallas_persona_evento ON medallas_persona_evento.eid = deporte_evento.id
inner JOIN pais_persona ON pais_persona.pid = medallas_persona_evento.pid
WHERE pais_persona.region_id = 9
GROUP BY dep;

-- 5

select pais_persona.region_name, medal_name, COUNT(*)
FROM medalla_persona
INNER JOIN pais_persona ON medalla_persona.pid = pais_persona.pid
GROUP BY pais_persona.region_name, medal_name
ORDER BY pais_persona.region_name;

-- 6
(
    SELECT region_name, SUM(medallas) as total
    FROM (
        select pais_persona.region_name, medal_name, COUNT(*) as medallas
        FROM medalla_persona
        INNER JOIN pais_persona ON medalla_persona.pid = pais_persona.pid
        GROUP BY pais_persona.region_name, medal_name
        ORDER BY pais_persona.region_name
    ) as distinguidas
    GROUP BY region_name
    ORDER BY total desc
    LIMIT 1
)
UNION
(
    SELECT region_name, SUM(medallas) as total
    FROM (
        select pais_persona.region_name, medal_name, COUNT(*) as medallas
        FROM medalla_persona
        INNER JOIN pais_persona ON medalla_persona.pid = pais_persona.pid
        GROUP BY pais_persona.region_name, medal_name
        ORDER BY pais_persona.region_name
    ) as distinguidas
    GROUP BY region_name
    ORDER BY total ASC
    LIMIT 1
);

-- 7

-- a
CREATE Trigger `increse_number_of_medals`
AFTER INSERT ON competitor_event
for each row
    UPDATE person
    set total_medals = total_medals + 1
    WHERE new.competitor_id = person.id;

-- b
create trigger `decrease_number_of_medals`
after delete on competitor_event
for each row
    update person
    set total_medals = total_medals - 1
    where old.competitor_id = person.id;

-- 8

create Procedure `add_new_medalists` (IN `event_id` INT,
    in `g_id` int, in `s_id` int, in `b_id` int)
insert into competitor_event(event_id, competitor_id, medal_id)
VALUES
    (`event_id`, `g_id`, 1),
    (`event_id`, `s_id`, 2),
    (`event_id`, `b_id`, 3);  

-- 9

create role `organizer`;

grant DELETE ON olympics.`games` to `organizer`;

grant update (games_name) ON olympics.`games` to `organizer`;