#!/bin/bash

#----------------------------------
# step : test cline arguments

n_args=$#
if test $n_args -lt 2
then
    str+="[linux/mac] "
    str+="[dynamic/static] "

    echo "usage:"
    echo "$0 $str"
    exit 1;
fi


build_gtest(){
    local PWD=`pwd`
    local PARENTDIR=$PWD

    local is_mac=OFF
    local is_shared=ON

    [[ $1 == mac ]] && is_mac=ON
    echo "is_mac = $is_mac"

    [[ $2 == static ]] && is_shared=OFF
    echo "is_shared = $is_shared"

    #-----------------------------------

    # create dir
    [[ ! -d gtest ]] && mkdir gtest
    cd gtest

    # clone repo
    if [ ! -d googletest ]; then
	git clone git@github.com:google/googletest.git
    fi
    cd googletest && git checkout master && cd ..

    # create build
    mkdir build && cd build

    # run cmake
    cmake -D BUILD_SHARED_LIBS=$is_shared \
    	  -D CMAKE_MACOSX_RPATH:BOOL=$is_mac \
    	  -D CMAKE_CXX_COMPILER:FILEPATH=${CXX} \
    	  -D CMAKE_C_COMPILER:FILEPATH=${CC} \
    	  -D CMAKE_INSTALL_PREFIX:PATH=../install \
    	  ../googletest

    make -j2 install
    cd ${PARENTDIR}
}

build_gtest $1 $2
