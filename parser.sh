echo $1
echo $2

phantomjs inc/bingparser.js $1 --proxy=$2
DATE=`date +%Y%m%d`
while IFS=, read col1 
do

	echo "\"$col1\""
	#echo "\"$LINE\",\"$WPCONTENT\",\"$README\"" >> output.csv
	mongo local --eval "var _domain='"$col1"'; var _set={'lastQuery':'"$1"'}" inc/add-object-to-mongodb.js

done < "workspace/$DATE.csv"

echo "------------------------------------------------------------"
echo '  _____ ___ ___ _____   ___ ___ _  _ ___ ___ _  _ ___ ___    '
echo ' |_   _| __/ __|_   _| | __|_ _| \| |_ _/ __| || | __|   \  '
echo '   | | | _|\__ \ | |   | _| | || .` || |\__ \ __ | _|| |) | '
echo '   |_| |___|___/ |_|   |_| |___|_|\_|___|___/_||_|___|___/  '
echo " "
echo "------------------------------------------------------------"

rm "workspace/$DATE.csv"