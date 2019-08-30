#!/bin/bash

function default_mac(){
    trilinos_always_needed
    trilinos_mpi_compilers
    trilinos_mpi_fortran_on
    trilinos_tests_off
    trilinos_examples_off
    trilinos_kokkos_serial
    trilinos_packages_for_pressio
    echo CMAKELINE
}

function default(){
    default_mac
    echo CMAKELINE
}
