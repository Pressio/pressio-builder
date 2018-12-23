#!/bin/bash

#----------------------------------
# step : test cline arguments

n_args=$#
if test $n_args -lt 6
then
    str+="[DEBUG/RELEASE] "
    str+="[dynamic/static] "
    str+="[numCoresForMake] "
    str+="<eigen_full_path> "
    str+="<gtest_full_path> "
    str+="<trilinos_full_path> "

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

    local nCoreMake=$3

    # # where to find all tpls
    # local tpls_path=$4
    local EIGENPATH=$4
    local GTESTPATH=$5
    local TRILPATH=$6

    #-----------------------------------

    # create dir
    [[ ! -d romppdir ]] && mkdir romppdir
    cd romppdir

    # clone repo
    if [ ! -d rompp ]; then
	git clone --recursive git@gitlab.com:fnrizzi/rompp.git
    fi
    cd rompp && git checkout develop && cd ..

    # create build
    mkdir build && cd build

    cmake -D CMAKE_BUILD_TYPE:STRING=$1 \
          -D CMAKE_INSTALL_PREFIX:PATH=../install \
          -D CMAKE_VERBOSE_MAKEFILE:BOOL=ON \
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
          -D rompp_ENABLE_CXX11:BOOL=ON \
          -D rompp_ENABLE_SHADOW_WARNINGS:BOOL=OFF \
          -D CMAKE_CXX_FLAGS="-fopenmp" \
          \
          -D TPL_ENABLE_TRILINOS=ON \
          -D TRILINOS_LIBRARY_DIRS="${TRILPATH}/lib64;${TRILPATH}/lib" \
          -D TRILINOS_INCLUDE_DIRS:PATH=${TRILPATH}/include \
          -D TPL_ENABLE_EIGEN=ON \
          -D EIGEN_INCLUDE_DIRS:PATH=${EIGENPATH} \
          -D TPL_ENABLE_GTEST=ON \
          -D GTEST_LIBRARY_DIRS="${GTESTPATH}/lib;${GTESTPATH}/lib64" \
          -D GTEST_INCLUDE_DIRS:PATH=${GTESTPATH}/include \
          \
          -D rompp_ENABLE_Fortran=OFF \
          -D rompp_ENABLE_TESTS:BOOL=ON \
          -D rompp_ENABLE_EXAMPLES:BOOL=OFF \
          -D rompp_ENABLE_ALL_PACKAGES:BOOL=OFF \
          -D rompp_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
          \
          -D rompp_ENABLE_core:BOOL=ON \
          -D rompp_ENABLE_qr:BOOL=ON \
          -D rompp_ENABLE_solvers:BOOL=ON \
          -D rompp_ENABLE_svd:BOOL=ON \
          -D rompp_ENABLE_ode:BOOL=ON \
          -D rompp_ENABLE_rom:BOOL=ON \
          -D DEBUG_PRINT::BOOL=ON \
          \
          ../rompp

    make -j ${nCoreMake} install

    cd ${PARENTDIR}
}

# see top
build $1 $2 $3 $4 $5 $6




# -D BLAS_LIBRARY_NAMES:STRING="openblas" \
#    -D BLAS_LIBRARY_DIRS:PATH=/opt/local/lib \
#    -D LAPACK_LIBRARY_NAMES:STRING="openblas" \
#    -D LAPACK_LIBRARY_DIRS:PATH=/opt/local/lib \
#	  -D MPI_BASE_DIR:PATH=${MPIPATH} \
