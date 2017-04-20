#!/bin/bash

__pushd ./assets/minecraft/textures/items/

__rotate_exact './clock_movement.png' "./${2}.png" "$(echo "${2}/64" | bc -l)"

__overlay "./clock_background.png" "./${2}.png" "./${2}_.png"

__overlay "./${2}_.png" "./clock_cover.png" "./clock_${2}.png"

rm "./${2}_.png" "./${2}.png"

__popd

exit
