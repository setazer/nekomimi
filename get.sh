#! /bin/bash
pref=$1
id=$2
api_url=$3
pref_dl=$4
if [ "$pref_dl" == "-" ]; then
pref_dl=""
fi 
URL=`curl -# "$api_url&tags=id:$2"|grep -E -o -e 'file_url=[^ ]+'|sed -e "s/file_url=/$pref_dl/g" -e 's/\"//g'`
filename=`basename "$URL" |sed -e "s/%20/ /g" -e "s/%28/(/g" -e "s/%29/)/g"`
ext=`echo "\"$filename\"" | grep -E -o -e "\.[^\"]{3,4}\""|sed -e "s/\"//g"`
wget -c $URL
mv "$filename" "$pref.$2$ext"