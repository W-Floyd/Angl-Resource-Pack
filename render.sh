#!/bin/bash
###############################################################
# Debugging flag
###############################################################

#set -x

###############################################################
# Set variables
###############################################################

__name='Angl'
__tmp_dir="/tmp/texpack$$"
__catalogue='catalogue.xml'

###############################
# Defaults
###############################

__size='128'
__verbose='0'
__very_verbose='0'
__force='0'
__cores='1'
__optimize='0'

###############################################################
# Setting up functions
###############################################################

source functions.sh

__usage () {
echo "render.sh <OPTIONS> <SIZE>

Renders the texture pack at the specified size (or default 128)
Order of options and size are not important.

Options:
  -h  --help            This help message
  -f  --force           Discard pre-rendered data
  -v  --verbose         Verbose
  -vv --very-verbose    Very verbose
  -o  --optimize        Optimize\
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
            exit 0
            ;;
        "-f" | "--force")
            __force='1'
            echo "Discarding pre-rendered data"
            ;;
        "-v" | "--verbose")
            __verbose='1'
            ;;
        "-vv" | "--very-verbose")
            __verbose='1'
            __very_verbose='1'
            ;;
        "-o" | "--optimize")
            __optimize='1'
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
# Set variables dependant on options
###############################################################

__pack="${__name}-${__size}px"

###############################################################
# Announce size
__announce "Using size ${__size}px"
###############################################################

###############################################################
# Set up folders
###############################################################

mkdir "${__tmp_dir}"

if [ -d "${__pack}" ]; then
    if [ "${__force}" = 1 ]; then
        rm -r "${__pack}"
    else
        echo "Reusing rendered data"
    fi
fi

###############################################################
# Hash sources
__announce "Hashing sources"
###############################################################

__source_hashes="${__tmp_dir}/source_hashes"

__pushd src

__hash_folder "${__source_hashes}"

__popd

###############################################################
# Split XML
__announce "Splitting XML"
###############################################################

__xml_current="${__tmp_dir}/xml_current"
__xml_old="${__tmp_dir}/xml_old"

for __range in $(__get_range "${__catalogue}" ITEM); do
    __random="${RANDOM}"
    __read_range_file="${__tmp_dir}/${__range}${__random}"
    __read_range "${__catalogue}" "${__range}" > "${__read_range_file}"

    #TODO
    # Optimize __get_value

    __item_name="$(__get_value "${__read_range_file}" NAME)"
    mkdir -p "$(__odir "${__xml_current}/${__item_name}")"
    mv "${__read_range_file}" "${__xml_current}/${__item_name}"
done &

wait

###############################################################
# General Cleanup
__announce "Cleaning up"
###############################################################

#rm -r "${__tmp_dir}"

exit
