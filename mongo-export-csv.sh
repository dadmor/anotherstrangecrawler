RESULT="`mongo --quiet demoDb ../inc/mongo-export-csv.js`" 
echo "$RESULT" > ../processed-files/crawled-domains/domains-`date +%Y-%m-%d`.csv
