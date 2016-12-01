#!/bin/bash

cd ./assets/minecraft/textures/blocks/

cp ../../../../colour_planks_oak.png colour_planks_oak.png

__clip_src_in ladder_overlay.png colour_planks_oak.png ladder_.png

__multiply ladder_.png ladder_overlay.png ladder.png

rm colour_planks_oak.png

rm ladder_.png

cd ../../../../

exit
