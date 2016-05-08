#!/bin/bash

cd ../

bash Render.sh 128 grass_side

mv ./Angl-128px/assets/minecraft/textures/blocks/grass_side.png ./Checks/grass_side.png

rm -r ./Angl-128px/

bash Render.sh 128 dirt

mv ./Angl-128px/assets/minecraft/textures/blocks/dirt.png ./Checks/dirt.png

rm -r ./Angl-128px/

cd Checks

if [ -a Grass_and_Dirt.png ]; then
	rm Grass_and_Dirt.png
fi

IMGSEQ=$(for tile in $(seq 1 3); do echo -n "grass_side.png "; done)
IMGSEQ2=$(for tile in $(seq 1 6); do echo -n "dirt.png "; done)

IMGSEQ=$(echo $IMGSEQ""$IMGSEQ2)

montage -geometry +0+0 -tile 3x3 $IMGSEQ Grass_and_Dirt.png
montage -geometry +1+1 -tile 3x3 $IMGSEQ Grass_and_Dirt_.png

rm grass_side.png

rm dirt.png

exit
