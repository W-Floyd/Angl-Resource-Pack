#!/bin/bash

# door_parts.sh <SIZE> <DOOR_NAME> <upper/lower>

case "${3}" in
    "upper")
    	__start="0 0"
        ;;
    "lower")
    	__start="0 1"
        ;;
esac

__crop "./assets/minecraft/textures/blocks/door_${2}.png" "${1}" ${__start} "./assets/minecraft/textures/blocks/door_${2}_${3}.png"


exit
