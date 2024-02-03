/* 1 */

db.theaters.aggregate([
    {
        $group: {
          _id: '$location.address.state',
          cantidadDeCines: {$count: {}}
        }
    }
])

/* 2 */

db.theaters.aggregate([
    {
        $group: {
          _id: '$location.address.state',
          cantidadDeCines: {$count: {}}
        }
    },
    {
        $match: {
          'cantidadDeCines': {$gte: 2}
        }
    },
    {
        $count: 'Estados con mas de dos cines registrados'
    }
])

/* 3 */

db.movies.aggregate([
    {
        $match: {
          'directors': {$all: ['Louis Lumière']}
        }
    },
    {
        $count: 'Dirigidas por Lumiere'
    }
])

/* 4 */

db.movies.aggregate([
    {
        $match: {
          'year': {$gte: 1950, $lte: 1959}
        }
    },
    {
        $count: 'Peliculas de los 50s'
    }
])

/* 5 */

db.movies.aggregate([
    {
        $unwind: '$genres'
    },
    {
        $group: {
          _id: '$genres',
          porGenero: {
            $count: {}
          }
        }
    },
    {
        $sort: {
          porGenero: -1
        }
    },
    {
        $limit: 10
    }
])

/* 6 */

db.comments.aggregate([
    {
        $group: {
          _id: '$email',
          'Nombre': {$first: '$name'},
          'Mail': {$first: '$email'},
          cantidadComentarios: {
            $count: {}
          }
        }
    },
    {
        $sort: {
          cantidadComentarios: -1
        }
    },
    {
        $limit: 10
    }
])

/* 7 */

db.movies.aggregate([
    {
        $match: {
          $and : [
            {'year': {$gte: 1980, $lte: 1989}},
            {'imdb.rating': {$ne: ''}}
          ]
        }
    },
    {
        $group: {
          _id: '$year',
          'maxRating': {
            $max: '$imdb.rating'
          },
          'avgRating': {
            $avg: '$imdb.rating'
          },
          'minRating': {
            $min: '$imdb.rating'
          }
        }
    },
    {
        $sort: {
          'avgRating': -1
        }
    }
])

/* 8 */

db.movies.aggregate([
    {
        $lookup: {
          from: 'comments',
          localField: '_id',
          foreignField: 'movie_id',
          as: 'cmmts'
        }
    },
    {
        $project: {
          'title': 1,
          'year': 1,
          'cantidadComentarios': {$size: '$cmmts'}
        }
    },
    {
        $sort: {
          'cantidadComentarios': -1
        }
    },
    {
        $limit: 10
    }
])

/* 9 */

db.createView(
    'mostCommentedGenres',
    'movies',
    [
    {
        $lookup: {
          from: 'comments',
          localField: '_id',
          foreignField: 'movie_id',
          as: 'cmmts'
        }
    },
    {
        $unwind: '$genres'
    },
    {
        $group: {
          _id: '$genres',
          genre: {$first: '$genres'},
          comment_amount: {
            $sum: {$size : '$cmmts'}
          }
        }
    },
    {
        $project: {
          '_id': 0,
          'genre': 1,
          'comment_amount': 1
        }
    },
    {
        $sort: {
          comment_amount: -1
        }
    },
    {
        $limit: 5
    }
])

/* 10 */

db.movies.aggregate([
    {
        $match: {
          'directors': {$all: ['Jules Bass']}
        }
    },
    {
        $unwind: '$cast'
    },
    {
        $group: {
          _id: '$cast',
          'actor/actriz': {$first: '$cast'},
          peliculasConJules: {
            $addToSet: {
                'title': '$title',
                'year': '$year'
            }
          }
        }
    },
    {
        $match: {
            'peliculasConJules.1': {$exists: true}
        }
    },
    {
        $project: {
          'actor/actriz': 1,
          'peliculasConJules': 1,
          '_id': 0
        }
    }
])

/* 11 

db.comments.aggregate([
    {
        $lookup: {
          from: 'movies',
          let: {
            'movie_id': '$movie_id',
            'comment_date': '$date'
          },
          pipeline: [
            
          ],
          as: 'result'
        }
    }
])
*/ 

/* 12 */

/*  
Consigna: 
Listar el id y nombre de los restaurantes junto con su puntuación máxima,
mínima y la suma total. Se puede asumir que el restaurant_id es único. 
*/

/* a. Resolver con $group y accumulators */

