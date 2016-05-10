#!/bin/bash

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

TEXTURE="log_oak"

cd ../

bash Render.sh $RES $TEXTURE

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE".png" ./Checks/$TEXTURE".png"

rm -r ./Angl-128px/

cd Checks

if [ -a "montage_"$TEXTURE"_trunk.png" ]; then
	rm "montage_"$TEXTURE"_trunk.png"
fi

if [ -a "montage_"$TEXTURE"_trunk_.png" ]; then
	rm "montage_"$TEXTURE"_trunk_.png"
fi

IMGSEQ=$(for tile in $(seq 1 4); do echo -n $TEXTURE".png "; done)

montage -geometry +0+0 -tile 1x4 $IMGSEQ "montage_"$TEXTURE"_trunk.png"

montage -geometry +1+1 -tile 1x4 $IMGSEQ "montage_"$TEXTURE"_trunk_.png"

rm $TEXTURE".png"

exit
