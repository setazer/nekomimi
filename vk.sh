#! /bin/bash
id=$1
post_url=$2
api_url=$3
pref_dl=$4
URL=`curl -s "$api_url&tags=id:$id"|grep -E -o -e 'sample_url=[^ ]+'|sed -e "s/sample_url=/$pref_dl/g" -e 's/\"//g'`
echo "$post_url$id"
echo "$URL"