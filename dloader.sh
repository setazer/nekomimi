#! /bin/bash
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
head -n $linen urlsids.txt |sed -e "s/ / $pref./g" > new/urlsids.txt
cd new
while read LINE ;do
ext=`echo "$LINE" | grep -E -o -e "\.[^ ]{3,4} "|sed -e "s/ //g"`
echo $LINE$ext | awk '{print "wget -nc -nv "$1" -O "$2}' | bash
done < UrlsIds.txt
rm -f urlsids.txt
cd ..
echo -e ">>>\E[32mСкачивание завершено\E[37m"
else
echo -e ">>>\E[31mНовые посты не найдены\E[37m"
fi
head -n 1 ids.txt > "$pref.lastpost.txt"
rm -f UrlsIds.txt
rm -f ids.txt