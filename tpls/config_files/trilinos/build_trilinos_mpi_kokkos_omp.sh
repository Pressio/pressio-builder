#!/bin/bash

#----------------------------------
# step : test cline arguments

n_args=$#
if test $n_args -lt 3
then
    str+="[DEBUG/RELEASE] "
    str+="[dynamic/static] "
    str+="[numCoresForMake] "

    echo "usage:"
    echo "$0 $str"
    exit 1;
fi


build(){
    local PWD=`pwd`
    local PARENTDIR=$PWD

    local is_shared=ON
    [[ $2 == static ]] && is_shared=OFF
    echo "is_shared = $is_shared"
    local link_search_static=OFF
    [[ $2 == static ]] && link_search_static=ON

    nCoreMake=$3

    #-----------------------------------

    # create dir
    [[ ! -d trilinos ]] && mkdir trilinos
    cd trilinos

    # clone repo
    if [ ! -d Trilinos ]; then
	git clone git@github.com:trilinos/Trilinos.git
    fi
    cd Trilinos && git checkout trilinos-release-12-14-branch && cd ..

    # create build
    mkdir build && cd build

    cmake -D CMAKE_BUILD_TYPE:STRING=$1 \
    	  -D CMAKE_INSTALL_PREFIX:PATH=../install \
    	  \
    	  -D BUILD_SHARED_LIBS:BOOL=$is_shared \
    	  -D TPL_FIND_SHARED_LIBS=$is_shared \
    	  -D Trilinos_LINK_SEARCH_START_STATIC=$link_search_static \
    	  \
    	  -D TPL_ENABLE_MPI:BOOL=ON \
    	  -D MPI_C_COMPILER:FILEPATH=${CC} \
    	  -D MPI_CXX_COMPILER:FILEPATH=${CXX} \
    	  -D MPI_EXEC:FILEPATH=${MPIRUNe} \
    	  -D MPI_USE_COMPILER_WRAPPERS:BOOL=ON \
    	  \
    	  -D Trilinos_ENABLE_EXPORT_MAKEFILES:BOOL=OFF \
    	  -D TPL_ENABLE_BoostLib:BOOL=OFF \
    	  -D Trilinos_ENABLE_Fortran:BOOL=OFF \
    	  -D Trilinos_ENABLE_TESTS:BOOL=OFF \
    	  -D Trilinos_ENABLE_EXAMPLES:BOOL=OFF \
    	  -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
    	  -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
    	  \
    	  -D Trilinos_ENABLE_OpenMP:BOOL=ON \
    	  -D KOKKOS_ENABLE_SERIAL:BOOL=ON \
    	  -D KOKKOS_ENABLE_THREADS:BOOL=OFF \
    	  -D KOKKOS_ENABLE_OPENMP:BOOL=ON \
    	  \
    	  -D Trilinos_ENABLE_Teuchos:BOOL=ON \
    	  -D Trilinos_ENABLE_Epetra:BOOL=ON \
    	  -D Trilinos_ENABLE_Tpetra:BOOL=ON \
    	  -D Tpetra_ENABLE_TSQR:BOOL=ON \
    	  -D Trilinos_ENABLE_EpetraExt:BOOL=ON \
    	  -D Trilinos_ENABLE_AztecOO:BOOL=ON \
    	  -D Trilinos_ENABLE_Anasazi:BOOL=ON \
    	  -D Anasazi_ENABLE_TSQR:BOOL=ON \
    	  -D Trilinos_ENABLE_Ifpack:BOOL=ON \
    	  -D Trilinos_ENABLE_Ifpack2:BOOL=ON \
    	  \
    	  -D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE \
    	  ../Trilinos

    make -j ${nCoreMake} install

    cd ${PARENTDIR}
}

# DEBUG/RELEASE DYNAMIC/STATIC nCoresForMake
build $1 $2 $3




# -D BLAS_LIBRARY_NAMES:STRING="openblas" \
#    -D BLAS_LIBRARY_DIRS:PATH=/opt/local/lib \
#    -D LAPACK_LIBRARY_NAMES:STRING="openblas" \
#    -D LAPACK_LIBRARY_DIRS:PATH=/opt/local/lib \
#	  -D MPI_BASE_DIR:PATH=${MPIPATH} \
