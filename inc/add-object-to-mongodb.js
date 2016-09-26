db.MyCollection.update(
   {domain:_domain},
   {$set:_set},
   { upsert: true}
)
db.MyCollection.ensureIndex( { "domain": 1 }, { unique: true } )


