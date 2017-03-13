#!/bin/bash

__custom_tile \
$(for __num in $(seq 1 6); do echo -n './assets/minecraft/textures/blocks/planks_oak.png '; done) \
$(for __num in $(seq 1 3); do echo -n './assets/minecraft/textures/blocks/bookshelf.png '; done) \
$(for __num in $(seq 1 6); do echo -n './assets/minecraft/textures/blocks/planks_oak.png '; done) \
5x3 \
"${2}" \
"./demos/bookshelf_${2}.png"

exit
