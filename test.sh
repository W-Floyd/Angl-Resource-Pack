#!/bin/bash
export PS4='Line ${LINENO}: '
__split_dir='/tmp/cataloguedir'

__default_variant='+base'

mkdir -p "${__split_dir}"

__catalogue="./catalogue.yml"

export __run_dir="$(dirname "$(readlink -f "$(which 'smelt')")")"
source "${__run_dir}/catalogue_processors/yaml.sh"
source "${__run_dir}/smelt_functions.sh"

if [ -z "${1}" ]; then
    __variant="$(__format_variants "${__default_variant}" -l)"
else
    __variant="$(__format_variants "${1}" -l)"
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
__list_items < "${__split_dir}/split/catalogue" | while read -r __item; do
    __get_item "${__item}" < "${__split_dir}/split/catalogue" > "${__split_dir}/split/items/${__item}"
done
}

################################################################
# Checks and splits the catalogue as needed
__check_split_catalogue () {

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
    if [ -d "${__split_dir}/split/items" ]; then
        rm -r "${__split_dir}/split/items"
    fi
    mkdir -p "${__split_dir}/split/items"
    __clean_pack < "${__catalogue}" > "${__split_dir}/split/catalogue"
    __split_catalogue
fi

}

################################################################
# Splits all fields out into their own folders, checking variant
__split_fields () {

ls -1 "${__split_dir}/split/items" | while read -r __item; do
    __read_item="$(cat "${__split_dir}/split/items/${__item}")"
    __fields="$(__list_fields <<< "${__read_item}")"

    __check_required_fields <<< "${__fields}"

    if __check_variant "$(__format_variants "${__variant}")" "$(__format_variants "$(if __test_field variant <<< "${__fields}"; then __get_value variant <<< "${__read_item}"; else __field_default variant; fi)")"; then

        __name="$(__get_value provides <<< "${__read_item}")"

        if ! [ -e "${__split_dir}/variants/${__variant}/variant/${__name}" ]; then

            __write_fields <<< "$( { __list_optional_fields; echo "${__fields}"; } | grep -vx 'name' | sort | uniq)"

        elif __prioritize_variant "${__variant}" "$(cat "${__split_dir}/variants/${__variant}/variant/${__name}")"; then

            __write_fields <<< "$( { __list_optional_fields; echo "${__fields}"; } | grep -vx 'name' | sort | uniq)"

        fi

    fi

done

}

################################################################
# Checks and splits the fields out of the catalogue

__check_split_fields () {

local __should_split_fields='0'

if ! [ -d "${__split_dir}/split/items" ]; then

    __should_split_catalogue='1'

    mkdir -p "${__split_dir}/split/items"

fi

if ! [ -e "${__split_dir}/split/catalogue" ]; then
    __error "Catalogue must be split first."
fi

if [ -e "${__split_dir}/variants/${__variant}/catalogue" ]; then

    if ! [ "$(md5sum < "${__split_dir}/split/catalogue")" = "$( md5sum < "${__split_dir}/variants/${__variant}/catalogue")" ]; then
        rm "${__split_dir}/variants/${__variant}/catalogue"
        __should_split_fields='1'
    fi

else
    __should_split_fields='1'
fi

if [ "${__should_split_fields}" = '1' ]; then
    if [ -d "${__split_dir}/variants/${__variant}" ]; then
        rm -r "${__split_dir}/variants/${__variant}"
    fi
    mkdir -p "${__split_dir}/variants/${__variant}"
    __split_fields
    cp "${__split_dir}/split/catalogue" "${__split_dir}/variants/${__variant}/catalogue"
fi

}

################################################################

export __time='1'
export __verbose='1'

__time "Split catalogue" start

__check_split_catalogue

__time "Split catalogue" end

################################################################

__time "Split fields" start

################################################################

__check_split_fields

################################################################

__time "Split fields" end

exit
