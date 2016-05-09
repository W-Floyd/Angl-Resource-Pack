#!/bin/bash

TEXTURE="planks_big_oak"

cd ../

bash Render.sh 128 $TEXTURE

mv ./Angl-128px/assets/minecraft/textures/blocks/$TEXTURE".png" ./Checks/$TEXTURE".png"

rm -r ./Angl-128px/

cd Checks

if [ -a $TEXTURE".png" ]; then
	rm $TEXTURE".png"
fi

if [ -a $TEXTURE"_.png" ]; then
	rm O$TEXTURE"_.png"
fi

IMGSEQ=$(for tile in $(seq 1 9); do echo -n $TEXTURE".png "; done)

montage -geometry +0+0 -tile 3x3 $IMGSEQ "montage_"$TEXTURE".png"

montage -geometry +1+1 -tile 3x3 $IMGSEQ "montage_"$TEXTURE"_.png"

rm $TEXTURE".png"

exit
