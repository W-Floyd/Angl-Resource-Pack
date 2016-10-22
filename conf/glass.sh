#!/bin/bash

cd ./assets/minecraft/textures/blocks/

cp ../../../../colour_"$2".png colour_"$2".png

__fade colour_"$2".png colour_"$2"_.png 0.25

__clip_src_in glass.png colour_"$2".png glass_"$2"_.png

__overlay colour_"$2"_.png glass_"$2"_.png glass_"$2".png

rm colour_"$2".png

rm colour_"$2"_.png

rm glass_"$2"_.png

cd ../../../../

exit
