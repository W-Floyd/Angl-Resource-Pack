#!/bin/bash

BASE="~ignore~log_top"
OVERLAY="log_birch_top"
COLOUR="planks_birch"

render () {
inkscape \
--export-dpi=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev) \
--export-png \
$2".png" $2".svg"
}

render $1 $BASE

cp $COLOUR".svg" $COLOUR"_.svg"

render $1 $COLOUR"_"

rm $COLOUR"_.svg"

render $1 $OVERLAY

composite -compose Screen $COLOUR"_.png" $OVERLAY".png" $OVERLAY"_.png"

rm $COLOUR"_.png"

rm $OVERLAY".png"

mv $OVERLAY"_.png" $OVERLAY".png"

composite $OVERLAY".png" $BASE".png" $OVERLAY"_.png"

rm $BASE".png"

rm $OVERLAY".png"

mv $OVERLAY"_.png" $OVERLAY".png"

exit
