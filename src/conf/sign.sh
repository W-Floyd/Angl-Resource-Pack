#!/bin/bash

__pushd './assets/minecraft/textures/entity/'

__fudge_value='0.8'

case "${2}" in
    'planks_front')
        __overlay_texture='../blocks/planks_oak.png'
        __colour='../../../../colour_planks_oak.png'
        __fade_level='0.5'
        ;;
	'planks_base')
        __overlay_texture='../blocks/planks_oak.png'
        __colour='../../../../colour_planks_oak.png'
        __fade_level='0'
		;;
	'log')
        __overlay_texture='../blocks/log_oak.png'
        __colour='../../../../colour_log_oak.png'
        __fade_level='0.5'
		;;
	'all')
	    __stack 'sign.png' 'sign_planks_front.png' 'sign_planks_base.png' 'sign_log.png'
	    exit
	    ;;
esac

cp "${__overlay_texture}" "./base.png"

__shift "base.png" "0.05"

__rotate "base.png" "1"

__shift "base.png" "${__fudge_value}"

__rotate "base.png" "-1"

__tile "base.png" 2x1 "./base_.png"

if ! [ "${__fade_level}" = '0' ]; then

    cp "${__colour}" "./colour.png"

    __rotate "colour.png" "1"

    __shift "colour.png" "${__fudge_value}"

    __rotate "colour.png" "-1"

    __tile "colour.png" 2x1 "./colour_.png"

    __fade "./colour_.png" "./colour_2.png" "${__fade_level}"

    __clip_src_atop "./base_.png" "./colour_2.png" "./base_2.png"

    rm "./base.png" "./base_.png" "./colour.png" "./colour_.png" "./colour_2.png"

    mv "./base_2.png" "./base.png"

else

    rm "base.png"

    mv "base_.png" "base.png"

fi

__clip_src_in "sign_${2}_cutout.png" "base.png" "sign_${2}_.png"

mv "sign_${2}_.png" "sign_${2}.png"

rm "./base.png"

__popd

exit
