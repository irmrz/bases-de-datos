-- 1
-- Error: despues de foreign key no van parentesis.

CREATE TABLE stocks (
    store_id INT NOT NULL,
    product_id  INT NOT NULL,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY store_id REFERENCES stores (store_id),
    FOREIGN KEY product_id REFERENCES products (product_id)
);


-- 2
/*
Listar los precios de lista máximos y mínimos en cada categoría retornando
solamente aquellas categorías que tiene el precio de lista máximo superior 
a 5000 o el precio de lista mínimo inferior a 400 
*/

SELECT categories.category_id,
    MAX(list_price) AS MaxPrecio,
    MIN(list_price) AS MinPrecio
FROM categories
INNER JOIN products ON categories.category_id = products.category_id
GROUP BY category_id
HAVING MaxPrecio > 4000 or MinPrecio < 400;


-- 3
/*
Crear un procedimiento `add_product_stock_to_store` que tomará un
nombre de store, un nombre de producto y una cantidad entera donde
actualizará la cantidad del producto en la store especificada (i.e., solo sumará el
valor de entrada al valor corriente en la tabla `stocks`).
*/

DELIMITER //
CREATE PROCEDURE add_product_stock_to_store (IN store_identifier VARCHAR (255), 
                                             IN product_identifier VARCHAR (255),
                                             IN new_quantity INT)
BEGIN
    UPDATE stocks
    SET quantity = quantity + new_quantity
    WHERE store_id = (SELECT store_id FROM stores WHERE store_name = store_identifier)
      AND product_id = (SELECT product_id FROM products WHERE product_name = product_identifier);
END//
DELIMITER ;


-- 4
/*
Crear un trigger llamado `decrease_product_stock_on_store` que decrementará 
el valor del campo `quantity` de la tabla `stocks` con el valor
del campo `quantity` de la tabla `order_items`.
El trigger se ejecutará luego de un `INSERT` en la tabla `order_items` y deberá
actualizar el valor en la tabla `stocks` de acuerdo al valor correspondiente.
*/

DELIMITER //
CREATE TRIGGER decrease_product_stock_on_store
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE stocks 
    SET quantity = quantity - NEW.quantity
    WHERE store_id = (SELECT store_id 
                      FROM orders 
                      WHERE order_id = NEW.order_id)
        AND product_id = NEW.product_id;
END //
DELIMITER;


-- 5
/*
Devuelva el precio de lista promedio por brand para todos los productos con
modelo de año (`model_year`) entre 2016 y 2018.
*/

SELECT brands.brand_id,
        brands.brand_name, 
        AVG(list_price) AS Promedio,
        model_year
FROM brands
INNER JOIN products ON (products.brand_id = brands.brand_id)
WHERE model_year BETWEEN 2016 AND 2018
GROUP BY brand_id, model_year
ORDER BY brands.brand_id;


-- 6
/*
Liste el número de productos y ventas para cada categoría de producto.
Tener en cuenta que una venta (`orders` table) es completada cuando la
columna `order_status` = 4.
*/

SELECT
    c.category_id,
    c.category_name,
    COUNT(DISTINCT p.product_id) AS num_products,
    SUM(o.order_status = 4) AS num_sales
FROM
    categories c
JOIN
    products p ON c.category_id = p.category_id
LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
LEFT JOIN
    orders o ON oi.order_id = o.order_id
GROUP BY
    c.category_id, c.category_name;


-- 7
/*
Crear el rol `human_care_dept` y asignarle permisos de creación sobre la tabla
`staffs` y permiso de actualización sobre la columna `active` de la tabla
`staffs`.
*/

CREATE ROLE human_care_dept;
GRANT INSERT ON bicyclestores.staffs TO human_care_dept;
GRANT UPDATE (active) ON bicyclestores.staffs TO human_care_dept;