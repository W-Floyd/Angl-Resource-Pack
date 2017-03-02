#!/bin/bash

__verbose='0'

__smelt_functions_bin='/usr/share/smelt/smelt_functions.sh'
__smelt_render_bin='/usr/share/smelt/smelt_render.sh'

# Print help
__usage () {
echo "update-exports.sh <OPTIONS>

Makes the texture pack at the default sizes. Order of options
are not important.

Options:
  -h  --help            This help message
  -v  --verbose         Be verbose\
"
}

# If there are are options,
if ! [ "${#}" = 0 ]; then

# then let's look at them in sequence.
while ! [ "${#}" = '0' ]; do

    case "${1}" in

        "-h" | "--help")
            __usage
            exit
            ;;

        "-v" | "--verbose")
            __verbose='1'
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

# get functions from file
source "${__smelt_functions_bin}" &> /dev/null || { echo "Failed to load functions '${__smelt_functions_bin}'"; exit 1; }

if ! [ -e 'config.sh' ]; then
    __warn "No config file was found, using default values"
else
    source 'config.sh' || __error "Config file has an error."
fi

__sizes='32 64 128 256 512'

if ! [ -d '../Angl-Resource-Pack-Export' ]; then
    __error "Export dir does not exist"
fi

__date="$(date -u +%Y-%m-%d_%H-%M-%S)"

if [ "${__verbose}" = '1' ]; then
    smelt -m -v ${__sizes}
else
    smelt -m ${__sizes}
fi

__pushd ../Angl-Resource-Pack-Export

git pull

__popd

for __size in ${__sizes}; do

    __name="$("${__smelt_render_bin}" -n "${__size}")"

    __file="${__name}.zip"

	cp "${__file}" "../Angl-Resource-Pack-Export/${__file}"

	__file="${__name}_mobile.zip"

	cp "${__file}" "../Angl-Resource-Pack-Export/${__file}"

done

__pushd ../Angl-Resource-Pack-Export

sed -i '3s/.*/'"${__date}"' UTC/' README.md

git add ./*

git commit -m "${__date}"

git push

git tag -a "${__date}" -m "Exports updated at ${__date} UTC"

git push --tags

__popd

exit
