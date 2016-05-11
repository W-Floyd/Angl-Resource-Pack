#!/bin/bash

BASE="planks_oak"
OVERLAY="planks_acacia"

inkscape \
--export-dpi=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev) \
--export-png \
$OVERLAY".png" $OVERLAY".svg"

REMOVE=0
if ! [ -a $BASE".png" ]; then
	REMOVE=1
	bash $BASE".sh" $1
fi

composite -compose Multiply $OVERLAY".png" $BASE".png" $OVERLAY"_.png"

rm $OVERLAY".png"

if [ $REMOVE = 1 ]; then
	rm $BASE".png"
fi

mv $OVERLAY"_.png" $OVERLAY".png"

exit
