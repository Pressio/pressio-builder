#!/usr/bin/env bash

function build_kokkos-kernels(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local TPLname=kokkos-kernels
    local CMAKELINEGEN=$1
    local nCoreMake=4

    if [ -z $CMAKELINEGEN ]; then
	echo "build_kokkos-kernels called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_kokkos-kernels name_of_cmake_line_generator_function"
	exit 0
    fi
    #-----------------------------------

    # check that blas and lapack are set
    if [[ -z ${BLAS_ROOT} ]]; then
	echo "error: kokkos-kernels need BLAS_ROOT to be found in the environment, exiting"
	exit 2
    fi
    if [[ -z ${BLAS_LIBRARIES} ]]; then
	echo "error: kokkos-kernels need BLAS_LIBRARIES to be found in the environment, exiting"
	exit 2
    fi
    if [[ -z ${LAPACK_ROOT} ]]; then
	echo "error: kokkos-kernels need LAPACK_ROOT to be found in the environment, exiting"
	exit 2
    fi
    if [[ -z ${LAPACK_LIBRARIES} ]]; then
	echo "error: kokkos-kernels need LAPACK_LIBRARIES to be found in the environment, exiting"
	exit 2
    fi

    # create dir
    [[ ! -d kokkos-kernels ]] && mkdir kokkos-kernels
    cd kokkos-kernels

    # clone repos (see tpls_versions_details)
    if [ $DRYRUN == no ]; then
	if [ ! -d kokkos-kernels ]; then
	    git clone ${KOKKOSKERURL}
	fi
	cd kokkos-kernels
	git checkout ${KOKKOSTAG}
	cd ..
    fi

    # -----------------
    # BUILD
    # -----------------
    # create build
    mkdir build && cd build

    CMAKELINE=""
    # call the generator to build the string for cmake line
    # this will append to the global var CMAKELINE
    ${CMAKELINEGEN}

    # append where Kokkos installation is
    CMAKELINE+="-D Kokkos_ROOT=../../kokkos/install "

    # append prefix
    CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "

    # append the location of the source
    CMAKELINE+="../kokkos-kernels"

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
	    make -j ${nCoreMake} >> ${BFName} 2>&1
	else
	    (make -j ${nCoreMake}) 2>&1 | tee ${BFName}
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
