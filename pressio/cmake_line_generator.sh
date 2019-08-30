#!/bin/bash

#-------------------------------------
# default: tests on, examples off
#-------------------------------------
function default() {
    pressio_always_needed
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
    pressio_serial_c_cxx_compilers
    pressio_fortran_off
    pressio_tests_on
    pressio_examples_on
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_pressio_packages
    pressio_enable_debug_print
}
