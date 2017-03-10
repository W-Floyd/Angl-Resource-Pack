#!/bin/bash

__wools='black
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

__num_wools="$(echo "${__wools}" | wc -l)"

echo "${__wools}" | while read -r __wool; do

    __tile "./assets/minecraft/textures/blocks/wool_colored_${__wool}.png" 2x1 "./demos/wool_colored_${__wool}.png" "${2}"

done

__custom_tile $(echo "${__wools}" | while read -r __wool; do echo -n "./demos/wool_colored_${__wool}.png "; done) "$((__num_wools/4))x4" "0" "./demos/wool_${2}.png"

echo "${__wools}" | while read -r __wool; do

    rm "./demos/wool_colored_${__wool}.png"

done

exit
