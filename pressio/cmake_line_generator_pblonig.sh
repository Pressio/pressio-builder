#!/bin/bash

pblonig_mpi_alltpls_mac() {
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
