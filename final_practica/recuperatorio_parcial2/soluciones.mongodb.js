// 1

db.movies.aggregate([
    {
        $unwind: "$genres"
    },
    {
        $group: {
          _id: "$genres",
          'tiempo_promedio': {
            $avg: '$runtime'
          }
        }
    },
    {
        $sort: {
          'tiempo_promedio': -1
        }
    },
    {
        $limit: 3
    },
    {
        $addFields: {
          'Genero': '$_id'
        }
    },
    {
        $project: {
          'Genero':1,
          '_id':0,
          'tiempo_promedio':1
        }
    }
])

// 2

db.movies.aggregate([
    {
        $unwind: '$genres'
    },
    {
        $group: {
          _id: '$genres',
          'largo_promedio_titulo': {
            $avg: {$strLenCP: '$genres'}
          }
        }
    },
    {
        $sort: {
          'largo_promedio_titulo': -1
        }
    },
    {
        $addFields: {
          'Genero': '$_id'
        }
    },
    {
        $project: {
            '_id':0,
            'Genero':1,
            'largo_promedio_titulo':1
        }
    }
])

// 3

db.comments.aggregate([
    {
        $lookup: {
          from: "movies",
          localField: "movie_id",
          foreignField: "_id",
          as: "mvs"
        }
    },
    {
        $group: {
          _id: "$email",
          'años_distintos': {
            $addToSet: "$mvs.year"
          }
        }
    },
    {
        $project: {
          'email': '$_id',
          'diversidad': {$size: "$años_distintos"},
          '_id': 0
        }
    },
    {
        $sort: {
          'diversidad': -1
        }
    }
])


// 4

db.runCommand({
    collMod:  'theaters',
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['theaterId', 'location', 'geo'],
            properties: {
                'theaterId': {
                    bsonType: 'Int',
                    description: 'ID must be an integer'
                },
                'location': {
                    
                }
            }
        }
    }
})