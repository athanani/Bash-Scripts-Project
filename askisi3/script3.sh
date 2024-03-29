#!/bin/bash

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: `basename $0` [--help] [-h] [args]
  Analyzes a plain text file of an ebook from https://www.gutenberg.org (that its full path
  is given to the script as the first argument) and outputs the n (value given as the 
  second argument) most shown words of the ebook followed by the number of times shown, between
  the start of the book (\"*** START OF THIS PROJECT GUTENBERG EBOOK ...\") and the end of it
  (\"*** END OF THIS PROJECT GUTENBERG EBOOK ...\")."
  exit 0
fi


bool=true
echo "" > temp.txt

if [ -f $1 ]; then
    while read line; do
        if [[ "${line:0:39}" == "*** END OF THIS PROJECT GUTENBERG EBOOK" ]]; then
            bool=true
        fi

        if [[ $bool == false ]]; then
            echo "${line}" >> temp.txt
        fi

        if [[ "${line:0:41}" == "*** START OF THIS PROJECT GUTENBERG EBOOK" ]]; then
            bool=false
        fi
    done < $1
fi

sed -i 's|[][,.!?"^*()-/\\&_;:]| |g' temp.txt
sed -i 's/[A-Z]/\L&/g' temp.txt

sed -i 's/'\''[a-z]\s/ /g' temp.txt 
sed -i 's/ '\''/ /g' temp.txt
sed -i 's/'\'' / /g' temp.txt
sed -i 's/^'\''/\n/g' temp.txt
sed -i 's/'\''[a-z]$/ /g' temp.txt

sed -i 's/^\s*//g' temp.txt
sed -i 's/\s*$//g' temp.txt
sed -i ' /^$/d' temp.txt
sed -i 's/  */ /g' temp.txt
sed -e 's/\s/\n/g' < temp.txt | sort | uniq -c | sort -nr | head -$2 | while read c w; do echo "${w} ${c}"; done
