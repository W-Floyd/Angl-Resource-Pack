###############################################################
# Configurables
###############################################################
#
# __mode="quick" or __mode="slow"
#
#
# Render Mode
# Not really much different, but it will become more apparent
# with larger image sets. "slow" is safer (uses inkscape)
#
###############################################################

__mode="slow"

###############################################################

###############################################################
# Functions
###############################################################
#
# __mext <string>
#
# Minus Extension
# Strips last file extension from string
# Nevermind readability, we all want one-liners!
#
###############################################################

__mext () {
sed 's|\(.*\)\(\.\).*|\1|' <<< "$1"
}

###############################################################
#
# __render <DPI> <FILE.svg>
#
# Render Image
# Renders the specified .svg to a .png of the same name
#
###############################################################

if [ $__mode = "quick" ]; then
__render () {
rsvg-convert \
-d $(echo "(90*$1)/128" | bc -l | rev | sed 's/0*//' | rev) \
-p $(echo "(90*$1)/128" | bc -l | rev | sed 's/0*//' | rev) \
"$2" \
-o $(__mext "$2")".png"
}
elif [ $__mode = "slow" ]; then
__render () {
# DPI and FILE.svg inputs
inkscape \
--export-dpi=$(echo "(90*$1)/128" | bc -l | rev | sed 's/0*//' | rev) \
--export-png $(__mext "$2")".png" "$2"
}

###############################################################
# Composition functions
###############################################################
#
# __multiply <BASE.png> <OVERLAY_TO_MULTIPLY.png> <OUTPUT.png>
#
# Multiply Images
# Composites specified images, with a multiply blending method
#
###############################################################

__multiply () {
composite -compose Multiply "$2" "$1" "$3"
}

###############################################################
#
# __screen <BASE.png> <OVERLAY_TO_SCREEN.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with a screen blending method
#
###############################################################

__screen () {
composite -compose Screen "$2" "$1" "$3"
}

###############################################################
#
# __clip_src_over <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with src-over alpha blending
#
###############################################################

__clip_src_over () {
composite -compose src-over "$2" "$1" "$3"
}

###############################################################
#
# __clip_dst_over <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with dst-over alpha blending
#
###############################################################

__clip_dst_over () {
composite -compose dst-over "$2" "$1" "$3"
}

###############################################################
#
# __clip_src_in <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with src-in alpha blending
#
###############################################################

__clip_src_in () {
composite -compose src-in "$2" "$1" "$3"
}

###############################################################
#
# __clip_dst_in <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with dst-in alpha blending
#
###############################################################

__clip_dst_in () {
composite -compose dst-in "$2" "$1" "$3"
}

###############################################################
#
# __clip_src_out <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with src-out alpha blending
#
###############################################################

__clip_src_out () {
composite -compose src-out "$2" "$1" "$3"
}

###############################################################
#
# __clip_dst_out <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with dst-out alpha blending
#
###############################################################

__clip_dst_out () {
composite -compose dst-out "$2" "$1" "$3"
}

###############################################################
#
# __clip_src_atop <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with src-atop alpha blending
#
###############################################################

__clip_src_atop () {
composite -compose src-atop "$2" "$1" "$3"
}

###############################################################
#
# __clip_dst_atop <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with dst-atop alpha blending
#
###############################################################

__clip_dst_atop () {
composite -compose dst-atop "$2" "$1" "$3"
}

###############################################################
#
# __clip_xor <BASE.png> <OVERLAY.png> <OUTPUT.png>
#
# Screen Images
# Composites specified images, with xor alpha blending
#
###############################################################

__clip_xor () {
composite -compose xor "$2" "$1" "$3"
}

###############################################################
# Export functions
###############################################################
# 
# Do this so that any child shells have these functions
###############################################################
for __function in $(compgen -A function); do
	export -f $__function
done
