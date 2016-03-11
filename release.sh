#!/bin/bash
# ----------------------------------------------------------------------------
# This script is for new version release purpose for mocap related project 
# Created by Howard Huang
# ----------------------------------------------------------------------------

# Script revision
# ----------------------------------------------------------------------------
# 0.1
# 1. Support mocap android L release version modification
# 2. Support mocap android L release git commit
# 3. Support mocap android L release tag add
# ----------------------------------------------------------------------------
# 0.2
# 1. Original function support with mocap bodypack release
# 2. Add script version number
# ----------------------------------------------------------------------------
SCRIPT_VERSION=0.2

# Set debug flag
DEBUG=""

MOCAP_DIR=$HOME/share/CodeBase/MoCap

# MoCap Android L related information
L_DIR=$MOCAP_DIR/mocap-android-l.git
L_VERSION_DIR=$L_DIR/build/tools
L_VERSION_FILE=buildinfo.sh
L_VERSION_TARGET="BUILD_SWVERSION1="

# MoCap bodypack related information
BODYPACK_DIR=$MOCAP_DIR/mocap-bodypack.git
BODYPACK_VERSION_DIR=$BODYPACK_DIR/Src
BODYPACK_VERSION_FILE=debug.c
BODYPACK_VERSION_TARGET1="FIRMWARE_VERSION_MAJOR"
BODYPACK_VERSION_TARGET2="FIRMWARE_VERSION_MINOR"

GIT_ARRAY=( \
    $L_DIR,$L_VERSION_DIR,$L_VERSION_FILE,$L_VERSION_TARGET \
    $BODYPACK_DIR,$BODYPACK_VERSION_DIR,$BODYPACK_VERSION_FILE,$BODYPACK_VERSION_TARGET1,$BODYPACK_VERSION_TARGET2 \
)

VERSION_DIR=""
VERSION_FILE=""
VERSION_TARGET_ARRAY=()

# Show help
function show_help() {
    ME=`basename $0`
    echo "$ME -c [version] -m [version] -t [version] [-a [version]] -v"
    echo "option:"
    echo "  -m [version]: modify verison to $VERSION_FILE"
    echo "  -c [version]: commit new version"
    echo "  -t [version]: tag new version to this release"
    echo "  -a [verison]: do all the task above:"
    echo "                1. Modify verson."
    echo "                2. Commit new version."
    echo "                3. Tag new version"
    echo "  -v          : show script version"
}

check_path() {
    for ((index=0; index<${#GIT_ARRAY[@]}; index++)); do
        j=0

	# Parse GIT_ARRAY index
        LOCAL_ARRAY=(`echo ${GIT_ARRAY[$index]}|sed 's/,/ /g'`)

	# Check Correct git repository
        # LOCAL_ARRAY[0] is dir to git source
        GIT_PATH=`pwd|grep ${LOCAL_ARRAY[0]}`
        [ "$GIT_PATH" == "" ] && continue

        # Assign corresponding information
        VERSION_DIR=${LOCAL_ARRAY[1]}
        VERSION_FILE=${LOCAL_ARRAY[2]}
        while [ "${LOCAL_ARRAY[3+$j]}" != "" ]; do
            VERSION_TARGET_ARRAY[$j]=${LOCAL_ARRAY[3+$j]}
            [ "$DEBUG" != "" ] && { # Debug print
            	echo "VERSION_TARGET_ARRAY[$j]=${VERSION_TARGET_ARRAY[$j]}"
            }
            j=$((j+1))
        done
    done

    [ "$VERSION_DIR" == "" ] && [ "$VERSION_FILE" == "" ] && {
        echo "You are not in any supported .git repository path!!"
        exit 0
    }
}

version_modify_android() {
    OLD_MODIFY=`cat $VERSION_DIR/$VERSION_FILE|grep "$VERSION_TARGET_ARRAY"`
    NEW_MODIFY="$VERSION_TARGET_ARRAY\"$1.\""
    echo "old_version: $OLD_MODIFY, New version: $NEW_MODIFY"
    sed -i "s/$OLD_MODIFY/$NEW_MODIFY/g" $VERSION_DIR/$VERSION_FILE
}

version_modify_bodypack() {
    # Split version into two parts(major, minor)
    LOCAL_VERSION=(`echo $1|sed 's/\./ /g'`)
    [ "$DEBUG" != "" ] && { # Debug print
        echo "$1(${LOCAL_VERSION[0]}.${LOCAL_VERSION[1]})"
    }

    for ((index=0; index<${#LOCAL_VERSION[@]}; index++)); do
	# Decimal to hex conversion
        VERSION_HEX=`echo "obase=16; ${LOCAL_VERSION[$index]}"|bc`

        # Need add a 0 while version number <= 15
        [ "${LOCAL_VERSION[$index]}" -le "15" ] && VERSION_HEX="0$VERSION_HEX"

        # Modify corresponding part(major, minor)
        OLD_MODIFY=`cat $VERSION_DIR/$VERSION_FILE|grep "${VERSION_TARGET_ARRAY[$index]}  0x"`
	NEW_MODIFY="#define ${VERSION_TARGET_ARRAY[$index]}  0x$VERSION_HEX"
        echo "Old: $OLD_MODIFY, new: $NEW_MODIFY"
        sed -i "s/$OLD_MODIFY/$NEW_MODIFY/g" $VERSION_DIR/$VERSION_FILE
    done
}

version_modify() {

   case $VERSION_FILE in
       "buildinfo.sh" )
           version_modify_android $1
           ;;
       "version.c" )
           version_modify_bodypack $1
           ;;
       *)
           echo "File to modify version is not found!!"
           exit 0
           ;;
   esac

   # After modification, check what have you done
   git diff $VERSION_DIR/$VERSION_FILE
}

version_commit() {
    NEW_COMMIT="$1"
    echo "Commit new version $NEW_COMMIT for $VERSION_FILE"
    git add $VERSION_DIR/$VERSION_FILE
    git commit -s -m "Release version $NEW_COMMIT"
    git stash
    git pull
    git push origin
    git stash pop 2>&1 > /dev/null
}

version_tag() {
    NEW_TAG="$1"
    NEW_TAG_MESSAGE="Release vesrion $NEW_TAG"
    echo "New version tag $NEW_TAG release to git"
    git tag -a $NEW_TAG -m "$NEW_TAG_MESSAGE"
    git show $NEW_TAG
    git push origin $NEW_TAG
}

version_all() {
    NEW_VERSION=$1
    version_modify $NEW_VERSION
    version_commit $NEW_VERSION
    version_tag $NEW_VERSION
}

script_version_show() {
    echo "Release script version:"
    echo "$SCRIPT_VERSION"
}

function main() {
    while getopts :c:m:t:a:v flag
    do
        case $flag in
        c)
            check_path
            version_commit $OPTARG
            ;;
        m)
            check_path
            version_modify $OPTARG
            ;;
        t)
            check_path
            version_tag $OPTARG
            ;;
        a)
            check_path
            version_all $OPTARG
            ;;
        v)
            script_version_show
            ;;
        \?)
            show_help
            exit 0
            ;;
        esac
    done
}

# Start main process
main "$@"
