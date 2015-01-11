#! /bin/bash
uag="Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.1) Gecko/20090715 Firefox/3.5.1 (.NET CLR 3.5.30729)"
tag=$1
pref=$2
api_url=$3
pref_dl=$4
page=$5
bl_tags=$6
if [ ! -d $tag ];then
	mkdir "$tag"
fi
if [ ! -d $tag/new ];then
	mkdir "$tag/new"
fi
cd $tag
echo -e ">>>\E[36mСкачивание данных тэга\E[37m"
res=`curl -# "$api_url&tags=$tag$bl_tags&limit=1"`
postcount=`echo $res|grep -E -o -e 'posts\ count=\"[^"]+'|sed -e 's/posts\ count=//' -e 's/\"//'`
posts_on_page=`echo $res |grep -c -e "<post "`
if [ ! -z $postcount ]
	then
	if [ $postcount -ne 0 ];then
		echo -e ">>>\E[36mВсего постов: \E[37m$postcount"
		rm -f UrlsIds.txt
		let "pcount=postcount/1000"
		for ((i=0; i<=$pcount; i++));do
			`curl -# "$api_url&tags=$tag$bl_tags&limit=1000&$page=$i" |grep -E -o -e 'file_url=[^ ]+' -e ' id=[^ ]+'|sed -e 's/file_url=//g' -e 's/id=//g' -e 's/\"//g' >>UrlsIds.txt`
			echo -e "\n" >> UrlsIds.txt
			sed -i ':a;N;$!ba;s/\n / /g' UrlsIds.txt 
		done;
		grep -E -o -e ' [^\n]+' UrlsIds.txt |sed -e 's/ //g' > Ids.txt
		echo -e ">>>\E[32mДанные сохранены\E[37m"
	else
		echo -e ">>>\E[31mПостов почему-то нет. Изменили тег?\E[37m"
		echo "$tag" >> ../lost_tags.txt
	fi
elif [ $posts_on_page -gt 0 ]; then
	echo -e ">>>\E[36mОбщее количество постов неизвестно. Скачиваем постранично\E[37m"
	rm -f UrlsIds.txt
	i=1
	curl -# "$api_url&tags=$tag$bl_tags&limit=200&$page=$i" >> links.txt
	posts_on_page=`grep -c -e "post " links.txt`
	while [ $posts_on_page -gt 0 ]; do
		echo -e ">>>\E[36mПарсим (еще) \E[37m$posts_on_page \E[36mпостов\E[37m"
		grep -E -o -e 'file_url=[^ ]+' -e ' id=[^ ]+' links.txt|sed -e "s,file_url=,$pref_dl,g" -e 's/id=//g' -e 's/\"//g' >>UrlsIds.txt
		let "i++"
		sed -i ':a;N;$!ba;s/\n / /g' UrlsIds.txt 
		curl -# "$api_url&tags=$tag$bl_tags&limit=200&$page=$i" >> links.txt
		posts_on_page=`grep -c -e "post " links.txt`
	done
	rm -f links.txt
	grep -E -o -e ' [^\n]+' UrlsIds.txt |sed -e 's/ //g' > Ids.txt
	echo -e ">>>\E[32mДанные сохранены\E[37m"
else
	echo -e ">>>\E[31mОшибка при получении количества постов. Пропуск оставшихся операций\E[37m"
	echo "" > skip.flag
fi