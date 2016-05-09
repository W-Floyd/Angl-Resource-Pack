#!/bin/bash

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

TEXTURE1="dirt"
TEXTURE2="grass_side"

cd ../

bash Render.sh $RES $TEXTURE1

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE1".png" ./Checks/$TEXTURE1".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE2

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE2".png" ./Checks/$TEXTURE2".png"

rm -r ./Angl-128px/

cd Checks

if [ -a "montage_dirt-and-grass.png" ]; then
	rm "montage_dirt-and-grass.png"
fi

if [ -a "montage_dirt-and-grass_.png" ]; then
	rm "montage_dirt-and-grass_.png"
fi

IMGSEQ=$(for tile in $(seq 1 3); do echo -n $TEXTURE2".png "; done)
IMGSEQ2=$(for tile in $(seq 1 6); do echo -n $TEXTURE1".png "; done)

IMGSEQ=$(echo $IMGSEQ""$IMGSEQ2)

montage -geometry +0+0 -tile 3x3 $IMGSEQ montage_dirt-and-grass.png
montage -geometry +1+1 -tile 3x3 $IMGSEQ montage_dirt-and-grass_.png

rm $TEXTURE1".png"

rm $TEXTURE2".png"

exit
