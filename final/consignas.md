# Examen Final Bases de datos 

Marzo 2024

## Parte 1: SQL

### Para cargar la base de datos ejecutar los siguientes comandos:

``` bash
$ mysql -h <host> -u <user> -p<password> < data.sql
$ mysql -h <host> -u <user> -p<password> < schema.sql
```

### Consignas

Trabajaremos sobre la base de datos ​“company” cuyo diagrama se presenta en el archivo eer-model.jpg. ​El script `​schema.sql` ​contiene los DDLs de la tablas mientras que el script ​data.sql ​contiene los datos de la misma.

1. Crear una vista que muestre el nombre apellido, cantidad de dependientes, salario, departamento y horas trabajadas en cada proyecto junto con el nombre del proyecto. Ordenar por apellido y nombre.
2. Definamos la métrica salario por tamaño de grupo familiar (SPTGF) como el salario del empleado dividido por el tamaño de su grupo familiar (en el que el empleado mismo está incluido). Muestre el nombre, apellido, tamaño del grupo familiar y SPTGF.
3. Crear un procedimiento que tome el número de seguro social (ssn) y un nuevo salario como parámetros y actualice el salario del empleado en la tabla de empleados. Llamar al procedimiento para actualizar el salario del empleado con el número de seguro social 123456789 a $9.99.
4. Extender el esquema de la base de datos al agregar una nueva tabla llamada employee_certification, que mantiene un registro de las certificaciones que tienen los empleados. Cada certificación tiene un id, el número de seguro social del empleado, el nombre de la certificación y la fecha en que se obtuvo. 

## Parte 2: MongoDB

### Para cargar la base de datos ejecutar los siguientes comandos:

```bash
$ tar xzvf mflix.tar.gz
$ mongorestore --host <host> --drop --db mflix mflix/
```

### Consignas
Usaremos la base de datos `mflix` (la pueden bajar de [aquí](https://famaf.aulavirtual.unc.edu.ar/mod/resource/view.php?id=8058)) que contiene información sobre películas. La base de datos contiene las siguientes colecciones:

- movies: Contiene información de las películas, incluyendo título, año de estreno, y director.
- theaters: Contiene ubicaciones de salas de cine.
- users: Contiene información del usuario.
- comments: Contiene comentarios asociados a películas específicas
- sessions: Campo de metadatos. Contiene JSON Web Token de los usuarios.

1. Mostrar los 10 directores mejor valorados en imdb de Argentina con más de 3 películas. Mostrar el nombre del director, el rating medio y el número de películas y la lista de los nombres de sus peliculas
2. Mostrar todos los comentarios de las películas de Guillermo Francella. Mostrar el nombre del usuario, el email, el texto del comentario, el título de la película y el género de la película
3. Especificar reglas de validación en la colección `movies` utilizando JSON Schema. Validar que tenga título, año, imdb, lastupdated, countries, directors, genres y runtime. Dar validaciones razonables para cada campo. Dar un ejemplo de inserción que cumpla con las reglas de validación. Para los géneros usen un enum con los valores de los géneros que existen en la colección (buscarlos con una mini-query)

# Puntos a tener en cuenta
- Algunos nombres de columnas o tablas pueden ser palabras reservadas de SQL. Para evitar problemas, utilizar `` `backticks` ``:
- E.g. SELECT u.username FROM `` `user` `` u;
- Mostrar únicamente los campos pedidos en la consigna y en el orden en el que se los pide (tanto a nivel fila como a nivel columna).
- Buscar hacer la consulta de la forma más sencilla posible.
- Se evaluará el correcto formato de las soluciones:
- El código entregado debe ser legible.
- No escribir toda la consulta en una sola línea. Usen buen criterio para separar partes de la consulta.
- Utilizar mayúsculas para denotar palabras clave de SQL (e.g. `SELECT`, `INSERT`, `FROM`, etc.).

# Detalle Importante
El alumno puede usar sus notas personales e internet, pero queda prohibido utilizar modelos generativos (Chat-GPT, LLAMA, etc) y comunicarse con otras personas oral o digitalmente. 
Romper alguna de estas dos restricciones invalida el examen

