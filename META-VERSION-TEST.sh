#!/bin/bash

#   Slick Progress Bar
#   Created by: Ian Brown (ijbrown@hotmail.com)
#   Please share with me your modifications
# Functions
PUT(){ echo -en "\033[${1};${2}H";}  
DRAW(){ echo -en "\033%";echo -en "\033(0";}         
WRITE(){ echo -en "\033(B";}  
HIDECURSOR(){ echo -en "\033[?25l";} 
NORM(){ echo -en "\033[?12l\033[?25h";}
function showBar {
        percDone=$(echo 'scale=2;'$1/$2*100 | bc)
        halfDone=$(echo $percDone/2 | bc) #I prefer a half sized bar graph
        barLen=$(echo ${percDone%'.00'})
        halfDone=`expr $halfDone + 6`
        tput bold
        PUT 8 5; printf "%4.4s  " $barLen% 
        PUT 8 10; printf "$1/$2         "   
        tput rev
        PUT 0 6; printf "                                                   "
        PUT 0 6; printf "$3"
        PUT 0 35;printf "$4"
        PUT 5 $halfDone;  echo -e "\033[7m \033[0m" #Draw the bar
        tput sgr0
        }
# Start Script
clear
HIDECURSOR
echo -e ""                                           
echo -e ""                                          
DRAW
echo -e "          PLEASE WAIT WHILE SCRIPT IS IN PROGRESS"
echo -e "    lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk"  
echo -e "    x                                                   x" 
echo -e "    mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj"
WRITE             
#-------------------------------------------------------------------


DATE=`date +%Y%m%d`
#mongo --eval "db = connect('localhost:27017/local');"
# This script have timeout problem

#count filelength
while IFS=, read col1
do
	(( length++ ))
done < "workspace/$DATE.csv"

#process csv
while IFS=, read col1
do
	(( i++ ))
	RESULT="`wget  -qO- $col1 -t 1 --timeout=15 | sed -n '/generator/s/.*name="generator"\s\+content="\([^"]\+\).*/\1/p'`"
	#echo "$i/$length $col1 __________ $RESULT"
	showBar $i $length $col1 $RESULT
	


	PUT 10 12                                           
	echo -e ""                                        
	NORM

	mongo local --eval "var _domain='"$col1"'; var _set={'metaGeneratorTest':\"$RESULT\"}" inc/add-object-to-mongodb.js

done < "workspace/$DATE.csv"






echo "------------------------------------------------------------"
echo '  _____ ___ ___ _____   ___ ___ _  _ ___ ___ _  _ ___ ___    '
echo ' |_   _| __/ __|_   _| | __|_ _| \| |_ _/ __| || | __|   \  '
echo '   | | | _|\__ \ | |   | _| | || .` || |\__ \ __ | _|| |) | '
echo '   |_| |___|___/ |_|   |_| |___|_|\_|___|___/_||_|___|___/  '
echo " "
echo "------------------------------------------------------------"


rm "workspace/$DATE.csv"
