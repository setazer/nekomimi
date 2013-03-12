#! /bin/bash
while [ ! -d "$(cat pictures-folder.txt)" ]
do
echo ">>>Основаная папка с пикчами не найдена"
echo ">>>Введите путь до папки с пикчами:"
read new_fold
echo $new_fold > pictures-folder.txt
done
scriptfolder=`pwd`
pref=$2
serv_line=`grep "pref=\"$pref\"" servers.txt`
if [ -n "$serv_line" ]; then
name=`echo $serv_line | grep -E -o -e "name=\"[^\"]+" | sed -e "s/name=\"//"`
api_url=`echo $serv_line | grep -E -o -e "api_url=\"[^\"]+" | sed -e "s/api_url=\"//"`
post_url=`echo $serv_line | grep -E -o -e "post_url=\"[^\"]+" | sed -e "s/post_url=\"//"`
pref_dl=`echo $serv_line | grep -E -o -e "pref_dl=\"[^\"]*" | sed -e "s/pref_dl=\"//"`
page=`echo $serv_line | grep -E -o -e "page=\"[^\"]+" | sed -e "s/page=\"//"`
bl_tags=`echo $serv_line | grep -E -o -e "bl_tags=\"[^\"]+" | sed -r -e "s/bl_tags=\"//" -e "s/^/\+\-/" -e "s/ /\+\-/g"`
else
echo -e ">>>\E[31mПрефикс сервера не опознан\E[37m"
exit
fi
cd "$(cat pictures-folder.txt)"
if [ ! -d $name ]
then
mkdir "$name"
fi
cd $name
case "$1" in
	-ua)
rm -f "$pref.NewPostsCount.txt"
ls -d */ | grep -v -e '+' |sed -e 's/\///g' > tags.txt
i=0
total=`ls -d -1 */ | wc -l`
while read LINE; do
let i++
echo -e ">>>\E[35mОбработка тэга ($i/$total): \E[37m$LINE"
$scriptfolder/getinfo.sh $LINE $pref $api_url $pref_dl $page $bl_tags
$scriptfolder/lpgen.sh $LINE $pref
$scriptfolder/dloader.sh $LINE $pref
echo ">>>"
done < tags.txt
rm -f tags.txt
echo -e ">>>\E[35mОбновление тэгов завершено\E[37m"
if [ -e "$pref.NewPostsCount.txt" ]; then
echo ">>>"
echo -e ">>>\E[35mНовые посты у тегов:\E[37m"
cat "$pref.NewPostsCount.txt"
echo -e ">>>\E[35mОткрыть папки с новыми тэгами?(y/n)\E[37m"
read ans
if [ "$ans" == "y" ]; then
$scriptfolder/show_new.sh $pref
fi
fi
;;
	-u)
if [ -d "$3" ]
then
rm -f "$pref.NewPostsCount.txt"
echo -e ">>>\E[35mОбработка тэга: \E[37m$3"
$scriptfolder/getinfo.sh $3 $pref $api_url $pref_dl $page $bl_tags
$scriptfolder/lpgen.sh $3 $pref
$scriptfolder/dloader.sh $3 $pref
echo -e ">>>\E[35mОбновление тэга завершено\E[37m"
if [ -e "$pref.NewPostsCount.txt" ]; then
echo ">>>"
echo -e ">>>\E[35mОткрыть папку с новыми постами?(y/n)\E[37m"
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
$scriptfolder/getinfo.sh $3 $pref $api_url $pref_dl $page $bl_tags
echo 0 > $3/$pref.lastpost.txt
$scriptfolder/lpgen.sh $3 $pref
$scriptfolder/dloader.sh $3 $pref
mv $3/new/*.* $3/
echo -e ">>>\E[35mСкачивание тэга завершено\E[37m"
if [ -e "$pref.NewPostsCount.txt" ]; then
echo ">>>"
echo -e ">>>\E[35mОткрыть папку с новыми постами?(y/n)\E[37m"
read ans
if [ "$ans" == "y" ]; then
start $3
fi
fi
;;
	-l)
$scriptfolder/genlink.sh $post_url $3
;;
	-gp)
echo -e ">>>\E[35mСкачивание поста \E[37m'$3'"
$scriptfolder/get.sh $pref $3 $api_url $pref_dl
echo -e ">>>\E[35mСкачивание завершено\E[37m"
;;
	-sn)
$scriptfolder/show_new.sh $pref
;;
	-mv)
$scriptfolder/movenew.sh
echo -e ">>>\E[32mПеремещение завершено\E[37m"
;;
	--help)
cat $scriptfolder/README.txt
;;
	*)
echo "Для вывода справки попробуйте sapphire.sh --help"
esac