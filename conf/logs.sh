#!/bin/bash

cd ./assets/minecraft/textures/blocks/

cp ../../../../colour_log_"$2".png colour_log_"$2".png

__multiply colour_log_"$2".png log_generic_overlay.png log_"$2".png

rm colour_log_"$2".png

cd ../../../../

exit
