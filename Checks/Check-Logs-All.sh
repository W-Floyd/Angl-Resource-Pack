#!/bin/bash

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

TEXTURE1="log_acacia"
TEXTURE11=$(echo $TEXTURE1"_top")
TEXTURE2="log_big_oak"
TEXTURE21=$(echo $TEXTURE2"_top")
TEXTURE3="log_birch"
TEXTURE31=$(echo $TEXTURE3"_top")
TEXTURE4="log_jungle"
TEXTURE41=$(echo $TEXTURE4"_top")
TEXTURE5="log_oak"
TEXTURE51=$(echo $TEXTURE5"_top")
TEXTURE6="log_spruce"
TEXTURE61=$(echo $TEXTURE6"_top")

cd ../

bash Render.sh $RES $TEXTURE1

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE1".png" ./Checks/$TEXTURE1".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE11

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE11".png" ./Checks/$TEXTURE11".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE2

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE2".png" ./Checks/$TEXTURE2".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE21

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE21".png" ./Checks/$TEXTURE21".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE3

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE3".png" ./Checks/$TEXTURE3".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE31

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE31".png" ./Checks/$TEXTURE31".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE4

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE4".png" ./Checks/$TEXTURE4".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE41

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE41".png" ./Checks/$TEXTURE41".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE5

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE5".png" ./Checks/$TEXTURE5".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE51

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE51".png" ./Checks/$TEXTURE51".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE6

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE6".png" ./Checks/$TEXTURE6".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE61

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE61".png" ./Checks/$TEXTURE61".png"

rm -r ./Angl-128px/

cd Checks

if [ -a "montage_logs_all.png" ]; then
	rm "montage_logs_all.png"
fi

if [ -a "montage_logs_all_.png" ]; then
	rm "montage_logs_all_.png"
fi

IMGSEQ1=$(echo $TEXTURE11".png "$TEXTURE21".png "$TEXTURE31".png "$TEXTURE41".png "$TEXTURE51".png "$TEXTURE61".png ")
IMGSEQ2=$(echo $TEXTURE1".png "$TEXTURE2".png "$TEXTURE3".png "$TEXTURE4".png "$TEXTURE5".png "$TEXTURE6".png ")
IMGSEQ3=$(for row in $(seq 1 3); do echo -n $IMGSEQ2" "; done)


montage -geometry +0+0 -tile 6x4 $IMGSEQ1""$IMGSEQ3 "montage_planks_all.png"

montage -geometry +1+1 -tile 6x4 $IMGSEQ1""$IMGSEQ3 "montage_planks_all_.png"

rm $TEXTURE1".png"
rm $TEXTURE2".png"
rm $TEXTURE3".png"
rm $TEXTURE4".png"
rm $TEXTURE5".png"
rm $TEXTURE6".png"
rm $TEXTURE11".png"
rm $TEXTURE21".png"
rm $TEXTURE31".png"
rm $TEXTURE41".png"
rm $TEXTURE51".png"
rm $TEXTURE61".png"

exit
