#!/bin/bash

cd ./assets/minecraft/textures/blocks/

case "$2" in
	"bed_feet_end")
		__shift="0.5625"
		__rotate="-1"
		__start="0 0"
		;;
	"bed_feet_side")
		__shift="0.5625"
		__rotate="0"
		__start="1 1"
		;;
	"bed_head_side")
		__shift="0.5625"
		__rotate="0"
		__start="2 1"
		;;
	"bed_head_end")
		__shift="0.5625"
		__rotate="1"
		__start="3 0"
		;;
	"bed_feet_top")
		__shift="0"
		__rotate="0"
		__start="1 0"
		;;
	"bed_head_top")
		__shift="0"
		__rotate="0"
		__start="2 0"
		;;
esac

__crop "bed_covers.png" "$1" $__start "${2}_covers.png"
__crop "bed_wood.png" "$1" $__start "${2}_wood.png"

__overlay "${2}_wood.png" "${2}_covers.png" "${2}.png"

rm "${2}_covers.png"
rm "${2}_wood.png"

__rotate "${2}.png" "$__rotate"

__shift "${2}.png" "$__shift"

cd ../../../../

exit
