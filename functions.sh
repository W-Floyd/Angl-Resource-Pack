###############################################################
# Functions
###############################################################
#
# _demo_tile <SPACING>
#
# Demo Tile
# Tiles images for a demo
#
###############################################################

__demo_tile () {

if [ -z "${__prefix}" ]; then
    __error "__prefix has not been defined for this function."
elif [ -z "${__name}" ]; then
    __error "__name has not been defined for this function."
fi

if [ -z "${__colour}" ]; then
    __colours='black
gray
silver
white
red
orange
brown
yellow
lime
green
cyan
light_blue
blue
purple
magenta
pink'
fi

__num_colours="$(echo "${__colours}" | wc -l)"

__custom_tile $(while read -r __colour; do echo -n "${__prefix}${__colour}.png "; echo -n "${__prefix}${__colour}.png "; done <<< "${__colours}") "$((__num_colours/2))x4" "${1}" "./demos/${__name}_${1}.png"

}
