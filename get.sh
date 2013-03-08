#! /bin/bash
URL=`curl -# "http://youhate.us/index.php?page=dapi&s=post&q=index&id=$1"|grep -E -o -e 'file_url=[^ ]+'|sed -e 's/file_url=//g' -e 's/\"//g'`
filename=`basename $URL`
ext=`echo $filename | grep -E -o -e '\..+'`
wget -c $URL
mv $filename $1$ext
if [ -d $2 ];then
mv $1$ext $2
else
mv $1$ext "+unsorted/"
fi