#!/bin/bash

build_kokkos(){
    local PWD=`pwd`
    local PARENTDIR=$PWD

    local CMAKELINEGEN=$1
    nCoreMake=$2

    if [ -z $CMAKELINEGEN ]; then
	echo "build_kokkos called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_kokkos name_of_cmake_line_generator_function"
	exit 0
    fi
    #-----------------------------------

    # for the time being, we build kokkos via Trilinos which means:
    # (a) cloning trilinos
    # (b) and enabling only kokkos packages
    # later on, we can change this by building kokkos directly

    # create dir
    [[ ! -d kokkos ]] && mkdir kokkos
    cd kokkos

    # clone repo (yes, trilinos because we build kokkos from there)
    if [ ! -d kokkos-tril ]; then
	git clone git@github.com:trilinos/Trilinos.git
	# the unpacked dir is called trilinos, rename it to kokkos-tril
	mv Trilinos kokkos-tril
    fi

    # enter and co right branch
    cd kokkos-tril && git checkout trilinos-release-12-14-branch && cd ..

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
    CMAKELINE+="../kokkos-tril"

    # print command to terminal
    echo "cmake command: "
    echo -e "cmake $CMAKELINE"
    echo ""

    # run the cmake commnad
    cmake eval ${CMAKELINE}

    # build
    make -j ${nCoreMake} install

    cd ${PARENTDIR}
}
