/* Parte 1 */

use('mflix');

// 1

db.users.insertMany(
    [
        {
            "name": 'Garcilaso de la Vega',
            "email": 'garcilaso@yahoo.com',
            "password": 'nololeinunca'
        },
        {
            "name": 'Calderon de la Barca',
            "email": 'calderonkpo@gmail.com',
            "password": 'lavidaesunsueño',
        },
        {
            "name": 'Francisco de Quevedo',
            "email": 'panchoquevedo@gmail.com',
            "password": 'pocosydoctos',
        },
        {
            "name": 'Lope de Vega',
            "email": 'felix@gmail.com',
            "password": 'ladamaboba',
        },
        {
            "name": 'Luis de Gongora',
            "email": 'luisillo@yahoo.com',
            "password": 'noentiendo',
        }
    ]
)

db.comments.insertMany(
    [
        {
            "name": 'Garcilaso de la Vega',
            "email": 'garcilaso@yahoo.com',
            "movie_id": ObjectId("573a1390f29313caabcd4132") ,
            "text": "Muy bueno",
            "date": new Date
        },
        {
            "name": 'Calderon de la Barca',
            "email": 'calderonkpo@gmail.com',
            "movie_id": ObjectId("573a1390f29313caabcd4132") ,
            "text": "Muy waso",
            "date": new Date
        },
        {
            "name": 'Francisco de Quevedo',
            "email": 'panchoquevedo@gmail.com',
            "movie_id": ObjectId("573a1390f29313caabcd4132") ,
            "text": "Tremendo che",
            "date": new Date
        },
        {
            "name": 'Lope de Vega',
            "email": 'felix@gmail.com',
            "movie_id": ObjectId("573a1390f29313caabcd4132") ,
            "text": "El loquito la vió",
            "date": new Date
        },
        {
            "name": 'Luis de Gongora',
            "email": 'luisillo@yahoo.com',
            "movie_id": ObjectId("573a1390f29313caabcd4132") ,
            "text": "Fascinado",
            "date": new Date
        }
    ]
)

// 2

db.movies.find(
    {$and: [
        {"imdb.rating": {$type : 1}},
        {"year": {$gte : 1990}},
        {"year": {$lt : 2000}}
    ]},
    {"title":1, "year":1, "cast":1, "directors":1, "imdb.rating":1}
).sort(
    {"imdb.rating": -1}
).limit(10)

// 3

db.comments.find(
    {
        $and: [
            {"movie_id": {$eq: ObjectId("573a1399f29313caabcee886")}},
            {"date": {$gte: ISODate("2014-01-01")}},
            {"date": {$lte: ISODate('2016-12-31')}}
        ]
    },
    {
        "name": 1,
        "email": 1,
        "text": 1,
        "date": 1
    }
).sort(
    {"date": 1}
)

// para saber cuantos comentarios recibió:

db.comments.find(
    {
        $and: [
            {"movie_id": {$eq: ObjectId("573a1399f29313caabcee886")}},
            {"date": {$gte: ISODate("2014-01-01")}},
            {"date": {$lte: ISODate('2016-12-31')}}
        ]
    },
    {
        "name": 1,
        "email": 1,
        "text": 1,
        "date": 1
    }
).sort(
    {"date": 1}
).count()

// 4

db.comments.find(
    {
        "email": {$eq : "patricia_good@fakegmail.com"}
    },
    {
        "name": 1,
        "movie_id": 1,
        "text": 1,
        "date": 1
    }
).sort(
    {"date": -1}
).limit(3)

// 5

db.movies.find(
    {
        $and: [
            {"released": {$exists: true}},
            {"languages": {$size : 1}},
            {"genres": {$all: ["Drama", "Action"]}},
            {$or: [
                {"imdb.rating": {$gt: 9}},
                {"runtime": {$gte: 180}}
            ]}
        ]
    },
    {
        "title":1,
        "languages":1,
        "genres":1,
        "released":1,
        "imdb.votes": 1,
        "imdb.rating": 1,
        "runtime": 1
    }
).sort(
    {"released": 1,
    "imdb.votes": -1}
)

// 6

db.theaters.find(
    {
        $and: [
        {"location.address.city": /^F.*/},
        {$or: [
            {"location.address.state": {$eq : "CA"}},
            {"location.address.state": {$eq : "NY"}},
            {"location.address.state": {$eq : "TX"}}
        ]}
        ]
    },
    {
        "theaterId": 1,
        "location.address.state": 1,
        "location.address.city": 1,
        "location.geo.coordinates": 1
    }
).sort(
    {
        "location.address.city": 1,
        "location.address.state": 1
    }
)

// 7

db.comments.updateOne(
    {
        "_id": {$eq: ObjectId("5b72236520a3277c015b3b73")}
    },
    {
        $set: {
            "text": "mi mejor comentario",
            "date": new Date()
        }
    }
)

// 8

db.users.updateOne(
    {
        "email": {$eq: "joel.macdonel@fakegmail.com"}
    },
    {
        $set: {
            "password": "some password"
        }
    },
    {
        upsert: true
    }
)
/* 
En la primera corrida tenemos:
  acknowledged: true,
  insertedId: ObjectId("65b97a36c2e7c49f3ea6e41f"),
  matchedCount: 0,
  modifiedCount: 0,
  upsertedCount: 1
  
En la segunda:
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 0,
  upsertedCount: 0
  */

// 9

db.comments.deleteMany(
    {
        $and: [
            {"email": "victor_patel@fakegmail.com"},
            {"date": {$gte: ISODate("1980-01-01")}},
            {"date": {$lt: ISODate("1981-01-01")}}
        ]
    }
)
// { acknowledged: true, deletedCount: 21 }

/* Parte 2 */

use('restaurantdb');

// 10
/* 
    Lo que hace elem match es encontrar un elemento que satisfaga las condiciones 
*/
db.restaurants.find(
    {
        'grades': {
            $elemMatch: {
                $and: [
                    {'score': {$gt: 70}},
                    {'score': {$lte: 90}},
                    {'date': {$gte: ISODate('2014-01-01')}},
                    {'date': {$lte: ISODate('2015-12-31')}}
                ]
            }
        }
    },
    {
        'restaurant_id': 1,
        'grades': 1
    }
)

// 11

db.restaurants.updateMany(
    {
        'restaurant_id': '50018608'
    },
    {
       $addToSet: {
        'grades': {
            $each: [
                {
                    "date" : ISODate("2019-10-10T00:00:00Z"),
                    "grade" : "A",
                    "score" : 18
                },
                {
                    "date" : ISODate("2020-02-25T00:00:00Z"),
                    "grade" : "A",
                    "score" : 21
                } 
            ]           
        }
       } 
    }
)