#!/bin/bash

__pushd ./assets/minecraft/textures/items/

__rotate_exact './compass_movement.png' "./${2}.png" "$(echo "${2}/32" | bc -l)"

__overlay "./compass_background.png" "./${2}.png" "./${2}_.png"

__overlay "./${2}_.png" "./compass_cover.png" "./compass_${2}.png"

rm "./${2}_.png" "./${2}.png"

__popd

exit
