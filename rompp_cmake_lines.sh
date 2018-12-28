#!/bin/bash

cmake_rompp_mpi_omp() {

cmake -D CMAKE_BUILD_TYPE:STRING=$MODEbuild \
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
      -D TRILINOS_LIBRARY_DIRS="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib" \
      -D TRILINOS_INCLUDE_DIRS:PATH=${TRILINOSPATH}/include \
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
      -D rompp_ENABLE_core:BOOL=${buildCORE} \
      -D rompp_ENABLE_qr:BOOL=${buildQR} \
      -D rompp_ENABLE_solvers:BOOL=${buildSOLVERS} \
      -D rompp_ENABLE_svd:BOOL=${buildSVD} \
      -D rompp_ENABLE_ode:BOOL=${buildODE} \
      -D rompp_ENABLE_rom:BOOL=${buildROM} \
      -D DEBUG_PRINT::BOOL=ON \
      \
      ${ROMPPSRC}
}
#end cmake_rompp_mpi_omp
