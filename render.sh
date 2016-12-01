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
__force='0'

###############################################################
# Setting up functions
###############################################################

source functions.sh

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
  -f  --force      Discard pre-rendered data
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
            exit 0
            ;;
        "-v" | "--verbose")
            __verbose='1'
            ;;
        "-f" | "--force")
            __force='1'
            echo "Discarding pre-rendered data"
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
        rm -r "${__force}"
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
#
__announce
###############################################################



###############################################################
# General Cleanup
__announce "Cleaning up"
###############################################################

rm -r "${__tmp_dir}"

exit
