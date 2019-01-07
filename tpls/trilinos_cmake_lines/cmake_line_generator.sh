#!/bin/bash

frizzi_mac(){
    general_options
    mpi_compiler_options
    mpi_fortran_off
    tests_off
    examples_off
    kokkos_omp
    packages_for_rompp

    echo CMAKELINE
}

default(){
    frizzi_mac
    echo CMAKELINE
}
