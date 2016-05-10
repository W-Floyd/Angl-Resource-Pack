#!/bin/bash

BASE="log_oak_top"
# What to overlay things onto

OVERLAY1="log_acacia"
# The outer ring colour
# May need to match mode to the other script

OVERLAY2="planks_acacia"
# The inner circle colour
# May need to match mode to the other script

CLIP=$(echo $OVERLAY1"_top")
# A black clip of the inner area to apply
# The outer ring will be applied with the inverse of this

render () {
inkscape \
--export-dpi=$(echo "(90*"$1")/128" | bc -l | rev | sed 's/0*//' | rev) \
--export-png \
$2".png" $2".svg"
}

REMOVEBASE="0"
if ! [ -a $BASE".png" ]; then
	REMOVEBASE="1"
	render $1 $BASE
fi

cp $BASE".png" $BASE"_.png"

cp $OVERLAY1".svg" $OVERLAY1"_.svg"

render $1 $OVERLAY1"_"

rm $OVERLAY1"_.svg"

cp $OVERLAY2".svg" $OVERLAY2"_.svg"

render $1 $OVERLAY2"_"

rm $OVERLAY2"_.svg"

render $1 $CLIP

mv $CLIP".png" $CLIP"_.png"

# Just to keep things straight in my own head:
# BASE_ holds the base to be applied to 
# OVERLAY1_ now holds the outer ring colour to be applied
# OVERLAY2_ now holds the inner cicle colour to be applied
# CLIP_ now holds the silhouette to apply to the inner colour

composite -compose dst-out $CLIP"_.png" $OVERLAY1"_.png" $OVERLAY1"__.png"

rm $OVERLAY1"_.png"

mv $OVERLAY1"__.png" $OVERLAY1"_.png"

# At this point, OVERLAY1_ is the clipped outer ring to be applied to BASE_

composite -compose Screen $OVERLAY1"_.png" $BASE"_.png" $BASE"__.png"

rm $BASE"_.png"

mv $BASE"__.png" $BASE"_.png"

# BASE_ now has the outer ring applied. Need to do inner ring

composite -compose dst-in $CLIP"_.png" $OVERLAY2"_.png" $OVERLAY2"__.png"

rm $OVERLAY2"_.png"

mv $OVERLAY2"__.png" $OVERLAY2"_.png"

# OVERLAY2_ now has the inner circle, ready to be applied to BASE_

rm $CLIP"_.png"

composite -compose Multiply $OVERLAY2"_.png" $BASE"_.png" $CLIP"_.png"

# CLIP_ now has the final image

if [ $REMOVEBASE = "1" ]; then
	rm $BASE".png"
fi

rm $BASE"_.png"

rm $OVERLAY1"_.png"

rm $OVERLAY2"_.png"

mv $CLIP"_.png" $CLIP".png"

exit
