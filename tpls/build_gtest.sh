#!/usr/bin/env bash

function build_gtest(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local CMAKELINEGEN=$1
    local TPLname=gtest

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
	# GTESTGITURL is defined in tpls_versions_details
	git clone ${GTESTGITURL}
    fi
    # GTESTBRANCH is defined in tpls_versions_details
    cd googletest && git checkout ${GTESTBRANCH} && cd ..

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

    # print the cmake commnad that will be used
    echo ""
    echo "For ${TPLname}, the cmake command to use is:"
    echo "${fgcyan}cmake ${CMAKELINE}${fgrst}"

    if [ $DRYRUN -eq 0 ];
    then
	echo "${fgyellow}Starting config, build and install of ${TPLname} ${fgrst}"

	CFName="config.txt"
	if [ $DUMPTOFILEONLY -eq 1 ]; then
	    cmake eval ${CMAKELINE} >> ${CFName} 2>&1
	else
	    (cmake eval ${CMAKELINE}) 2>&1 | tee ${CFName}
	fi
	echo "Config output written to ${PWD}/${CFName}"

	BFName="build.txt"
	if [ $DUMPTOFILEONLY -eq 1 ]; then
	    make -j4 >> ${BFName} 2>&1
	else
	    (make -j4) 2>&1 | tee ${BFName}
	fi
	echo "Build output written to ${PWD}/${BFName}"

	IFName="install.txt"
	if [ $DUMPTOFILEONLY -eq 1 ]; then
	    make install >> ${IFName} 2>&1
	else
	    (make install) 2>&1 | tee ${IFName}
	fi
	echo "Install output written to ${PWD}/${IFName}"
    else
	echo "${fgyellow}with dryrun=1, here I would config, build and install ${TPLname} ${fgrst}"
    fi

    cd ${PARENTDIR}
}
