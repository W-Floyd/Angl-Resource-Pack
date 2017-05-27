#!/bin/bash

__pushd "./assets/minecraft/textures/entity/bed/"

__fade '../../blocks/planks_generic_overlay.png' './bed_base_plank__.png' '0.25'

__multiply '../../../../../colour_planks_oak.png' './bed_base_plank__.png' './bed_base_plank_.png'

__tile './bed_base_plank_.png' '4x4' './bed_base_plank.png'

rm './bed_base_plank_.png' './bed_base_plank__.png'

__popd

exit
