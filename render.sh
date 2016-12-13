#!/bin/bash
###############################################################
# Debugging flag
###############################################################

#set -x

###############################################################
# Set variables
###############################################################

__name='Angl'
__tmp_dir="/tmp/texpack$$"
__catalogue='catalogue.xml'

###############################
# Defaults
###############################

__size='128'
__verbose='0'
__very_verbose='0'
__force='0'
__cores='1'
__optimize='0'

###############################################################
# Setting up functions
###############################################################

source functions.sh

__usage () {
echo "render.sh <OPTIONS> <SIZE>

Renders the texture pack at the specified size (or default 128)
Order of options and size are not important.

Options:
  -h  --help            This help message
  -f  --force           Discard pre-rendered data
  -v  --verbose         Verbose
  -vv --very-verbose    Very verbose
  -o  --optimize        Optimize\
"
}

###############################################################
# Read options
###############################################################

if ! [ "$#" = 0 ]; then
for __option in $(seq "$#"); do
    case "$1" in
        "-h" | "--help")
            __usage
            exit 0
            ;;
        "-f" | "--force")
            __force='1'
            echo "Discarding pre-rendered data"
            ;;
        "-v" | "--verbose")
            __verbose='1'
            ;;
        "-vv" | "--very-verbose")
            __verbose='1'
            __very_verbose='1'
            ;;
        "-o" | "--optimize")
            __optimize='1'
            ;;
        [0-9]*)
            __size="${1}"
            ;;
	    *)
            echo "Unknown option \"${1}\""
            __usage
            exit 1
            ;;
    esac
    shift
done
fi

###############################################################
# Set variables dependant on options
###############################################################

__pack="${__name}-${__size}px"
__old_pack="${__pack}-old"

###############################################################
# Announce size
__announce "Using size ${__size}px"
###############################################################

###############################################################
# Set up folders
###############################################################

mkdir "${__tmp_dir}"

if [ -d "${__pack}" ]; then
    if [ "${__force}" = 1 ]; then
        rm -r "${__pack}"
    else
        echo "Reusing rendered data"
    fi
fi

###############################################################
# Split XML
__announce "Splitting XML files"
###############################################################

__xml_current="${__tmp_dir}/xml_current"
__xml_old="${__tmp_dir}/xml_old"

for __range in $(__get_range "${__catalogue}" ITEM); do
    __random="${RANDOM}"
    __read_range_file="${__tmp_dir}/${__range}${__random}"
    __read_range "${__catalogue}" "${__range}" > "${__read_range_file}"

    #TODO
    # Optimize xml functions more

    __item_name="$(__get_value "${__read_range_file}" NAME)"
    mkdir -p "$(__odir "${__xml_current}/${__item_name}")"
    mv "${__read_range_file}" "${__xml_current}/${__item_name}.xml"
done &

wait

if [ -d './src/xml/' ]; then
    rm -r './src/xml/'
fi

mv "${__tmp_dir}/xml_current" './src/xml/'

###############################################################
# Inherit deps and cleanup
__announce "Inheriting and creating dependancies and cleanup files"
###############################################################

mkdir "${__tmp_dir}/tmp_deps"

###############################
# __check_deps <DATASET>
###############################
__check_deps () {
__get_value "${1}" DEPENDS
}
###############################

###############################
# __check_deps_loop <DATASET>
###############################
__check_deps_loop () {
__get_value "${1}" CONFIG
for __dep in $(__check_deps "${1}"); do
    echo "${__dep}"
    if [ -a "${__dep}.xml" ]; then
        __get_value "${__dep}.xml" CONFIG
        __get_value "${__dep}.xml" CLEANUP
        __check_deps_loop "${__dep}.xml"
    fi
done
}
###############################

__pushd ./src/xml/

for __xml in $(find -type f); do
    __dep_list="${__tmp_dir}/tmp_deps/${__xml}"
    mkdir -p "$(__odir "${__dep_list}")"
    __check_deps_loop "${__xml}" | sort | uniq > "${__dep_list}"
    __set_value "${__xml}" DEPENDS "$(cat "${__dep_list}")"

    __get_value "${__xml}" CLEANUP >> "${__dep_list}_cleanup"
    for __dep in $(cat "${__dep_list}"); do
        if [ -a "${__dep}.xml" ]; then
            __get_value "${__dep}.xml" CLEANUP >> "${__dep_list}_cleanup"
        fi
    done

    __set_value "${__xml}" CLEANUP "$(cat "${__dep_list}_cleanup" | sort | uniq)"

done &

wait

__popd

###############################################################
# Set up folders for re-use
__announce "Setting up folders."
###############################################################

if ! [ -d "${__pack}" ]; then
    mkdir -p "${__pack}/xml"
else
    cp -r "${__pack}" "${__old_pack}"
    mv "${__pack}/xml" "${__tmp_dir}/xml" ### TODO
    rm -r "${__pack}"
    mkdir "${__pack}"
    mv "${__tmp_dir}/xml" "${__pack}"
fi

###############################################################
# List new and matching XML entries
__announce "Listing new and matching XML entries."
###############################################################

__new_xml_list="${__tmp_dir}/xml_list_new"
__old_xml_list="${__tmp_dir}/xml_list_old"
__new_split_xml_list="${__tmp_dir}/xml_list_new_shared"
__shared_xml_list="${__tmp_dir}/xml_list_shared"

__pushd ./src/xml

find -type f > "${__new_xml_list}"

__popd

__pushd "./${__pack}/xml"

find -type f > "${__old_xml_list}"

__popd

grep -Fxvf "${__old_xml_list}" "${__new_xml_list}" > "${__new_split_xml_list}"
grep -Fxf "${__old_xml_list}" "${__new_xml_list}" > "${__shared_xml_list}"

###############################################################
# Check changes in XML files
__announce "Checking changes in XML files."
###############################################################

__new_hashes="${__tmp_dir}/new_hashes"
__old_hashes="${__tmp_dir}/old_hashes"

__changed="${__tmp_dir}/changed_xml"

__pushd ./src/xml

__hash_folder "${__new_hashes}"

__popd

__pushd "./${__pack}/xml"

__hash_folder "${__old_hashes}"

__popd

for __shared in $(cat "${__shared_xml_list}"); do
    __old_hash="$(cat "${__old_hashes}" | grep -w "${__shared}")"
    __new_hash="$(cat "${__new_hashes}" | grep -w "${__shared}")"
    if [ "${__old_hash}" = "${__new_hash}" ]; then
        echo "${__shared}" >> "${__changed}"
    fi
done

###############################################################
# Check changes in source files
__announce "Checking changes in source files."
###############################################################



###############################################################
# General Cleanup
__announce "Cleaning up"
###############################################################

rm -r "${__tmp_dir}"

exit
