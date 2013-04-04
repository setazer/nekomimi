#! /bin/bash
pref=$1
id=$2
api_url=$3
pref_dl=$4
URL=`wget --no-check-certificate -q -U "$uag" "$api_url&tags=id:$id" -O - |grep -E -o -e 'file_url=[^ ]+' |sed -e 's/file_url=//g' -e 's/\"//g'`
ext=`echo "\"$URL\"" | grep -E -o -e "\.[^\"]{3,4}\""|sed -e "s/\"//g"`
wget -c "$pref_dl$URL" -O $pref.$id$ext