#!/usr/bin/env bash

function build_trilinos(){
    local PWD=`pwd`
    local PARENTDIR=$PWD
    local TPLname=trilinos
    local CMAKELINEGEN=$1
    local nCoreMake=4

    if [ -z $CMAKELINEGEN ]; then
	echo "build_trilinos called without specifying cmake_line_generator_function"
	echo "usage:"
	echo "build_trilinos name_of_cmake_line_generator_function"
	exit 0
    fi
    #-----------------------------------

    # create dir
    [[ ! -d trilinos ]] && mkdir trilinos
    cd trilinos

    # clone repo
    if [ ! -d Trilinos ]; then
	git clone ${TRILINOSGITURL}
    fi
    cd Trilinos && git checkout ${TRILINOSBRANCH} && cd ..
    # TRILINOSGITURL and TRILINOSVERSION are defined in tpls_versions_details

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
    CMAKELINE+="../Trilinos"

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
	echo "${fgyellow}with dryrun=0, here I would config, build and install ${TPLname} ${fgrst}"
    fi

    cd ${PARENTDIR}
}

# cmake -D CMAKE_BUILD_TYPE:STRING=$1 \
    # 	  -D CMAKE_INSTALL_PREFIX:PATH=../install \
    # 	  \
    # 	  -D BUILD_SHARED_LIBS:BOOL=$is_shared \
    # 	  -D TPL_FIND_SHARED_LIBS=$is_shared \
    # 	  -D Trilinos_LINK_SEARCH_START_STATIC=$link_search_static \
    # 	  \
    # 	  -D TPL_ENABLE_MPI:BOOL=ON \
    # 	  -D MPI_C_COMPILER:FILEPATH=${CC} \
    # 	  -D MPI_CXX_COMPILER:FILEPATH=${CXX} \
    # 	  -D MPI_EXEC:FILEPATH=${MPIRUNe} \
    # 	  -D MPI_USE_COMPILER_WRAPPERS:BOOL=ON \
    # 	  \
    # 	  -D Trilinos_ENABLE_EXPORT_MAKEFILES:BOOL=OFF \
    # 	  -D TPL_ENABLE_BoostLib:BOOL=OFF \
    # 	  -D Trilinos_ENABLE_Fortran:BOOL=OFF \
    # 	  -D Trilinos_ENABLE_TESTS:BOOL=OFF \
    # 	  -D Trilinos_ENABLE_EXAMPLES:BOOL=OFF \
    # 	  -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
    # 	  -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
    # 	  \
    # 	  -D Trilinos_ENABLE_OpenMP:BOOL=ON \
    # 	  -D KOKKOS_ENABLE_SERIAL:BOOL=ON \
    # 	  -D KOKKOS_ENABLE_THREADS:BOOL=OFF \
    # 	  -D KOKKOS_ENABLE_OPENMP:BOOL=ON \
    # 	  \
    # 	  -D Trilinos_ENABLE_Teuchos:BOOL=ON \
    # 	  -D Trilinos_ENABLE_Epetra:BOOL=ON \
    # 	  -D Trilinos_ENABLE_Tpetra:BOOL=ON \
    # 	  -D Tpetra_ENABLE_TSQR:BOOL=ON \
    # 	  -D Trilinos_ENABLE_EpetraExt:BOOL=ON \
    # 	  -D Trilinos_ENABLE_AztecOO:BOOL=ON \
    # 	  -D Trilinos_ENABLE_Anasazi:BOOL=ON \
    # 	  -D Anasazi_ENABLE_TSQR:BOOL=ON \
    # 	  -D Trilinos_ENABLE_Ifpack:BOOL=ON \
    # 	  -D Trilinos_ENABLE_Ifpack2:BOOL=ON \
    # 	  \
    # 	  -D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE \
    # 	  ../Trilinos


# -D BLAS_LIBRARY_NAMES:STRING="openblas" \
    #    -D BLAS_LIBRARY_DIRS:PATH=/opt/local/lib \
    #    -D LAPACK_LIBRARY_NAMES:STRING="openblas" \
    #    -D LAPACK_LIBRARY_DIRS:PATH=/opt/local/lib \
    #	  -D MPI_BASE_DIR:PATH=${MPIPATH} \
