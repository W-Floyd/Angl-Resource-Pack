#!/bin/bash

__ores='coal_ore
redstone_ore
diamond_ore'

__num_ores="$(echo "${__ores}" | wc -l )"

__custom_tile \
$(for __num in $(seq 1 "$((__num_ores+3))"); do echo -n './assets/minecraft/textures/blocks/stone.png '; done) \
$(echo "${__ores}" | while read -r __ore; do echo -n "./assets/minecraft/textures/blocks/${__ore}.png "; done) \
$(for __num in $(seq 1 "$((__num_ores+3))"); do echo -n './assets/minecraft/textures/blocks/stone.png '; done) \
"$((__num_ores+2))x$((3))" \
"${2}" \
"./demos/ores_${2}.png"

exit
