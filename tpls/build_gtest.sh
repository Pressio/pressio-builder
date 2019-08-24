#!/bin/bash

function build_gtest(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local CMAKELINEGEN=$1

    if [ -z $CMAKELINEGEN ]; then
	echo ""
	echo "build_gtest called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_gtest name_of_cmake_line_generator_function"
	exit 0
    fi
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

    # make sure the global var CMAKELINE is empty
    CMAKELINE=""

    # call the generator to build the string for cmake line
    # this will append to the global var CMAKELINE
    ${CMAKELINEGEN}

    # append prefix
    CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "
    # append the location of the source
    CMAKELINE+="../googletest"

    # run the cmake commnad
    echo "cmake command for gtest: "
    echo "cmake ${CMAKELINE}"
    echo ""
    cmake eval ${CMAKELINE}

    make -j2 install

    cd ${PARENTDIR}
}


# n_args=$#
# if test $n_args -lt 1
# then
#     str+="[cmake-line-generator-fnc] "
#     # str+="[linux/mac] "
#     # str+="[dynamic/static] "

#     echo "usage:"
#     echo "$0 $str"
#     exit 1;
# fi
