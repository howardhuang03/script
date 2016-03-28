#!/bin/bash
# This script is for different OS platform working directory definition

# Linux working path
LINUX_PATH=/home/howard-huang/share/CodeBase/MoCap

# Mac OS X working path
MAC_PATH=/Users/howardhuang/MoCap/CodeBase

Check_working_PATH() {
    case "$(uname -s)" in
        Darwin)
            #echo 'Mac OS X'
            echo $MAC_PATH
            ;;
        Linux)
            #echo 'Linux'
            echo $LINUX_PATH
            ;;
        CYGWIN*|MINGW32*|MSYS*)
            #echo 'MS Windows'
            ;;
        *)
            #echo 'other OS'
            ;;
    esac
}
