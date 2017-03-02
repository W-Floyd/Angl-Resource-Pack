#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

__clip_dst_in grass_side_snowed_colour.png grass_side_overlay.png grass_side_snowed_overlay_.png

__fade grass_side_overlay.png grass_side_overlay__.png 0.25

__multiply grass_side_snowed_overlay_.png grass_side_overlay__.png grass_side_snowed_overlay.png

rm grass_side_snowed_overlay_.png grass_side_overlay__.png

__popd

exit
