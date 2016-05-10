#!/bin/bash

BASE="!ignore!log_top"
OVERLAY="log_oak_top"

render () {
inkscape \
--export-dpi=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev) \
--export-png \
$2".png" $2".svg"
}

render $1 $BASE

render $1 $OVERLAY

composite $OVERLAY".png" $BASE".png" $OVERLAY"_.png"

rm $BASE".png"

rm $OVERLAY".png"

mv $OVERLAY"_.png" $OVERLAY".png"

exit
