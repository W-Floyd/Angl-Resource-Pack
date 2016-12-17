#!/bin/bash

__size=''

# Print help
__usage () {
echo "render.sh <OPTIONS> <SIZE>

Renders the texture pack at the specified size (or default 128)
Order of options and size are not important.

Options:
  -h  --help            This help message
  -r  --re-use          Re-use xml files\
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

        [0-9]*)
            __size="${1}"
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

./render.sh -r "${1}"

cd "${__packfile}_cleaned"

zip -qZ store -r "../${__packfile}" ./

cd ../

}

if [ "${__re_use_xml_processed}" = 0 ]; then

    ./render.sh -x

fi

if [ -z "${__size}" ]; then

    for __size in "$(echo "${__sizes}")"; do

        __render_and_pack "${__size}"

    done

else

    __render_and_pack "${1}"

fi

exit
