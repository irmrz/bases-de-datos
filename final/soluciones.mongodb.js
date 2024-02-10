/* Ignacio Tomas Ramirez - DNI: 44432780 */

/* 1 */

db.movies.aggregate([
    {
        $match: {
          'countries': 'Argentina'
        }
    },
    {
        $unwind: '$directors'
    },
    {
        $group: {
          _id: '$directors',
          'peliculas': {
            $addToSet: '$title'
          },
          'rating_promedio': {
            $avg: '$imdb.rating'
          },
          'cantidad_peliculas': {
            $count: {}
          }
        }
    },
    {
        $match: {
          'peliculas.3': {'$exists': true}
        }
    },
    {
        $sort: {
          'rating_promedio': -1
        }
    },
    {
        $limit: 10
    },
    {
        $project: {
          '_nombre_director': '$_id',
          '_rating_promedio': '$rating_promedio',
          '_cantidad_peliculas': '$cantidad_peliculas',
          '_peliculas': '$peliculas',
          '_id': 0
        }
    }
])

/* 2 */

db.movies.aggregate([
    {
        $match: {
          'cast': 'Guillermo Francella'
        }
    },
    {
        $lookup: {
          from: 'comments',
          localField: '_id',
          foreignField: 'movie_id',
          as: 'comentarios'
        }
    },
    {
        $unwind: '$comentarios'
    },
    {
        $addFields: {
          'nombre': '$comentarios.name',
          'email': '$comentarios.email',
          'texto': '$comentarios.text'
        }
    },
    {
        $project: {
          '_nombre': "$nombre",
          '_email': "$email",
          '_texto': "$texto",
          '_pelicula': "$title",
          '_generos': "$genres",
          '_id': 0
        }
    }
])

/* 3 */

db.runCommand({
    collMod: 'movies',
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['title', 'year', 'imdb','lastupdated', 'countries', 'directors', 'genres', 'runtime'],
            properties: {
                'title': {
                    bsonType: 'string',
                    description: 'Title must be a string'
                },
                'year':{
                    bsonType: 'int',
                    description: 'Year must be an integer'
                },
                'imdb': {
                    bsonType: 'object',
                    required: ['rating', 'votes', 'id'],
                    properties: {
                        'rating': {
                            bsonType: 'double',
                            description: 'Rating must be a DOUBLE'
                        },
                        'votes': {
                            bsonType: 'int',
                            description: 'The number of votes must be an integer'
                        },
                        'id': {
                            bsonType: 'int',
                            description: 'The id from imdb must be an integer'
                        }
                    }
                },
                'lastupdated': {
                    bsonType: 'date', // Es una fecha formateada como string
                    description: 'It must be a Date'
                },
                'countries': {
                    bsonType: 'array',
                    items: {
                        bsonType: 'string'
                    },
                    minItems: 1,
                    description: 'It must be an array of strings'
                },
                'directors': {
                    bsonType: 'array',
                    items: {
                        bsonType: 'string'
                    },
                    minItems: 1,
                    description: 'It must be an array of strings'
                },
                'genres' : {
                    bsonType: 'array',
                    minItems: 1,
                    items: {
                        enum: ['Animation',  'Biography',   'Comedy',
                    'Crime',      'Documentary', 'Drama',
                    'Family',     'Fantasy',     'Film-Noir',
                    'History',    'Horror',      'Music',
                    'Musical',    'Mystery',     'News',
                    'Reality-TV', 'Romance',     'Sci-Fi',
                    'Short',      'Sport',       'Talk-Show',
                    'Thriller',   'War',         'Western', 'Action', 'Adventure']
                    },
                    description: 'The genre must be one of the listed strings'
                },
                'runtime': {
                    bsonType: 'int',
                    description: 'The runtime in minutes must be an integer'
                }
            }
        }
    }
})

/* Query para buscar generos de las peliculas */ 

db.movies.distinct('genres')

/* Ejemplos de insercion que cumple las reglas */

db.movies.insertOne({
    title: 'El Padrino',
    year: 1972,
    imdb: {rating: 9.2, votes: 932000, id: 72},
    lastupdated: new Date(),
    countries: ['USA', 'ITALY'],
    directors: ['Francis Ford Coppola'],
    genres: ['Drama'],
    runtime: 175
})