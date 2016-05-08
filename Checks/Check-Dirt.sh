#!/bin/bash

cd ../

bash Render.sh 128 dirt

mv ./Angl-128px/assets/minecraft/textures/blocks/dirt.png ./Checks/dirt.png

rm -r ./Angl-128px/

cd Checks

if [ -a Dirt.png ]; then
	rm Dirt.png
fi

if [ -a Dirt_.png ]; then
	rm Dirt_.png
fi

IMGSEQ=$(for tile in $(seq 1 3); do echo -n "dirt.png "; done)
IMGSEQ2=$(for tile in $(seq 1 6); do echo -n "dirt.png "; done)

IMGSEQ=$(echo $IMGSEQ""$IMGSEQ2)

montage -geometry +0+0 -tile 3x3 $IMGSEQ Dirt.png

montage -geometry +1+1 -tile 3x3 $IMGSEQ Dirt_.png

rm dirt.png

exit
