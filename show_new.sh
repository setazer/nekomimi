#! /bin/bash
echo "#! /bin/bash" >starter.sh
ls -d */ | sed -e 's/\///g' > tags.txt
while read LINE; do
cd "$LINE/new"
if [ `ls -1 | wc -l` -gt 0 ]
then
echo ">>>Будет открыта папка: $LINE"
echo "cd \"$LINE\"" >> ../../starter.sh
echo "start new" >> ../../starter.sh
echo "cd .." >> ../../starter.sh
fi
cd ../..
done < tags.txt
rm -f tags.txt
starter.sh
rm -f starter.sh
