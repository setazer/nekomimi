#! /bin/bash
pref=$1
echo "#! /bin/bash" >starter.sh
grep -E -o -e "^[^\:]+" $pref.NewPostsCount.txt | sed -r -e "s/^/cd \"/g" -e "s/$/\"\nstart new\ncd \.\./g" >> starter.sh
starter.sh
rm -f starter.sh
