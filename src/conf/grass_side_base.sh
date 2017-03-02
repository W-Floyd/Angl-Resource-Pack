#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

__multiply dirt.png grass_side_overlay_other.png grass_side_base_.png

__screen grass_side_base_.png grass_side_overlay_other.png grass_side_base.png

rm grass_side_base_.png

__popd

exit
