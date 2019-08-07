#!/bin/bash

default_mac(){
    always_needed
    mpi_compilers
    mpi_fortran_off
    tests_off
    examples_off
    kokkos_serial
    echo CMAKELINE
}

default(){
    default_mac
    echo CMAKELINE
}
