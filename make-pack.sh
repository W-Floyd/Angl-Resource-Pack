#!/bin/bash

__sizes=''
__verbose='0'

# Print help
__usage () {
echo "make-pack.sh <OPTIONS> <SIZE>

Makes the texture pack at the specified size (or using default
list). Order of options and size are not important.

Options:
  -h  --help            This help message
  -v  --verbose         Be verbose\
"
}

# If there are are options,
if ! [ "${#}" = 0 ]; then

# then let's look at them in sequence.
for __option in $(seq "${#}"); do

    case "${1}" in

        "-v" | "--verbose")
            __verbose='1'
            ;;

        [0-9]*)
            __sizes="${__sizes}
${1}"
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

if [ -z "${__sizes}" ]; then
__sizes="32
64
128
256
512"
fi

__render_and_pack () {

__packfile="$(./render.sh --name-only "${1}")"

echo "Processing size ${1}"

if [ "${__verbose}" = '1' ]; then
    ./render.sh -v "${1}"
else
    ./render.sh "${1}" 1> /dev/null
fi

if [ -a "${__packfile}" ]; then
    rm "${__packfile}.zip"
fi

cd "${__packfile}_cleaned"

zip -qZ store -r "../${__packfile}" ./

cd ../

rm -r "${__packfile}_cleaned"

}

for __size in $(echo "${__sizes}"); do

    __render_and_pack "${__size}"

done

exit
