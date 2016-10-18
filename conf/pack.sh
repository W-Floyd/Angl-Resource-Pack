#!/bin/bash

__render $1 pack.svg

convert -size ${1}x${1} canvas:white pack_.png

__overlay pack_.png pack.png pack__.png

rm pack_.png pack.png

mv pack__.png pack.png

exit
