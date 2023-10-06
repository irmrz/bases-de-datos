## Funciones de Agregacion:
- Ej: count, min, max
- Siempre que haya una funcion de agregación en el select junto con una columna normal hay que usar el GROUP BY
para "agregar" a esa columna normal el resultado de la funcion.

## NEW
- En el contexto de un trigger en MySQL, NEW es un alias que se utiliza para referirse a la fila recién insertada en la tabla que activó el trigger. En este caso, el trigger está configurado para ejecutarse después de una inserción en la tabla order_items, por lo que NEW.quantity representa la cantidad recién insertada en la columna quantity de la tabla order_items en la fila que desencadenó el trigger.
- Cuando se realiza una inserción en order_items, el trigger captura esa nueva fila, y NEW.quantity es el valor de la columna quantity en esa fila específica. Este valor se utiliza en la instrucción UPDATE para decrementar la cantidad correspondiente en la tabla stocks.

## Piden valor minimo y maximo
- Se puede hacer dos subqueries en el HAVING o el WHERE usando un OR para separarlas
-Ejemplo: parcial 2022-10-14 ejercicio 3

### Agregar columna
- Ejemplo: `ALTER TABLE user ADD number_of_reviews INT NOT NULL DEFAULT 0;`

### Modificar columna sin cambiarle el nombre
- `ALTER TABLE reviews MODIFY comment VARCHAR (250) NOT NULL;`

### Asegurar unicidad
- `UNIQUE KEY nombre (columna1, columna2)`

### Procedimientos donde solo se actualiza en un valor de una tabla
- `Create procedure ... (..) UPDATE nombreTabla SET nombreColumna = ..hacer algo.. WHERE condicion  `

### TRIGGERS
- Siempre tiene que tener la declaracion `FOR EACH ROW` ya que lo que sigue define el cuerpo del trigger.
- INSERT -> NEW
- DELETE -> OLD
- In an UPDATE trigger, you can use OLD.col_name to refer to the columns of a row before it is updated and NEW.col_name to refer to the columns of the row after it is updated.