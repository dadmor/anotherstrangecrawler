RESULT="`mongo --quiet local inc/mongo-export-csv.js`" 
echo "$RESULT" > workspace/`date +%Y%m%d`.csv
echo "------------------------"
echo "export domains completed"
