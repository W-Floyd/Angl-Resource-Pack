#!/bin/bash

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

TEXTURE="planks_spruce"

cd ../

bash Render.sh $RES $TEXTURE

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE".png" ./Checks/$TEXTURE".png"

rm -r ./Angl-128px/

cd Checks

if [ -a "montage_"$TEXTURE".png" ]; then
	rm "montage_"$TEXTURE".png"
fi

if [ -a "montage_"$TEXTURE"_.png" ]; then
	rm "montage_"$TEXTURE"_.png"
fi

IMGSEQ=$(for tile in $(seq 1 9); do echo -n $TEXTURE".png "; done)

montage -geometry +0+0 -tile 3x3 $IMGSEQ "montage_"$TEXTURE".png"

montage -geometry +1+1 -tile 3x3 $IMGSEQ "montage_"$TEXTURE"_.png"

rm $TEXTURE".png"

exit
