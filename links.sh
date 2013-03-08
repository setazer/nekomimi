#! /bin/bash
echo "Link: http://gelbooru.com/index.php?page=post&s=view&id=$1"
URL=`curl -# "http://youhate.us/index.php?page=dapi&s=post&q=index&id=$1"|grep -E -o -e 'file_url=[^ ]+' -e 'sample_url=[^ ]+'`
file=`echo $URL | grep -E -o -e 'file_url=[^ ]+' |sed -e 's/file_url=//' -e 's/\"//g'`
sample=`echo $URL | grep -E -o -e 'sample_url=[^ ]+' |sed -e 's/sample_url=//' -e 's/\"//g'`
echo "File Link:"
echo $file
echo "Sample Link:"
echo $sample
