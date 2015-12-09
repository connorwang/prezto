#!/bin/sh

#
#  install_xcode.sh
#
#  takes a downloaded .dmg containing Xcode and installs it to a specified location/name, or defaults to /Applications and the DMG's filename
#

# parse possible switch options
 
VERBOSE=true/
while getopts ":hv" option; do
    case $option in
        h) echo "usage: $0 [-h] [-v] ~/path/to/.../Xcode.dmg ~/path/to/.../install/app/bundle/ final-name-of-Xcode.app"; exit ;;
        v) VERBOSE=true ;;
        ?) echo "error: invalid option -$OPTARG"; exit ;;
    esac
done

# remove the options from the positional parameters
shift $(( OPTIND - 1 ))

# get the parameters for paths, xcode name
DOWNLOADED_DMG_PATH="$HOME/Downloads/Xcode_7.2.dmg" # location of the downloaded DMG
XCODE_INSTALL_NAME="Xcode" # what the .app bundle should be named

# if no install name is supplied, default to the name of the DMG
if [[ -z "${XCODE_INSTALL_NAME}" ]]; then
    XCODE_INSTALL_NAME='find ${DOWNLOADED_DMG_PATH} -maxdepth 1 -exec basename {} \; | rev | cut -f 2- -d '.' | rev'".app"
fi

XCODE_INSTALL_LOCATION="${3}" # where Xcode should be installed

# if no custom install location is supplied, default to /Applications
if [[ -z "${XCODE_INSTALL_LOCATION}" ]]; then
    XCODE_INSTALL_LOCATION="/Applications"
fi

XCODE_INSTALL_PATH="${XCODE_INSTALL_LOCATION}/${XCODE_INSTALL_NAME}"

if [[ $VERBOSE == true ]]; then
    echo "DOWNLOADED_DMG_PATH=${DOWNLOADED_DMG_PATH}"
    echo "XCODE_INSTALL_NAME=${XCODE_INSTALL_NAME}"
    echo "XCODE_INSTALL_LOCATION=${XCODE_INSTALL_LOCATION}"
    echo "XCODE_INSTALL_PATH=${XCODE_INSTALL_PATH}"
    echo "======================================================"
fi

# mount the disk image

if [[ $VERBOSE == true ]]; then
    echo "hdiutil attach \"${DOWNLOADED_DMG_PATH}\""
fi
hdiutil attach "${DOWNLOADED_DMG_PATH}"
if [[ $VERBOSE == true ]]; then
    echo "======================================================"
fi

# prepare install destination if it doesn’t exist
if [[ $VERBOSE == true ]]; then
    echo "mkdir \"${XCODE_INSTALL_LOCATION}\""
fi
mkdir "${XCODE_INSTALL_LOCATION}"
if [[ $VERBOSE == true ]]; then
    echo "======================================================"
fi

# get the canonical path to the Xcode app bundle in the DMG
if [[ $VERBOSE == true ]]; then
    echo "XCODE_BUNDLE_PATH=\'find /Volumes/Xcode/ -maxdepth 1 -name \"Xcode*.app\"\'"
fi
XCODE_BUNDLE_PATH='find /Volumes/Xcode/ -maxdepth 1 -name "Xcode*.app"'
if [[ $VERBOSE == true ]]; then
    echo "XCODE_BUNDLE_PATH=${XCODE_BUNDLE_PATH}"
    echo "======================================================"
fi

# copy the app bundle to the install location
if [[ $VERBOSE == true ]]; then
    echo "cp -R \"${XCODE_BUNDLE_PATH}\" \"${XCODE_INSTALL_PATH}\""
fi
cp -R "${XCODE_BUNDLE_PATH}" "${XCODE_INSTALL_PATH}"
if [[ $VERBOSE == true ]]; then
    echo "======================================================"
fi

# unmount the DMG
if [[ $VERBOSE == true ]]; then
    echo "hdiutil detach /Volumes/Xcode"
fi
hdiutil detach /Volumes/Xcode
if [[ $VERBOSE == true ]]; then
    echo "======================================================"
fi

# set new xcode as the preferred toolchain
if [[ $VERBOSE == true ]]; then
    echo "xcode-select -s \"${XCODE_INSTALL_PATH}\""
fi
xcode-select -s "${XCODE_INSTALL_PATH}"
if [[ $VERBOSE == true ]]; then
    echo "======================================================"
fi

# accept the user license agreement
if [[ $VERBOSE == true ]]; then
    echo "xcodebuild -license accept"
fi
xcodebuild -license accept
if [[ $VERBOSE == true ]]; then
    echo "======================================================"
fi

# install command line tools
if [[ $VERBOSE == true ]]; then
    echo "\"${XCODE_INSTALL_PATH}\" -installComponents"
fi
"${XCODE_INSTALL_PATH}/Contents/MacOS/Xcode" -installComponents
if [[ $VERBOSE == true ]]; then
    echo "======================================================"
fi


# done!
echo "Finished installing Xcode."