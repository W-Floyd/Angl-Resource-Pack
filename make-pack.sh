#!/bin/bash

__sizes=''
__verbose='0'
__install='0'
__mobile='0'

# Print help
__usage () {
echo "make-pack.sh <OPTIONS> <SIZE>

Makes the texture pack at the specified size(s) (or using
default list of sizes). Order of options and size(s) are not
important.

Options:
  -h  --help            This help message
  -v  --verbose         Be verbose
  -i  --install         Install or update .minecraft folder copy
  -m  --mobile          Make mobile resource pack as well\
"
}

# If there are are options,
if ! [ "${#}" = 0 ]; then

# then let's look at them in sequence.
for __option in $(seq "${#}"); do

    case "${1}" in

        "-h" | "--help")
            __usage
            exit
            ;;

        "-v" | "--verbose")
            __verbose='1'
            ;;

        "-i" | "--install")
            __install='1'
            ;;

        "-m" | "--mobile")
            __mobile='1'
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

if [ "${__mobile}" = '1' ]; then

    __install='0'

fi

if [ -z "${__sizes}" ]; then
__sizes="32
64
128
256
512"
fi

__render_and_pack () {

echo "Processing size ${1}"

__options="${1}"

if [ "${__mobile}" = '1' ]; then
    __options="${__options} -m"
fi

if [ "${__verbose}" = '1' ]; then
    __options="${__options} -v"
else
    __options="${__options} &> /dev/null"
fi

./render.sh ${__options}

if [ -a "${2}.zip" ]; then
    rm "${2}.zip"
fi

if [ "${__mobile}" = '1' ] && [ -a "${2}_mobile.zip" ]; then
    rm "${2}_mobile.zip"
fi

cd "${2}_cleaned"

zip -qZ store -r "../${2}" ./

cd ../

if [ "${__mobile}" = '1' ]; then
    cd "${2}_mobile"
    zip -qZ store -r "../${2}_mobile" ./
    cd ../
fi

if [ -d "${2}_cleaned" ]; then
    rm -r "${2}_cleaned"
fi

if [ -d "${2}_mobile" ]; then
    rm -r "${2}_mobile"
fi

}

for __size in $(echo "${__sizes}"); do

    __packfile="$(./render.sh --name-only "${__size}")"

    __render_and_pack "${__size}" "${__packfile}"

    __dest="${HOME}/.minecraft/resourcepacks/${__packfile}.zip"

    if [ "${__install}" = '1' ]; then

    if [ -a "${__dest}" ] ; then
        rm "${__dest}"
    fi

    cp "${__packfile}.zip" "${__dest}"

    fi

done

exit
