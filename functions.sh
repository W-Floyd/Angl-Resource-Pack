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

while read -r __colour; do

    __tile "${__prefix}${__colour}.png" 2x1 "./demos/${__name}_${__colour}.png" "${1}"

done <<< "${__colours}"

__custom_tile $(while read -r __colour; do echo -n "./demos/${__name}_${__colour}.png "; done <<< "${__colours}") "$((__num_colours/4))x4" "0" "./demos/${__name}_${1}.png"

while read -r __wool; do

    rm "./demos/${__name}_${__wool}.png"

done <<< "${__colours}"

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
