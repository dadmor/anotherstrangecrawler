#https://wiki.knownhost.com/cms/find-cms-version
#https://www.unixmen.com/scan-check-wordpress-website-security-using-wpscan-nmap-nikto/
#http://www.cvedetails.com/vulnerability-list/vendor_id-2337/product_id-4096/version_id-100796/Wordpress-Wordpress-3.0.1.html
#!/bin/bash
DATE=`date +%Y%m%d`
#mongo --eval "db = connect('localhost:27017/local');"


while IFS=, read col1 
do

	echo $col1

	value=$(
	  curl -s "https://www.googleapis.com/pagespeedonline/v3beta1/mobileReady?url=http://$col1" |
	  ruby -rjson -e 'data = JSON.parse(STDIN.read); puts data["pageStats"]["cms"]'
	)
	
	echo '-------------------'

	mongo local --eval "var _domain='"$col1"'; var _set={'pageInsideCms':'"$value"'}" inc/add-object-to-mongodb.js


done < "workspace/$DATE.csv"

echo "------------------------------------------------------------"
echo '  _____ ___ ___ _____   ___ ___ _  _ ___ ___ _  _ ___ ___    '
echo ' |_   _| __/ __|_   _| | __|_ _| \| |_ _/ __| || | __|   \  '
echo '   | | | _|\__ \ | |   | _| | || .` || |\__ \ __ | _|| |) | '
echo '   |_| |___|___/ |_|   |_| |___|_|\_|___|___/_||_|___|___/  '
echo " "
echo "------------------------------------------------------------"

rm "workspace/$DATE.csv"