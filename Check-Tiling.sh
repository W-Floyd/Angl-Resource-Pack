#!/bin/bash

ENDDIR=$PWD"/tmp/"

mkdir tmp

bash Render.sh 128 $1

cd Angl-128px

cd assets

recurse () {

for image in $(ls *.png 2> /dev/null); do
	IMGSEQ=$(for tile in $(seq 1 16); do echo -n $image" "; done)
	montage -geometry +0+0 -tile 4x4 $IMGSEQ "montage_"$image
	rm $image
	mv "montage_"$image $ENDDIR"montage_"$image
done

for dir in $(ls -d ./*/ 2> /dev/null); do
	cd $dir
	recurse
	cd ../
done

}

recurse

cd ../

rm -r ./*

cd ../tmp

TILEDFILE=$(ls -1)

mv $TILEDFILE ../Angl-128px/$TILEDFILE

cd ../

rm -r ./tmp/

exit
