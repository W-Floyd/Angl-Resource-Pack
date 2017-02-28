#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp ../../../../colour_planks_oak.png colour_planks_oak.png

__overlay colour_planks_oak.png crafting_table_top_overlay.png crafting_table_top_.png

__overlay crafting_table_top_.png crafting_table_top_decal.png crafting_table_top.png

rm crafting_table_top_.png colour_planks_oak.png

__popd

exit
