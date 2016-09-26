#!/bin/bash
# usage:
# bash script.sh readfile > savefile

DATE=`date +%Y%m%d`



mongo --eval "db = connect('localhost:27017/local');"
#mongo --eval "db.adminCommand('listDatabases');"
#mongo --eval "printjson(db.getCollectionNames());"

#mongo --eval "db = connect('local')"
while IFS=, read col1 col2
do

	WPCONTENT="`curl -o /dev/null --silent --head --write-out '%{http_code}' "$col1/wp-content"`"
	README="`curl -o /dev/null --silent --head --write-out '%{http_code}' "$col1/readme.html"`"
	echo "\"$col1\",\"$col2\",\"$WPCONTENT\",\"$README\""
	
	#echo "\"$LINE\",\"$WPCONTENT\",\"$README\"" >> output.csv
	mongo local --eval "var _domain='"$col1"'; var _set={'404Test':'"$WPCONTENT"','readmeTest':'"$README"','lastQuery':'"$col2"'}" inc/add-object-to-mongodb.js

done < "workspace/$DATE.csv"

echo "------------------------------------------------------------"
echo '  _____ ___ ___ _____   ___ ___ _  _ ___ ___ _  _ ___ ___    '
echo ' |_   _| __/ __|_   _| | __|_ _| \| |_ _/ __| || | __|   \  '
echo '   | | | _|\__ \ | |   | _| | || .` || |\__ \ __ | _|| |) | '
echo '   |_| |___|___/ |_|   |_| |___|_|\_|___|___/_||_|___|___/  '
echo " "
echo "------------------------------------------------------------"

rm "workspace/$DATE.csv"