#!/bin/bash

export __run_dir="$(dirname "$(readlink -f "$(which 'smelt')")")"
export __smelt_setup_bin="${__run_dir}/smelt_setup.sh"

# get set up
source "${__smelt_setup_bin}" &> /dev/null || { echo "Failed to load setup \"${__smelt_setup_bin}\""; exit 1; }

__get_field_piped () {
printf "%q" "$(cat)" | pcregrep -M -o1 "<(.*)>(\n|.)*</(.*)>"
}

__function () {
local __input="$(cat | sed 's/^[ |\t]*//')"
local __field="${1}"
local __value="$(__get_value_piped "${__field}" <<< "${__input}")"

if ! [ -z "${__value}" ]; then

if ! [ "${__value}" = 'NO' ] && ! [ "${__field}" = 'NAME' ]; then
    echo -n '  '
fi

case "${__field}" in
    "SCRIPT" | "COMMON" | "OPTIONS" | "NAME")
        echo "$(tr '[A-Z]' '[a-z]' <<< ${__field}): \"${__value}\""
        ;;
    "SIZE")
        echo "$(tr '[A-Z]' '[a-z]' <<< ${__field}): ${__value}"
        ;;
    "OPTIONAL" | "KEEP")
        if [ "${__value}" = 'YES' ]; then
            echo "$(tr '[A-Z]' '[a-z]' <<< ${__field}): $(tr '[A-Z]' '[a-z]' <<< ${__value})"
        fi
        ;;
    "DEPENDS" | "CLEANUP")
        echo "$(tr '[A-Z]' '[a-z]' <<< ${__field}):"
        while read -r __entry; do
            echo "  - \"${__entry}\""
        done <<< "${__value}"
        ;;

esac

fi
}

__fields='NAME
SCRIPT
SIZE
OPTIONS
KEEP
DEPENDS
CLEANUP
OPTIONAL
COMMON'

echo "catalogue:"

__get_range catalogue.xml ITEM | while read -r __range; do
    {
    echo -n '- '
    while read -r __field; do
        __function "${__field}" <<< "$(__read_range catalogue.xml "${__range}")"
    done <<< "${__fields}"
    } | sed 's/^/  /'
    echo
done

exit
