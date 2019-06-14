#!/bin/bash

build_pybind11(){
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
    fi

    # I don't need to make a build, just copy source to install
    if [ ! -d install ]; then
	mkdir install
    else
	rm -rf install
    fi

    echo "installing Pybind11 by copying source files to target install directory"
    mkdir -p ./install/include
    cp -rf ./pybind11/* ./install/include

    cd ${PARENTDIR}
}
