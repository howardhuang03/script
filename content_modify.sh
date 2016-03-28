#!/bin/bash

# include
. ~/Dropbox/Code/script/include/path.sh

MOCAP_PATH=$(Check_working_PATH)
GIT_CONFIG=.git/config

NEW_MODIFY="inhouse.htcstudio"
OLD_MODIFY="git.sw.studio.htc"

content_modify() {
    for repository in $( ls ); do
        echo $repository
        GIT_CONFIG_FILE=$MOCAP_DIR/$repository/$GIT_CONFIG
        [ -e "$GIT_CONFIG_FILE" ] && {
            CONTENT_EXIST=`grep $OLD_MODIFY $GIT_CONFIG_FILE`
            [ -n "$CONTENT_EXIST" ] && {
                # Update the host
                sed -i "s/$OLD_MODIFY/$NEW_MODIFY/g" $GIT_CONFIG_FILE
                grep $NEW_MODIFY $GIT_CONFIG_FILE
            }
        }
    done
}

content_modify
