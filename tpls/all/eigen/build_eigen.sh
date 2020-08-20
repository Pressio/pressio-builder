#!/usr/bin/env bash

function build_eigen(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local CMAKELINEGEN=$1
    local TPLname=eigen

    if [ -z $CMAKELINEGEN ]; then
	echo ""
	echo "build_eigen called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_eigen [name_of_cmake_line_generator_function]"
	exit 0
    fi
    #-----------------------------------

    # create dir
    [[ ! -d eigen ]] && mkdir eigen
    cd eigen

    # clone repo
    if [ $DRYRUN == no ]; then
	if [ ! -d ${EIGENUNPACKEDDIRNAME} ]; then
	    wget ${EIGENTARURL}
	    tar zxf eigen-${EIGENVERSION}.tar.gz
	fi
    fi

    # I don't need to make a build, just copy source to install
    if [ ! -d install ]; then
	mkdir install
    else
	rm -rf install
    fi

    if [ $DRYRUN == no ];
    then
	echo "${fgyellow}Starting config, build and install of ${TPLname} ${fgrst}"
	echo "installing Eigen by copying source files to target install directory"
	mkdir -p ./install/include/eigen3/Eigen
	cp -rf ./${EIGENUNPACKEDDIRNAME}/Eigen/* ./install/include/eigen3/Eigen
    else
	print_message_dryrun_no
    fi

    cd ${PARENTDIR}
}


# # create build
# mkdir build && cd build

# # make sure the global var CMAKELINE is empty
# CMAKELINE=""

# # call the generator to build the string for cmake line
# # this will append to the global var CMAKELINE
# ${CMAKELINEGEN}

# # append prefix
# CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "
# # append the location of the source
# CMAKELINE+="../eigen-eigen-b3f3d4950030"

# # run the cmake commnad
# echo "cmake command for eigen: "
# echo "cmake ${CMAKELINE}"
# echo ""
# cmake eval ${CMAKELINE}
# make install
