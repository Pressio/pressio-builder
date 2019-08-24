#!/bin/bash

#frizzi_mrsteam_mpi() {
#    default
#}

#-------------------------------------
# frizzi mac
#-------------------------------------
function frizzi_mac_mpi_testson_trilinos() {
    always_needed
    mpi_c_cxx_compilers
    mpi_fortran_on
    tests_on
    examples_off
    openblas
    openblaslapack
    enable_eigen
    enable_gtest
    enable_trilinos
    pressio_packages
    enable_debug_print
}

# frizzi_mpi_mac_kokkos_only() {
#     always_needed
#     mpi_c_cxx_compilers
#     fortran_off
#     tests_on
#     examples_off
#     CMAKELINE+="-D TPL_ENABLE_BLAS=ON "
#     CMAKELINE+="-D TPL_ENABLE_LAPACK=ON "
#     enable_eigen
#     enable_gtest
#     enable_kokkos
#     pressio_packages
#     enable_debug_print
# }

# frizzi_mpi_mac_3() {
#     always_needed
#     mpi_c_cxx_compilers
#     fortran_off
#     tests_on
#     examples_off
#     enable_eigen
#     enable_gtest
#     enable_pybind11
#     pressio_packages
#     enable_debug_print
#     CMAKELINE+="-D PYTHON_INCLUDE_PATH:PATH=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/include/python3.4m/ "
# }

function sisc_paper_adr2dcpp(){
    always_needed
    mpi_c_cxx_compilers
    mpi_fortran_on
    tests_off
    examples_off
    openblas
    openblaslapack
    enable_eigen
    enable_trilinos
    pressio_packages
}

function sisc_paper_burgcpp(){
    always_needed
    serial_c_cxx_compilers
    fortran_off
    tests_off
    examples_off
    enable_eigen
    pressio_packages
}

function sisc_paper_burgpython(){
    always_needed
    serial_c_cxx_compilers
    fortran_off
    tests_off
    examples_off
    enable_eigen
    enable_pybind11
    pressio_packages
}
