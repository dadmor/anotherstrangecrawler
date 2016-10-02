#!/bin/bash
DATE=`date +%Y%m%d`



mongo --eval "db = connect('localhost:27017/local');"
#mongo --eval "db.adminCommand('listDatabases');"
#mongo --eval "printjson(db.getCollectionNames());"

#mongo --eval "db = connect('local')"
while IFS=, read col1 
do

	echo "# $col1"
	RESULT="`wget -qO- $col1 |
		grep -Eoi '\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b'`"

	
	if [ -z "$RESULT" ]
	then
	  echo "brak maili"
	  mongo local --eval "var _domain='"$col1"'; var _set={'emails':'false'}" inc/add-object-to-mongodb.js
	else
	  echo "$RESULT"
	  mongo local --eval "var _domain='"$col1"'; var _set={'emails':'"$RESULT"'}" inc/add-object-to-mongodb.js
	fi
	

done < "workspace/$DATE.csv"

echo "------------------------------------------------------------"
echo '  _____ ___ ___ _____   ___ ___ _  _ ___ ___ _  _ ___ ___    '
echo ' |_   _| __/ __|_   _| | __|_ _| \| |_ _/ __| || | __|   \  '
echo '   | | | _|\__ \ | |   | _| | || .` || |\__ \ __ | _|| |) | '
echo '   |_| |___|___/ |_|   |_| |___|_|\_|___|___/_||_|___|___/  '
echo " "
echo "------------------------------------------------------------"

rm "workspace/$DATE.csv"