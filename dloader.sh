#! /bin/bash
tag=$1
pref=$2
new_dload=$3
cd $tag

if [ -a skip.flag ];then
	rm -f skip.flag
	exit
fi

linen=0;
if [ "$new_dload" == "false" ];then
	lastpost=$(cat "lastpost.txt")
elif [ "$new_dload" == "true" ];then
	lastpost=0
fi

while read LINE; do
	if [ $LINE -le $lastpost ];then
		break
	fi
	let "linen=linen+1"
done < Ids.txt

if [ $linen -ne 0 ];then
	echo -e ">>>\E[32mНайдены новые посты\E[37m"
	echo -e ">>>\E[36mВсего: \E[37m$linen"
	echo "$tag: $linen" >> "../$pref.NewPostsCount.txt"
	if [ -d "new" ];then
		head -n $linen UrlsIds.txt |sed -e "s/ / $pref./g" > new/UrlsIds.txt
		cd new
	else
		head -n $linen UrlsIds.txt |sed -e "s/ / $pref./g" > UrlsIds.txt
	fi
	i=1
	while read LINE; do
		ext=`echo "$LINE" | grep -E -o -e "\.[^ ]{3,4} "|sed -e "s/ //g"`
		echo -e ">>>\E[36mСкачивание поста $i/$linen\E[37m"
		gelproxy=`echo "$LINE" | grep -o -e "/gelbooru"`
		if [ "$gelproxy" == "/gelbooru" ];then
			echo $LINE$ext | awk '{print "wget --no-check-certificate -nc -nv "$1" -O "$2" -e use_proxy=on -e http_proxy=proxy.antizapret.prostovpn.org:3128"}' | bash
		else
			echo $LINE$ext | awk '{print "wget --no-check-certificate -nc -nv "$1" -O "$2" -e use_proxy=off"}' | bash
		fi
		let "i++"
	done < UrlsIds.txt
	rm -f UrlsIds.txt
	cd ..
	echo -e ">>>\E[32mСкачивание '$tag' завершено\E[37m"
else
	echo -e ">>>\E[31mНовые посты не найдены\E[37m"
fi

head -n 1 Ids.txt > lastpost.txt
rm -f UrlsIds.txt
rm -f Ids.txt