#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

case "$2" in
    "acacia")
        __colour='white'
        __shade='0.1'
        ;;
    "big_oak")
        __colour='black'
        __shade='0.1'
    "birch")
        __colour='white'
        __shade='0.05'
    "jungle")
        __colour='white'
        __shade='0.1'
    "spruce")
        __colour='black'
        __shade='0.05'
        ;;
esac

cp ../../../../colour_"${__colour}".png colour_"${__colour}".png

__fade colour_"${__colour}".png colour_"${__colour}"_.png "${__fade}"

__overlay colour_"${__colour}".png leaves_oak.png leaves_"$2".png

rm colour_"$2".png

rm colour_"$2"_.png

__popd

exit
