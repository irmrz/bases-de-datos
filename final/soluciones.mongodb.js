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
          'peliculas.2': {'$exists': true}
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
          'nombre_director': '$_id',
          'rating_promedio': 1,
          'cantidad_peliculas': 1,
          'peliculas': 1,
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
        $project: {
          'comentarios.name': 1,
          'comentarios.email': 1,
          'comentarios.text': 1,
          'title': 1,
          'genres': 1,
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
                            bsonType: 'double'
                        },
                        'votes': {
                            bsonType: 'int'
                        },
                        'id': {
                            bsonType: 'int'
                        }
                    }
                },
                'lastupdated': {
                    bsonType: 'string' // Es una fecha formateada como string
                },
                'countries': {
                    bsonType: 'object',
                    items: {
                        bsonType: 'string'
                    }
                },
                'directors': {
                    bsonType: 'object',
                    items: {
                        bsonType: 'string'
                    }
                },
                'genres' : {
                    enum: ['Animation',  'Biography',   'Comedy',
                    'Crime',      'Documentary', 'Drama',
                    'Family',     'Fantasy',     'Film-Noir',
                    'History',    'Horror',      'Music',
                    'Musical',    'Mystery',     'News',
                    'Reality-TV', 'Romance',     'Sci-Fi',
                    'Short',      'Sport',       'Talk-Show',
                    'Thriller',   'War',         'Western', 'Action', 'Adventure']
                },
                'runtime': {
                    bsonType: 'int'
                }
            }
        }
    }
})

/* Buscar generos de las peliculas */ 

db.movies.distinct('genres')

/* Ejemplos de insercion que cumple las reglas */

