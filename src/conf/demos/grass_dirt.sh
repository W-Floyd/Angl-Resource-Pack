#!/bin/bash

__custom_tile \
$(for __num in $(seq 1 4); do echo -n './assets/minecraft/textures/blocks/grass_side.png '; done) \
$(for __num in $(seq 1 12); do echo -n './assets/minecraft/textures/blocks/dirt.png '; done) \
4x4 \
"${2}" \
"./demos/grass_dirt_${2}.png"

exit
