#!/usr/bin/env bash

function build_pybind11(){
    local PARENTDIR=$PWD
    local CMAKELINEGEN=$1
    local TPLname=pybind11

    if [ -z $CMAKELINEGEN ]; then
	echo ""
	echo "build_pybind11 called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_pybind11 [name_of_cmake_line_generator_function]"
	exit 13
    fi
    #-----------------------------------

    # create dir
    [[ ! -d pybind11 ]] && mkdir pybind11
    cd pybind11

    # clone repo
    # PYBINDGITURL and PYBINDBRANCH are defined in tpls_versions_details
    if [ $DRYRUN == no ]; then
	if [ ! -d pybind11 ]; then
	    git clone ${PYBINDGITURL}
	    cd pybind11
	    git checkout ${PYBINDBRANCH}
	    cd ..
	fi
    fi

    # I don't need to make a build, just copy source to install
    if [ ! -d install ]; then
	mkdir install
    else
	rm -rf install
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
    CMAKELINE+="../pybind11"

    # print the cmake commnad that will be used
    echo ""
    echo "For ${TPLname}, the cmake command to use is:"
    echo "${fgcyan}cmake ${CMAKELINE}${fgrst}"

    if [ $DRYRUN == no ];
    then
	echo "${fgyellow}Starting config, build and install of ${TPLname} ${fgrst}"

	CFName="config.txt"
	if [ $DUMPTOFILEONLY == yes ]; then
	    cmake eval ${CMAKELINE} >> ${CFName} 2>&1
	else
	    (cmake eval ${CMAKELINE}) 2>&1 | tee ${CFName}
	fi
	echo "Config output written to ${PWD}/${CFName}"

	BFName="build.txt"
	if [ $DUMPTOFILEONLY == yes ]; then
	    make -j4 >> ${BFName} 2>&1
	else
	    (make -j4) 2>&1 | tee ${BFName}
	fi
	echo "Build output written to ${PWD}/${BFName}"

	IFName="install.txt"
	if [ $DUMPTOFILEONLY == yes ]; then
	    make install >> ${IFName} 2>&1
	else
	    (make install) 2>&1 | tee ${IFName}
	fi
	echo "Install output written to ${PWD}/${IFName}"
    else
	print_message_dryrun_no
    fi
    cd ${PARENTDIR}
}
