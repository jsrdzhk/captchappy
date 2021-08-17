#!/bin/sh

###
# @title: cmp_and_upload.sh
# @author: Rodney Cheung
# @date: 2021-08-17 10:23:10
 # @last_author: Rodney Cheung
 # @last_edit_time: 2021-08-17 13:39:17
###
if [ $# -eq 3 ]; then
    REMOTE_SERVER=$1
    LOCAL_HOME=$2
else
    REMOTE_SERVER="first@10.3.1.217"
    LOCAL_HOME="/c/workspace/F.I.R.S.T/server/deploy"
fi
REMOTE_HOME=$(ssh "$REMOTE_SERVER" echo \$HOME)
FIRST_HOME=$REMOTE_HOME/first
FIRST_LIB_DIR=$FIRST_HOME/lib
LOCAL_LIB_DIR=$LOCAL_HOME/lib

cmp_and_upload() {
    ssh "$REMOTE_SERVER" ls $1 | grep "SNAPSHOT.jar" | while read line; do
        REMOTE_MD5=$(ssh -n "$REMOTE_SERVER" md5sum "$1"/"$line" | awk '{ print $1 }')
        LOCAL_MD5=$(md5sum "$2"/"$line" | awk '{ print $1 }')
        if [[ $REMOTE_MD5 != $LOCAL_MD5 ]]; then
            echo "local file $2/$line md5($LOCAL_MD5) is diff from remote file $1/$line($REMOTE_MD5),updating..."
            scp $2/$line $REMOTE_SERVER:$1/$line
        # else
        #     echo "local file($2/$line) is the same as remote file($1/$line)"
        fi
    done
}

cmp_and_upload "$FIRST_HOME" $LOCAL_HOME
cmp_and_upload "$FIRST_LIB_DIR" $LOCAL_LIB_DIR
echo "Done!"
