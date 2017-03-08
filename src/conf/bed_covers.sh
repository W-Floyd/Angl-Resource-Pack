#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp ../../../../noise_colour.png bed_noise.png

__tile bed_noise.png 4x2 bed_noise_.png

rm bed_noise.png

__clip_src_in bed_covers_underlay.png bed_noise_.png bed_noise.png

__overlay bed_covers_underlay.png bed_noise.png bed_covers.png

rm bed_noise_.png bed_noise.png

__popd

exit
