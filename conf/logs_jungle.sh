#!/bin/bash

cd ./assets/minecraft/textures/blocks/

cp ../../../../colour_log_jungle.png colour_log_jungle.png

__multiply colour_log_jungle.png log_jungle_overlay.png log_jungle.png

rm colour_log_jungle.png

cd ../../../../

exit
