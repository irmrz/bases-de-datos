-- 1

SELECT officeCode, COUNT(employeeNumber) AS cantidad_empleados
FROM employees
GROUP BY officeCode
ORDER BY cantidad_empleados DESC
LIMIT 1;

-- 2

SELECT officeCode, AVG(ordersPerOffice)
FROM (
    SELECT officeCode, COUNT(orders.orderNumber) AS ordersPerOffice
    FROM employees
    INNER JOIN customers ON customers.salesRepEmployeeNumber = employees.employeeNumber
    INNER JOIN orders ON orders.customerNumber = customers.customerNumber
    GROUP BY officeCode
) AS officeOrders;

SELECT officeCode, COUNT(orders.orderNumber) AS ordersPerOffice
FROM employees
INNER JOIN customers ON customers.salesRepEmployeeNumber = employees.employeeNumber
INNER JOIN orders ON orders.customerNumber = customers.customerNumber
GROUP BY officeCode
ORDER BY ordersPerOffice DESC
LIMIT 1;

-- 3

SELECT MONTH(paymentDate) as Mes, AVG(amount), MAX(amount), MIN(amount)
FROM payments
GROUP BY Mes
ORDER BY Mes ASC;

-- 4

CREATE PROCEDURE update_credit(IN customer_id INT(11), IN new_limit DECIMAL(10,2))
UPDATE customers
SET creditLimit = new_limit
WHERE customerNumber = customer_id;

-- 5

CREATE VIEW Premium_Customers AS
SELECT customers.contactFirstName,
        customers.contactLastName,
        SUM(payments.amount) AS gastado
FROM customers
INNER JOIN payments ON payments.customerNumber = customers.customerNumber
GROUP BY customers.contactFirstName, customers.contactLastName      
ORDER BY gastado DESC
LIMIT 10;

-- 6

CREATE FUNCTION employee_of_the_month(mon MONTH, y YEAR)
BEGIN
    SELECT firstName, lastName
    FROM (
        SELECT employees.firstName, 
                employees.lastName,
                customers.salesRepEmployeeNumber, 
                COUNT(orderNumber) AS por_cliente
        FROM orders
        INNER JOIN customers ON customers.customernumber = orders.customerNumber
        INNER JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
        WHERE MONTH(orders.orderDate) = mon AND YEAR(orders.orderDate) = y
        GROUP BY employees.firstName, 
                employees.lastName,
                customers.salesRepEmployeeNumber
        ORDER BY por_cliente DESC
        LIMIT 1
    ) as empleado_mes;

    return CONCAT(firstName, " ",  lastName );
END

-- 7

CREATE TABLE product_refillment(
    refillment_id INT NOT NULL AUTO_INCREMENT,
    productCode varchar(15) NOT NULL,
    orderDate date not null,
    quantity SMALLINT not null,
    PRIMARY KEY (refillment_id),
    Foreign Key (productCode) REFERENCES products(productCode)
);

-- 8

CREATE TRIGGER restock_product
AFTER INSERT ON orderdetails
for each row
    insert into product_refillment(productCode, quantity, orderDate)
    SELECT orderdetails.productCode, quantityOrdered * 0 + 10, CURRENT_DATE
    FROM orderdetails
    INNER JOIN products on products.productCode = orderdetails.productCode
    WHERE products.quantityInStock - orderdetails.quantityordered < 10;

-- 9

create role Empleado;

grant select ON * TO Empleado;

grant create view on * to Empleado;