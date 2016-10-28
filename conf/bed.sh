#!/bin/bash

cd ./assets/minecraft/textures/blocks/

case "$2" in
	"bed_feet_end")
		__shift="0.5"
		__rotate="-1"
		__start="0 0"
		;;
	"bed_feet_side")
		__shift="0"
		__rotate="0"
		__start="+$(echo ${1}'*1' | bc)+$(echo ${1}'*1' | bc)"
		;;
	"bed_head_side")
		__shift=1
		__rotate="0"
		__start="+$(echo ${1}'*2' | bc)+$(echo ${1}'*1' | bc)"
		;;
	"bed_head_side")
		__shift=1
		__rotate="0"
		__start="+$(echo ${1}'*2' | bc)+$(echo ${1}'*1' | bc)"
		;;
esac



for __image in $(echo "bed_covers.png
bed_wood_overlay.png"); do

convert "${__image}" -crop 

cd ../../../../

exit
