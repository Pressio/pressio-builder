#!/bin/bash

#-------------------------------------
# for cee sparc
#-------------------------------------
rompp_cee_sparc_basic() {
    general_options
    mpi_compiler_options
    fortran_off
    examples_off
    cee_sparc_blas_options
    cee_sparc_lapack_options
    enable_eigen
    enable_gtest
    enable_trilinos
    rompp_packages
    enable_debug_print
}

rompp_cee_sparc_tests_on() {
    rompp_cee_sparc_basic
    tests_on
}

rompp_cee_sparc_tsqr_tests_on() {
    rompp_cee_sparc_basic
    enable_anasazi_tsqr
    tests_on
}
#-------------------------------------

frizzi_mpi_alltpls_mac() {
    general_options
    mpi_compiler_options
    fortran_off
    with_omp_flag
    tests_on
    examples_off
    enable_eigen
    enable_gtest
    enable_trilinos
    rompp_packages
    enable_anasazi_tsqr
    enable_debug_print
}

frizzi_serial_mac() {
    general_options
    serial_compiler_options
    fortran_off
    with_omp_flag
    tests_on
    examples_off
    enable_eigen
    enable_gtest
    if [[ ! -z ${TRILINOSPATH} ]]; then
	enable_trilinos
    fi
    rompp_packages
}



# cmake -D CMAKE_BUILD_TYPE:STRING=$MODEbuild \
#       -D CMAKE_INSTALL_PREFIX:PATH=../install \
#       -D CMAKE_VERBOSE_MAKEFILE:BOOL=ON \
#       \
#       -D BUILD_SHARED_LIBS:BOOL=$is_shared \
#       -D TPL_FIND_SHARED_LIBS=$is_shared \
#       -D rompp_LINK_SEARCH_START_STATIC=$link_search_static \
#       \
#       -D TPL_ENABLE_MPI:BOOL=ON \
#       -D MPI_C_COMPILER:FILEPATH=${CC} \
#       -D MPI_CXX_COMPILER:FILEPATH=${CXX} \
#       -D MPI_EXEC:FILEPATH=${MPIRUNe} \
#       -D MPI_USE_COMPILER_WRAPPERS:BOOL=ON \
#       \
#       -D rompp_ENABLE_CXX11:BOOL=ON \
#       -D rompp_ENABLE_SHADOW_WARNINGS:BOOL=OFF \
#       -D CMAKE_CXX_FLAGS="-fopenmp" \
#       \
#       -D TPL_ENABLE_TRILINOS=ON \
#       -D TRILINOS_LIBRARY_DIRS="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib" \
#       -D TRILINOS_INCLUDE_DIRS:PATH=${TRILINOSPATH}/include \
#       -D TPL_ENABLE_EIGEN=ON \
#       -D EIGEN_INCLUDE_DIRS:PATH=${EIGENPATH} \
#       -D TPL_ENABLE_GTEST=ON \
#       -D GTEST_LIBRARY_DIRS="${GTESTPATH}/lib;${GTESTPATH}/lib64" \
#       -D GTEST_INCLUDE_DIRS:PATH=${GTESTPATH}/include \
#       \
#       -D rompp_ENABLE_Fortran=OFF \
#       -D rompp_ENABLE_TESTS:BOOL=ON \
#       -D rompp_ENABLE_EXAMPLES:BOOL=OFF \
#       -D rompp_ENABLE_ALL_PACKAGES:BOOL=OFF \
#       -D rompp_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
#       \
#       -D rompp_ENABLE_core:BOOL=${buildCORE} \
#       -D rompp_ENABLE_qr:BOOL=${buildQR} \
#       -D rompp_ENABLE_solvers:BOOL=${buildSOLVERS} \
#       -D rompp_ENABLE_svd:BOOL=${buildSVD} \
#       -D rompp_ENABLE_ode:BOOL=${buildODE} \
#       -D rompp_ENABLE_rom:BOOL=${buildROM} \
#       -D DEBUG_PRINT::BOOL=ON \
#       -D HAVE_ANASAZI_TSQR::BOOL=ON \
#       \
#       ${ROMPPSRC}
