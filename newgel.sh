#! /bin/bash
uag="Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.1) Gecko/20090715 Firefox/3.5.1 (.NET CLR 3.5.30729)"
tag=$1
pref=$2
cd $tag
if [ -a skip.flag ] 
then
rm -f skip.flag
exit
fi
lastpost=$(cat "$pref.lastpost.txt")
linen=0;
while read LINE; do
if [ $LINE -le $lastpost ]
then
break
fi
let "linen=linen+1"
done < Ids.txt
if [ $linen -ne 0 ]
then
echo -e ">>>\E[32mНайдены новые посты\E[37m"
echo -e ">>>\E[36mВсего: \E[37m$linen"
echo "$tag: $linen" >> "../$pref.NewPostsCount.txt"
head -n $linen urlsids.txt | sed -r -e 's/ [0-9]+//g' > new/dload.txt
head -n $linen urlsids.txt > new/urlsids.txt
cd new
wget -nc -nv -i dload.txt
echo -e ">>>\E[36mПереименование новых постов\E[37m"
echo "#! /bin/bash" > renamer.sh
sed -e "s/ /\" $pref./g" UrlsIds.txt | sed -r -e "s/.+\//mv \"/g"  > temp.txt
while read LINE ;do
ext=`echo "$LINE" | grep -E -o -e "\.[^\"]{3,4}\""|sed -e "s/\"//g"`
echo $LINE$ext|sed -e "s/%20/ /g" >> renamer.sh
done < temp.txt
rm -f temp.txt
read -p "waiting"
renamer.sh
rm -f renamer.sh
rm -f urlsids.txt
echo -e ">>>\E[32mПереименование завершено\E[37m"
rm -f dload.txt
cd ..
echo -e ">>>\E[32mСкачивание завершено\E[37m"
else
echo -e ">>>\E[31mНовые посты не найдены\E[37m"
fi
head -n 1 ids.txt > "$pref.lastpost.txt"
rm -f UrlsIds.txt
rm -f ids.txt