#!/bin/bash

cd ./assets/minecraft/textures/blocks/

__multiply dirt.png grass_side_overlay_other.png dirt_.png

__screen dirt_.png grass_side_overlay_other.png dirt__.png

rm dirt_.png

__overlay dirt__.png grass_side_overlay.png grass_side.png

rm dirt__.png

cd ../../../../

exit
