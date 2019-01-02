#!/bin/bash

EXTRA_ARGS=$@

SRC=/Users/fnrizzi/Desktop/work/ROM/sources/rompp_demo_apps
PFX=/Users/fnrizzi/Desktop/work/ROM/installs/rompp_demo_apps_install

ROMPPPATH=/Users/fnrizzi/Desktop/work/ROM/installs/rompp_install
MPIPATH=/Users/fnrizzi/tpl/openmpi/4.0.0/install_gcc650
TRILPATH=/Users/fnrizzi/tpl/trilinos/install_ompi400_gcc650_dbg_shared
EIGENINCPATH=/Users/fnrizzi/tpl/eigen/3.3.5/install
GTESTPATH=/Users/fnrizzi/tpl/gtest/install_gcc650

cmake \
    -D CMAKE_BUILD_TYPE:STRING=DEBUG \
    -D CMAKE_INSTALL_PREFIX:PATH=${PFX} \
    -D CMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    \
    -D BUILD_SHARED_LIBS:BOOL=ON \
    -D TPL_FIND_SHARED_LIBS=ON \
    -D rompp_demo_apps_LINK_SEARCH_START_STATIC=OFF \
    \
    -D BLAS_LIBRARY_NAMES:STRING="openblas" \
    -D BLAS_LIBRARY_DIRS:PATH=/opt/local/lib \
    -D LAPACK_LIBRARY_NAMES:STRING="openblas" \
    -D LAPACK_LIBRARY_DIRS:PATH=/opt/local/lib \
    \
    -D MPI_EXEC_MAX_NUMPROCS:STRING=8 \
    -D rompp_demo_apps_ENABLE_CXX11:BOOL=ON\
    -D rompp_demo_apps_ENABLE_SHADOW_WARNINGS:BOOL=OFF\
    \
    -D CMAKE_CXX_FLAGS="-fopenmp" \
    \
    -D TPL_ENABLE_ROMPP=ON \
    -D ROMPP_LIBRARY_DIRS:PATH=${ROMPPPATH}/lib \
    -D ROMPP_INCLUDE_DIRS:PATH=${ROMPPPATH}/include \
    -D TPL_ENABLE_MPI=ON \
    -D MPI_BASE_DIR:PATH=${MPIPATH} \
    -D MPI_EXEC:FILEPATH=${MPIPATH}/bin/mpirun \
    -D TPL_ENABLE_TRILINOS=ON \
    -D TRILINOS_LIBRARY_DIRS:PATH=${TRILPATH}/lib \
    -D TRILINOS_INCLUDE_DIRS:PATH=${TRILPATH}/include \
    -D TPL_ENABLE_EIGEN=ON \
    -D EIGEN_INCLUDE_DIRS:PATH=${EIGENINCPATH} \
    -D TPL_ENABLE_GTEST=ON \
    -D GTEST_LIBRARY_DIRS:PATH=${GTESTPATH}/lib \
    -D GTEST_INCLUDE_DIRS:PATH=${GTESTPATH}/include \
    \
    -D rompp_demo_apps_ENABLE_Fortran=OFF \
    -D rompp_demo_apps_ENABLE_TESTS:BOOL=ON \
    -D rompp_demo_apps_ENABLE_EXAMPLES:BOOL=OFF \
    -D rompp_demo_apps_ENABLE_ALL_PACKAGES:BOOL=OFF \
    -D rompp_demo_apps_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
    \
    -D rompp_demo_apps_ENABLE_oneD:BOOL=ON \
    -D rompp_demo_apps_ENABLE_twoD:BOOL=OFF \
    \
    $EXTRA_ARGS \
    ${SRC}

    # -D TPL_ENABLE_KOKKOS=ON \
    # -D KOKKOS_LIBRARY_DIRS:PATH=${KOKKOSPATH}/lib \
    # -D KOKKOS_INCLUDE_DIRS:PATH=${KOKKOSPATH}/include \
    #-D rompp_ENABLE_CXX11:BOOL=ON\
    #-D CMAKE_CXX_FLAGS="-std=c++11 -fopenmp"\
