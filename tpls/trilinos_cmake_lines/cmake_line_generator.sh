#!/bin/bash

default_mac(){
    always_needed
    mpi_compilers
    mpi_fortran_off
    tests_off
    examples_off
    kokkos_serial
    packages_for_rompp
    echo CMAKELINE
}

default(){
    default_mac
    echo CMAKELINE
}
