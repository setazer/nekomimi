#! /bin/bash
ls -d */ | sed -e 's/\///g' > tags.txt
while read LINE; do
cd "$LINE/new"
if [ `ls -1 | wc -l` -gt 0 ]
then
mv -f *.* ../
echo -e ">>>\E[36mПеремещение новых постов тэга: \E[37m$LINE"
fi
cd ../..
done < tags.txt
rm -f tags.txt
