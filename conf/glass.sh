#!/bin/bash

cd ./assets/minecraft/textures/blocks/

cp ../../../../colour_"$2".png colour_"$2".png

__clip_src_in glass.png colour_"$2".png glass_colored_"$2".png

rm colour_"$2".png

cd ../../../../

exit
