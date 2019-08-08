#!/bin/bash

default_mac(){
    always_needed
    mpi_compilers
    mpi_fortran_on
    tests_off
    examples_off
    kokkos_serial
    packages_for_pressio
    echo CMAKELINE
}

default(){
    default_mac
    echo CMAKELINE
}

frizzi_mac_kokkos_serial(){
    always_needed
    mpi_compilers
    mpi_fortran_on
    tests_off
    examples_off
    kokkos_serial
    openblas
    openblaslapack
    packages_for_pressio
    echo CMAKELINE
}
