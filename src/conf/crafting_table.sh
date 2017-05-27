#!/bin/bash

shift

__pushd './assets/minecraft/textures/blocks/'

__stack "crafting_table_${1}.png" 'planks_oak.png' "crafting_table_${1}_overlay.png" "crafting_table_${1}_decal.png"

__popd

exit
