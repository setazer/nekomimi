#! /bin/bash
grep -v -E -e "^#" servers.txt | grep -E -o -E "pref=\"[^\"]+\" name=\"[^\"]+\"" | sed -e "s/pref=//g" -e "s/\" name=/ - /g" -e "s/\"//g"
