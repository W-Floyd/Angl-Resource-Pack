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
# Functions
###############################################################
#
# __mext <string>
#
# Minus Extension
# Strips last file extension from string
#
###############################################################

__mext () {
sed 's|\(.*\)\(\.\).*|\1|' <<< "${1}"
}

###############################################################
#
# __render <DPI> <FILE.svg>
#
# Render Image
# Renders the specified .svg to a .png of the same name
#
###############################################################

if [ $__mode = 'quick' ]; then
__render () {
rsvg-convert
-d "$(echo "(90*${1})/128" | bc -l | rev | sed 's/0*//' | rev)" \
-p "$(echo "(90*${1})/128" | bc -l | rev | sed 's/0*//' | rev)" \
"${2}" \
-o "$(__mext "${2}")"".png" 1> /dev/null
convert "$(__mext "${2}")"".png" -define png:color-type=6 "$(__mext "$2")"'_'".png"
mv "$(__mext "${2}")"'_'".png" "$(__mext "${2}")"".png"
}
elif [ "{$__mode}" = 'slow' ]; then
__render () {
inkscape \
--export-dpi="$(echo "(90*${1})/128" | bc -l | rev | sed 's/0*//' | rev)" \
--export-png "$(__mext "${2}").png" "${2}" 1> /dev/null
convert "$(__mext "${2}")"".png" -define png:color-type=6 "$(__mext "${2}")"'_'".png"
mv "$(__mext "${2}")"'_'".png" "$(__mext "${2}")"".png"
}
fi

###############################################################
# Composition functions
###############################################################
#
# __overlay <BASE.png> <OVERLAY> <OUTPUT.png>
#
# Overlay Images
# Composites specified images, one on the other
# Same as src-over, but this is easier to remember
#
###############################################################

__overlay () {
composite -define png:color-type=6 -compose src-over "${2}" "${1}" "${3}"
}

###############################################################
#
# __multiply <BASE.png> <OVERLAY_TO_MULTIPLY.png> <OUTPUT.png>
#
# Multiply Images
# Composites specified images, with a multiply blending method
#
###############################################################

__multiply () {
composite -define png:color-type=6 -compose Multiply "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose Screen "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose src-over "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose dst-over "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose src-in "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose dst-in "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose src-out "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose dst-out "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose src-atop "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose dst-atop "${2}" "${1}" "${3}"
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
composite -define png:color-type=6 -compose xor "${2}" "${1}" "${3}"
}

###############################################################
# Image manipulation functions
###############################################################
#
# __fade <INPUT> <OUTPUT> <AMOUNT>
#
# Fade image
# Makes an image transparent.Note that AMOUNT must be a value
# 0-1, 0 being fully transparent, 1 being unchanged
#
###############################################################

__fade () {
__tmptrans=$(echo '1/'"${3}" | bc)
convert "${1}" -alpha set -channel Alpha -evaluate Divide "${__tmptrans}" -define png:color-type=6 "${2}"
}

###############################################################
#
# __tile <FILE> <GRID> <OUTPUT> <DIVIDER>
#
# Tile
# Tiles image at the specified grid size, with an optional
# divider width
#
###############################################################

__tile () {
if ! [ -z "${4}" ]; then
	__spacer="${4}"
else
	__spacer=0
fi

__imgseq=$(for __tile in $(seq 1 "$(echo "${2}" | sed 's/x/\*/' | bc)"); do echo -n "${1} "; done)

montage -geometry "+${__spacer}+${__spacer}" -background none -tile "${2}" ${__imgseq} "${3}" 2> /dev/null

}

###############################################################
#
# __crop <INPUT> <RESOLUTION> <X-CORD> <Y-CORD> <OUTPUT>
#
# Crop
# Crops an image to the specified square
#
# Example:
# __crop image.png 128 2 1 out.png
#
# That will crop the image to the third square across and the
# second square down.
#
# Example:
# __crop image.png 512 0 0 out.png
#
# That will crop the top-left square, assuming a resolution of
# 512px
#
###############################################################

__crop () {
convert "${1}" -crop "${2}x${2}+$(echo "${3}*${2}" | bc)+$(echo "${4}*${2}" | bc)" "${5}"
}

###############################################################
#
# __rotate <IMAGE> <STEP>
#
# Rotate
# Rotates the image 0, 90, 180, 270, 360
# Give option +/- 0, 1, 2, 3 or 4
#
# 0 = 0 degrees
# 1, -3 = 90 degrees
# 2, -2 = 180 degrees
# 3, -1 = 270 degrees
# 4, -4 = 360 degrees
#
###############################################################

__rotate () {
case "${2}" in
	"0")
		__angle="0"
		;;
	"1")
		__angle="90"
		;;
	"2")
		__angle="180"
		;;
	"3")
		__angle="270"
		;;
	"4")
		__angle="360"
		;;
	"-1")
		__angle="270"
		;;
	"-2")
		__angle="180"
		;;
	"-3")
		__angle="90"
		;;
	"-4")
		__angle="360"
		;;
esac

mogrify -rotate "${__angle}" "${1}"
}

###############################################################
#
# __shift <IMAGE> <PROPORTION>
#
# Shift
# Tiles an image vertically, then crops at the specified
# proportion. Equivalent to looping by shifting UP
#
###############################################################

__shift () {
__tile "${1}" 1x2 "${1}"_
mv "${1}"_ "${1}"
convert "${1}" -crop "$(identify -format "%wx%w" "${1}")+0+$(printf "%.0f" "$(echo "$(identify -format "%w" "${1}")*${2}" | bc)")" "${1}"_
mv "${1}"_ "${1}"
}

###############################################################
# XML Functions
###############################################################
#
# __get_range <FILE> <FIELD_NAME>
#
# Get Range
# Gets the range/s in a <FILE> between each set of <FIELD_NAME>
#
#
# Example:
#
# __get_range catalogue.xml ITEM
#
# will print
#
# 2,10
# 11,19
# 20,28
# 31,39
#
###############################################################

__get_range () {
cat "${1}" | grep -n '[</|<]'"${2}"'>' | sed 's/\:.*//' |  sed 'N;s/\n/,/'
}

###############################################################
#
# __read_range <FILE> <RANGE>
#
# Read Range
# Reads the <RANGE> from a <FILE>, as generated by __get_range
# Must be single line input.
#
###############################################################

__read_range () {
cat "${1}" | sed "${2}"'!d' | sed 's/^[ |	]*//'
}

###############################################################
#
# __get_value <DATASET> <FIELD_NAME>
#
# Get Value
# Gets the value/s of <FIELD_NAME> from <DATASET>
# Meant to be used on separated datasets
#
###############################################################

__get_value () {
__read_range "${1}" "$(__get_range "${1}" "${2}")" | sed -e 's/^<'"${2}"'>//' -e 's/<\/'"${2}"'>$//'
}

###############################################################
#
# __set_value <DATASET> <FIELD_NAME> <VALUE>
#
# Set Value
# Sets the <VALUE> of the specified <FIELD_NAME>
#
###############################################################

__set_value () {
cat "${1}" | sed -n '1,/<'"${2}"'>.*/p' | head -n -1 > /tmp/__set_value
echo '<'"${2}"'>'"${3}"'</'"${2}"'>' >> /tmp/__set_value
cat "${1}" | sed -n '/<\/'"${2}"'>/,$p' | tail -n +2 >> /tmp/__set_value
mv /tmp/__set_value "${1}"
}

###############################################################
# Other stuff
###############################################################
#
# __emergency_exit
#
# Prints the last known command and exits, to be used when a
# commmand fails
#
# Example:
# cd "${__dir}" || __emergency_exit
#
###############################################################

__emergency_exit () {
echo "Last command run was ["!:0"] with arguments ["!:*"]"
exit 1
}

###############################################################
#
# __hash_folder <FILE>
#
# Hashes the current folder and outputs to <FILE>
#
###############################################################

__hash_folder () {
find -type f -exec md5sum '{}' \; > "${1}"
}

###############################################################
#
# __pushd <DIR>
#
# Same as regular pushd, just quiet
#
###############################################################

__pushd () {
pushd "${1}" 1> /dev/null
}

###############################################################
#
# __popd
#
# Same as regular popd, just quiet
#
###############################################################

__popd () {
popd 1> /dev/null
}

###############################################################
# Export functions
###############################################################
#
# Do this so that any child shells have these functions
###############################################################
for __function in $(compgen -A function); do
	export -f ${__function}
done
