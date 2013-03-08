#! /bin/bash
echo ">>>Список серверов"
if [ -a servers.txt ]; then
while read LINE; do
#echo $LINE
pref=`echo $LINE | grep -E -o -e "pref=\"[^\"]+" | sed -e "s/pref=\"//"`
name=`echo $LINE | grep -E -o -e "name=\"[^\"]+" | sed -e "s/name=\"//"`
echo ">>>$pref - $name"
done < servers.txt
else
echo ">>>Список серверов пуст"
echo ">>>Внесите хотя бы 1 сервер в файл servers.txt"
#echo "pref=\" \" name=\" \" api_url=\" \" lim=\" \" page=\" \"" > servers.txt
exit
fi
