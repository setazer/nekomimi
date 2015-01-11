#! /bin/bash
uag="Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.1) Gecko/20090715 Firefox/3.5.1 (.NET CLR 3.5.30729)"
tag=$1
pref=$2
cd $tag
if [ -a skip.flag ];then
	exit
fi
if [ -a "lastpost.txt" ];then
	lastpost=$(cat "lastpost.txt")
	if [ ! -z $lastpost ];then
		echo -e ">>>\E[32mФайл последнего поста найден\E[37m"
		echo -e ">>>\E[36mID последнего поста: \E[37m$lastpost"
		exit
	fi
fi
lastpost=0
echo -e ">>>\E[31mID последнего поста не найден. Генерация по имеющимся пикчам\E[37m"
ls "$pref*.*" | grep -E -o -e "[0-9]+" > files.txt
while read LINE; do
	if [ $lastpost -lt $LINE ];then
		let "lastpost=LINE"
	fi
done < files.txt
rm files.txt
echo -e ">>>\E[32mОпределен ID последнего: \E[37m$lastpost"
if [ $lastpost -gt 0 ];then
	echo $lastpost > "lastpost.txt"
else
	echo "0" > "lastpost.txt"
fi
