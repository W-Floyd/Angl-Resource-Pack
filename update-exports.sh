#!/bin/bash

__sizes='32 64 128 256 512'
__verbose='0'

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
for __option in $(seq "${#}"); do

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

if ! [ -d '../Angl-Resource-Pack-Export' ]; then
    echo "Export dir does not exist."
    exit 1
fi

__date="$(date -u +%Y-%m-%d_%H-%M-%S)"

if [ "${__verbose}" = '1' ]; then
    ./make-pack.sh -v ${__sizes}
else
    ./make-pack.sh ${__sizes}
fi

for __size in ${__sizes}; do

    __name="$(./render.sh -n "${__size}")"

    __file="${__name}.zip"

	cp "${__file}" "../Angl-Resource-Pack-Export/${__file}"

done

cd ../Angl-Resource-Pack-Export

sed -i '3s/.*/'"${__date}"' UTC/' README.md

git add *

git commit -m "${__date}"

git push

git tag -a "${__date}" -m "Exports updated at ${__date} UTC"

git push --tags

cd ../Angl-Resource-Pack

exit
