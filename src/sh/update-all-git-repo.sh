#!/bin/sh

###
# @title: update-all-git-repo.sh
# @author: Rodney Cheung
# @date: 2021-05-11 09:09:51
 # @last_author: Rodney Cheung
 # @last_edit_time: 2021-05-12 09:04:04
###
CUR_DIR=$(pwd)
for item in $(find . -name ".git" -d 2 | cut -c 3-); do
    echo "${item}"
    cd "${item}" || exit
    cd ..
    CUR_BRANCH=$(git branch --show-current)
    if [ "${CUR_BRANCH}" != "$1" ]; then
        echo "current branch is ${CUR_BRANCH},checkout to $1"
        git checkout "$1"
    fi
    git pull origin
    cd "$CUR_DIR" || exit
done
echo "Done!"
