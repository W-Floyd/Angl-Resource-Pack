#!/bin/bash

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

TEXTURE1="glass"
TEXTURE2="glass_white"
TEXTURE3="glass_silver"
TEXTURE4="glass_gray"
TEXTURE5="glass_black"
TEXTURE6="glass_red"
TEXTURE7="glass_brown"
TEXTURE8="glass_orange"
TEXTURE9="glass_yellow"
TEXTURE10="glass_lime"
TEXTURE11="glass_green"
TEXTURE12="glass_cyan"
TEXTURE13="glass_light_blue"
TEXTURE14="glass_blue"
TEXTURE15="glass_purple"
TEXTURE16="glass_pink"
TEXTURE17="glass_glass_magenta"

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

bash Render.sh $RES $TEXTURE7

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE7".png" ./Checks/$TEXTURE7".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE8

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE8".png" ./Checks/$TEXTURE8".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE9

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE9".png" ./Checks/$TEXTURE9".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE10

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE10".png" ./Checks/$TEXTURE10".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE11

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE11".png" ./Checks/$TEXTURE11".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE12

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE12".png" ./Checks/$TEXTURE12".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE13

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE13".png" ./Checks/$TEXTURE13".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE14

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE14".png" ./Checks/$TEXTURE14".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE15

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE15".png" ./Checks/$TEXTURE15".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE16

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE16".png" ./Checks/$TEXTURE16".png"

rm -r ./Angl-128px/

bash Render.sh $RES $TEXTURE17

mv "./Angl-"$RES"px/assets/minecraft/textures/blocks/"$TEXTURE17".png" ./Checks/$TEXTURE17".png"

rm -r ./Angl-128px/

cd Checks

if [ -a "montage_glass_all.png" ]; then
	rm "montage_glass_all.png"
fi

if [ -a "montage_glass_all_.png" ]; then
	rm "montage_glass_all_.png"
fi

IMGSEQ1=$(for tile in $(seq 1 3); do echo -n $TEXTURE1".png "; done)
IMGSEQ2=$(for tile in $(seq 1 3); do echo -n $TEXTURE2".png "; done)
IMGSEQ3=$(for tile in $(seq 1 3); do echo -n $TEXTURE3".png "; done)
IMGSEQ4=$(for tile in $(seq 1 3); do echo -n $TEXTURE4".png "; done)
IMGSEQ5=$(for tile in $(seq 1 3); do echo -n $TEXTURE5".png "; done)
IMGSEQ6=$(for tile in $(seq 1 3); do echo -n $TEXTURE6".png "; done)
IMGSEQ7=$(for tile in $(seq 1 3); do echo -n $TEXTURE7".png "; done)
IMGSEQ8=$(for tile in $(seq 1 3); do echo -n $TEXTURE8".png "; done)
IMGSEQ9=$(for tile in $(seq 1 3); do echo -n $TEXTURE9".png "; done)
IMGSEQ10=$(for tile in $(seq 1 3); do echo -n $TEXTURE10".png "; done)
IMGSEQ11=$(for tile in $(seq 1 3); do echo -n $TEXTURE11".png "; done)
IMGSEQ12=$(for tile in $(seq 1 3); do echo -n $TEXTURE12".png "; done)
IMGSEQ13=$(for tile in $(seq 1 3); do echo -n $TEXTURE13".png "; done)
IMGSEQ14=$(for tile in $(seq 1 3); do echo -n $TEXTURE14".png "; done)
IMGSEQ15=$(for tile in $(seq 1 3); do echo -n $TEXTURE15".png "; done)
IMGSEQ16=$(for tile in $(seq 1 3); do echo -n $TEXTURE16".png "; done)
IMGSEQ17=$(for tile in $(seq 1 3); do echo -n $TEXTURE17".png "; done)

montage -geometry +0+0 -tile 3x17 $IMGSEQ1 $IMGSEQ2 $IMGSEQ3 $IMGSEQ4 $IMGSEQ5 $IMGSEQ6 $IMGSEQ7 $IMGSEQ8 $IMGSEQ9 $IMGSEQ10 $IMGSEQ11 $IMGSEQ12 $IMGSEQ13 $IMGSEQ14 $IMGSEQ15 $IMGSEQ16 $IMGSEQ17 "montage_glass_all.png"

montage -geometry +1+1 -tile 3x17 $IMGSEQ1 $IMGSEQ2 $IMGSEQ3 $IMGSEQ4 $IMGSEQ5 $IMGSEQ6 $IMGSEQ7 $IMGSEQ8 $IMGSEQ9 $IMGSEQ10 $IMGSEQ11 $IMGSEQ12 $IMGSEQ13 $IMGSEQ14 $IMGSEQ15 $IMGSEQ16 $IMGSEQ17 "montage_glass_all_.png"

rm $TEXTURE1".png"
rm $TEXTURE2".png"
rm $TEXTURE3".png"
rm $TEXTURE4".png"
rm $TEXTURE5".png"
rm $TEXTURE6".png"
rm $TEXTURE7".png"
rm $TEXTURE8".png"
rm $TEXTURE9".png"
rm $TEXTURE10".png"
rm $TEXTURE11".png"
rm $TEXTURE12".png"
rm $TEXTURE13".png"
rm $TEXTURE14".png"
rm $TEXTURE15".png"
rm $TEXTURE16".png"
rm $TEXTURE17".png"

exit
