#!/bin/sh

GATEWAY_HOME=$HOME/build/gateway/FIRSTApi
SWIG_HOME=$HOME/build/swig
TARGET_HOME=$GATEWAY_HOME/build

cpToSwig() {
    cp "${GATEWAY_HOME}"/include/CrossPlatform.h "${SWIG_HOME}"
    cp "${GATEWAY_HOME}"/include/ThostFtdcUserApiStruct.h "${SWIG_HOME}"
    cp "${GATEWAY_HOME}"/include/ThostFtdcUserApiDataType.h "${SWIG_HOME}"
    cp "${GATEWAY_HOME}"/include/FIRSTApi.h "${SWIG_HOME}"
    cp "${GATEWAY_HOME}"/build/lib/libFIRST_API_CPP.so "${SWIG_HOME}"
}

buildGatewayLib() {
    CUR_DIR=$(pwd)
    cd "${GATEWAY_HOME}" || exit
    if [ -d "$GATEWAY_HOME/build" ]; then
        echo "directory \"$GATEWAY_HOME/build\" exists"
    else
        mkdir build
    fi
    cd build || exit
    cmake ..
    make clean
    make FIRST_API_CPP
    make CTP_SE_Trade
    make CTP_MINI2_Trade
    make CTP_MINI2_Quote
    make FirstGatewayTestTool
    cd "${CUR_DIR}" || exit
}

buildSwig() {
    CUR_DIR=$(pwd)
    cd "${SWIG_HOME}" || exit
    ./create.sh
    cd "${CUR_DIR}" || exit
}

packSwigAndGatewayLib() {
    cp "${SWIG_HOME}"/linux_release/firstapi.jar "${TARGET_HOME}"/lib
    cp "${SWIG_HOME}"/linux_release/libfirstapi_wrap.so "${TARGET_HOME}"/lib
    tar -zcvPf "${HOME}"/build/build_target.tar.gz "${TARGET_HOME}"/lib "${TARGET_HOME}"/bin
}

buildGateway() {
    echo "start to build gateway..."
    echo "step 1:build gateway"
    buildGatewayLib
    echo "step 2:cp libFIRST_API_CPP.so and headers to swig home"
    cpToSwig
    echo "step 3:build swig"
    buildSwig
    echo "step 4:package swig and gateway lib"
    packSwigAndGatewayLib
}

buildGateway
