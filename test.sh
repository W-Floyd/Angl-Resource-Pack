#!/bin/bash
export PS4='Line ${LINENO}: '
__split_dir='/tmp/cataloguedir'
__variant="${1}"

__default_variant='+base'

mkdir -p "${__split_dir}"

__catalogue="./catalogue.yml"

export __run_dir="$(dirname "$(readlink -f "$(which 'smelt')")")"
source "${__run_dir}/catalogue_processors/yaml.sh"
source "${__run_dir}/smelt_functions.sh"

if [ -z "${__variant}" ]; then
    __variant="${__default_variant}"
fi

__goal_variants="$(__format_variants "${__variant}")" || exit 1

################################################################
#
# ... field list in | __check_required_fields
#
# Checks a list of fields if they contain a required field.
#
################################################################

__check_required_fields () {
local __fields="$(cat)"
while read -r __field; do
    __test_field "${__field}" <<< "${__fields}" || __error "Item with identifier \"${__item}\" does not contain field \"${__field}\""
done <<< "$(__list_required_fields)"
}

################################################################
#
# ... field list in | __write_fields
#
# Splits all fields into folders of the same name in the given
# directory, with the field list being piped in. Relies on
# __read_item, __name, __variant, __split_dir, . Reads the field if it exists, uses default if it
# does not.
#
################################################################

__write_fields () {
cat | while read -r __field; do
    local __value="$(if __test_field "${__field}" <<< "${__fields}"; then __get_value "${__field}" <<< "${__read_item}"; else __field_default "${__field}"; fi)"
    if ! [ -z "${__value}" ]; then
        local __goalfile="${__split_dir}/variants/${__variant}/${__field}/${__name}"
        local __goaldir="$(dirname "${__goalfile}")"
        if ! [ -d "${__goaldir}" ]; then
            mkdir -p "${__goaldir}"
        fi
        echo "${__value}" > "${__goalfile}"
    fi
done
}

################################################################
# Splits the catalogue
__split_catalogue () {
__list_items < "${__catalogue}" | while read -r __item; do
    __get_item "${__item}" < "${__split_dir}/split/catalogue" > "${__split_dir}/split/items/${__item}"
done
}

################################################################
# Checks and splits the catalogue as needed
__check_split () {

local __should_split_catalogue='0'

if ! [ -d "${__split_dir}/split/items" ]; then

    __should_split_catalogue='1'

    mkdir -p "${__split_dir}/split/items"

fi

if [ -e "${__split_dir}/split/catalogue" ]; then

    if ! [ "$(md5sum < "${__split_dir}/split/catalogue")" = "$( __clean_pack < "${__catalogue}" | md5sum)" ]; then
        rm "${__split_dir}/split/catalogue"
        __should_split_catalogue='1'
    fi

else
    __should_split_catalogue='1'
fi

if [ "${__should_split_catalogue}" = '1' ]; then
    __clean_pack < "${__catalogue}" > "${__split_dir}/split/catalogue"
    __split_catalogue
fi

}

################################################################

export __time='1'
export __verbose='1'

__time "Split catalogue" start

__check_split

__time "Split catalogue" end

export __verbose='0'

################################################################

ls -1 "${__split_dir}/split/items" | while read -r __item; do
    __read_item="$(cat "${__split_dir}/split/items/${__item}")"
    __fields="$(__list_fields <<< "${__read_item}")"

    __check_required_fields <<< "${__fields}"

    __name="$(__get_value name <<< "${__read_item}")"

    __write_fields <<< "$( { __list_optional_fields; echo "${__fields}"; } | sort | uniq)"

done

exit
