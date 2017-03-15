#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

__fade "./log_generic_overlay.png" "./door_overlay_log.png" "0.125"

__rotate "./door_overlay_log.png" "1"

__tile "./door_overlay_log.png" 1x2 "./door_overlay_log_.png"

mv "./door_overlay_log_.png" "./door_overlay_log.png"

__popd

exit
