#!/bin/bash

#-------------------------------------
# default, basic configurations
#-------------------------------------
default() {
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
