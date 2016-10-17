#!/bin/bash

DPI=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev)
GENERICBASE=$(echo "~ignore~colour_"$(basename $0 .sh | sed 's/glass_//'))
GENERICOVERLAY="glass"

# Takes DPI and FILE in
render () {
inkscape --export-dpi=$1 --export-png $2".png" $2".svg"
}

REMOVE=0
if ! [ -a $GENERICOVERLAY".png" ]; then
	REMOVE=1
	render $DPI $GENERICOVERLAY
fi

render $DPI $GENERICBASE

composite -compose dst-in $GENERICOVERLAY".png" $GENERICBASE".png" $GENERICBASE"_.png"

rm $GENERICBASE".png"

mv $GENERICBASE"_.png" $GENERICBASE".png"

#composite -compose Multiply $GENERICOVERLAY".png" $GENERICBASE".png" $GENERICBASE"_.png"

if [ $REMOVE = 1 ]; then
	rm $GENERICOVERLAY".png"
fi

#mv $GENERICBASE"_.png" $GENERICBASE".png"

mv $GENERICBASE".png" $(basename $0 .sh)".png"

exit
