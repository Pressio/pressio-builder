#!/bin/bash

#-------------------------------------
# default: serial, tests on
#-------------------------------------
function default() {
    pressio_build_type
    pressio_link_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_serial_fortran_compiler
    pressio_tests_on
    pressio_examples_off
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_pressio_target_package
    pressio_enable_debug_print
    pressio_ode_tests_on
    pressio_solvers_tests_on
    pressio_rom_tests_on
}

function default_mpi_trilinos() {
    pressio_build_type
    pressio_link_type
    pressio_cmake_verbose
    pressio_mpi_c_cxx_compilers
    pressio_mpi_fortran_on
    pressio_tests_on
    pressio_examples_off
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_enable_trilinos
    trilinos_blas_on
    trilinos_lapack_on
    pressio_pressio_target_package
    pressio_enable_debug_print
}

#------------------------------------------
# default generator function for tutorials
#------------------------------------------
function default_for_tutorials() {
    pressio_build_type
    pressio_link_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_fortran_off
    pressio_enable_eigen
    pressio_pressio_target_package
    pressio_enable_debug_print
}
