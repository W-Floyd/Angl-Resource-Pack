#!/bin/bash

BASE="stone"
OVERLAY="cobblestone"

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

composite $OVERLAY".png" $BASE".png" $OVERLAY"_.png"

rm $OVERLAY".png"

mv $OVERLAY"_.png" $OVERLAY".png"

if [ $REMOVE = 1 ]; then
	rm $BASE".png"
fi

exit
