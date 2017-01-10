#!/bin/bash

###############################
# Defaults
###############################

__size='128'
__verbose='0'
__very_verbose='0'
__force='0'
__re_use_xml='0'
__pid="$$"
__debug='0'
__xml_only='0'
__name_only='0'
__mobile='0'
export __quick='1'
__time='0'

###############################################################
# Setting up functions
###############################################################

# get functions from file
source functions.sh

# print help
__usage () {
echo "render.sh <OPTIONS> <SIZE>

Renders the texture pack at the specified size (or default 128)
Order of options and size are not important.

Options:
  -h  --help  -?        This help message
  -f  --force           Discard pre-rendered data
  -v  --verbose         Verbose
  -vv --very-verbose    Very verbose
  -p  --process-id      Using PID as given after
  -x  --xml-only        Only process xml files
  -n  --name-only       Print output folder name
  -m  --mobile          Make mobile resource pack
  -s  --slow            Use slower render engine (Inkscape)
  -t  --time            Time operations (for debugging)\
"
}

###############################################################
# Read options
__time "Reading options" start
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
                "-h" | "--help" | "-?")
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
# If we're supposed to be in debugging mode and be very verbose
                    if [ "${__debug}" = '1' ]; then
                        if [ "${__very_verbose}" = '1' ]; then
                            set -x
                        fi
                    fi
                    ;;

# tell the script to use a specified PID (this is taken care of
# earlier) using the last option which is set later,
                "-p" | "--process-id")
                    ;;

# make the script be verbose and not clean up,
                "-d" | "--debug")
                    echo "Debugging mode enabled"
                    __debug='1'
                    __verbose='1'
# If we're supposed to be in debugging mode and be very verbose
                    if [ "${__debug}" = '1' ]; then
                        if [ "${__very_verbose}" = '1' ]; then
                            set -x
                        fi
                    fi
                    ;;

# only process xml files
                "-x" | "--xml-only")
                    echo "Only processing xml files"
                    __xml_only='1'
                    ;;

# Whether or not to just print the exported folder name
                "-n" | "--name-only")
                    __name_only='1'
                    ;;

# whether to make mobile reousource pack
                "-m" | "--mobile")
                    __mobile='1'
                    ;;

# whether to use quick render engine
                "-s" | "--slow")
                    export __quick='0'
                    ;;

# whether to time functions
                "-t" | "--time")
                    __time='1'
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

# Done with option loop and if statement
done
fi


__time "Reading options" end


__time "Setting variables" start

###############################################################
# Check software deps
###############################################################

# check tsort
which tsort &> /dev/null

if ! [ "$?" = '0' ]; then
    echo "Please install 'tsort' to continue. It is required for dependency resolution."
    exit 1
fi

# print where inkscape is
which inkscape &> /dev/null

# if that didn't return an error, we know it exists
if [ "$?" = '0' ]; then
    __has_inkscape='1'

# if that did return an error, we know it doesn't exist
else
    __has_inkscape='0'
fi

# print where rsvg-convert is
which rsvg-convert &> /dev/null

# if that didn't return an error, we know it exists
if [ "$?" = '0' ]; then
    __has_rsvg_convert='1'

# if that did return an error, we know it doesn't exist
else
    __has_rsvg_convert='0'
fi

# if both inkscape and rsvg-convert don't exist, say so and exit
if [ "${__has_inkscape}" = '0' ] && [ "${__has_rsvg_convert}" = '0' ]; then
    echo "Missing both inkscape and rsvg-convert. Please install either/both to continue."
    echo "Please install 'librsvg-devel' to obtain rsvg-convert, and 'inkscape' for Inkscape"
    exit 1

# if inkscape exists, but rsvg-convert doesn't exist, and we're
# wanting to use rsvg-convert, say so and force inkscape
elif [ "${__has_inkscape}" = '1' ] && [ "${__has_rsvg_convert}" = '0' ] && [ "${__quick}" = '1' ]; then
    echo "Missing rsvg-convert. Cannot continue in quick mode."
    echo "Please install 'librsvg-devel'. Defaulting to inkscape."
    export __quick='0'

# if rsvg-convert exists, but inkscape doesn't exist, and we're
# wanting to use inkscape, say so and force rsvg-convert
elif [ "${__has_inkscape}" = '0' ] && [ "${__has_rsvg_convert}" = '1' ] && [ "${__quick}" = '0' ]; then
    echo "Missing Inkscape. Must continue in quick mode."
    echo "Please install 'inkscape'. Defaulting to rsvg-convert."
    export __quick='1'
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

# if we're supossed to make a mobile pack,
if [ "${__mobile}" = '1' ]; then

# set a special end pack folder
    __pack_end="${__pack}_mobile"

# otherwise
else

# set the end pack name the same as normal
    __pack_end="${__pack}"

# end mobile if statement
fi

# if we're only supposed to print the pack name
if [ "${__name_only}" = '1' ]; then

# print the pack end pack folder name
    echo "${__pack_end}"

# and exit
    exit

# exit the name only if statement
fi

__time "Setting variables" end

###############################################################
# If not only doing xml
if [ "${__xml_only}" = '0' ]; then

__time "Setting up folders" start

###############################################################
# Announce size
__announce "Using size ${__size}px."
###############################################################
# Announce PID
__announce "Using PID ${__pid}."
###############################################################

###############################################################
# Announce mobile if set on
if [ "${__mobile}" = '1' ]; then

    __announce "Making mobile resource pack."

fi
###############################################################

###############################################################
# Set up folders
__announce "Setting up folders."
###############################################################

# End conditional if only doing xml processing
fi

# Clean out the temporary directory if need be
if [ -d "${__tmp_dir}" ]; then
    rm -r "${__tmp_dir}"
fi

# Make the temporary directory
mkdir "${__tmp_dir}"

###############################################################
# If not only doing xml
if [ "${__xml_only}" = '0' ]; then

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
    fi

# Otherwise, make the pack and xml folder
else
    mkdir -p "${__pack}/xml"
fi

__time "Setting up folders" end

# End conditional if only doing xml processing
fi

###############################################################
# Split XML
###############################################################

__time "Splitting XML" start

__tsort_file='tsort'

__dep_list_tsort="${__tmp_dir}/${__tsort_file}"

__dep_list_name='tmp_deps'
__dep_list_folder="${__tmp_dir}/${__dep_list_name}"

__cleanup_file='cleanup'

__cleanup_all="${__tmp_dir}/${__cleanup_file}"
touch "${__cleanup_all}"

# if the xml folder does not exist,
if ! [ -d ./src/xml/ ]; then

# make the xml folder
    mkdir ./src/xml/

# end the xml folder if statement
fi

# get into the xml folder
__pushd ./src/xml

# if the catalogue exists
if [ -e "${__catalogue}" ]; then

# get the md5sum hash of the catalogue
    __old_catalogue_hash="$(md5sum "${__catalogue}")"

# remove the catalogue
    rm "${__catalogue}"

# end the if statement if the catalogue exists
fi

# get back into the main directory
__popd

# md5sum hash the current catalogue
__new_catalogue_hash="$(md5sum "${__catalogue}")"

# if the new catalogue is the same as the old catalogue, then
if [ "${__old_catalogue_hash}" = "${__new_catalogue_hash}" ] && [ -e "./src/xml/${__tsort_file}" ] && [ -d "./src/xml/${__dep_list_name}" ] && [ -e "./src/xml/${__cleanup_file}" ]; then

# say so
    __announce "No changes to xml catalogue."

# tell the script to re-use the xml files
    __re_use_xml='1'

# make sure tsort file exists
    mv "./src/xml/${__tsort_file}" "${__dep_list_tsort}"

    mv "./src/xml/${__dep_list_name}" "${__tmp_dir}"

    mv "./src/xml/${__cleanup_file}" "${__cleanup_all}"

# end if statement whether the catalogues are the same
fi

# If we're told not to re-use xml, then
if [ "${__re_use_xml}" = '0' ]; then

__announce "Splitting XML files."

# Where current xml files are split off to temporarily
__xml_current="${__tmp_dir}/xml_current"

# For every ITEM in catalogue,
for __range in $(__get_range "${__catalogue}" ITEM); do

# File to use for reading ranges
    __read_range_file="${__tmp_dir}/${__range}"

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
done

# If xml files currently exist, and we're not told to re-use
# them, delete them and move new xml in
if [ -d './src/xml/' ]; then
    rm -r './src/xml/'
fi

# Move xml into src now, so it can be used later
mv "${__xml_current}" './src/xml/'

__time "Splitting XML" end

###############################################################
# Inherit deps and cleanup
__announce "Inheriting and creating dependencies and cleanup files."
###############################################################

# End if statement whether to split xml again or not
fi

# If we're told not to re-use xml, then
if [ "${__re_use_xml}" = '0' ]; then

__time "Inheriting and creating dependencies" start

if [ -e "${__dep_list_tsort}" ]; then
    rm "${__dep_list_tsort}"
fi
touch "${__dep_list_tsort}"

if [ -d "${__dep_list_folder}" ]; then
    rm -r "${__dep_list_folder}"
fi

# Make directory for dependency work
mkdir -p "${__dep_list_folder}"

# Get into the xml directory
__pushd ./src/xml/

# For every xml file,
for __xml in $(find -type f); do

    __tmp_deps="$(__get_value "${__xml}" DEPENDS | sed '/^$/d')"

    echo "${__xml} ${__xml}" >> "${__dep_list_tsort}"

    for __line in ${__tmp_deps}; do
        echo "${__xml} ${__line}" >> "${__dep_list_tsort}"
    done

# Finish loop
done

tsort "${__dep_list_tsort}" | tac > "${__dep_list_tsort}_"

mv "${__dep_list_tsort}_" "${__dep_list_tsort}"

for __xml in $(cat "${__dep_list_tsort}"); do

# Set the location for the dep list
    __dep_list="${__dep_list_folder}/${__xml}"

# Make the directory for the dep list if need be
    mkdir -p "$(__odir "${__dep_list}")"

    touch "${__dep_list}"

    __get_value "${__xml}" CONFIG >> "${__dep_list}"
    __get_value "${__xml}" CLEANUP >> "${__dep_list}"
    __get_value "${__xml}" DEPENDS >> "${__dep_list}"

    for __dep in $(__get_value "${__xml}" DEPENDS); do

        cat "${__dep_list_folder}/${__dep}" >> "${__dep_list}"

    done

    touch "${__dep_list}_"

    sort "${__dep_list}" | uniq | sed '/^$/d' > "${__dep_list}_"

    mv "${__dep_list}_" "${__dep_list}"

done

for __xml in $(find -type f); do

    __set_value "${__xml}" DEPENDS "$(cat "${__dep_list_folder}/${__xml}")"

done

__rev_dep_list_folder="${__tmp_dir}/tmp_revdeps"

mkdir -p "${__rev_dep_list_folder}"

for __xml in $(cat "${__dep_list_tsort}" | tac); do

    for __dep in $(cat "${__dep_list_folder}/${__xml}"); do

        if [ -e "${__dep}" ]; then

            __dep_list="${__rev_dep_list_folder}/${__dep}"

# Make the directory for the dep list if need be
            mkdir -p "$(__odir "${__dep_list}")"

            touch "${__dep_list}"

            echo "${__xml}" >> "${__dep_list}"

            sort "${__dep_list}" | uniq | sed '/^$/d' > "${__dep_list}_"

            mv "${__dep_list}_" "${__dep_list}"

        fi

    done

done

for __xml in $(find -type f); do

    sed -i -e '1d' -e '$d' "${__xml}"

# get the cleanup files, and list it to a file
    __get_value "${__xml}" CLEANUP >> "${__cleanup_all}"

# if the file is not to be kept,
    if [ "$(__get_value "${__xml}" KEEP)" = "NO" ]; then

# add it to the cleanup file list
        echo "${__xml}" >> "${__cleanup_all}"

# end the if statement
    fi

done

sort "${__cleanup_all}" | uniq > "${__cleanup_all}_"

mv "${__cleanup_all}_" "${__cleanup_all}"

# Go back to the regular directory
__popd

__time "Inheriting and creating dependencies" end

# Else, if we're supposed to re-use xml files
else

# Let the user know we're re-using xml
__announce "Re-using xml files."

# End if statement whether to split xml again or not
fi

###############################################################
# If only xml splitting
if [ "${__xml_only}" = '0' ]; then

###############################################################
# List new and matching XML entries
__announce "Listing new and matching XML entries."
###############################################################

__time "Listing new and matching XML entries" start

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

__time "Listing new and matching XML entries" end

###############################################################
# Check changes in XML files
__announce "Checking changes in XML files."
###############################################################

__time "Checking changes in XML files" start

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

# TODO - Make a more efficient method of doing this

__time "Checking hash changes" start

if ! [ "$(cat "${__new_hashes}" | md5sum)" = "$(cat "${__old_hashes}" | md5sum)" ]; then

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

else

    __announce "No changes to XML."

    if [ -e "${__unchanged_xml}" ]; then

        rm "${__unchanged_xml}"

    fi

     cp "${__shared_xml_list}" "${__unchanged_xml}"

fi

__time "Checking hash changes" end

__time "Checking changes in XML files" end

###############################################################
# List new and matching source files
__announce "Listing new and matching source files."
###############################################################

__time "Listing new and matching source files" start

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

__time "Listing new and matching source files" end

###############################################################
# Check changes in source files
__announce "Checking changes in source files."
###############################################################

__time "Checking changes in source files" start

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

__shared_source_list_hash="${__tmp_dir}/source_list_shared_hashes"
touch "${__shared_source_list_hash}"

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

for __file in $(cat "${__shared_source_list}"); do
    md5sum "${__file}" >> "${__shared_source_list_hash}"
done

# Get back to main directory
__popd

if ! [ "$(cat "${__shared_source_list_hash}" | sort | md5sum)" = "$(cat "${__source_hash_new}" | sort | md5sum)" ]; then

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

else

    __announce "No changes to source."

    if [ -e "${__unchanged_source}" ]; then

        rm "${__unchanged_source}"

    fi

     cp "${__shared_source_list}" "${__unchanged_source}"

fi

__time "Checking changes in source files" end

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
# Checking files to re/render
__announce "Checking for items to re/process."
###############################################################

__time "Checking for items to re/process" start

# Where we'll start putting new work in, will eventually be
# renamed to regular
__pack_new="${__pack}_new"
if [ -d "${__pack_new}" ]; then
    rm -r "${__pack_new}"
fi
mkdir "${__pack_new}"

# List of xml files to re/render
__render_list="${__tmp_dir}/render_list"
touch "${__render_list}"

# List of xml files that are correctly rendered
__rendered_list="${__tmp_dir}/rendered_list"
touch "${__rendered_list}"

# Combine and sort all changed source and changed xml files (also new)
__changed_both="${__tmp_dir}/changed_all"
touch "${__changed_both}"
sort "${__changed_source}" "${__changed_xml}" "${__new_split_source_list}" "${__new_split_xml_list}" | uniq > "${__changed_both}"

# Combine and sort all unchanged source and unchanged xml files
__unchanged_both="${__tmp_dir}/unchanged_both"
touch "${__unchanged_both}"
sort "${__unchanged_source}" "${__unchanged_xml}" | uniq > "${__unchanged_both}"

# Get into the xml directory
__pushd ./src/xml/

# TODO - Make a more efficient method of doing this

################################################################
#
# What's happening here is that all files are checked.
# If it, or a dependency, has been changed, then it is cleaned
# and aded to the render list.
#
# If it has not been changed, and exists, copy across and add
# to the rendered list
#
# If it is not changed, but it not rendered (that is, the
# rendered file was deleted for whatever reason, it is added to
# the list to be rendered.
#
################################################################

__list_file="${__tmp_dir}/listing_complete"
touch "${__list_file}"

__list_file_proc="${__tmp_dir}/listing_processing"
touch "${__list_file_proc}"

__pushd "${__dep_list_folder}"

for __changed in $(cat "${__changed_both}"); do
    grep -rlx "${__changed}" "./" >> "${__list_file_proc}"
done

__popd

find -type f > "${__list_file}"

while [ -s "${__list_file_proc}" ]; do

    __xml="$(head -n 1 "${__list_file_proc}")"

    sed -i '1d' "${__list_file_proc}"

# Get dependancies
    cat "${__dep_list_folder}/${__xml}"  > "${__tmp_dir}/tmp_deps2"

    echo "${__xml}" >> "${__tmp_dir}/tmp_deps2"

    __xml_name="${__xml//.\//}"

# Compare to list of changed ITEMS, and check if file exists,
    if ! [ -z "$(grep -Fxf "${__tmp_dir}/tmp_deps2" "${__changed_both}")" ]; then

# ensure the old file does not exist, and make sure to be
# re/rendered
        if [ -e "${__working_dir}/${__pack}/${__xml}" ]; then
            rm "${__working_dir}/${__pack}/${__xml}"
        fi
        echo "${__xml}" >> "${__render_list}"

    elif [ -e "${__working_dir}/${__pack}/${__xml_name}" ]; then

# otherwise if file exists, add to a list of properly processed
# files and copy file across,

        mkdir -p "$(__odir "$(echo "${__working_dir}/${__pack_new}/${__xml_name}")")"
        cp "${__working_dir}/${__pack}/${__xml_name}" "${__working_dir}/${__pack_new}/${__xml_name}"
        echo "${__xml}" >> "${__rendered_list}"

# if the file does not exist, re-render
    elif ! [ -e "${__working_dir}/${__pack}/${__xml_name}" ]; then
        echo "${__xml}" >> "${__render_list}"


# Done with if statement
    fi

# Finish loop
done

sort "${__render_list}" | uniq > "${__render_list}_"

mv "${__render_list}_" "${__render_list}"

for __xml in $(grep -Fxvf "${__render_list}" "${__list_file}" | sort | uniq); do

    __xml_name="${__xml//.\//}"

    if [ -e "${__working_dir}/${__pack}/${__xml_name}" ]; then

# otherwise if file exists, add to a list of properly processed
# files and copy file across,

        mkdir -p "$(__odir "$(echo "${__working_dir}/${__pack_new}/${__xml_name}")")"
        cp "${__working_dir}/${__pack}/${__xml_name}" "${__working_dir}/${__pack_new}/${__xml_name}"
        echo "${__xml}" >> "${__rendered_list}"

# if the file does not exist, re-render
    elif ! [ -e "${__working_dir}/${__pack}/${__xml_name}" ]; then
        echo "${__xml}" >> "${__render_list}"

# Done with if statement
    fi

# Finish loop
done

sort "${__render_list}" | uniq > "${__render_list}_"

mv "${__render_list}_" "${__render_list}"

cp "${__render_list}" "${__render_list}_backup"

# Go back to the regular directory
__popd

# sort and uniq render list
sort "${__render_list}" | uniq > "${__render_list}_"
mv "${__render_list}_" "${__render_list}"

__time "Checking for items to re/process" end

###############################################################
# Copy all source, xml and conf scripts
__announce "Setting up files for processing."
###############################################################

# copy src files into new pack folder
cp -r "./src/"* "${__pack_new}"

# remove old pack
rm -r "${__pack}"

# rename the new pack to the regular pack
mv "${__pack_new}" "${__pack}"

###############################################################
# Render loop
__announce "Starting to render."
###############################################################

__time "Rendered" start

__start_time="$(date +%s)"

# get into the pack folder, ready to render
__pushd "${__pack}"

# while the render list has lines to process,
while [ "$(cat "${__render_list}" | wc -l)" -gt '0' ]; do

# set the original name of the config file
    __orig_config="$(head -n 1 "${__render_list}")"

# set the formatted name of the config file
    __config="./xml/${__orig_config//.\//}"

# get the dependancies of the config, and put it in a temporary file
    __get_value "${__config}" DEPENDS > "${__tmp_dir}/tmpdeps"

# if the dependancies are not yet to be rendered, then
    if [ -z "$(grep -Fxf "${__tmp_dir}/tmpdeps" "${__render_list}")" ]; then

# get the size of the texture
        __tmp_val="$(__get_value "${__config}" SIZE)"

# if the size was set,
        if ! [ -z "${__tmp_val}" ]; then

# use it as the real size
            __tmp_size="${__tmp_val}"

# otherwise,
        else

# use the pack size
            __tmp_size="${__size}"

# end size check
        fi

# get the name of the config script
        __config_script="$(__get_value "${__config}" CONFIG)"

# if there is a config script to use, then
        if ! [ -z "${__config_script}" ]; then

# announce that we are processing the given config
            __announce "Processing \"${__config}\""

# copy the config script out so we can use it
            cp "${__config_script}" ./

# execute the script, given the determined size and options set
# in the config
            eval '\./'"$(basename "${__config_script}")" "${__tmp_size}" "$(__get_value "${__config}" OPTIONS)"

# remove the script now we're done with it
            rm "$(basename "${__config_script}")"

# end loop for when a config script is present
        fi

# if the config still has dependencies that need to be rendered
    else

# add the config to the end of the render list
        echo "${__orig_config}" >> "${__render_list}"

# end loop to process the top item on the render list
    fi

# remove the top item from the render list
    sed -i '1d' "${__render_list}"

# finish render loop
done

# get out of the render directory
__popd

__time "Rendered" end

###############################################################
# Final stats
###############################################################

# set the end time for rendering
__end_time="$(date +%s)"

__announce "Done rendering!"
__announce "Rendered ${__size}px in $((__end_time-__start_time)) seconds"

###############################################################
# Make cleaned folder
__announce "Making cleaned folder."
###############################################################

__time "Making cleaned folder" start

# set and create the file for listing cleanup files
__cleanup_all="${__tmp_dir}/cleanup_all"
touch "${__cleanup_all}"

# set the directory for the cleaned pack
__pack_cleaned="${__pack}_cleaned"

# removed the directory for the cleaned pack, if it exists
if [ -d "${__pack_cleaned}" ]; then
    rm -r "${__pack_cleaned}"
fi

# copy the pack to a new folder to be cleaned
cp -r "${__pack}" "${__pack_cleaned}"

# get into the cleaned folder
__pushd "${__pack_cleaned}"

# for every file to clean
for __file in $(cat "${__cleanup_all}"); do

# remove it
    rm "${__file}"

# finish loop
done

# remove xml and conf from cleaned pack
rm -r ./xml
rm -r ./conf

# get back to the right directory
__popd

__time "Making cleaned folder" end

###############################################################
# Make mobile pack if asked to
###############################################################

# mobile script to be used to make a mobile pack
__mobile_script='convert_to_mobile.sh'

# if a mobile pack is supposed to be made
if [ "${__mobile}" = '1' ]; then

    __time "Making mobile pack" start

# if the end pack folder exists,
    if [ -d "${__pack_end}" ]; then

# remove it
        rm -r "${__pack_end}"

# end the if statement
    fi

# copy the cleaned folder to the end pack folder
    cp -r "${__pack_cleaned}" "${__pack_end}"

# if the mobile script doesn't exist,
    if ! [ -a "${__mobile_script}" ]; then

# complain
        echo "Missing mobile script system, aborting."

# and exit
        exit 1

# end if statement whether the mobile script exists
    fi

# copy the script to the end pack folder
    cp "${__mobile_script}" "${__pack_end}/${__mobile_script}"

# get into the end pack folder
    __pushd "${__pack_end}"

# excecute the mobile script folder
    "./${__mobile_script}"

# remove the mobile script folder
    rm "${__mobile_script}"

# get back into the main directory
    __popd

    __time "Making mobile pack" end

fi

###############################################################
# End if only xml splitting
fi

# copy the catalogue into the src xml folder
cp "${__catalogue}" "./src/xml/${__catalogue}"

cp "${__dep_list_tsort}" "./src/xml/${__tsort_file}"

mv "${__dep_list_folder}" "./src/xml/"

mv "${__cleanup_all}" "./src/xml/${__cleanup_file}"

###############################################################
# General Cleanup
###############################################################

# If we're debugging, don't clean up (it will be done on next
# run anyway)
if [ "${__debug}" = '0' ]; then
    __announce "Cleaning up."
    rm -r "${__tmp_dir}"
fi

exit
