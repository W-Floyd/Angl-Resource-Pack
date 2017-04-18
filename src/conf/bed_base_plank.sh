#!/bin/bash

__pushd "./assets/minecraft/textures/entity/bed/"

__tile "../../../../../colour_planks_oak.png" 4x4 "./bed_base_plank_.png"

__fade "../../blocks/planks_generic_overlay.png" "./bed_base_plank__.png" "0.25"

__tile "./bed_base_plank__.png" 4x4 "./bed_base_plank___.png"

mv "./bed_base_plank___.png" "./bed_base_plank__.png"

__multiply "./bed_base_plank_.png" "./bed_base_plank__.png" "./bed_base_plank.png"

rm "./bed_base_plank_.png" "./bed_base_plank__.png"

__popd

exit
