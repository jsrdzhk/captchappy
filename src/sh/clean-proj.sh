#!/bin/sh

###
 # @title: clean-porj.sh
 # @author: Rodney Cheung
 # @date: 2021-07-20 08:18:23
 # @last_author: Rodney Cheung
 # @last_edit_time: 2021-07-20 08:59:10
###
CUR_DIR=$(pwd)
# clean gradle project
for gradlewFilePath in $(find . -iname "gradlew" | cut -c 3-); do
    echo "${gradlewFilePath}"
    gradlewFileDir=$(echo "${gradlewFilePath}" | rev | cut -c 8- | rev)
    cd "${gradlewFileDir}" || exit
    ./gradlew clean
    cd "$CUR_DIR" || exit
done

# clean python project
for cleanPyFilePath in $(find . -iname "clean_build.sh" | cut -c 3-); do
    echo "${cleanPyFilePath}"
    cleanPyFileDir=$(echo "${cleanPyFilePath}" | rev | cut -c 15- | rev)
    cd "${cleanPyFileDir}" || exit
    ./clean_build.sh
    cd "$CUR_DIR" || exit
done
echo "Done!"