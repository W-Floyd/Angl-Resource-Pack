#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

__clip_src_in 'glass_pane_top.png' "../../../../colour_${2}.png" "glass_pane_top_${2}.png"

__popd

exit
