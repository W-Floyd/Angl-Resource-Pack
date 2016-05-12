#!/bin/bash

render () {
inkscape \
--export-dpi=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev) \
--export-png \
$2".png" $2".svg"
} 

#The plank colour
BASE1=$(basename $0 .sh | sed 's/_top//' | sed 's/log_/planks_/')

#Generic log ring pattern top
OVERLAY1="log_generic_top_1~ignore~"

#The log bark colour
BASE2=$(basename $0 .sh | sed 's/_top/_colour~ignore~/')

#Generic log bark pattern top
OVERLAY2="log_generic_top_2~ignore~"

cp $BASE1".svg" $BASE1"_.svg"

BASE1=$(echo $BASE1"_")

render $1 $BASE1

rm $BASE1".svg"

render $1 $OVERLAY1

composite -compose Multiply $OVERLAY1".png" $BASE1".png" $BASE1"_.png"

rm $OVERLAY1".png"

rm $BASE1".png"

mv $BASE1"_.png" $BASE1".png"

# BASE1 now holds the plank coloured ring pattern

cp $BASE2".svg" $BASE2"_.svg"

BASE2=$(echo $BASE2"_")

render $1 $BASE2

rm $BASE2".svg"

render $1 $OVERLAY2

composite -compose dst-in $OVERLAY2".png" $BASE2".png" $BASE2"_.png"

rm $BASE2".png"

mv $BASE2"_.png" $BASE2".png"

# We now have:
# BASE1 - ring pattern
# BASE2 - outer ring to be shaded
# OVERLAY2 - outer ring to shade with

composite -compose Multiply $OVERLAY2".png" $BASE2".png" $BASE2"_.png"

rm $OVERLAY2".png"

rm $BASE2".png"

mv $BASE2"_.png" $BASE2".png"

# We now have:
# BASE1 - ring pattern
# BASE2 - outer ring

composite $BASE2".png" $BASE1".png" $(basename $0 .sh)".png"

rm $BASE1".png"

rm $BASE2".png"

exit
