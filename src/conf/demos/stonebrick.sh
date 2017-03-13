#!/bin/bash

__stonebricks='stonebrick
stonebrick_cracked
stonebrick_mossy'

__num_stonebricks="$(echo "${__stonebricks}" | wc -l )"

echo "${__stonebricks}" | while read -r __stonebrick; do

    __tile "./assets/minecraft/textures/blocks/${__stonebrick}.png" 2x2 "./demos/${__stonebrick}.png" "${2}"

done

__custom_tile $(echo "${__stonebricks}" | while read -r __stonebrick; do echo -n "./demos/${__stonebrick}.png "; done) "${__num_stonebricks}x1" "0" "./demos/stonebrick_${2}.png"

echo "${__stonebricks}" | while read -r __stonebrick; do

    rm "./demos/${__stonebrick}.png"

done

exit
