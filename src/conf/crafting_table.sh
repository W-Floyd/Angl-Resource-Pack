#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

__overlay planks_oak.png crafting_table_${2}_overlay.png crafting_table_${2}_.png

__overlay crafting_table_${2}_.png crafting_table_${2}_decal.png crafting_table_${2}.png

rm crafting_table_${2}_.png

__popd

exit
