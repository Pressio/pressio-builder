#!/bin/bash

#-------------------------------------
# default: tests on, examples off
#-------------------------------------
function default() {
    always_needed
    mpi_c_cxx_compilers
    mpi_fortran_on
    tests_on
    examples_off
    enable_eigen
    enable_gtest
    enable_trilinos
    pressio_packages
    enable_debug_print
}

#-------------------------------------
# serial, examples and tests on
#-------------------------------------
function serial_with_examples() {
    always_needed
    serial_c_cxx_compilers
    fortran_off
    tests_on
    examples_on
    enable_eigen
    enable_gtest
    pressio_packages
    enable_debug_print
}
