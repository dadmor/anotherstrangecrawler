echo "Argument 1: $1"
mongo local --eval "var _domain='"$1"'; var _set={'lastQuery':false}" inc/add-object-to-mongodb.js

