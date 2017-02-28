#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp ../../../../colour_"$2".png colour_"$2".png

__clip_src_in glass_pane_top.png colour_"$2".png glass_pane_top_"$2".png

rm colour_"$2".png

__popd

exit
