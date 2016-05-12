#!/bin/bash

DPI=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev)
GENERICBASE=$(basename $0 .sh)
GENERICOVERLAY="planks~ignore~"

# Takes DPI and FILE in
render () {
inkscape --export-dpi=$1 --export-png $2".png" $2".svg"
}

render $DPI $GENERICOVERLAY

REMOVE=0
if [ -a $GENERICBASE".png" ]; then
	rm $GENERICBASE
fi

render $DPI $GENERICBASE

composite -compose Multiply $GENERICOVERLAY".png" $GENERICBASE".png" $GENERICBASE"_.png"

rm $GENERICOVERLAY".png"

if [ $REMOVE = 1 ]; then
	rm $GENERICBASE".png"
fi

mv $GENERICBASE"_.png" $GENERICBASE".png"

exit