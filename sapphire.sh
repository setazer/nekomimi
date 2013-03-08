#! /bin/bash
while [ ! -d "$(cat pictures-folder.txt)" ]
do
echo ">>>Основаная папка с пикчами не найдена"
echo ">>>Введите путь до папки с пикчами:"
read new_fold
echo $new_fold > pictures-folder.txt
done
scriptfolder=`pwd`
#TO-DO: Вывод списка доступных серверов
show_servers.sh
echo ">>>Выберите сервер, введя его префикс"
read pref
serv_line=`grep "pref=\"$pref\"" servers.txt`
if [ -n "$serv_line" ]; then
name=`echo $serv_line | grep -E -o -e "name=\"[^\"]+" | sed -e "s/name=\"//"`
api_url=`echo $serv_line | grep -E -o -e "api_url=\"[^\"]+" | sed -e "s/api_url=\"//"`
pref_dl=`echo $serv_line | grep -E -o -e "pref_dl=\"[^\"]*" | sed -e "s/pref_dl=\"//"`
page=`echo $serv_line | grep -E -o -e "page=\"[^\"]+" | sed -e "s/page=\"//"`
else
echo ">>>Такой сервер не найден"
exit
fi
cd "$(cat pictures-folder.txt)"
cd $name
case "$1" in
	-ua)
ls -d */ | grep -v -e '+' |sed -e 's/\///g' > tags.txt
echo "Новые посты у тегов:" > "$pref.NewPostsCount.txt"
i=0
total=`ls -d -1 */ | wc -l`
while read LINE; do
let i++
echo -e ">>>\E[35mОбработка тэга ($i/$total): \E[37m$LINE"
$scriptfolder/getinfo.sh $LINE $pref $api_url $pref_dl $page
$scriptfolder/lpgen.sh $LINE $pref
$scriptfolder/newgel.sh $LINE $pref
echo ">>>"
done < tags.txt
rm -f tags.txt
echo -e ">>>\E[35mОбновление тэгов завершено\E[37m"
cat "$pref.NewPostsCount.txt"
;;
	-u)
if [ -d "$2" ]
then
echo -e ">>>\E[35mОбработка тэга: \E[37m$2"
$scriptfolder/getinfo.sh $2 $pref $api_url $pref_dl $page
$scriptfolder/lpgen.sh $2 $pref
$scriptfolder/newgel.sh $2 $pref
echo -e ">>>\E[35mОбновление тэга завершено\E[37m"
else
echo -e ">>>\E[31mТэг \E[37m'$2' \E[31mне найден!\E[37m"
fi
;;
	-n)
echo -e ">>>\E[35mОбработка тэга: \E[37m$2"
$scriptfolder/getinfo.sh $2 $pref $api_url $pref_dl $page
echo 0 > $2/$pref.lastpost.txt
$scriptfolder/lpgen.sh $2 $pref
$scriptfolder/newgel.sh $2 $pref
mv $2/new/*.* $2/
echo -e ">>>\E[35mСкачивание тэга завершено\E[37m"
;;
	-gp)
echo -e ">>>\E[35mСкачивание поста \E[37m'$2'"
$scriptfolder/get.sh $2 $3
echo -e ">>>\E[35mСкачивание завершено\E[37m"
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