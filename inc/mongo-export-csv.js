var query=null;
var query = { pageInsideCms : null }
var query = { metaGeneratorTest: /.*WordPress 2.*/ }
var query = { metaGeneratorTest : null }


db.MyCollection.find(query).forEach(function(MyCollection){
  print(MyCollection.domain);
});