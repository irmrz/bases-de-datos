/* 1 */
with proyecto_horas AS 
(
    SELECT pno, SUM(hours) AS horas
    from works_on
    GROUP BY pno
    HAVING horas >= 50
)
SELECT pname, horas
FROM project, proyecto_horas
WHERE pnumber = proyecto_horas.pno
ORDER BY horas DESC;

/* 2 */
(
    SELECT ssn, fname, minit, lname
    FROM employee
)
except
(
    SELECT ssn, fname, minit, lname
    FROM employee
    JOIN dependent ON employee.ssn = dependent.essn
);

/* 3 */

with research as (
select pnumber, pname, dname
from project
inner join department on project.dnum = department.dnumber
WHERE dname = 'Research'
)
SELECT DISTINCT ssn, fname, minit, lname
FROM employee
JOIN works_on ON employee.ssn = works_on.essn
join research on works_on.pno = research.pnumber;

/* 4 */

create Procedure dept_projects (in dept_name char(15))
    with 
    por_proyecto AS 
    (
        SELECT dnum, pno, pname, SUM(hours) AS horas, count(*) AS cantidad
        from works_on
        join project on works_on.pno = project.pnumber
        GROUP BY pno, pname
    )
    SELECT pname AS nombre_proyecto, cantidad AS empleados, horas
    FROM por_proyecto
    join department ON por_proyecto.dnum = department.dnumber
    where dname = dept_name;