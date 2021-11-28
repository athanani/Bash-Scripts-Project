#!/bin/bash

argdir=$(dirname $(readlink -f $1))
cd $argdir

tar -zxf $1
if [ ! -d assignments ]; then
    mkdir assignments
fi

txtfiles=`find . -type f -name "*.txt"`
for i in $txtfiles
do
    while read line; do
        if [[ "${line:0:1}" != "#" && "${line:0:5}" == "https" ]]; then 
            cd assignments
            GIT_TERMINAL_PROMPT=0 git clone -q $line &> /dev/null # git clone is in quiet mode. Remove -q to see output.
            if [ -d $(basename -s .git $line) ]; then 
                echo "$line: Cloning OK"
            else 
                echo "${line}: Cloning FAILED" 1>&2
            fi
            cd ..
            break
        fi 
    done < $i
done

cd assignments
if [ "$(ls -A $assignments)" ]; then 
    for d in */ ; do
        cd $d
        components=$(find . -mindepth 1)
        dirs=$(find . -mindepth 1 -type d)
        txts=$(find . -type f -name "*.txt")
        counter1=0
        counter2=0
        counter3=0
        for i in $components ; do
            ((counter1++))
        done 
        for i in $dirs ; do
            ((counter2++))
        done 
        for i in $txts ; do
            ((counter3++))
        done
        counter1=$((counter1 - counter2 - counter3))
        printf "${d%/*} :\nNumber of directories : ${counter2}\nNumber of txt files : ${counter3}\nNumber of other files : ${counter1-counter2-counter3}\n"

        bool=true

        if [[ "$counter2" == 1 && "$counter3" == 3 && ${counter1-$counter2-$counter3} == 0 ]] ; then 
            if [[ -f dataA.txt && -d more ]] ; then
                cd more
                if [[ -f dataB.txt && -f dataC.txt ]] ; then 
                    bool=false
                fi
                cd ..
            fi
        fi

        if [ $bool == false ] ; then
            echo "Directory structure is OK."
        else 
            echo "Directory structure is NOT OK."
        fi
        cd ..
    done
fi