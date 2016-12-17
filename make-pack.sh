#!/bin/bash

__size=''
__use_size='0'
__re_use_xml_processed='0'
__verbose='0'

# Print help
__usage () {
echo "make-pack.sh <OPTIONS> <SIZE>

Makes the texture pack at the specified size (or using default
list). Order of options and size are not important.

Options:
  -h  --help            This help message
  -r  --re-use          Re-use xml files
  -v  --verbose         Be verbose\
"
}

# If there are are options,
if ! [ "${#}" = 0 ]; then

# then let's look at them in sequence.
for __option in $(seq "${#}"); do

    case "${1}" in

        "-r" | "--re-use")
            __re_use_xml_processed='1'
            ;;

        "-v" | "--verbose")
            __verbose='1'
            ;;

        [0-9]*)
            __size="${1}"
            __use_size='1'
            ;;

        *)
            echo "Unknown option \"${1}\""
            echo
            __usage
            exit 1
            ;;

    esac

    shift

done

fi

__sizes="32
64
128
256
512"

__render_and_pack () {

__packfile="$(./render.sh --name-only "${1}")"

echo "Processing size ${1}"

if [ "${__verbose}" = '1' ]; then
    ./render.sh -v -r "${1}"
else
    ./render.sh -r "${1}" 1> /dev/null
fi

cd "${__packfile}_cleaned"

zip -qZ store -r "../${__packfile}" ./

cd ../

rm -r "${__packfile}_cleaned"

}

if [ "${__re_use_xml_processed}" = 0 ]; then

    echo "Processing xml files"

    if [ "${__verbose}" = '1' ]; then
        ./render.sh -x -v
    else
        ./render.sh -x 1> /dev/null
    fi

fi

if [ "${__use_size}" = '0' ]; then

    for __size in $(echo "${__sizes}"); do

        __render_and_pack "${__size}"

    done

else

    __render_and_pack "${1}"

fi

exit
