#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

__fade "../../../../colour_${2}.png" "colour_${2}_.png" '0.25'

__clip_src_in 'glass.png' "../../../../colour_${2}.png" "glass_${2}_.png"

__stack "glass_${2}.png" "colour_${2}_.png" "glass_${2}_.png"

rm "colour_${2}_.png" "glass_${2}_.png"

__popd

exit
