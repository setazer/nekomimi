#! /bin/bash
echo "#! /bin/bash" >starter.sh
ls -d */ | sed -e 's/\///g' > tags.txt
i=0
j=0
while read LINE; do
	cd "$LINE/new"
	if [ `ls -1 | wc -l` -gt 0 ];then
		let "i++"
		let "j++"
		echo ">>>Будет открыта папка: $LINE"
		echo "cd \"$LINE\"" >> ../../starter.sh
		echo "start new" >> ../../starter.sh
		echo "cd .." >> ../../starter.sh
		if [ $i -eq 10 ]; then
			echo "read -p '10 папок открыто. Нажмите Enter чтобы продолжить.'" >> ../../starter.sh
			let "i=0"
		fi
	fi
	cd ../..
done < tags.txt
echo ">>>Всего будет открыто папок: $j"
rm -f tags.txt
starter.sh
rm -f starter.sh
