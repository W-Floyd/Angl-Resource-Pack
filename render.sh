#!/bin/bash

###############################
# Defaults
###############################

__size='128'
__verbose='0'
__very_verbose='0'
__force='0'
__cores='1'
__optimize='0'
__re_use='0'
__pid="$$"
__debug='0'

###############################################################
# Setting up functions
###############################################################

# Gets functions from file
source functions.sh

# Print help
__usage () {
echo "render.sh <OPTIONS> <SIZE>

Renders the texture pack at the specified size (or default 128)
Order of options and size are not important.

Options:
  -h  --help            This help message
  -f  --force           Discard pre-rendered data
  -v  --verbose         Verbose
  -vv --very-verbose    Very verbose
  -o  --optimize        Optimize
  -p  --process-id      Using PID as given after
  -r  --re-use          Re-use split xml files\
"
}

###############################################################
# Read options
###############################################################

# If there are are options,
if ! [ "${#}" = 0 ]; then

# then let's look at them in sequence.
for __option in $(seq "${#}"); do

# So, let's say the last given option was
    case "${__last_option}" in

# to use a special PID.
        "-p" | "--process-id")

# So, if it's a number,
            if [ "${1}" -eq "${1}" ] 2>/dev/null; then

# set the PID to this
                __pid="${1}"

# If it isn't though,
            else

# warn the user and exit, because they're doing it wrong.
                echo "Invalid process ID \"${1}\""
                echo
                __usage
                exit 1
            fi
            ;;

# Now, with the option to the last option out of the way, let's
# look at regular options.
        *)

# So, again, if the options matches any of these:
            case "${1}" in

# help the user out if they ask and exit nicely,
                "-h" | "--help")
                    __usage
                    exit 0
                    ;;

# let the script and user know it should and will force rendering,
                "-f" | "--force")
                    __force='1'
                    echo "Discarding pre-rendered data"
                    ;;

# tell the script to be verbose,
                "-v" | "--verbose")
                    __verbose='1'
                    ;;

# tell the script to be very verbose,
                "-vv" | "--very-verbose")
                    __verbose='1'
                    __very_verbose='1'
                    ;;

# tell the script to optimize the produced files,
                "-o" | "--optimize")
                    __optimize='1'
                    ;;

# tell the script to use a specified PID (this is taken care of
# earlier) using the last option which is set later,
                "-p" | "--process-id")
                    ;;

# tell the script to not re-split the xml file, since it's all current
                "-r" | "--re-use")
                    __re_use='1'
                    ;;

# make the script be verbose and not clean up,
                "-d" | "--debug")
                    echo "Debugging mode enabled"
                    __debug='1'
                    __verbose='1'
                    ;;

# general catch all for any number input that isn't for the PID
# which is set as the render size,
                [0-9]*)
                    __size="${1}"
                    ;;

# any other options are invalid so the script says what it was
# and exits after telling you how to use it.
	            *)
                    echo "Unknown option \"${1}\""
                    echo
                    __usage
                    exit 1
                    ;;

# We're done with single flag options
            esac
            ;;

# We're done with 2 flag options
    esac

# Let the script know what the last option was, for use in two
# flag options
    __last_option="${1}"

# Make option 2 option 1, so we can loop through nicely
    shift

# Done with out loop and if statement
done
fi

###############################################################
# Set variables
###############################################################

# Master name of pack, so re-branding is easy.
__name='Angl'

# Designated temporary directory
__tmp_dir="/tmp/texpack${__pid}"

# Location of catalogue file, just to be pedantic
__catalogue='catalogue.xml'

# Rendered folder name
__pack="${__name}-${__size}px"

###############################################################
# Debugging flag
###############################################################

# If we're supposed to be in debugging mode and be very verbose
if [ "${__debug}" = '1' ]; then
    if [ "${__very_verbose}" = '1' ]; then
        set -x
    fi
fi

###############################################################
# Announce size
__announce "Using size ${__size}px."
###############################################################
# Announce PID
__announce "Using PID ${__pid}."
###############################################################
# Announce optimize
__announce "Will optimize output files."
###############################################################

###############################################################
# Set up folders
__announce "Setting up folders."
###############################################################

# Clean out the temporary directory if need be
if [ -d "${__tmp_dir}" ]; then
    rm -r "${__tmp_dir}"
fi

# Make the temporary directory
mkdir "${__tmp_dir}"

# If the pack folder already exists, then
if [ -d "${__pack}" ]; then

# If we must remove it
    if [ "${__force}" = 1 ]; then

# Announce and remove it
        __announce "Purging rendered data"
        rm -r "${__pack}"
        mkdir -p "${__pack}/xml"

# Otherwise, re-use rendered data
    else
        __announce "Re-using rendered data"
        __re_use='1'
    fi

# Otherwise, make the pack and xml folder
else
    mkdir -p "${__pack}/xml"
fi

###############################################################
# Split XML
__announce "Splitting XML files."
###############################################################

__xml_current="${__tmp_dir}/xml_current"

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

mv "${__xml_current}" './src/xml/'

###############################################################
# Inherit deps and cleanup
__announce "Inheriting and creating dependancies and cleanup files."
###############################################################

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

mkdir "${__tmp_dir}/tmp_deps"

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
###############################################################

if [ "${__debug}" = '0' ]; then
    __announce "Cleaning up."
    rm -r "${__tmp_dir}"
fi

exit
