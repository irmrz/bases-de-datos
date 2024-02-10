/* Ignacio Tomas Ramirez - DNI: 44432780 */

/* 1 */

CREATE VIEW informacion_empleado AS 
WITH cantidad_a_cargo AS
(
    SELECT essn AS responsable, count(*) AS cantidad
    FROM dependent
    GROUP BY essn
),
departamento AS
(
    SELECT ssn, dname
    FROM employee
    INNER JOIN department ON employee.dno = department.dnumber
),
horas_trabajadas AS
(
    SELECT essn, pno, pname,SUM(hours) AS horas
    FROM works_on
    INNER JOIN project ON works_on.pno = project.pnumber
    GROUP BY essn, pno, pname
)
SELECT fname AS nombre, 
        lname AS apellido,
        COALESCE(cantidad_a_cargo.cantidad, 0) AS cantidad_dependientes,
        salary AS salario,
        departamento.dname AS departamento,
        horas_trabajadas.pname AS proyecto,
        horas_trabajadas.horas
FROM employee
LEFT join cantidad_a_cargo ON cantidad_a_cargo.responsable = employee.ssn
INNER JOIN departamento ON departamento.ssn = employee.ssn
INNER JOIN horas_trabajadas ON horas_trabajadas.essn = employee.ssn
ORDER BY apellido, nombre;

/* 2 */

WITH cantidad_a_cargo AS
(
    SELECT essn AS responsable, count(*) AS cantidad
    FROM dependent
    GROUP BY essn
)
SELECT fname AS nombre, 
        lname AS apellido, 
        COALESCE(cantidad_a_cargo.cantidad, 1) AS tamano_familia,
        salary / COALESCE(cantidad_a_cargo.cantidad, 1) AS SPTGF
FROM employee
LEFT JOIN cantidad_a_cargo ON cantidad_a_cargo.responsable = employee.ssn
ORDER BY nombre;

/* 3 */

CREATE PROCEDURE update_salary (IN update_to CHAR(9), IN new_salary DECIMAL(7,2))
UPDATE employee 
SET salary = new_salary
WHERE employee.ssn = update_to;

CALL update_salary('123456789', 9.99);

/* 4 */

CREATE TABLE employee_certification
(
    `cert_id` INT NOT NULL,
    `essn` CHAR(9) NOT NULL,
    `cert_name` CHAR(40) NOT NULL,
    `date_given` DATE NOT NULL,
    PRIMARY KEY (`cert_id`),
    FOREIGN KEY (`essn`) REFERENCES employee(ssn)
);