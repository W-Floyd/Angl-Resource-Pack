#!/bin/bash

__colours='acacia
big_oak
birch
jungle
oak
spruce'

__num_colours="$(wc -l <<< "${__colours}")"

__imgseq="$(while read -r __colour; do echo -n "./assets/minecraft/textures/blocks/${2}_${__colour}.png ./assets/minecraft/textures/blocks/${2}_${__colour}.png "; done <<< "${__colours}")"

__imgseq="${__imgseq} ${__imgseq}"

__custom_tile ${__imgseq} "$((__num_colours*2))x2" "${3}" "./demos/${2}_${3}.png"

exit
