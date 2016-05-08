#!/bin/bash

cd $1

cd assets

recurse () {

for image in $(ls *.png 2> /dev/null); do
	IMGSEQ=$(for tile in $(seq 1 16); do echo -n $image" "; done)
	montage -geometry +0+0 -tile 4x4 $IMGSEQ "montage_"$image
	rm $image
done

for dir in $(ls -d ./*/ 2> /dev/null); do
	cd $dir
	recurse
	cd ../
done

}

recurse

cd ../

exit
