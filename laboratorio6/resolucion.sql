-- 1
-- Seleccionar la oficina con el mayor numero de empleados
SELECT offices.officeCode,
    COUNT((employeeNumber)) AS empleados
FROM offices 
INNER JOIN employees ON (employees.officeCode = offices.officeCode)
GROUP BY offices.officeCode
ORDER BY empleados DESC 
LIMIT 1;

-- 2 
/*
¿Cuál es el promedio de órdenes hechas por oficina?,
¿Qué oficina vendió la mayor cantidad de productos?
*/

SELECT employees.officeCode as office_empleado,
    COUNT(orders.orderNumber) as order_counter
FROM orders
INNER JOIN customers ON (orders.customerNumber = customers.customerNumber)
INNER JOIN employees ON (employees.employeeNumber = customers.salesRepEmployeeNumber)
GROUP BY office_empleado;


-- 3
/* Devolver el valor promedio, máximo y mínimo
de pagos que se hacen por mes */

SELECT MONTH(paymentDate) AS mes,
    AVG(amount),
    MAX(amount),
    MIN(amount)
FROM payments
GROUP BY mes
ORDER BY mes;

-- 4
/* Crear un procedimiento "Update Credit" en donde 
se modifique el límite de crédito de un cliente con 
un valor pasado por parámetro. */

DELIMITER //
CREATE PROCEDURE update_credit (IN customerNum int(11), IN newLimit DECIMAL (10,2))
BEGIN
    UPDATE customers
    SET creditLimit = newLimit
    WHERE customerNumber = customerNum;
END //
DELIMITER ;


-- 5
/* Cree una vista "Premium Customers" que devuelva 
el top 10 de clientes que más dinero han gastado 
en la plataforma. La vista deberá devolver el nombre 
del cliente, la ciudad y el total gastado por ese 
cliente en la plataforma. */

CREATE VIEW premium_customers AS
SELECT customerName, city, SUM(amount) AS Gastado
FROM customers
INNER JOIN payments ON (payments.customerNumber = customers.customerNumber)
GROUP BY customerName
ORDER BY Gastado DESC
LIMIT 10;

-- 6
/* Cree una función "employee of the month" que tome 
un mes y un año y devuelve el empleado (nombre y apellido) 
cuyos clientes hayan efectuado la mayor cantidad de órdenes en ese mes.
*/

