#!/bin/bash

###############################
# Defaults
###############################

__size='128'
__verbose='0'
__very_verbose='0'
__force='0'
__optimize='0'
__re_use='0'
__re_use_xml='0'
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
                    __re_use_xml='1'
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

# Master folder
__working_dir="$PWD"

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
        __announce "Purging rendered data."
        rm -r "${__pack}"
        mkdir -p "${__pack}/xml"

# Otherwise, re-use rendered data
    else
        __announce "Re-using rendered data."
        __re_use='1'
    fi

# Otherwise, make the pack and xml folder
else
    mkdir -p "${__pack}/xml"
fi

###############################################################
# Split XML
###############################################################

# If we're told not to re-use xml, then
if [ "${__re_use_xml}" = '0' ]; then

__announce "Splitting XML files."

# Where current xml files are split off to temporarily
__xml_current="${__tmp_dir}/xml_current"

# For every ITEM in catalogue,
for __range in $(__get_range "${__catalogue}" ITEM); do

# Use a random value (so this can be run in parallel)
    __random="${RANDOM}"

# File to use for reading ranges
    __read_range_file="${__tmp_dir}/${__range}${__random}"

# Actually read the range into file. This now contains an ITEM.
    __read_range "${__catalogue}" "${__range}" > "${__read_range_file}"

# TODO
# Optimize xml functions more
# Currently way too slow (though better than before)

# Get the NAME of this ITEM
    __item_name="$(__get_value "${__read_range_file}" NAME)"

# Make the correct directory for dumping the xml into an
# appropriately named file
    mkdir -p "$(__odir "${__xml_current}/${__item_name}")"

# Move that temporary read range file from before to somewhere
# more useful, according to the item's name
    mv "${__read_range_file}" "${__xml_current}/${__item_name}"

# Finish loop, but don't block the loop until it finishes
done &

# Wait here as all those loops from above finish
wait

# If xml files currently exist, and we're not told to re-use
# them, delete them and move new xml in
if [ -d './src/xml/' ]; then
    rm -r './src/xml/'
fi

# Move xml into src now, so it can be used later
mv "${__xml_current}" './src/xml/'

###############################################################
# Inherit deps and cleanup
__announce "Inheriting and creating dependencies and cleanup files."
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
    if [ -a "${__dep}" ]; then
        __get_value "${__dep}" CONFIG
        __get_value "${__dep}" CLEANUP
        __check_deps_loop "${__dep}"
    fi
done
}
###############################

# Make directory for dependency work
mkdir "${__tmp_dir}/tmp_deps"

# Get into the xml directory
__pushd ./src/xml/

# For every xml file,
for __xml in $(find -type f); do

# Set the location for the dep list
    __dep_list="${__tmp_dir}/tmp_deps/${__xml}"

# Make the directory for the dep list if need be
    mkdir -p "$(__odir "${__dep_list}")"

# Recursively get ALL dependencies for said xml files
    __check_deps_loop "${__xml}" | sort | uniq > "${__dep_list}"

# Set the value of the dependancies according to previous
# dependency list
    __set_value "${__xml}" DEPENDS "$(cat "${__dep_list}")"

# Recurse cleanup
    __get_value "${__xml}" CLEANUP >> "${__dep_list}_cleanup"
    for __dep in $(cat "${__dep_list}"); do
        if [ -a "${__dep}" ]; then
            __get_value "${__dep}" CLEANUP >> "${__dep_list}_cleanup"
        fi
    done

# Set cleanup as well
    __set_value "${__xml}" CLEANUP "$(cat "${__dep_list}_cleanup" | sort | uniq)"

# Finish loop and start again, so it is in parallel
done &

# Wait for all loops to finish
wait

# Go back to the regular directory
__popd

# Else, if we're supposed to re-use xml files
else

# Let the user know we're re-using xml
__announce "Re-using xml files."

# End if statement whether to split xml again or not
fi

###############################################################
# List new and matching XML entries
__announce "Listing new and matching XML entries."
###############################################################

# This is where all new xml files are listed
__new_xml_list="${__tmp_dir}/xml_list_new"
touch "${__new_xml_list}"

# This is where all old xml files are listed
__old_xml_list="${__tmp_dir}/xml_list_old"
touch "${__old_xml_list}"

# This is files only in the new list
__new_split_xml_list="${__tmp_dir}/xml_list_new_split"
touch "${__new_split_xml_list}"

# This is files shared between list_new and list_old
__shared_xml_list="${__tmp_dir}/xml_list_shared"
touch "${__shared_xml_list}"

# This is files only in old list
__old_split_xml_list="${__tmp_dir}/xml_list_old_split"
touch "${__old_split_xml_list}"

# Get to xml directory again
__pushd ./src/xml

# List all files into new list
find -type f > "${__new_xml_list}"

# Get back to main directory
__popd

# Get to old xml directory again
__pushd "./${__pack}/xml"

# List all files into old list
find -type f > "${__old_xml_list}"

# Get back to main directory
__popd

# Grep stuff to get uniq entries from different lists
grep -Fxvf "${__old_xml_list}" "${__new_xml_list}" > "${__new_split_xml_list}"
grep -Fxvf "${__new_xml_list}" "${__old_xml_list}" > "${__old_split_xml_list}"
grep -Fxf "${__old_xml_list}" "${__new_xml_list}" > "${__shared_xml_list}"

###############################################################
# Check changes in XML files
__announce "Checking changes in XML files."
###############################################################

# Where all new xml files are hashed to
__new_hashes="${__tmp_dir}/new_hashes_xml"
touch "${__new_hashes}"

# Where all old xml files are hashed to
__old_hashes="${__tmp_dir}/old_hashes_xml"
touch "${__old_hashes}"

# Where shared, but changed xml files are listed to
__changed_xml="${__tmp_dir}/changed_xml"
touch "${__changed_xml}"

# Where unchanged xml files are listed
__unchanged_xml="${__tmp_dir}/unchanged_xml"
touch "${__unchanged_xml}"

# Get to xml directory again
__pushd ./src/xml

# Hash the folder, and output to the new hashes file
__hash_folder "${__new_hashes}"

# Get back to main directory
__popd

# Get to old xml directory again
__pushd "./${__pack}/xml"

# Hash the folder, and output to the old hashes file
__hash_folder "${__old_hashes}"

# Get back to main directory
__popd

# For every file in the shared xml list,
for __shared in $(cat "${__shared_xml_list}"); do

# Get the old hash
    __old_hash="$(cat "${__old_hashes}" | grep -w "${__shared}")"

# Get the new hash
    __new_hash="$(cat "${__new_hashes}" | grep -w "${__shared}")"

# If the two hashes do not match, we know the xml file
# for that file has changed, and so needs to be re-rendered
    if ! [ "${__old_hash}" = "${__new_hash}" ]; then
        echo "${__shared}" >> "${__changed_xml}"
    else
        echo "${__shared}" >> "${__unchanged_xml}"
    fi

# Done with the hash checking
done

###############################################################
# List new and matching source files
__announce "Listing new and matching source files."
###############################################################

# This is where all new source files are listed
__new_source_list="${__tmp_dir}/source_list_new"
touch "${__new_source_list}"

# This is where all old source files are listed
__old_source_list="${__tmp_dir}/source_list_old"
touch "${__old_source_list}"

# This is files only in the new list
__new_split_source_list="${__tmp_dir}/source_list_new_split"
touch "${__new_split_source_list}"

# This is files shared between list_new and list_old
__shared_source_list="${__tmp_dir}/source_list_shared"
touch "${__shared_source_list}"

# This is files only in old list
__old_split_source_list="${__tmp_dir}/source_list_old_split"
touch "${__old_split_source_list}"

# Get to source directory again
__pushd ./src

# List all files into new list
find -not -path "./xml/*" -type f > "${__new_source_list}"

# Get back to main directory
__popd

# Get to old xml directory again
__pushd "./${__pack}"

# List all files into old list
find -not -path "./xml/*" -type f > "${__old_source_list}"

# Get back to main directory
__popd

# Grep stuff to get uniq entries from different lists
grep -Fxvf "${__old_source_list}" "${__new_source_list}" > "${__new_split_source_list}"
grep -Fxvf "${__new_source_list}" "${__old_source_list}" > "${__old_split_source_list}"
grep -Fxf "${__old_source_list}" "${__new_source_list}" > "${__shared_source_list}"

###############################################################
# Check changes in source files
__announce "Checking changes in source files."
###############################################################

# Where new source files are hashed to
__source_hash_new="${__tmp_dir}/new_hashes_source"
touch "${__source_hash_new}"

# Where old source files are hashed to
__source_hash_old="${__tmp_dir}/old_hashes_source"
touch "${__source_hash_old}"

# Where changed source files are listed
__changed_source="${__tmp_dir}/changed_source"
touch "${__changed_source}"

# Where unchanged source files are listed
__unchanged_source="${__tmp_dir}/unchanged_source"
touch "${__unchanged_source}"

# Get to the source directory
__pushd ./src

# Hash source files into designated file, exluding xml files
__hash_folder "${__source_hash_new}" xml

# Get back to main directory
__popd

# Get to old xml directory again
__pushd "./${__pack}"

# Hash source files into designated file, exluding xml files
__hash_folder "${__source_hash_old}" xml

# Get back to main directory
__popd

# For every file in the shared xml list,
for __shared in $(cat "${__shared_source_list}"); do

# Get the old hash
    __old_hash="$(cat "${__source_hash_old}" | grep -w "${__shared}")"

# Get the new hash
    __new_hash="$(cat "${__source_hash_new}" | grep -w "${__shared}")"

# If the two hashes do not match, we know the source file
# for that file has changed, and so needs to be re-rendered
    if ! [ "${__old_hash}" = "${__new_hash}" ]; then
        echo "${__shared}" >> "${__changed_source}"
    else
        echo "${__shared}" >> "${__unchanged_source}"
    fi

# Done with the hash checking
done

###############################################################
# Before we go on, let's recap. These are the files we want
#
# "${__changed_xml}"
# "${__unchanged_xml}"
#
# "${__changed_source}"
# "${__unchanged_source}"
#
# "${__new_split_xml_list}"
#
# So, the plan is to:
#
# Find all valid existing rendered items to bring across.
# To do so, all files in "${__unchanged_xml}" should be checked
# whether they exist, then put on a list. If yes, just
# list. If not, add to a different list (re/render list)
#
# Combine "${__changed_source}" and "${__changed_xml}", then
# find any xml files that *depend* upon them. Then add
# "${__changed_xml}" itself.
#
# Find entries only in pre-rendered list and not in depends
# list to be re-rendered. Replace that list, and copy all files
# to the new folder.
#
# Next, add files from "${__new_split_xml_list}" to that list.
# These are new entries, and shouldn't have any problems
#
# At this point, we have a file with a list of files to render.
# All resultant files have been cleaned as needed.
#
###############################################################
# Get names source
###############################################################

# Where we'll start putting new work in, will eventually be
# renamed to regular
__pack_new="${__pack}_new"
mkdir "${__pack_new}"

# List of xml files to re/render
__render_list="${__tmp_dir}/render_list"
touch "${__render_list}"

# List of xml files that are correctly rendered
__render_list="${__tmp_dir}/rendered_list"
touch "${__rendered_list}"

# Combine and sort all changed source and changed xml files
__changed_both="${__tmp_dir}/changed_both"
touch "${__changed_both}"
sort "${__changed_source}" "${__changed_xml}" | uniq > "${__changed_both}"

# Combine and sort all unchanged source and unchanged xml files
__unchanged_both="${__tmp_dir}/unchanged_both"
touch "${__unchanged_both}"
sort "${__unchanged_source}" "${__unchanged_xml}" | uniq > "${__unchanged_both}"

# Find all ITEMS that rely on the list of changed sources and
# list of changed xml, then add any of the xml ITEMs themselves







# Get into the xml directory
__pushd ./src/xml/

# For every xml file,
for __xml in $(find -type f); do

# Get dependancies
    __get_value "${__xml}" DEPENDS > "${__tmp_dir}/tmp_deps2"

# Compare to list of changed ITEMS, and check if file exists,
    if [ -z "$(grep -Fxf "${__tmp_dir}/tmp_deps2" "${__changed_both}")" ] && [ -a "${__working_dir}/${__pack}" ]; then

# and if not present, and file exists, add to a list of
# properly processed files and copy file across,
        cp "${__working_dir}/${__pack}" "${__working_dir}/${__pack_new}"
        echo "${__xml}" >> "${__rendered_list}"

# otherwise, ensure the old file does not exist, and make sure
# to be re/rendered
    else
        if [ -a "${__working_dir}/${__pack}" ]; then
            rm "${__working_dir}/${__pack}"
        fi
        echo "${__xml}" >> "${__render_list}"

# Done with if statement
    fi

# Finish loop
done

# Go back to the regular directory
__popd

###############################################################
# General Cleanup
###############################################################

# If we're debugging, don't clean up (it will be done on next run)
if [ "${__debug}" = '0' ]; then
    __announce "Cleaning up."
    rm -r "${__tmp_dir}"
fi

exit
