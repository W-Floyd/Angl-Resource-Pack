#!/bin/bash

#Input RES BASE OVERLAY

BASE=$(echo $(basename $0 .sh)"_colour~ignore~")
OVERLAY=$(basename $0 .sh)

DPI=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev)

# Takes DPI and FILE in
render () {
inkscape --export-dpi=$1 --export-png $2".png" $2".svg"
}

render $DPI $OVERLAY

REMOVE=0
if ! [ -a $BASE".png" ]; then
	REMOVE=1
	render $DPI $BASE
fi

composite -compose Multiply $OVERLAY".png" $BASE".png" $OVERLAY"_.png"

rm $OVERLAY".png"

if [ $REMOVE = 1 ]; then
	rm $BASE".png"
fi

mv $OVERLAY"_.png" $OVERLAY".png"

exit