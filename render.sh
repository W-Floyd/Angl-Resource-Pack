#!/bin/bash
###############################################################
# Debugging flag
###############################################################

#set -x

###############################################################
#
# render.sh <OPTIONS> <SIZE>
#
# Renders the texture pack at the specified size (or default)
# Order of options is not important
#
###############################################################
# Set variables
###############################################################

__name='Angl'
__tmp_directory="/tmp/texpack$$"
__catalogue='catalogue.xml'

###############################
# Defaults
###############################

__size='128'
__verbose='0'

###############################################################
# Setting up functions
###############################################################

source ./conf/__functions.sh

__announce () {
if [ "${__verbose}" = 1 ]; then
    echo "
${1}"
fi
}

__usage () {
echo "render.sh <OPTIONS> <SIZE>

Renders the texture pack at the specified size (or default 128)
Order of options and size are not important.

Options:
  -h  --help       This help message
  -v  --verbose    Verbose\
"
}

###############################################################
# Read options
###############################################################

if ! [ "$#" = 0 ]; then
for __option in $(seq "$#"); do
    case "$1" in
        "-h" | "--help")
            __usage
            exit
            ;;
        "-v" | "--verbose")
            __verbose='1'
            ;;
        [0-9]*)
            __size="${1}"
            ;;
	    *)
            echo "Unknown option \"${1}\""
            __usage
            exit 1
            ;;
    esac
    shift
done
fi

###############################################################
# Announce size
###############################################################

__announce "Using size ${__size}px"

###############################################################
# Process XML
###############################################################

__get_value_given_value catalogue.xml ITEM NAME assets/minecraft/textures/blocks/bed_head_side.png DEPENDS

exit
