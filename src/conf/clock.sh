#!/bin/bash

__pushd './assets/minecraft/textures/items/'

__rotate_exact './clock_movement.png' "./${2}.png" "$(echo "${2}/64" | bc -l)"

__stack "./clock_${2}.png" './clock_background.png' "./${2}.png" './clock_cover.png'

rm "./${2}.png"

__popd

exit
