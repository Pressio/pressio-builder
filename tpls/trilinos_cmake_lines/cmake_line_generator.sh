#!/bin/bash

function default_mac(){
    always_needed
    mpi_compilers
    mpi_fortran_on
    tests_off
    examples_off
    kokkos_serial
    packages_for_pressio
    echo CMAKELINE
}

function default(){
    default_mac
    echo CMAKELINE
}

function frizzi_mac_kokkos_serial(){
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

function sisc_paper_adrcpp_mac(){
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
