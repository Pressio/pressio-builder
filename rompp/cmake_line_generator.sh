#!/bin/bash

#-------------------------------------
# cee sparc
#-------------------------------------
cee_sparc_basic() {
    always_needed
    mpi_c_cxx_compilers
    fortran_off
    examples_off
    cee_sparc_blas
    cee_sparc_lapack
    enable_binutils
    enable_eigen
    enable_gtest
    enable_trilinos
    rompp_packages
    enable_debug_print
}

cee_sparc_gcc_tests_on() {
    cee_sparc_basic
    add_dl_link
    tests_on
}
cee_sparc_clang_tests_on() {
    cee_sparc_basic
    add_dl_link
    tests_on
}
cee_sparc_intel_tests_on() {
    cee_sparc_basic
    #CMAKELINE+="CMAKE_Fortran_FLAGS=-cpp "
    tests_on
}

cee_sparc_intel_tests_off() {
    cee_sparc_basic
    tests_off
}
cee_sparc_gcc_tests_off() {
    cee_sparc_basic
    tests_off
}
cee_sparc_clang_tests_off() {
    cee_sparc_basic
    tests_off
}

cee_sparc_cuda_tests_on() {
    cee_sparc_basic
    # local ldlflag="-fopenmp -ldl"
    # CMAKELINE+="-D CMAKE_EXE_LINKER_FLAGS=${ldlflag} "
    # # needed to handle constexpr or a warning is issued by nvcc
    # #CMAKELINE+="-D CMAKE_CUDA_FLAGS=--expt-relaxed-constexpr "
    # tests_on
}

#-------------------------------------
# default, basic configurations
#-------------------------------------
default() {
    always_needed
    mpi_c_cxx_compilers
    fortran_off
    tests_on
    examples_off
    enable_eigen
    enable_gtest
    enable_trilinos
    rompp_packages
    enable_debug_print
}

#-------------------------------------
# mrsteam
#-------------------------------------
mrsteam_mpi_alltpls() {
    default
}

#-------------------------------------
# frizzi mac
#-------------------------------------
frizzi_mpi_mac_1() {
    default
}
frizzi_mpi_mac_2() {
    default
    examples_on
}
frizzi_mpi_mac_3() {
    always_needed
    mpi_c_cxx_compilers
    fortran_off
    tests_on
    examples_off
    enable_eigen
    enable_gtest
    rompp_packages
    enable_debug_print

    CMAKELINE+="-D PYTHON_INCLUDE_DIR:PATH=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/include/python3.4m/ "
    CMAKELINE+="-D USE_PYTHON_INCLUDE_DIR:BOOL=OFF "
    enable_pybind11
}

# frizzi_serial_mac() {
#     always_needed
#     serial_compiler_options
#     fortran_off
#     tests_on
#     examples_off
#     enable_eigen
#     enable_gtest
#     if [[ ! -z ${TRILINOSPATH} ]]; then
# 	enable_trilinos
#     fi
#     rompp_packages
# }

#-------------------------------------
# pblonigan mac
#-------------------------------------
pblonig_mpi_alltpls_mac() {
    default_alltpls
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
