#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

__fade './planks_generic_overlay.png' './door_overlay_plank.png' '0.25'

__rotate './door_overlay_plank.png' '1'

__tile './door_overlay_plank.png' '1x2' './door_overlay_plank_.png'

mv './door_overlay_plank_.png' './door_overlay_plank.png'

__popd

exit
