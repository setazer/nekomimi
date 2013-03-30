#! /bin/bash
cls
uag="Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.1) Gecko/20090715 Firefox/3.5.1 (.NET CLR 3.5.30729)"
scriptfolder=`pwd`
artfolder=`cat $scriptfolder/pictures-folder.txt`
while [ ! -d "$artfolder" ]; do
echo ">>>Основаная папка с пикчами не найдена"
echo ">>>Введите путь до папки с пикчами:"
read new_fold
echo $new_fold > pictures-folder.txt
done

pref=$2
serv_line=`grep "pref=\"$pref\"" servers.txt`
if [ -n "$serv_line" ]; then
name=`echo $serv_line | grep -E -o -e "name=\"[^\"]+" | sed -e "s/name=\"//"`
api_url=`echo $serv_line | grep -E -o -e "api_url=\"[^\"]+" | sed -e "s/api_url=\"//"`
post_url=`echo $serv_line | grep -E -o -e "post_url=\"[^\"]+" | sed -e "s/post_url=\"//"`
pref_dl=`echo $serv_line | grep -E -o -e "pref_dl=\"[^\"]+" | sed -e "s/pref_dl=\"//"`
page=`echo $serv_line | grep -E -o -e "page=\"[^\"]+" | sed -e "s/page=\"//"`
bl_tags=`echo $serv_line | grep -E -o -e "bl_tags=\"[^\"]+" | sed -r -e "s/bl_tags=\"//" -e "s/^/\+\-/" -e "s/ /\+\-/g"`
else
echo -e ">>>\E[31mПрефикс сервера не опознан\E[37m"
exit
fi
cd "$artfolder"
if [ ! -d $name ]
then
mkdir "$name"
fi
cd $name
case "$1" in
	-ua)
rm -f "$pref.NewPostsCount.txt"
ls -d */ |sed -e 's/\///g' > tags.txt
actual_lastpost=`wget "$api_url&limit=1" --no-check-certificate -q -U "$uag" -O -|grep -E -o -e ' id=\"[^"]+'|sed -e "s/ id=\"//" -e "s/\"//"`
echo -e ">>>\E[35mАктуальный ID: \E[37m$actual_lastpost"
if [ -e "global_lastpost.txt" ]; then
global_lastpost=$(cat global_lastpost.txt)
echo -e ">>>\E[35mАктуальный ID в прошлый раз: \E[37m$global_lastpost"
else
echo 0 > global_lastpost.txt
fi
total=`ls -d -1 */ | wc -l`
i=0
while read LINE; do
let i++
echo -e ">>>\E[35mОбработка тэга ($i/$total): \E[37m$LINE"
$scriptfolder/getinfo.sh "$LINE" "$pref" "$api_url" "$pref_dl" "$page" "$bl_tags"
$scriptfolder/dloader.sh "$LINE" "$pref" "$global_lastpost"
echo ">>>"
done < tags.txt
echo $actual_lastpost > global_lastpost.txt
rm -f tags.txt
echo -e ">>>\E[35mОбновление тэгов завершено\E[37m"
if [ -e "$pref.NewPostsCount.txt" ]; then
echo ">>>"
echo -e ">>>\E[35mНовые посты у тегов:\E[37m"
cat "$pref.NewPostsCount.txt"
echo -e ">>>\E[35mОткрыть папки с новыми тэгами?\E[37m(y/n)"
read ans
if [ "$ans" == "y" ]; then
$scriptfolder/show_new.sh
fi
fi
;;
	-u)
if [ -d "$3" ]
then
rm -f "$pref.NewPostsCount.txt"
echo -e ">>>\E[35mОбработка тэга: \E[37m$3"
$scriptfolder/getinfo.sh "$3" "$pref" "$api_url" "$pref_dl" "$page" "$bl_tags"
$scriptfolder/dloader.sh "$3" "$pref" "$global_lastpost"
echo -e ">>>\E[35mОбновление тэга завершено\E[37m"
if [ -e "$pref.NewPostsCount.txt" ]; then
echo ">>>"
echo -e ">>>\E[35mОткрыть папку с новыми постами?\E[37m(y/n)"
read ans
if [ "$ans" == "y" ]; then
cd $3
start new
cd ..
fi
fi
else
echo -e ">>>\E[31mТэг \E[37m'$3' \E[31mне найден!\E[37m"
fi
;;
	-n)
rm -f "$pref.NewPostsCount.txt"
echo -e ">>>\E[35mОбработка тэга: \E[37m$3"
$scriptfolder/getinfo.sh "$3" "$pref" "$api_url" "$pref_dl" "$page" "$bl_tags"
$scriptfolder/dloader.sh "$3" "$pref" "0"
echo -e ">>>\E[35mСкачивание тэга завершено\E[37m"
if [ -e "$pref.NewPostsCount.txt" ]; then
echo ">>>"
echo -e ">>>\E[35mОткрыть папку с новыми постами?\E[37m(y/n)"
read ans
if [ "$ans" == "y" ]; then
cd $3
start new
fi
fi
;;
	-l)
$scriptfolder/genlink.sh "$post_url" "$3"
;;
	-gp)
echo -e ">>>\E[35mСкачивание поста \E[37m'$3'"
$scriptfolder/get.sh "$pref" "$3" "$api_url" "$pref_dl"
echo -e ">>>\E[35mСкачивание завершено\E[37m"
;;
	-sn)
$scriptfolder/show_new.sh "$pref"
;;
	-mv)
$scriptfolder/movenew.sh
echo -e ">>>\E[32mПеремещение завершено\E[37m"
;;
	-vk)
	$scriptfolder/vk.sh "$3" "$post_url" "$api_url" "$pref_dl" 
;;
	--help)
cat $scriptfolder/README.txt
;;
	*)
echo "Для вывода справки попробуйте sapphire.sh --help"
esac