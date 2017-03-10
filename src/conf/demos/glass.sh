#!/bin/bash

__glasses='black
gray
silver
white
red
orange
brown
yellow
lime
green
cyan
light_blue
blue
purple
magenta
pink'

__num_glasses="$(echo "${__glasses}" | wc -l)"

echo "${__glasses}" | while read -r __glass; do

    __tile "./assets/minecraft/textures/blocks/glass_${__glass}.png" 2x1 "./demos/glass_${__glass}.png" "${2}"

done

__custom_tile $(echo "${__glasses}" | while read -r __glass; do echo -n "./demos/glass_${__glass}.png "; done) "$((__num_glasses/4))x4" "0" "./demos/glass_${2}.png"

echo "${__glasses}" | while read -r __glass; do

    rm "./demos/glass_${__glass}.png"

done

exit
