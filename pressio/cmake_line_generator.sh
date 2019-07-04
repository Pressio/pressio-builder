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
    pressio_packages
    enable_debug_print
}

## CEE, tests ON
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
cee_sparc_cuda_tests_on() {
    cee_sparc_basic
    EXTRALINKFLAGS+=";cublas"
    CXXFLAGS+="-fopenmp "
    tests_on
}

## CEE, tests OFF
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
cee_sparc_cuda_tests_off() {
    cee_sparc_basic
    tests_off
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
    pressio_packages
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
    pressio_packages
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
#     pressio_packages
# }

#-------------------------------------
# pblonigan mac
#-------------------------------------
pblonig_mpi_alltpls_mac() {
    default
    examples_on
}