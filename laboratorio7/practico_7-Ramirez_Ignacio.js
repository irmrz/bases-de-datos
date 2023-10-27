/*  Parte 1  */

/*  Ejercicio 1
Insertar 5 nuevos usuarios en la colección users. 
Para cada nuevo usuario creado, insertar al menos 
un comentario realizado por el usuario en la colección comments.
*/

db.users.insertMany([
    {name: 'Pepe Argento', email: 'pepe@gmail.com', password: 'papucho'},
    {name: 'Moni Argento', email: 'moni@gmail.com', password: 'mamucha'},
    {name: 'Coqui Argento', email: 'coqui@gmail.com', password: 'nosoycoqui'},
    {name: 'Paola Argento', email: 'paola@gmail.com', password: 'nosoypaola'},
    {name: 'Dardo NoArgento', email: 'dardo@gmail.com', password: 'nosoydardo'},
])


/*  Ejercicio 2
Listar el título, año, actores (cast), directores y rating de las 10 
películas con mayor rating (“imdb.rating”) de la década del 90. 
¿Cuál es el valor del rating de la película que tiene mayor rating? 
(Hint: Chequear que el valor de “imdb.rating” sea de tipo “double”).
*/

db.movies.find({$and:[{year:{$gte:1990}}, {year: {$lte:1999}}, {"imdb.rating":{$exists:true}}, {"imdb.rating":{$type:"double"}}]}, 
    {"title":1, year:1, "cast":1, "imdb.rating":1}
    ).sort({"imdb.rating":-1}
    ).limit(10)


/*  Ejericio 3
Listar el nombre, email, texto y fecha de los comentarios que la película 
con id (movie_id) ObjectId("573a1399f29313caabcee886") recibió entre los 
años 2014 y 2016 inclusive. Listar ordenados por fecha. Escribir una nueva 
consulta (modificando la anterior) para responder ¿Cuántos comentarios recibió?
*/

db.comments.find({$and:[
        {movie_id:ObjectId("573a1399f29313caabcee886")}, 
        {date:{$gte: ISODate("2014-01-01")}},
        {date:{$lte: ISODate("2016-12-31")}}]},
    {name:1, email:1, text:1, date:1}
    ).sort({date:1})

db.comments.find(
        {$and:[{movie_id:ObjectId("573a1399f29313caabcee886")}, 
        {date:{$gte: ISODate("2014-01-01")}},
        {date:{$lte: ISODate("2016-12-31")}}]},
    {name:1, email:1, text:1, date:1}
    ).sort(
        {date:1}
    ).count()    


/*  Ejercicio 4
Listar el nombre, id de la película, texto y fecha de los 3 
comentarios más recientes realizados por el usuario con 
email patricia_good@fakegmail.com.
*/

db.comments.find(
    {email:"patricia_good@fakegmail.com"},
    {name:1, movie_id:1, text:1, date:1}
    ).sort(
        {date:-1}
    ).limit(3)


/*  Ejercicio 5
Listar el título, idiomas (languages), géneros, fecha de lanzamiento 
(released) y número de votos (“imdb.votes”) de las películas de géneros 
Drama y Action (la película puede tener otros géneros adicionales), 
que solo están disponibles en un único idioma y por último tengan un 
rating (“imdb.rating”) mayor a 9 o bien tengan una duración (runtime) de 
al menos 180 minutos. Listar ordenados por fecha de lanzamiento y número de votos.
*/

db.movies.find(
    {$and:[
        {$or: [
            { genres: "Drama" },
            { genres: "Action" }
        ]}, 
        {languages: {$exists: true}},
        {languages: {$size: 1}},
        {$or: [{"imdb.rating":{$gt:9}}, {runtime: {$gte: 180}}]}
    ]},
    {title: 1, languages: 1, genres: 1, release: 1, "imdb.votes": 1}
).sort({release:1, "imdb.votes":-1})


/* Ejercicio 6
Listar el id del teatro (theaterId), estado (“location.address.state”), 
ciudad (“location.address.city”), y coordenadas (“location.geo.coordinates”)
de los teatros que se encuentran en algunos de los estados "CA", "NY", 
"TX" y el nombre de la ciudades comienza con una ‘F’. Listar ordenados 
por estado y ciudad.
*/

db.theaters.find(
    {$and: [
        {$or: [
            {"location.address.state": {$eq: "CA"}},
            {"location.address.state": {$eq: "NY"}},
            {"location.address.state": {$eq: "TX"}}
        ]},
        {"location.address.city": {$regex: /^F/}}]},
    {theaterId: 1, 
        "location.address.state": 1, 
        "location.address.city": 1,
        "location.geo.coordinates": 1
    }
).sort(
    {"location.address.state": -1, "location.address.city": -1}
)


/* Ejercicio 7
Actualizar los valores de los campos texto (text) y fecha (date) del 
comentario cuyo id es ObjectId("5b72236520a3277c015b3b73") a 
"mi mejor comentario" y fecha actual respectivamente.
*/

db.comments.updateOne(
    {_id: {$eq: ObjectId("5b72236520a3277c015b3b73")}},
    {
        $set: {text: "mi mejor comentario"},
        $currentDate: {date: true}
    }
)


/* Ejercicio 8
Actualizar el valor de la contraseña del usuario cuyo email es 
joel.macdonel@fakegmail.com a "some password". La misma 
consulta debe poder insertar un nuevo usuario en caso que 
el usuario no exista. Ejecute la consulta dos veces. 
¿Qué operación se realiza en cada caso?  (Hint: usar upserts).
*/

db.users.updateOne(
    {email: {$eq: "joel.macdonel@fakegmail.com"}},
    {$set: {password: "some password"}},
    {upsert: true}
)

/*
{
  acknowledged: true,
  insertedId: ObjectId("653c3f0d33cbd007e3a03d55"),
  matchedCount: 0,
  modifiedCount: 0,
  upsertedCount: 1
}
mflix> db.users.updateOne( { email: { $eq: "joel.macdonel@fakegmail.com" } }, { $set: { password: "some password" } }, { upsert: true } )
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 0,
  upsertedCount: 0
}
*/


/* Ejercicio 9
Remover todos los comentarios realizados por el usuario cuyo 
email es victor_patel@fakegmail.com durante el año 1980.
*/

db.comments.deleteMany(
    {$and: [
        {email: "victor_patel@fakegmail.com"},
        {date: {
            $gte: ISODate("1980-01-01T00:00:00Z"),
            $lt: ISODate("1981-01-01T00:00:00Z")
        }
}
    ]}
)

// DeletedCount: 21