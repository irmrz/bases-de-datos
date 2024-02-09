/* 1 */

db.sales.aggregate([
    {
        $match: {
          $and: [
            {'storeLocation': {$in: ["London", "Austin", "San Diego"]}},
            {'customer.age': {$gte: 18}},
            {'items.price': {$gte: 1000}},
            {$or: [
                {'items.tags': "school"},
                {'items.tags': "kids"}
            ]}
          ]
        }
    },
    {
        $addFields: {
          'sale': '$_id'
        }
    },
    {
        $project: {
          '_id': 0,
          'sale': 1,
          'saleDate': 1,
          'storeLocation': 1,
          'customer.email': 1
        }
    }
])

/* 2 */

db.sales.aggregate([
    {
        $match: {
            $and: [
                {'storeLocation': "Seattle"},
                {$or: [
                    {'purchaseMethod': "In store"},
                    {'purchaseMethod': "Online"}
                ]},
                {'saleDate': {$gte: ISODate("2014-02-01")}},
                {'saleDate': {$lte: ISODate("2015-01-31")}},
            ]
        }
    },
    {
        $project: {
          '_id': 0,
          'customer.email': 1,
          'customer.satisfaction': 1,
          'costoTotal': {
            $sum: {
                $map: {
                   input: "$items", 
                   in: {$multiply: ["$$this.price", "$$this.quantity"]}
                }
            }
          }
        }
    },
    {
        $sort: {
          'customer.satisfaction': -1
        }
    }
])

/* 3 */

db.sales.aggregate([
    {
        $addFields: {
          "saleMonth": {$month: "$saleDate"},
          "saleYear": {$year: "$saleDate"},
          "totalSum": {
            $sum: {
                $map: {
                  "input": "$items",
                  "in": { $multiply: ["$$this.price", "$$this.quantity"] }
                }
              }
          }
        }
    },
    {
        $group: {
          _id: {
            "saleMonth": "$saleMonth",
            "saleYear": "$saleYear"
          },
          "montoMin": {
            $min: "$totalSum"
          },
          "montoMax": {
            $max: "$totalSum"
          },
          "montoPromedio": {
            $avg: "$totalSum"
          },
          "montoTotal": {
            $sum: "$totalSum"
          }
        }
    },
    {
        $project: {
          '_id': 0,
          'saleMonth': "$_id.saleMonth",
          'saleYear': "$_id.saleYear",
          'montoMin': {$toDouble: "$montoMin"},
          'montoPromedio': {$toDouble: "$montoPromedio"},
          'montoMax': {$toDouble: "$montoMax"},
          'montoTotal': {$toDouble: "$montoTotal"},
        }
    },
    {
        $sort: {
          'saleYear': 1,
          'saleMonth': 1
        }
    }
])

/* 4 */

