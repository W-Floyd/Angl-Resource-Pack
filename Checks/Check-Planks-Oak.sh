#!/bin/bash

cd ../

bash Render.sh 128 planks_oak

mv ./Angl-128px/assets/minecraft/textures/blocks/planks_oak.png ./Checks/planks_oak.png

rm -r ./Angl-128px/

cd Checks

if [ -a Oak_Planks.png ]; then
	rm Oak_Planks.png
fi

if [ -a Oak_Planks_.png ]; then
	rm Oak_Planks_.png
fi

IMGSEQ=$(for tile in $(seq 1 9); do echo -n "planks_oak.png "; done)

montage -geometry +0+0 -tile 3x3 $IMGSEQ Oak_Planks.png

montage -geometry +1+1 -tile 3x3 $IMGSEQ Oak_Planks_.png

rm planks_oak.png

exit
