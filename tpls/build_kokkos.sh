#!/bin/bash

function build_kokkos(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local TPLname=kokkos
    local CMAKELINEGEN=$1
    local nCoreMake=4

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
	    make -j ${nCoreMake} >> ${BFName} 2>&1
	else
	    (make -j ${nCoreMake}) 2>&1 | tee ${BFName}
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
