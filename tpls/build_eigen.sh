#!/bin/bash

build_eigen(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local CMAKELINEGEN=$1

    if [ -z $CMAKELINEGEN ]; then
	echo ""
	echo "build_gtest called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_gtest [name_of_cmake_line_generator_function]"
	exit 0
    fi
    #-----------------------------------

    # create dir
    [[ ! -d eigen ]] && mkdir eigen
    cd eigen

    # clone repo
    if [ ! -d eigen-eigen-b3f3d4950030 ]; then
	wget http://bitbucket.org/eigen/eigen/get/3.3.5.tar.bz2
	tar xf 3.3.5.tar.bz2
    fi

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
    CMAKELINE+="../eigen-eigen-b3f3d4950030"

    # run the cmake commnad
    echo "cmake command for eigen: "
    echo "cmake ${CMAKELINE}"
    echo ""
    cmake eval ${CMAKELINE}

    make install

    cd ${PARENTDIR}
}


# echo `pwd`
# mkdir -p install/Eigen
# ls
# cp -rf eigen-eigen-b3f3d4950030/Eigen/* install/Eigen

# n_args=$#
# if test $n_args -lt 1
# then
#     str+="[linux/mac] "

#     echo "usage:"
#     echo "$0 $str"
#     exit 1;
# fi
