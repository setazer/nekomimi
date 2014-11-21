#! /bin/bash
uag="Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.1) Gecko/20090715 Firefox/3.5.1 (.NET CLR 3.5.30729)"
id=$1
pref=$2
pool_url=$3
if [ ! -d $id ];then
	mkdir "$id"
fi
cd $id
echo -e ">>>\E[36mСкачивание данных тэга\E[37m"
res=`wget "$pool_url$id" --no-check-certificate -q -U "$uag" -O -`
postcount=`echo $res|grep -E -o -e 'post_count=\"[^"]+'|sed -e 's/post_count=\"//' -e 's/\"//'`
if [ ! -z $postcount ];then
	echo -e ">>>\E[36mВсего постов: \E[37m$postcount"
	rm -f UrlsIds.txt
	echo $res |grep -E -o -e 'file_url=[^ ]+' -e ' id=[^ ]+'|sed -e 's/file_url=//g' -e 's/id=//g' -e 's/\"//g' >>UrlsIds.txt
	sed '1d' UrlsIds.txt | sed -n '{h;${p;q;};n;G;p;}' >UrlsIds.txt
	sed -i ':a;N;$!ba;s/\n / /g' UrlsIds.txt 
	grep -E -o -e ' [^\n]+' UrlsIds.txt |sed -e 's/ //g' > Ids.txt
	echo -e ">>>\E[32mДанные сохранены\E[37m"
else
	echo -e ">>>\E[31mОшибка при получении количества постов. Пропуск оставшихся операций\E[37m"
	echo "" > skip.flag
fi