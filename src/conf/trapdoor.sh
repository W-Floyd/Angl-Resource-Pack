#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp ../../../../colour_planks_oak.png colour_planks_oak.png

__clip_src_in trapdoor_overlay.png colour_planks_oak.png trapdoor_.png

__multiply trapdoor_.png trapdoor_overlay.png trapdoor.png

rm colour_planks_oak.png

rm trapdoor_.png

__popd

exit
