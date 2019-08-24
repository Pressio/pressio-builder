#!/bin/bash

function build_pybind11(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local CMAKELINEGEN=$1

    if [ -z $CMAKELINEGEN ]; then
	echo ""
	echo "build_pybind11 called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_pybind11 [name_of_cmake_line_generator_function]"
	exit 0
    fi
    #-----------------------------------

    # create dir
    [[ ! -d pybind11 ]] && mkdir pybind11
    cd pybind11

    echo "cd pybind"
    echo $PWD

    # clone repo
    if [ ! -d pybind11 ]; then
	git clone git@github.com:pybind/pybind11.git
	cd pybind11
	git checkout origin/v2.3
	cd ..
    fi

    # I don't need to make a build, just copy source to install
    if [ ! -d install ]; then
	mkdir install
    else
	rm -rf install
    fi

    echo "installing Pybind11"
    # mkdir -p ./install/include
    # cp -rf ./pybind11/* ./install/include

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
    CMAKELINE+="../pybind11"

    # run the cmake commnad
    echo "cmake command for gtest: "
    echo "cmake ${CMAKELINE}"
    echo ""
    cmake eval ${CMAKELINE}

    make -j4 install

    cd ${PARENTDIR}
}
