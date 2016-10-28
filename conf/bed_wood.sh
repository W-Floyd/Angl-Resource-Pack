#!/bin/bash

cd ./assets/minecraft/textures/blocks/

__tile planks_oak.png 4x2 planks_oak_.png

__clip_src_in bed_wood_overlay.png planks_oak_.png bed_wood.png

__multiply bed_wood.png bed_wood_overlay.png bed_wood_.png

rm planks_oak_.png

mv bed_wood_.png bed_wood.png

cd ../../../../

exit
