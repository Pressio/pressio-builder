#!/bin/bash

#------------------------------------------
# default generator function for tutorials
#------------------------------------------
function default_for_tutorials() {
    pressio_always_needed
    pressio_serial_c_cxx_compilers
    pressio_serial_fortran_compiler
    pressio_enable_eigen
    pressio_pressio_packages
    pressio_enable_debug_print
}

#-------------------------------------
# default: serial, tests on
#-------------------------------------
function default() {
    pressio_always_needed
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_serial_fortran_compiler
    pressio_tests_on
    pressio_examples_off
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_pressio_packages
    pressio_enable_debug_print
}

#-------------------------------------
function default_mpi_trilinos() {
    pressio_always_needed
    pressio_cmake_verbose
    pressio_mpi_c_cxx_compilers
    pressio_mpi_fortran_on
    pressio_tests_on
    pressio_examples_off
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_enable_trilinos
    pressio_pressio_packages
    pressio_enable_debug_print
}

#-------------------------------------
# serial, examples and tests on
#-------------------------------------
function serial_with_examples() {
    pressio_always_needed
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_fortran_off
    pressio_tests_on
    pressio_examples_on
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_pressio_packages
    pressio_enable_debug_print
}
