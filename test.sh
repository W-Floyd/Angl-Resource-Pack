#!/bin/bash
export PS4='Line ${LINENO}: '
__split_dir='/tmp/cataloguedir'

if [ -d "${__split_dir}" ]; then
    rm -r "${__split_dir}"
fi

mkdir "${__split_dir}"

if [ -e /tmp/catalogue ]; then
    rm /tmp/catalogue
fi

cp catalogue.yml /tmp/catalogue

__catalogue="/tmp/catalogue"

export __run_dir="$(dirname "$(readlink -f "$(which 'smelt')")")"
source "${__run_dir}/catalogue_processors/yaml.sh"
source "${__run_dir}/smelt_functions.sh"

__goal_variants="$(__format_variants "${1}")" || exit 1

echo "${__goal_variants}"

exit

__list_items < "${__catalogue}" | while read -r __item; do
    __read_item="$(__get_item "${__item}" < "${__catalogue}")"
    __fields="$(__list_fields <<< "${__read_item}")"

    while read -r __field; do
        __test_field "${__field}" <<< "${__fields}" || __error "Item with identifier \"${__item}\" does not contain field \"${__field}\""
    done <<< "$(__list_required_fields)"

    while read -r __field; do
        __get_value "${__field}" <<< "${__read_item}"
    done <<< "${__fields}"

done | __swallow

exit
