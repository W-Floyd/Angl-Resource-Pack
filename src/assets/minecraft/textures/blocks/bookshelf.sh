#!/bin/bash

BASE="planks_oak"
OVERLAY="bookshelf"

DPI=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev)

# Takes DPI and FILE in
render () {
inkscape --export-dpi=$1 --export-png $2".png" $2".svg"
}

render $DPI $OVERLAY

cp $BASE".svg" $BASE"_.svg"

render $DPI $BASE"_"

rm $BASE"_.svg"

composite $OVERLAY".png" $BASE"_.png" $OVERLAY"_.png"

rm $OVERLAY".png"

rm $BASE"_.png"

mv $OVERLAY"_.png" $OVERLAY".png"

exit
