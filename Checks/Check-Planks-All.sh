#!/bin/bash

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

TEXTURE1="planks_acacia"
TEXTURE2="planks_big_oak"
TEXTURE3="planks_birch"
TEXTURE4="planks_jungle"
TEXTURE5="planks_oak"
TEXTURE6="planks_spruce"

cd ../

bash Render.sh $RES $TEXTURE1

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE1".png" ./Checks/$TEXTURE1".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE2

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE2".png" ./Checks/$TEXTURE2".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE3

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE3".png" ./Checks/$TEXTURE3".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE4

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE4".png" ./Checks/$TEXTURE4".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE5

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE5".png" ./Checks/$TEXTURE5".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE6

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE6".png" ./Checks/$TEXTURE6".png"

rm -r ./Angl-128px/

cd Checks

if [ -a "montage_planks_all.png" ]; then
	rm "montage_planks_all.png"
fi

if [ -a "montage_planks_all_.png" ]; then
	rm "montage_planks_all_.png"
fi

IMGSEQ1=$(for tile in $(seq 1 3); do echo -n $TEXTURE1".png "; done)
IMGSEQ2=$(for tile in $(seq 1 3); do echo -n $TEXTURE2".png "; done)
IMGSEQ3=$(for tile in $(seq 1 3); do echo -n $TEXTURE3".png "; done)
IMGSEQ4=$(for tile in $(seq 1 3); do echo -n $TEXTURE4".png "; done)
IMGSEQ5=$(for tile in $(seq 1 3); do echo -n $TEXTURE5".png "; done)
IMGSEQ6=$(for tile in $(seq 1 3); do echo -n $TEXTURE6".png "; done)

montage -geometry +0+0 -tile 3x6 $IMGSEQ1 $IMGSEQ2 $IMGSEQ3 $IMGSEQ4 $IMGSEQ5 $IMGSEQ6 "montage_planks_all.png"

montage -geometry +1+1 -tile 3x6 $IMGSEQ1 $IMGSEQ2 $IMGSEQ3 $IMGSEQ4 $IMGSEQ5 $IMGSEQ6 "montage_planks_all_.png"

rm $TEXTURE1".png"
rm $TEXTURE2".png"
rm $TEXTURE3".png"
rm $TEXTURE4".png"
rm $TEXTURE5".png"
rm $TEXTURE6".png"

exit
