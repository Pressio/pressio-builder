#!/bin/bash

#TODO: FINISH

function build_cmake(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local CMAKELINEGEN=$1

    # create dir
    [[ ! -d cmake ]] && mkdir cmake
    cd cmake

    # # get source code
    # #if [ ! -f cmake-${CMAKEVERSIONMIN}.tar.gz ]; then
    # 	#wget https://github.com/Kitware/CMake/releases/download/v3.13.5/cmake-${CMAKEVERSIONMIN}.tar.gz
    # 	#tar zxf cmake-${CMAKEVERSIONMIN}.tar.gz
    # #else
    # rm -rf cmake-${CMAKEVERSIONMIN}
    # cp /Users/fnrizzi/tpl/cmake/3.11.0/cmake-${CMAKEVERSIONMIN}.tar.gz .
    # tar zxf cmake-${CMAKEVERSIONMIN}.tar.gz
    # #fi

    # # create build
    # [[ ! -d build ]] && mkdir build
    # cd build

    # # make sure the global var CMAKELINE is empty
    # CMAKELINE=""

    # # append prefix
    # CMAKELINE+="-D CMAKE_C_COMPILER=${CC}"
    # CMAKELINE+="-D CMAKE_CXX_COMPILER=${CXX}"
    # CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "
    # # append the location of the source
    # CMAKELINE+="../cmake-${CMAKEVERSIONMIN}"

    # # run the cmake commnad
    # echo "cmake command for gtest: "
    # echo "cmake ${CMAKELINE}"
    # echo ""
    # cmake eval ${CMAKELINE}
    # make -j4 install

    cd ${PARENTDIR}
}
