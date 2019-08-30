#!/bin/bash

function default_mac(){
    kokkos_always_needed
    kokkos_mpi_compilers
    kokkos_mpi_fortran_off
    kokkos_tests_off
    kokkos_examples_off
    kokkos_serial
    echo CMAKELINE
}

function default(){
    default_mac
    echo CMAKELINE
}
