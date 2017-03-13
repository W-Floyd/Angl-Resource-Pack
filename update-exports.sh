#!/bin/bash

__verbose='0'
__no_push='0'

export __run_dir="$(dirname "$(readlink -f "$(which 'smelt')")")"
export __smelt_setup_bin="${__run_dir}/smelt_setup.sh"

# get set up
source "${__smelt_setup_bin}" &> /dev/null || { echo "Failed to load setup \"${__smelt_setup_bin}\""; exit 1; }

# Print help
__usage () {
echo "update-exports.sh <OPTIONS>

Makes the texture pack at the default sizes. Order of options
are not important.

Options:
  -h  --help            This help message
  -v  --verbose         Be verbose
  -n  --no-connection   Do not attempt to push or pull\
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

        "-n" | "--no-push")
            __force_warn "Not pushing or pulling to Github, you'll need to run
\`git push && git push --tags\` yourself."
            __no_push='1'
            ;;

        *)
            __custom_error "Unknown option \"${1}\""
            __usage
            exit 1
            ;;

    esac

    shift

done

fi

__sizes='32
64
128
256
512'

if ! [ -d '../Angl-Resource-Pack-Export' ]; then
    __error "Export dir does not exist"
fi

__date="$(date -u +%Y-%m-%d_%H-%M-%S)"

if [ "${__verbose}" = '1' ]; then
    smelt --mobile --force-optimize --compress ${__sizes}
else
    smelt --mobile --force-optimize --compress --quiet ${__sizes}
fi

if [ "${__no_push}" = '0' ]; then

    __pushd ../Angl-Resource-Pack-Export

    git pull

    __popd

fi

for __size in ${__sizes}; do

    __pack_name="$("${__smelt_render_bin}" -n "${__size}")"

    __file="${__pack_name}.zip"

	cp "${__file}" "../Angl-Resource-Pack-Export/${__file}"

	__pack_name="$("${__smelt_render_bin}" -m -n "${__size}")"

	__file="${__pack_name}.zip"

	cp "${__file}" "../Angl-Resource-Pack-Export/${__file}"

done

__pushd ../Angl-Resource-Pack-Export

sed -i '3s/.*/'"${__date}"' UTC/' README.md

git add ./*

git commit -m "${__date}"

if [ "${__no_push}" = '0' ]; then

    git push

fi

git tag -a "${__date}" -m "Exports updated at ${__date} UTC"

if [ "${__no_push}" = '0' ]; then

    git push --tags

fi

__popd

exit
