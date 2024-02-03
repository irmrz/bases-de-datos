/* 1 */

db.runCommand({
    collMod: 'users',
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['name', 'email', 'password'],
            properties: {
                name: {
                    bsonType: 'string',
                    maxLength: 30,
                    description: 'Name of the user'
                },
                email: {
                    bsonType: 'string',
                    pattern: "^(.*)@(.*)\\.(.{2,4})$",
                    description: "email must be a string and is required",
                },
                password: {
                    bsonType: 'string',
                    minLength: 50,
                    description: 'password must be a string with at least 50 characters '
                }
            }
        }
    }
})

/* Inserciones invalidas */

db.users.insertOne({
    name: "John Malkovich",
    email: "juan@fakegmail.com",
    password: "palmas"
})

db.users.insertOne({
    name: "John Malkovich",
    email: "juanfakegmail.com",
    password: "$2b$12$UREFwsRUoyF0CRqGNK0LzO0HM/jLhgUCNNIJ9RJAqMUQ74crlJ1Vu"
})

db.users.insertOne({
    name: "John Malkovich The Third AKA THE LAST OF THE DINASTY",
    email: "juan@fakegmail.com",
    password: "$2b$12$UREFwsRUoyF0CRqGNK0LzO0HM/jLhgUCNNIJ9RJAqMUQ74crlJ1Vu"
})

/* Insercion Valida */

db.users.insertOne({
    name: "John Malkovich",
    email: "juan@fakegmail.com",
    password: "$2b$12$UREFwsRUoyF0CRqGNK0LzO0HM/jLhgUCNNIJ9RJAqMUQ74crlJ1Vu"
})

/* 2 */

db.getCollectionInfos( { name: "users" } )

/* 3 */

db.runCommand({
    collMod: "theaters",
    validator: {$jsonSchema: {
      bsonType: "object"  ,
      required: ["theaterId", "location"],
      properties: {
        theaterId: {
            bsonType: "int",
            description: "The ID of the theater must be an INT"
        },
        location: {
            bsonType: "object",
            required: ["address"],
            properties: {
                address: {
                    bsonType: "object",
                    required: ["street1", "city", "state", "zipcode"],
                    properties: {
                        street1: {
                            bsonType: "string",
                            description: "Name of the street must be a string and it is requiered"
                        },
                        city: {
                            bsonType: "string",
                            description: "Name of the city must be a string and it is requiered"
                        },
                        state: {
                            bsonType: "string",
                            description: "state must be a string and is requiered"
                        },
                        zipcode: {
                            bsonType: "string",
                            description: "zipcode must be a string and is requiered"
                        }
                    }
                },
                geo: {
                    bsonType: "object",
                    properties: {
                        type: {
                            enum: ["Point", null]
                        },
                        coordinates: {
                            bsonType: "array",
                            maxItems: 2,
                            minItems: 2,
                            items: {
                                bsonType: "double"
                            }
                        }
                    }
                }
            }

        }
      }
    }},
    validationLevel: "moderate",
    validationAction: "warn"
})

/* 5 */

db.createCollection(
    "userProfiles",
    {
        validator: {
            $jsonSchema: {
                bsonType: "object",
                required: ["user_id", "language"],
                properties: {
                    user_id: {
                        bsonType: "objectId"
                    },
                    language: {
                        enum: ["English", "Spanish", "Portuguese"]
                    },
                    favorite_genres: {
                        bsonType: "array",
                        items: {
                            bsonType: "string"
                        },
                        uniqueItems: true
                    }
                }
            }
        }
    }
)

db.userProfiles.insertOne({
    user_id: new Object, language: "Cantonese"
})

db.userProfiles.insertOne({
    user_id: ObjectId(), language: "English"
})

/* 6 */ 

/*
Identificar los distintos tipos de relaciones (One-To-One, One-To-Many) 
en las colecciones movies y comments. Determinar si se usó documentos 
anidados o referencias en cada relación y justificar la razón */

/* 
- Entre movies y comments hay una relacion uno a varios con comments en el lado varios.
Para cada documento de comments hay un atributo movie_id que actua como clave foranea 
de movies. Para cada pelicula hay muchos comentarios.

- Entre comments y users hay una relacion varios a uno del lado varios en comments.
Cada comentario tiene asociado el mail que le corresponde a un usuario (y que es unico
por cada uno).

- Tambien entre comments y users tenemos el name, que el name en un comment es el mismo 
nombre del users.name.

En los casos nombrados siempre se usaron referencias.
*/


/* 7 */

/* Querys */
/* 
Query 1: Listar el id, titulo, y precio de los libros y sus categorías de un autor en particular
Entidades: books - categories
Relaciones: categories(1) -> books(varios)

Query 2: Cantidad de libros por categorías
Entidades: books - categories
Relaciones: categories(1) -> books(varios)

Query 3: Listar el nombre y dirección entrega y el monto total (quantity * price) 
de sus pedidos para un order_id dado.
Entidades: orders - order_details
Relaciones: orders(1) -> order_details(varios)
Hay un order_detail por cada libro de la orden
*/

/* Usando modelo de datos anidados */

db.createCollection(
    "books",
    {
        validator: {
            $jsonSchema: {
                bsonType: "object",
                required: ["book_id", "title", "author", "price", "category"],
                properties: {
                    book_id: {
                        bsonType: "objectId",
                    },
                    title: {
                        bsonType: "string",
                        maxLength: 70
                    },
                    author: {
                        bsonType: "string",
                        maxLength: 70
                    },
                    price: {
                        bsonType: "double",
                    },
                    category: {
                        bsonType: "string",
                        maxLength: 70
                    }
                }
            }
        }
    }
)

db.books.insertMany([
    {
        book_id: ObjectId(),
        title: "The Lord Of The Rings",
        author: "Gordo Tolkien",
        price: 1.71,
        category: "Fantasy"
    },
    {
        book_id: ObjectId(),
        title: "Hunger Games: Sin Ajo",
        author: "Lola Mento",
        price: 2.49,
        category: "Sci-Fi"
    },
    {
        book_id: ObjectId(),
        title: "Game Of Thrones",
        author: "J.R.R Martin",
        price: 5.12,
        category: "Fantasy"
    }
])

db.books.aggregate([
    {
        $group: {
          _id: "$category",
          cantidadLibros: {
            $count: {}
          }
        }
    }
])