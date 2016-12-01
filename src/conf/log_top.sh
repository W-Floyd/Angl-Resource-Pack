#!/bin/bash

cd ./assets/minecraft/textures/blocks/

cp ../../../../colour_log_"$2".png colour_log_"$2".png
cp ../../../../colour_planks_"$2".png colour_planks_"$2".png

__clip_dst_in colour_log_"$2".png log_generic_top_2.png __log.png

rm colour_log_"$2".png

# __log.png now holds bark colour clipped to ring size

__multiply colour_planks_"$2".png log_generic_top_1.png __log2.png

rm colour_planks_"$2".png

# __log2.png now holds the plank colour tinted with rings

__overlay __log2.png __log.png __log3.png

rm __log2.png __log.png

# __log3.png now holds the log top, without the edge tinted on

__multiply __log3.png log_generic_top_2.png __log4.png

rm __log3.png

mv __log4.png log_"$2"_top.png

cd ../../../../

exit
