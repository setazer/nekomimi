#! /bin/bash
ls -d */ | grep -v -e '+' |sed -e 's/\///g' > tags.txt
while read LINE; do
if [ -e *.* ]
then
mv -f $LINE/new/*.* $LINE/
echo -e ">>>\E[36mПеремещение новых постов тэга: \E[37m$LINE"
fi
done < tags.txt
rm -f tags.txt
