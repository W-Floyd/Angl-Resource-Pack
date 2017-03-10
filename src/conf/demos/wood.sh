#!/bin/bash

__woods='acacia
big_oak
birch
jungle
oak
spruce'

__num_woods="$(echo "${__woods}" | wc -l )"

echo "${__woods}" | while read -r __wood; do

    __tile "./assets/minecraft/textures/blocks/${2}_${__wood}.png" 2x2 "./demos/${2}_${__wood}.png" "${3}"

done

__custom_tile $(echo "${__woods}" | while read -r __wood; do echo -n "./demos/${2}_${__wood}.png "; done) "${__num_woods}x1" "0" "./demos/${2}_${3}.png"

echo "${__woods}" | while read -r __wood; do

    rm "./demos/${2}_${__wood}.png"

done

exit
