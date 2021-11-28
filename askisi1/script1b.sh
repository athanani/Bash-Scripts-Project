#!/bin/bash

trap "kill 0" SIGINT

func() {
	curl -s $2 > "${1}" || echo "${2} FAILED" 1>&2 # curl is in silent mode. Remove -s to see output.
	if [[ ! -f md5sum${1}.txt && -s ${1} ]]; then
		md5sum "${1}" >> md5sum${1}.txt
		echo "$2 INIT"
	elif [ -f md5sum${1}.txt ]; then
		line=$(head -n 1 md5sum${1}.txt)
		temp=$(md5sum "${1}")
		if [ "$line" != "$temp" ]; then
			echo $2
			sed -i "s/$line/$temp/" md5sum${1}.txt
		fi
	fi
}

arr=()
while read line; do
    if [ "${line:0:1}" != "#" ]; then
		i=$(cksum <<< $line | cut -f 1 -d ' ')
		func $i $line &
    fi 
done < $1
wait
