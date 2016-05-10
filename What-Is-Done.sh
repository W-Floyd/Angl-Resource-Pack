#!/bin/bash

RES="1"

bash Render.sh $RES &> /dev/null

cd "Angl-"$RES"px"

TRIMDIR=$PWD

recurse () {

CURDIR=$PWD

RELATIVE=$(echo "."$(echo $CURDIR | sed 's/'$(echo $TRIMDIR | sed 's/\//\\\//g')'//')"/")

for file in $(ls -1 *.* 2> /dev/null); do
	echo $RELATIVE""$file
done

for dir in $(ls -d ./*/ 2> /dev/null); do
	cd $dir
	recurse
	cd ../
done

}

recurse

cd ../

rm -r "Angl-"$RES"px/"

exit
