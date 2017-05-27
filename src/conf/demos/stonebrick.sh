#!/bin/bash

__colours='stonebrick
stonebrick_cracked
stonebrick_mossy
stonebrick_carved'

__num_colours="$(wc -l <<< "${__colours}")"

__imgseq="$(while read -r __colour; do echo -n "./assets/minecraft/textures/blocks/${__colour}.png ./assets/minecraft/textures/blocks/${__colour}.png "; done <<< "${__colours}")"

__imgseq="${__imgseq} ${__imgseq}"

__custom_tile ${__imgseq} "$((__num_colours*2))x2" "${2}" "./demos/stonebrick_${2}.png"

exit
