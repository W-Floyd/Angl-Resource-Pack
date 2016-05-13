#!/bin/bash

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

TEXTURE1="planks_oak"
TEXTURE2="bookshelf"

cd ../

bash Render.sh $RES $TEXTURE1

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE1".png" ./Checks/$TEXTURE1".png"

rm -r "./Angl-"$RES"px/"

bash Render.sh $RES $TEXTURE2

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE2".png" ./Checks/$TEXTURE2".png"

rm -r "./Angl-"$RES"px/"

cd Checks

if [ -a "montage_"$TEXTURE2".png" ]; then
	rm "montage_"$TEXTURE2".png"
fi

if [ -a "montage_"$TEXTURE2"_.png" ]; then
	rm "montage_"$TEXTURE2"_.png"
fi

IMGSEQ1=$(for tile in $(seq 1 3); do echo -n $TEXTURE1".png "; done)
IMGSEQ2=$(for tile in $(seq 1 3); do echo -n $TEXTURE2".png "; done)

montage -geometry +0+0 -tile 3x3 $IMGSEQ1 $IMGSEQ2 $IMGSEQ1 "montage_"$TEXTURE2".png"

montage -geometry +1+1 -tile 3x3 $IMGSEQ1 $IMGSEQ2 $IMGSEQ1 "montage_"$TEXTURE2"_.png"

rm $TEXTURE1".png"

rm $TEXTURE2".png"

exit
