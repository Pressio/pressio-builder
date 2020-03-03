#!/bin/bash

#-------------------------------------
# default: serial
#-------------------------------------
function default() {
    pressio_build_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_enable_debug_print
}

function default_with_tests() {
    pressio_build_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_enable_debug_print
}

function default_mpi_trilinos() {
    pressio_build_type
    pressio_cmake_verbose
    pressio_mpi_c_cxx_compilers
    pressio_mpi_fortran_on
    pressio_tests_on
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_enable_trilinos
    pressio_enable_kokkos
    pressio_blas_on
    pressio_lapack_on
    pressio_enable_debug_print
}

function default_pybind() {
    pressio_build_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_enable_eigen
    pressio_enable_pybind11
    pressio_enable_debug_print
}

function pybind_with_test() {
    pressio_build_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_enable_eigen
    pressio_enable_pybind11
    pressio_enable_gtest
    pressio_tests_on
    pressio_enable_debug_print
}


#------------------------------------------
# default generator function for tutorials
#------------------------------------------
function default_for_tutorials() {
    pressio_build_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    CMAKELINE+="-DPRESSIO_ENABLE_TPL_EIGEN=ON "
    pressio_enable_debug_print
}
